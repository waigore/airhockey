extends RigidBody2D

## Mallet: velocity follow toward mouse/keys (no spring — avoids jitter/ghosting).

enum ControlMode { MOUSE, KEYS }

const SETTLE_PX := 3.0
const TARGET_SMOOTH := 30.0

@export var control_mode: ControlMode = ControlMode.MOUSE
@export var play_half: String = "bottom" ## "bottom" (P1) or "top" (P2)
@export var tint: Color = Color(0.3, 0.75, 1.0, 1.0)

var tunables: PoCTunables
var _key_target: Vector2 = Vector2.ZERO
var _follow_target: Vector2 = Vector2.ZERO
var _table_rect: Rect2 = Rect2()


func setup(t: PoCTunables, table: Rect2) -> void:
	tunables = t
	_table_rect = table
	_key_target = global_position
	_follow_target = global_position
	gravity_scale = 0.0
	lock_rotation = true
	continuous_cd = RigidBody2D.CCD_MODE_CAST_RAY
	physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	linear_damp_mode = RigidBody2D.DAMP_MODE_REPLACE
	_ensure_visual(tint, 36.0)
	_apply()
	if not tunables.changed.is_connected(_apply):
		tunables.changed.connect(_apply)


func _ensure_visual(color: Color, radius: float) -> void:
	# Drop any prior polygons (hot-reload / double-setup) so we never stack disks.
	for ch in get_children():
		if ch is Polygon2D:
			ch.free()
	var vis := Polygon2D.new()
	vis.name = "Visual"
	vis.color = color
	var pts := PackedVector2Array()
	for i in 28:
		var a := TAU * float(i) / 28.0
		pts.append(Vector2(cos(a), sin(a)) * radius)
	vis.polygon = pts
	add_child(vis)
	var hub := Polygon2D.new()
	hub.name = "Hub"
	hub.color = color.darkened(0.35)
	var hub_pts := PackedVector2Array()
	for i in 16:
		var a := TAU * float(i) / 16.0
		hub_pts.append(Vector2(cos(a), sin(a)) * (radius * 0.35))
	hub.polygon = hub_pts
	vis.add_child(hub)


func _apply() -> void:
	if tunables == null:
		return
	mass = tunables.mallet_mass
	linear_damp = 0.0
	var mat := PhysicsMaterial.new()
	mat.bounce = 0.85
	mat.friction = 0.0
	mat.absorbent = false
	physics_material_override = mat


func _physics_process(delta: float) -> void:
	if tunables == null:
		return
	var raw := _resolve_raw_target()
	var a := 1.0 - exp(-TARGET_SMOOTH * delta)
	_follow_target = _follow_target.lerp(raw, a)


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if tunables == null:
		return
	var to_t := _follow_target - state.transform.origin
	var dist := to_t.length()
	if dist < SETTLE_PX:
		state.linear_velocity = Vector2.ZERO
		return
	# Drive = follow gain (1/s). Desired velocity toward target, hard-assigned
	# so the controller cannot spring-oscillate into a double image.
	var gain := tunables.mallet_drive / 200.0 ## 3200 → ~16 /s
	gain = maxf(gain, 1.0)
	var desired := to_t * gain
	var max_s := tunables.mallet_max_speed
	if desired.length() > max_s:
		desired = desired.normalized() * max_s
	# Extra tunable damp blends toward desired (1 = instant).
	var blend := 1.0 - exp(-(12.0 + tunables.mallet_linear_damp) * state.step)
	state.linear_velocity = state.linear_velocity.lerp(desired, blend)


func _resolve_raw_target() -> Vector2:
	var raw: Vector2
	if control_mode == ControlMode.MOUSE:
		raw = get_global_mouse_position()
	else:
		_update_key_target()
		raw = _key_target
	return _clamp_to_half(raw)


func _update_key_target() -> void:
	var dir := Vector2.ZERO
	if Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_A):
		dir.x -= 1.0
	if Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D):
		dir.x += 1.0
	if Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_W):
		dir.y -= 1.0
	if Input.is_key_pressed(KEY_DOWN) or Input.is_key_pressed(KEY_S):
		dir.y += 1.0
	if dir != Vector2.ZERO:
		_key_target += dir.normalized() * 14.0
	_key_target = _clamp_to_half(_key_target)


func snap_to(pos: Vector2) -> void:
	global_position = pos
	linear_velocity = Vector2.ZERO
	_key_target = pos
	_follow_target = pos


func _clamp_to_half(p: Vector2) -> Vector2:
	var r := _table_rect
	var mid_y := r.position.y + r.size.y * 0.5
	var margin := 28.0
	var min_x := r.position.x + margin
	var max_x := r.position.x + r.size.x - margin
	var min_y: float
	var max_y: float
	if play_half == "bottom":
		min_y = mid_y + 4.0
		max_y = r.position.y + r.size.y - margin
	else:
		min_y = r.position.y + margin
		max_y = mid_y - 4.0
	return Vector2(clampf(p.x, min_x, max_x), clampf(p.y, min_y, max_y))
