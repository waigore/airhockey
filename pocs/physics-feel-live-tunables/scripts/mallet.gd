extends RigidBody2D

## Mallet: critically damped follow toward mouse/keys (avoids spring jitter).

enum ControlMode { MOUSE, KEYS }

const SETTLE_PX := 2.5
const TARGET_SMOOTH := 28.0 ## higher = snappier cursor tracking, still filtered

@export var control_mode: ControlMode = ControlMode.MOUSE
@export var play_half: String = "left" ## "left" or "right" — clamps target to that half

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
	# Follow damping is applied in the controller; keep engine damp low so it
	# does not fight the critically damped spring.
	linear_damp_mode = RigidBody2D.DAMP_MODE_REPLACE
	var color := Color(0.3, 0.75, 1.0, 1.0) if play_half == "left" else Color(1.0, 0.45, 0.35, 1.0)
	_ensure_visual(color, 36.0)
	_apply()
	tunables.changed.connect(_apply)


func _ensure_visual(color: Color, radius: float) -> void:
	if has_node("Visual"):
		return
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
	# Engine linear damp kept near-zero; tunable damp feeds the controller.
	linear_damp = 0.0
	var mat := PhysicsMaterial.new()
	mat.bounce = 0.15
	mat.friction = 0.02
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
	var k := tunables.mallet_drive
	# Critical damping for spring-mass: c = 2*sqrt(k*m), plus tunable extra.
	var c := 2.0 * sqrt(maxf(k * mass, 0.0001)) + tunables.mallet_linear_damp * 40.0
	if dist < SETTLE_PX:
		# Brake only — kills orbit/jitter when the cursor is on the mallet.
		state.linear_velocity = state.linear_velocity.move_toward(Vector2.ZERO, c * state.step / maxf(mass, 0.001))
		return
	var force := to_t * k - state.linear_velocity * c
	state.apply_central_force(force)
	var v := state.linear_velocity
	var max_s := tunables.mallet_max_speed
	if v.length() > max_s:
		state.linear_velocity = v.normalized() * max_s


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
	var mid_x := r.position.x + r.size.x * 0.5
	var margin := 28.0
	var min_x: float
	var max_x: float
	if play_half == "left":
		min_x = r.position.x + margin
		max_x = mid_x - 4.0
	else:
		min_x = mid_x + 4.0
		max_x = r.position.x + r.size.x - margin
	var min_y := r.position.y + margin
	var max_y := r.position.y + r.size.y - margin
	return Vector2(clampf(p.x, min_x, max_x), clampf(p.y, min_y, max_y))
