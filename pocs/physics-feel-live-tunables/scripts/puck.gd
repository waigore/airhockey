extends RigidBody2D

## Puck: RigidBody2D with live mass/bounce/damp/max-speed.

var tunables: PoCTunables


func setup(t: PoCTunables) -> void:
	tunables = t
	gravity_scale = 0.0
	lock_rotation = true
	# Shape CCD: ray CCD can miss/soft-resolve fast circle-vs-box wall hits.
	continuous_cd = RigidBody2D.CCD_MODE_CAST_SHAPE
	contact_monitor = true
	max_contacts_reported = 4
	# Damp must not fight restitution (Godot still bleeds energy if damp > 0).
	linear_damp_mode = RigidBody2D.DAMP_MODE_REPLACE
	angular_damp_mode = RigidBody2D.DAMP_MODE_REPLACE
	angular_damp = 0.0
	_ensure_visual(Color(0.95, 0.95, 1.0, 1.0), 18.0)
	_apply()
	if not tunables.changed.is_connected(_apply):
		tunables.changed.connect(_apply)


func _ensure_visual(color: Color, radius: float) -> void:
	if has_node("Visual"):
		return
	var vis := Polygon2D.new()
	vis.name = "Visual"
	vis.color = color
	var pts := PackedVector2Array()
	for i in 24:
		var a := TAU * float(i) / 24.0
		pts.append(Vector2(cos(a), sin(a)) * radius)
	vis.polygon = pts
	add_child(vis)


func _apply() -> void:
	if tunables == null:
		return
	mass = tunables.puck_mass
	linear_damp = tunables.puck_linear_damp
	var mat := PhysicsMaterial.new()
	mat.bounce = tunables.puck_bounce
	mat.friction = 0.0
	physics_material_override = mat


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if tunables == null:
		return
	var v := state.linear_velocity
	var max_s := tunables.puck_max_speed
	if v.length() > max_s:
		state.linear_velocity = v.normalized() * max_s


func reset_to(pos: Vector2) -> void:
	global_position = pos
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0
