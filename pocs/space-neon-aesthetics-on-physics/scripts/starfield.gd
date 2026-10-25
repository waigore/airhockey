extends Node2D

## Two starfield approaches (Godot-native only): static _draw() dots, or twinkle particles.

enum Approach { STATIC_DRAW, TWINKLE_PARTICLES }

var approach: Approach = Approach.STATIC_DRAW
var density: float = 0.55
var brightness: float = 0.35
var twinkle: float = 0.6

var _stars: PackedVector2Array = PackedVector2Array()
var _star_sizes: PackedFloat32Array = PackedFloat32Array()
var _particles: CPUParticles2D
var _rng := RandomNumberGenerator.new()


func setup(viewport_size: Vector2) -> void:
	_rng.seed = 42
	_rebuild_star_points(viewport_size)
	_ensure_particles(viewport_size)
	_apply_visibility()
	queue_redraw()


func apply(approach_id: int, dens: float, bright: float, tw: float, viewport_size: Vector2) -> void:
	approach = Approach.STATIC_DRAW if approach_id == 0 else Approach.TWINKLE_PARTICLES
	density = clampf(dens, 0.0, 1.0)
	brightness = clampf(bright, 0.0, 1.0)
	twinkle = clampf(tw, 0.0, 1.0)
	_rebuild_star_points(viewport_size)
	_configure_particles(viewport_size)
	_apply_visibility()
	queue_redraw()


func _rebuild_star_points(viewport_size: Vector2) -> void:
	_stars.clear()
	_star_sizes.clear()
	var count := int(lerp(40.0, 220.0, density))
	for i in count:
		_stars.append(Vector2(_rng.randf() * viewport_size.x, _rng.randf() * viewport_size.y))
		_star_sizes.append(_rng.randf_range(0.6, 1.8))


func _ensure_particles(viewport_size: Vector2) -> void:
	if _particles != null and is_instance_valid(_particles):
		_configure_particles(viewport_size)
		return
	_particles = CPUParticles2D.new()
	_particles.name = "TwinkleParticles"
	_particles.z_index = -20
	_particles.emitting = false
	_particles.one_shot = false
	_particles.explosiveness = 0.0
	_particles.randomness = 0.7
	_particles.lifetime = 3.5
	_particles.preprocess = 2.0
	_particles.local_coords = true
	_particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	_particles.direction = Vector2(0, 0)
	_particles.spread = 180.0
	_particles.gravity = Vector2.ZERO
	_particles.initial_velocity_min = 0.0
	_particles.initial_velocity_max = 4.0
	_particles.angular_velocity_min = -20.0
	_particles.angular_velocity_max = 20.0
	_particles.scale_amount_min = 0.4
	_particles.scale_amount_max = 1.4
	# Default particle quad — no imported texture (Godot-native).
	add_child(_particles)
	_configure_particles(viewport_size)


func _configure_particles(viewport_size: Vector2) -> void:
	if _particles == null:
		return
	_particles.position = viewport_size * 0.5
	_particles.emission_rect_extents = viewport_size * 0.5
	var amount := int(lerp(30.0, 160.0, density))
	_particles.amount = maxi(amount, 8)
	var a := clampf(brightness * 0.55, 0.05, 0.85)
	var dip := clampf(1.0 - twinkle * 0.85, 0.15, 1.0)
	_particles.color = Color(0.85, 0.9, 1.0, a)
	# Twinkle via alpha over lifetime (Godot Gradient — no image texture).
	var grad := Gradient.new()
	grad.add_point(0.0, Color(1, 1, 1, a * dip))
	grad.add_point(0.4, Color(1, 1, 1, a))
	grad.add_point(0.75, Color(1, 1, 1, a * dip * 0.6))
	grad.add_point(1.0, Color(1, 1, 1, a * 0.9))
	_particles.color_ramp = grad


func _apply_visibility() -> void:
	if _particles != null:
		var use_p := approach == Approach.TWINKLE_PARTICLES
		_particles.emitting = use_p
		_particles.visible = use_p


func _draw() -> void:
	if approach != Approach.STATIC_DRAW:
		return
	var a := clampf(brightness * 0.7, 0.04, 0.9)
	for i in _stars.size():
		var p := _stars[i]
		var s := _star_sizes[i]
		draw_circle(p, s, Color(0.85, 0.9, 1.0, a))
		if s > 1.2:
			draw_circle(p, s * 0.35, Color(1.0, 1.0, 1.0, a * 1.2))
