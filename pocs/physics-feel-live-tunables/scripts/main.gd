extends Node2D

## PoC root: portrait table, goals top/bottom, P1 bottom, live tunables panel.

# Portrait playfield ~2:1 length:width (standard air-hockey proportions).
const TABLE := Rect2(250, 8, 360, 704)
const WALL_THICKNESS := 24.0
const GOAL_WIDTH := 130.0

var tunables := PoCTunables.new()

@onready var walls: Node2D = $Walls
@onready var puck: RigidBody2D = $Puck
@onready var mallet_bottom: RigidBody2D = $MalletBottom
@onready var mallet_top: RigidBody2D = $MalletTop
@onready var panel: PanelContainer = $CanvasLayer/TunablesPanel
@onready var table_fill: Polygon2D = $TableFill


func _ready() -> void:
	var p := TABLE.position
	var s := TABLE.size
	table_fill.polygon = PackedVector2Array([
		p, p + Vector2(s.x, 0), p + s, p + Vector2(0, s.y)
	])
	table_fill.color = Color(0.08, 0.12, 0.18, 1.0)

	# P1 bottom (mouse), P2 top (keys).
	mallet_bottom.control_mode = 0 ## MOUSE
	mallet_bottom.play_half = "bottom"
	mallet_bottom.tint = Color(0.3, 0.75, 1.0, 1.0)
	mallet_top.control_mode = 1 ## KEYS
	mallet_top.play_half = "top"
	mallet_top.tint = Color(1.0, 0.45, 0.35, 1.0)

	walls.setup(tunables, TABLE, WALL_THICKNESS, GOAL_WIDTH)
	puck.setup(tunables)
	mallet_bottom.setup(tunables, TABLE)
	mallet_top.setup(tunables, TABLE)
	panel.setup(tunables)
	panel.reset_puck_pressed.connect(_reset_puck)

	_reset_positions()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_R:
			_reset_positions()


func _reset_puck() -> void:
	puck.reset_to(TABLE.get_center())


func _reset_positions() -> void:
	var mid := TABLE.get_center()
	puck.reset_to(mid)
	mallet_bottom.snap_to(Vector2(mid.x, TABLE.position.y + TABLE.size.y * 0.75))
	mallet_top.snap_to(Vector2(mid.x, TABLE.position.y + TABLE.size.y * 0.25))


func _process(_delta: float) -> void:
	# Soft reclaim if puck leaves far through a goal
	if not TABLE.grow(80.0).has_point(puck.global_position):
		_reset_puck()
