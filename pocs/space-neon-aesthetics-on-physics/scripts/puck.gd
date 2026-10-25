extends RigidBody2D

## Puck: RigidBody2D with live mass/bounce/damp/max-speed.
## Flight bleed is explicit from puck_linear_damp only (engine damp = 0).
## Wall/mallet restitution uses PhysicsMaterial bounce (engine solver).

var tunables: PoCTunables


func setup(t: PoCTunables) -> void:
	tunables = t
	gravity_scale = 0.0
	lock_rotation = true
	continuous_cd = RigidBody2D.CCD_MODE_CAST_SHAPE
	contact_monitor = true
	max_contacts_reported = 4
	linear_damp_mode = RigidBody2D.DAMP_MODE_REPLACE
	angular_damp_mode = RigidBody2D.DAMP_MODE_REPLACE
	linear_damp = 0.0
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
	# Engine damp stays 0 — flight bleed is applied in _integrate_forces only.
	linear_damp = 0.0
	var mat := PhysicsMaterial.new()
	mat.bounce = tunables.puck_bounce
	mat.friction = 0.0
	mat.absorbent = false
	physics_material_override = mat


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if tunables == null:
		return
	var v := state.linear_velocity

	# Intentional flight bleed — only from the damp slider (0 = no damp bleed).
	var damp := tunables.puck_linear_damp
	if damp > 0.0:
		v *= exp(-damp * state.step)

	var max_s := tunables.puck_max_speed
	if v.length() > max_s:
		v = v.normalized() * max_s

	state.linear_velocity = v


func reset_to(pos: Vector2) -> void:
	global_position = pos
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0
