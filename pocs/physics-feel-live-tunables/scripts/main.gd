extends Node2D

## PoC root: table, walls/goals, two mallets, puck, live tunables panel.

const TABLE := Rect2(160, 80, 960, 560)
const WALL_THICKNESS := 24.0
const GOAL_WIDTH := 160.0
const PUCK_RADIUS := 18.0
const MALLET_RADIUS := 36.0

var tunables := PoCTunables.new()

@onready var walls: Node2D = $Walls
@onready var puck: RigidBody2D = $Puck
@onready var mallet_left: RigidBody2D = $MalletLeft
@onready var mallet_right: RigidBody2D = $MalletRight
@onready var panel: PanelContainer = $CanvasLayer/TunablesPanel
@onready var table_fill: Polygon2D = $TableFill


func _ready() -> void:
	var p := TABLE.position
	var s := TABLE.size
	table_fill.polygon = PackedVector2Array([
		p, p + Vector2(s.x, 0), p + s, p + Vector2(0, s.y)
	])
	table_fill.color = Color(0.08, 0.12, 0.18, 1.0)

	walls.setup(tunables, TABLE, WALL_THICKNESS, GOAL_WIDTH)
	puck.setup(tunables)
	mallet_left.setup(tunables, TABLE)
	mallet_right.setup(tunables, TABLE)
	panel.setup(tunables)

	_reset_positions()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_R:
			_reset_positions()


func _reset_positions() -> void:
	var mid := TABLE.get_center()
	puck.reset_to(mid)
	mallet_left.snap_to(Vector2(TABLE.position.x + TABLE.size.x * 0.25, mid.y))
	mallet_right.snap_to(Vector2(TABLE.position.x + TABLE.size.x * 0.75, mid.y))


func _process(_delta: float) -> void:
	# Soft reclaim if puck leaves far through a goal
	if not TABLE.grow(80.0).has_point(puck.global_position):
		_reset_positions()
