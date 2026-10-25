extends Node2D

## Applies selectable neon-glow and starfield looks on top of the physics scene.
## Glow 0 = additive halo shells (Polygon2D); Glow 1 = HDR 2D + WorldEnvironment bloom.
## Both modes also draw a soft additive outer aura so glow is obvious in play.

enum GlowApproach { HALO_SHELLS, ENV_BLOOM }

const TABLE_BASE := Color(0.03, 0.04, 0.08, 0.94)
# HDR-friendly neon (channels > 1 feed bloom when hdr_2d is on).
const WALL_NEON := Color(0.35, 1.6, 2.2, 1.0)
const PUCK_NEON := Color(1.4, 1.5, 1.8, 1.0)
const MALLET_P1 := Color(0.2, 1.4, 2.0, 1.0)
const MALLET_P2 := Color(2.0, 0.45, 0.85, 1.0)

var tunables: PoCTunables
var _table: Rect2
var _wall_thickness: float
var _goal_width: float

var _starfield: Node2D
var _space_bg: ColorRect
var _env: WorldEnvironment
var _table_fill: Polygon2D
var _table_edge: Line2D
var _table_glow: Line2D
var _center_line: Line2D
var _walls: Node2D
var _puck: RigidBody2D
var _mallet_bottom: RigidBody2D
var _mallet_top: RigidBody2D
var _add_mat: CanvasItemMaterial


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
	_add_mat = CanvasItemMaterial.new()
	_add_mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	# Stack above the opaque table. Child z_index is relative — negative values
	# become absolute z below TableFill and the glow vanishes under the arena.
	if _table_fill != null:
		_table_fill.z_index = 0
	z_index = 2 ## table neon edges / center line
	if _walls != null:
		_walls.z_index = 4
	for body in [_puck, _mallet_bottom, _mallet_top]:
		if body != null:
			body.z_index = 8
	_ensure_table_lines()
	_apply()
	if not tunables.aesthetics_changed.is_connected(_apply):
		tunables.aesthetics_changed.connect(_apply)


func _ensure_table_lines() -> void:
	if _table_edge == null or not is_instance_valid(_table_edge):
		_table_edge = Line2D.new()
		_table_edge.name = "TableNeonEdge"
		_table_edge.width = 3.0
		_table_edge.default_color = WALL_NEON
		_table_edge.z_index = 2
		_table_edge.antialiased = true
		add_child(_table_edge)
	if _table_glow == null or not is_instance_valid(_table_glow):
		_table_glow = Line2D.new()
		_table_glow.name = "TableNeonGlow"
		_table_glow.width = 14.0
		_table_glow.default_color = Color(WALL_NEON.r, WALL_NEON.g, WALL_NEON.b, 0.45)
		_table_glow.z_index = 1
		_table_glow.antialiased = true
		_table_glow.material = _add_mat
		add_child(_table_glow)
	if _center_line == null or not is_instance_valid(_center_line):
		_center_line = Line2D.new()
		_center_line.name = "CenterNeonLine"
		_center_line.width = 2.0
		_center_line.default_color = Color(0.4, 1.2, 1.6, 0.55)
		_center_line.z_index = 2
		_center_line.antialiased = true
		_center_line.material = _add_mat
		add_child(_center_line)
	var p := _table.position
	var s := _table.size
	var loop := PackedVector2Array([
		p, p + Vector2(s.x, 0), p + s, p + Vector2(0, s.y), p
	])
	_table_edge.points = loop
	_table_glow.points = loop
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
		_space_bg.color = Color(0.015, 0.02, 0.05, 1.0)

	var sat := tunables.neon_saturation
	var wall_c := _sat_color(WALL_NEON, sat)
	var puck_c := _sat_color(PUCK_NEON, sat)
	var p1_c := _sat_color(MALLET_P1, sat)
	var p2_c := _sat_color(MALLET_P2, sat)
	var intensity := tunables.glow_intensity

	if _table_fill != null:
		_table_fill.color = TABLE_BASE
	if _table_edge != null:
		_table_edge.default_color = Color(wall_c.r, wall_c.g, wall_c.b, 1.0)
		_table_edge.width = 2.5 + intensity * 3.5
	if _table_glow != null:
		_table_glow.default_color = Color(wall_c.r, wall_c.g, wall_c.b, 0.25 + intensity * 0.55)
		_table_glow.width = 8.0 + intensity * 22.0
		_table_glow.visible = true
	if _center_line != null:
		_center_line.default_color = Color(wall_c.r, wall_c.g, wall_c.b, 0.35 + intensity * 0.5)
		_center_line.width = 1.5 + intensity * 2.5

	_tint_walls(wall_c)
	_style_disk(_puck, puck_c, 18.0)
	_style_disk(_mallet_bottom, p1_c, 36.0)
	_style_disk(_mallet_top, p2_c, 36.0)

	var use_bloom := tunables.glow_approach == GlowApproach.ENV_BLOOM
	_configure_environment(use_bloom)


func _sat_color(c: Color, sat: float) -> Color:
	# Keep HDR headroom while dialing saturation toward a mid gray of similar luminance.
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
			if ch is Line2D and str(ch.name).begins_with("Neon"):
				to_free.append(ch)
			elif ch is Polygon2D:
				# Bright neon fill so bloom / additive rims read as lit rails.
				(ch as Polygon2D).color = Color(
					neon.r * (0.55 + intensity * 0.55),
					neon.g * (0.55 + intensity * 0.55),
					neon.b * (0.55 + intensity * 0.55),
					1.0
				)
				poly_pts = (ch as Polygon2D).polygon
		for n in to_free:
			n.free()
		if poly_pts.size() < 3:
			continue
		var pts := PackedVector2Array()
		for v in poly_pts:
			pts.append(v)
		pts.append(poly_pts[0])

		# Soft additive outer glow first (under rim); keep z >= 0 so it stays above TableFill.
		var glow := Line2D.new()
		glow.name = "NeonGlow"
		glow.width = 10.0 + intensity * 28.0
		glow.default_color = Color(neon.r, neon.g, neon.b, 0.2 + intensity * 0.55)
		glow.z_index = 1
		glow.antialiased = true
		glow.material = _add_mat
		glow.points = pts
		body.add_child(glow)

		var rim := Line2D.new()
		rim.name = "NeonRim"
		rim.width = 2.0 + intensity * 3.0
		rim.default_color = Color(neon.r, neon.g, neon.b, 0.85)
		rim.z_index = 2
		rim.antialiased = true
		rim.points = pts
		body.add_child(rim)


func _style_disk(body: RigidBody2D, color: Color, radius: float) -> void:
	if body == null:
		return
	var vis := body.get_node_or_null("Visual") as Polygon2D
	if vis == null:
		return
	# Core stays readable; slight HDR lift for bloom.
	vis.color = Color(color.r, color.g, color.b, 1.0)
	vis.z_index = 10 ## above glow shells (never use negative z — sinks under TableFill)
	var hub := vis.get_node_or_null("Hub") as Polygon2D
	if hub != null:
		hub.color = Color(color.r * 0.45, color.g * 0.45, color.b * 0.45, 1.0)

	# Clear prior glow nodes immediately (avoid deferred duplicates).
	for ch in body.get_children():
		if str(ch.name).begins_with("Halo") or str(ch.name).begins_with("Aura"):
			ch.free()

	var intensity := tunables.glow_intensity
	var use_shells := tunables.glow_approach == GlowApproach.HALO_SHELLS

	# Soft additive aura always present so glow is never "missing".
	_add_aura(body, color, radius, intensity)

	if not use_shells:
		return

	# Extra concentric additive shells for the Halo approach (z 1..5 under Visual@10).
	var layers := 5
	for i in layers:
		var halo := Polygon2D.new()
		halo.name = "Halo%d" % i
		# Outer layers first (lower z); i=0 closest to disk.
		var scale := 1.2 + float(i) * (0.45 + intensity * 0.4)
		var pts := PackedVector2Array()
		var n := 36
		for k in n:
			var a := TAU * float(k) / float(n)
			pts.append(Vector2(cos(a), sin(a)) * radius * scale)
		halo.polygon = pts
		var alpha := (0.55 - float(i) * 0.08) * (0.45 + intensity * 0.7)
		halo.color = Color(color.r, color.g, color.b, clampf(alpha, 0.08, 0.85))
		halo.z_index = 5 - i ## outer = lower z, still >= 0
		halo.material = _add_mat
		body.add_child(halo)


func _add_aura(body: RigidBody2D, color: Color, radius: float, intensity: float) -> void:
	var aura := Polygon2D.new()
	aura.name = "Aura"
	var scale := 1.55 + intensity * 1.1
	var pts := PackedVector2Array()
	for k in 40:
		var a := TAU * float(k) / 40.0
		pts.append(Vector2(cos(a), sin(a)) * radius * scale)
	aura.polygon = pts
	aura.color = Color(color.r, color.g, color.b, 0.2 + intensity * 0.45)
	aura.z_index = 1 ## above TableFill via parent z; under Visual
	aura.material = _add_mat
	body.add_child(aura)

	# Tight bright ring just outside the disk.
	var ring := Line2D.new()
	ring.name = "AuraRing"
	ring.width = 2.0 + intensity * 4.0
	ring.default_color = Color(color.r, color.g, color.b, 0.7 + intensity * 0.3)
	ring.z_index = 11
	ring.antialiased = true
	ring.material = _add_mat
	var rpts := PackedVector2Array()
	for k in 41:
		var a := TAU * float(k) / 40.0
		rpts.append(Vector2(cos(a), sin(a)) * radius * 1.08)
	ring.points = rpts
	body.add_child(ring)


func _configure_environment(use_bloom: bool) -> void:
	if _env == null:
		return
	if not use_bloom:
		_env.environment = null
		return
	var e := Environment.new()
	e.background_mode = Environment.BG_CANVAS
	e.glow_enabled = true
	e.glow_normalized = true
	e.glow_intensity = 1.0 + tunables.glow_intensity * 2.2
	e.glow_strength = 1.0 + tunables.glow_intensity * 1.2
	e.glow_bloom = 0.35 + tunables.glow_intensity * 0.85
	e.glow_blend_mode = Environment.GLOW_BLEND_MODE_ADDITIVE
	e.glow_hdr_threshold = 0.35
	e.glow_hdr_scale = 1.5
	for level in range(1, 8):
		e.set("glow_levels/%d" % level, true)
	e.tonemap_mode = Environment.TONE_MAPPER_ACES
	e.tonemap_exposure = 0.95
	_env.environment = e
