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
var _frame_edge: Line2D
var _frame_glow: Line2D
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
		_table_edge = _make_line("TableNeonEdge", 2.0, WALL_NEON, 3, false)
	if _table_glow == null or not is_instance_valid(_table_glow):
		_table_glow = _make_line("TableNeonGlow", 5.0, Color(WALL_NEON.r, WALL_NEON.g, WALL_NEON.b, 0.35), 2, true)
	if _frame_edge == null or not is_instance_valid(_frame_edge):
		_frame_edge = _make_line("FrameNeonEdge", 2.0, WALL_NEON, 5, false)
	if _frame_glow == null or not is_instance_valid(_frame_glow):
		_frame_glow = _make_line("FrameNeonGlow", 5.0, Color(WALL_NEON.r, WALL_NEON.g, WALL_NEON.b, 0.35), 4, true)
	if _center_line == null or not is_instance_valid(_center_line):
		_center_line = _make_line("CenterNeonLine", 1.5, Color(0.4, 1.1, 1.4, 0.4), 3, true)

	var p := _table.position
	var s := _table.size
	var inner := PackedVector2Array([
		p, p + Vector2(s.x, 0), p + s, p + Vector2(0, s.y), p
	])
	_table_edge.points = inner
	_table_glow.points = inner
	var frame := _outer_frame_points(_table, _wall_thickness, _goal_width)
	_frame_edge.points = frame
	_frame_glow.points = frame
	var mid_y := p.y + s.y * 0.5
	_center_line.points = PackedVector2Array([
		Vector2(p.x + 8.0, mid_y), Vector2(p.x + s.x - 8.0, mid_y)
	])


func _make_line(line_name: String, width: float, color: Color, z: int, additive: bool) -> Line2D:
	var line := Line2D.new()
	line.name = line_name
	line.width = width
	line.default_color = color
	line.z_index = z
	line.antialiased = true
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	if additive:
		line.material = _add_mat
	add_child(line)
	return line


func _outer_frame_points(table: Rect2, th: float, goal_w: float) -> PackedVector2Array:
	## Continuous outer wall silhouette with goal notches — no per-segment seams.
	var x0 := table.position.x
	var y0 := table.position.y
	var x1 := x0 + table.size.x
	var y1 := y0 + table.size.y
	var mid := x0 + table.size.x * 0.5
	var gl := mid - goal_w * 0.5
	var gr := mid + goal_w * 0.5
	var ox0 := x0 - th
	var oy0 := y0 - th
	var ox1 := x1 + th
	var oy1 := y1 + th
	# Clockwise from outer top-left, dipping in at goal mouths.
	return PackedVector2Array([
		Vector2(ox0, oy0),
		Vector2(gl, oy0),
		Vector2(gl, y0),
		Vector2(gr, y0),
		Vector2(gr, oy0),
		Vector2(ox1, oy0),
		Vector2(ox1, oy1),
		Vector2(gr, oy1),
		Vector2(gr, y1),
		Vector2(gl, y1),
		Vector2(gl, oy1),
		Vector2(ox0, oy1),
		Vector2(ox0, oy0),
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
	var core_w := 1.5 + intensity * 1.5
	var fringe_w := 3.5 + intensity * 5.0
	var fringe_a := 0.18 + intensity * 0.28
	if _table_edge != null:
		_table_edge.default_color = Color(wall_c.r, wall_c.g, wall_c.b, 1.0)
		_table_edge.width = core_w
	if _table_glow != null:
		_table_glow.default_color = Color(wall_c.r, wall_c.g, wall_c.b, fringe_a)
		_table_glow.width = fringe_w
		_table_glow.visible = true
	if _frame_edge != null:
		_frame_edge.default_color = Color(wall_c.r, wall_c.g, wall_c.b, 1.0)
		_frame_edge.width = core_w
	if _frame_glow != null:
		_frame_glow.default_color = Color(wall_c.r, wall_c.g, wall_c.b, fringe_a)
		_frame_glow.width = fringe_w
		_frame_glow.visible = true
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
	## Fill only — neon outline is the continuous frame Line2D (avoids corner seams).
	if _walls == null:
		return
	var intensity := tunables.glow_intensity
	for body in _walls.get_children():
		for ch in body.get_children():
			if ch is Line2D and str(ch.name).begins_with("Neon"):
				ch.free() ## leftover from older rim approach
			elif ch is Polygon2D:
				(ch as Polygon2D).color = Color(
					neon.r * (0.22 + intensity * 0.18),
					neon.g * (0.22 + intensity * 0.18),
					neon.b * (0.22 + intensity * 0.18),
					1.0
				)


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
