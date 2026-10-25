extends Node2D

## Applies selectable neon-glow and starfield looks on top of the physics scene.
## Glow 0 = tight additive ring shells (rapid edge falloff); Glow 1 = focused HDR bloom.
## Neon look: bright core + short exponential fade — not a wide diffuse wash.

enum GlowApproach { HALO_SHELLS, ENV_BLOOM }

const TABLE_BASE := Color(0.03, 0.04, 0.08, 0.94)
# Modest HDR lift (enough for bloom; not a fog).
const WALL_NEON := Color(0.3, 1.25, 1.7, 1.0)
const PUCK_NEON := Color(1.15, 1.2, 1.35, 1.0)
const MALLET_P1 := Color(0.25, 1.15, 1.55, 1.0)
const MALLET_P2 := Color(1.55, 0.4, 0.7, 1.0)

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
		_table_edge.width = 2.0
		_table_edge.default_color = WALL_NEON
		_table_edge.z_index = 2
		_table_edge.antialiased = true
		add_child(_table_edge)
	if _table_glow == null or not is_instance_valid(_table_glow):
		_table_glow = Line2D.new()
		_table_glow.name = "TableNeonGlow"
		_table_glow.width = 5.0
		_table_glow.default_color = Color(WALL_NEON.r, WALL_NEON.g, WALL_NEON.b, 0.35)
		_table_glow.z_index = 1
		_table_glow.antialiased = true
		_table_glow.material = _add_mat
		add_child(_table_glow)
	if _center_line == null or not is_instance_valid(_center_line):
		_center_line = Line2D.new()
		_center_line.name = "CenterNeonLine"
		_center_line.width = 1.5
		_center_line.default_color = Color(0.4, 1.1, 1.4, 0.4)
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
		# Bright tube core.
		_table_edge.default_color = Color(wall_c.r, wall_c.g, wall_c.b, 1.0)
		_table_edge.width = 1.5 + intensity * 1.5
	if _table_glow != null:
		# Short outer fade only (not a wide wash).
		_table_glow.default_color = Color(wall_c.r, wall_c.g, wall_c.b, 0.18 + intensity * 0.28)
		_table_glow.width = 3.5 + intensity * 5.0
		_table_glow.visible = true
	if _center_line != null:
		_center_line.default_color = Color(wall_c.r, wall_c.g, wall_c.b, 0.25 + intensity * 0.3)
		_center_line.width = 1.0 + intensity * 1.0

	_tint_walls(wall_c)
	_style_disk(_puck, puck_c, 18.0)
	_style_disk(_mallet_bottom, p1_c, 36.0)
	_style_disk(_mallet_top, p2_c, 36.0)

	var use_bloom := tunables.glow_approach == GlowApproach.ENV_BLOOM
	_configure_environment(use_bloom)


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
			if ch is Line2D and str(ch.name).begins_with("Neon"):
				to_free.append(ch)
			elif ch is Polygon2D:
				# Dimmer rail body; neon lives in the rim/glow lines.
				(ch as Polygon2D).color = Color(
					neon.r * (0.25 + intensity * 0.2),
					neon.g * (0.25 + intensity * 0.2),
					neon.b * (0.25 + intensity * 0.2),
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

		# Tight additive fringe, then bright core rim on top.
		var glow := Line2D.new()
		glow.name = "NeonGlow"
		glow.width = 3.0 + intensity * 5.0
		glow.default_color = Color(neon.r, neon.g, neon.b, 0.15 + intensity * 0.3)
		glow.z_index = 1
		glow.antialiased = true
		glow.material = _add_mat
		glow.points = pts
		body.add_child(glow)

		var rim := Line2D.new()
		rim.name = "NeonRim"
		rim.width = 1.25 + intensity * 1.5
		rim.default_color = Color(neon.r, neon.g, neon.b, 0.95)
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
	vis.color = Color(color.r, color.g, color.b, 1.0)
	vis.z_index = 10 ## above glow (never use negative z — sinks under TableFill)
	var hub := vis.get_node_or_null("Hub") as Polygon2D
	if hub != null:
		hub.color = Color(color.r * 0.4, color.g * 0.4, color.b * 0.4, 1.0)

	for ch in body.get_children():
		if str(ch.name).begins_with("Halo") or str(ch.name).begins_with("Aura"):
			ch.free()

	var intensity := tunables.glow_intensity
	var use_shells := tunables.glow_approach == GlowApproach.HALO_SHELLS

	# Always: bright core ring + 1–2 rapid-falloff rings (tube neon).
	_add_focused_rings(body, color, radius, intensity, 3 if use_shells else 2)


func _add_focused_rings(
	body: RigidBody2D,
	color: Color,
	radius: float,
	intensity: float,
	ring_count: int
) -> void:
	## Exponential falloff rings just outside the disk — focused, not diffuse fill.
	## Offsets in multiples of radius; alpha *= falloff each step.
	var base_alpha := 0.55 + intensity * 0.4
	var falloff := 0.32 ## rapid edge fade
	var step := 0.045 + intensity * 0.025 ## how far each ring steps out
	var base_width := 1.4 + intensity * 1.6

	for i in ring_count:
		var t := float(i)
		var scale := 1.02 + step * t
		var alpha := base_alpha * pow(falloff, t)
		var width := base_width * pow(0.7, t)
		var ring := Line2D.new()
		ring.name = "AuraRing%d" % i if i > 0 else "AuraRing"
		ring.width = maxf(width, 0.6)
		ring.default_color = Color(color.r, color.g, color.b, clampf(alpha, 0.04, 0.95))
		ring.z_index = 11 - i
		ring.antialiased = true
		ring.material = _add_mat
		ring.points = _circle_points(radius * scale, 48)
		body.add_child(ring)

	# Optional innermost white-hot core (reads as tube filament).
	var core := Line2D.new()
	core.name = "AuraCore"
	core.width = 0.8 + intensity * 0.6
	core.default_color = Color(
		minf(color.r * 1.35, 2.0),
		minf(color.g * 1.35, 2.0),
		minf(color.b * 1.35, 2.0),
		0.75 + intensity * 0.2
	)
	core.z_index = 12
	core.antialiased = true
	core.material = _add_mat
	core.points = _circle_points(radius * 1.01, 48)
	body.add_child(core)


func _circle_points(r: float, n: int) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for k in n + 1:
		var a := TAU * float(k) / float(n)
		pts.append(Vector2(cos(a), sin(a)) * r)
	return pts


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
	# Focused bloom: mild, high threshold, prefer fine levels (less fog).
	e.glow_intensity = 0.45 + tunables.glow_intensity * 0.7
	e.glow_strength = 0.7 + tunables.glow_intensity * 0.5
	e.glow_bloom = 0.08 + tunables.glow_intensity * 0.22
	e.glow_blend_mode = Environment.GLOW_BLEND_MODE_ADDITIVE
	e.glow_hdr_threshold = 0.75
	e.glow_hdr_scale = 0.7
	for level in range(1, 8):
		# Fine levels on; coarser levels off to avoid wide haze.
		e.set("glow_levels/%d" % level, level <= 3)
	e.tonemap_mode = Environment.TONE_MAPPER_ACES
	e.tonemap_exposure = 1.0
	_env.environment = e
