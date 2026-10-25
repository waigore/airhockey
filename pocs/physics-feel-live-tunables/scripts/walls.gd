extends Node2D

## Static table walls with live bounce. Goal gaps on the short (left/right) ends.
## Segments are non-overlapping so a corner hit is one contact (not two that cancel speed).

var tunables: PoCTunables
var _bodies: Array[StaticBody2D] = []


func setup(t: PoCTunables, table: Rect2, wall_thickness: float, goal_width: float) -> void:
	tunables = t
	for c in get_children():
		c.queue_free()
	_bodies.clear()
	_build(table, wall_thickness, goal_width)
	_apply()
	if not tunables.changed.is_connected(_apply):
		tunables.changed.connect(_apply)


func _build(table: Rect2, th: float, goal_w: float) -> void:
	var x0 := table.position.x
	var y0 := table.position.y
	var w := table.size.x
	var h := table.size.y
	var mid_y := y0 + h * 0.5
	var half_goal := goal_w * 0.5
	# Top/bottom: table width only (do not overlap side rails).
	_add_rect(Vector2(x0 + w * 0.5, y0 - th * 0.5), Vector2(w, th))
	_add_rect(Vector2(x0 + w * 0.5, y0 + h + th * 0.5), Vector2(w, th))
	# Left/right: two segments around the goal, flush with the table y-range.
	var seg_h := (h - goal_w) * 0.5
	_add_rect(Vector2(x0 - th * 0.5, mid_y - half_goal - seg_h * 0.5), Vector2(th, seg_h))
	_add_rect(Vector2(x0 - th * 0.5, mid_y + half_goal + seg_h * 0.5), Vector2(th, seg_h))
	_add_rect(Vector2(x0 + w + th * 0.5, mid_y - half_goal - seg_h * 0.5), Vector2(th, seg_h))
	_add_rect(Vector2(x0 + w + th * 0.5, mid_y + half_goal + seg_h * 0.5), Vector2(th, seg_h))


func _add_rect(center: Vector2, size: Vector2) -> void:
	var body := StaticBody2D.new()
	body.position = center
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = size
	shape.shape = rect
	body.add_child(shape)
	var vis := Polygon2D.new()
	var hx := size.x * 0.5
	var hy := size.y * 0.5
	vis.polygon = PackedVector2Array([
		Vector2(-hx, -hy), Vector2(hx, -hy), Vector2(hx, hy), Vector2(-hx, hy)
	])
	vis.color = Color(0.35, 0.55, 0.75, 1.0)
	body.add_child(vis)
	add_child(body)
	_bodies.append(body)


func _apply() -> void:
	if tunables == null:
		return
	var mat := PhysicsMaterial.new()
	mat.bounce = tunables.wall_bounce
	mat.friction = 0.0
	mat.absorbent = false
	for b in _bodies:
		b.physics_material_override = mat
