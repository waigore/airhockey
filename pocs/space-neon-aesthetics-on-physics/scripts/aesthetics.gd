extends Node2D

## Applies selectable neon-glow and starfield looks on top of the physics scene.
## Glow 0 = halo shells (Polygon2D rings); Glow 1 = WorldEnvironment bloom.

enum GlowApproach { HALO_SHELLS, ENV_BLOOM }

const TABLE_BASE := Color(0.04, 0.06, 0.12, 0.92)
const WALL_NEON := Color(0.25, 0.95, 1.0, 1.0)
const PUCK_NEON := Color(0.95, 0.98, 1.0, 1.0)
const MALLET_P1 := Color(0.25, 0.85, 1.0, 1.0)
const MALLET_P2 := Color(1.0, 0.4, 0.55, 1.0)

var tunables: PoCTunables
var _table: Rect2
var _wall_thickness: float
var _goal_width: float

var _starfield: Node2D
var _space_bg: ColorRect
var _env: WorldEnvironment
var _table_fill: Polygon2D
var _table_edge: Line2D
var _center_line: Line2D
var _walls: Node2D
var _puck: RigidBody2D
var _mallet_bottom: RigidBody2D
var _mallet_top: RigidBody2D


func setup(
	t: PoCTunables,
	table: Rect2,
	wall_thickness: float,
	goal_width: float,
	starfield: Node2D,
	space_bg: ColorRect,
	env: WorldEnvironment,
	table_fill: Polygon2D,
	walls: Node2D,
	puck: RigidBody2D,
	mallet_bottom: RigidBody2D,
	mallet_top: RigidBody2D,
) -> void:
	tunables = t
	_table = table
	_wall_thickness = wall_thickness
	_goal_width = goal_width
	_starfield = starfield
	_space_bg = space_bg
	_env = env
	_table_fill = table_fill
	_walls = walls
	_puck = puck
	_mallet_bottom = mallet_bottom
	_mallet_top = mallet_top
	_ensure_table_lines()
	_apply()
	if not tunables.aesthetics_changed.is_connected(_apply):
		tunables.aesthetics_changed.connect(_apply)


func _ensure_table_lines() -> void:
	if _table_edge == null or not is_instance_valid(_table_edge):
		_table_edge = Line2D.new()
		_table_edge.name = "TableNeonEdge"
		_table_edge.width = 2.5
		_table_edge.default_color = WALL_NEON
		_table_edge.z_index = 2
		add_child(_table_edge)
	if _center_line == null or not is_instance_valid(_center_line):
		_center_line = Line2D.new()
		_center_line.name = "CenterNeonLine"
		_center_line.width = 1.5
		_center_line.default_color = Color(0.4, 0.9, 1.0, 0.45)
		_center_line.z_index = 2
		add_child(_center_line)
	var p := _table.position
	var s := _table.size
	_table_edge.points = PackedVector2Array([
		p, p + Vector2(s.x, 0), p + s, p + Vector2(0, s.y), p
	])
	var mid_y := p.y + s.y * 0.5
	_center_line.points = PackedVector2Array([
		Vector2(p.x + 8.0, mid_y), Vector2(p.x + s.x - 8.0, mid_y)
	])


func _apply() -> void:
	if tunables == null:
		return
	var vp := get_viewport_rect().size
	if _starfield != null and _starfield.has_method("apply"):
		_starfield.apply(
			tunables.starfield_approach,
			tunables.star_density,
			tunables.star_brightness,
			tunables.star_twinkle,
			vp
		)
	if _space_bg != null:
		_space_bg.color = Color(0.02, 0.03, 0.07, 1.0)

	var sat := tunables.neon_saturation
	var wall_c := _sat_color(WALL_NEON, sat)
	var puck_c := _sat_color(PUCK_NEON, sat)
	var p1_c := _sat_color(MALLET_P1, sat)
	var p2_c := _sat_color(MALLET_P2, sat)

	if _table_fill != null:
		_table_fill.color = TABLE_BASE
	if _table_edge != null:
		_table_edge.default_color = Color(wall_c.r, wall_c.g, wall_c.b, 0.85 + tunables.glow_intensity * 0.15)
		_table_edge.width = 2.0 + tunables.glow_intensity * 2.0
	if _center_line != null:
		_center_line.default_color = Color(wall_c.r, wall_c.g, wall_c.b, 0.25 + tunables.glow_intensity * 0.35)

	_tint_walls(wall_c)
	_style_disk(_puck, puck_c, 18.0, true)
	_style_disk(_mallet_bottom, p1_c, 36.0, false)
	_style_disk(_mallet_top, p2_c, 36.0, false)

	var use_bloom := tunables.glow_approach == GlowApproach.ENV_BLOOM
	_configure_environment(use_bloom)
	_set_halos(not use_bloom)


func _sat_color(c: Color, sat: float) -> Color:
	var gray := (c.r + c.g + c.b) / 3.0
	return Color(
		lerpf(gray, c.r, sat),
		lerpf(gray, c.g, sat),
		lerpf(gray, c.b, sat),
		c.a
	)


func _tint_walls(neon: Color) -> void:
	if _walls == null:
		return
	var intensity := tunables.glow_intensity
	for body in _walls.get_children():
		var to_free: Array[Node] = []
		var poly_pts := PackedVector2Array()
		for ch in body.get_children():
			if ch is Line2D and ch.name == "NeonRim":
				to_free.append(ch)
			elif ch is Polygon2D:
				(ch as Polygon2D).color = Color(
					neon.r * (0.35 + intensity * 0.45),
					neon.g * (0.35 + intensity * 0.45),
					neon.b * (0.35 + intensity * 0.45),
					1.0
				)
				poly_pts = (ch as Polygon2D).polygon
		for n in to_free:
			n.queue_free()
		if tunables.glow_approach != GlowApproach.HALO_SHELLS:
			continue
		if poly_pts.size() < 3:
			continue
		var rim := Line2D.new()
		rim.name = "NeonRim"
		rim.width = 1.5 + intensity * 2.5
		rim.default_color = Color(neon.r, neon.g, neon.b, 0.35 + intensity * 0.5)
		rim.z_index = 1
		var pts := PackedVector2Array()
		for v in poly_pts:
			pts.append(v)
		pts.append(poly_pts[0])
		rim.points = pts
		body.add_child(rim)


func _style_disk(body: RigidBody2D, color: Color, radius: float, is_puck: bool) -> void:
	if body == null:
		return
	var vis := body.get_node_or_null("Visual") as Polygon2D
	if vis == null:
		return
	vis.color = color
	var hub := vis.get_node_or_null("Hub") as Polygon2D
	if hub != null:
		hub.color = color.darkened(0.4)
	# Clear prior halo shells.
	for ch in body.get_children():
		if ch.name.begins_with("Halo"):
			ch.queue_free()
	if tunables.glow_approach != GlowApproach.HALO_SHELLS:
		return
	var intensity := tunables.glow_intensity
	var layers := 3 if is_puck else 3
	for i in layers:
		var halo := Polygon2D.new()
		halo.name = "Halo%d" % i
		var scale := 1.15 + float(i) * (0.35 + intensity * 0.25)
		var pts := PackedVector2Array()
		var n := 28
		for k in n:
			var a := TAU * float(k) / float(n)
			pts.append(Vector2(cos(a), sin(a)) * radius * scale)
		halo.polygon = pts
		var alpha := (0.22 - float(i) * 0.06) * intensity
		halo.color = Color(color.r, color.g, color.b, maxf(alpha, 0.04))
		halo.z_index = -1 - i
		# Insert behind Visual.
		body.add_child(halo)
		body.move_child(halo, 0)


func _set_halos(enabled: bool) -> void:
	# Halos are created in _style_disk when mode is HALO_SHELLS; nothing else needed.
	if not enabled:
		for body in [_puck, _mallet_bottom, _mallet_top]:
			if body == null:
				continue
			for ch in body.get_children():
				if ch.name.begins_with("Halo"):
					ch.queue_free()


func _configure_environment(use_bloom: bool) -> void:
	if _env == null:
		return
	if not use_bloom:
		_env.environment = null
		return
	var e := Environment.new()
	e.background_mode = Environment.BG_CANVAS
	e.glow_enabled = true
	e.glow_intensity = 0.4 + tunables.glow_intensity * 1.4
	e.glow_strength = 0.8 + tunables.glow_intensity * 0.6
	e.glow_bloom = 0.15 + tunables.glow_intensity * 0.55
	e.glow_blend_mode = Environment.GLOW_BLEND_MODE_ADDITIVE
	e.glow_hdr_threshold = 0.55
	e.tonemap_mode = Environment.TONE_MAPPER_ACES
	_env.environment = e
