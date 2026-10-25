extends Node2D

## PoC root: PoC 1 physics/arena baseline + selectable starfield/neon aesthetics.

# Portrait playfield ~2:1 length:width — locked to PoC 1 (do not retune/resize).
const TABLE := Rect2(250, 8, 360, 704)
const WALL_THICKNESS := 24.0
const GOAL_WIDTH := 130.0

var tunables := PoCTunables.new()

@onready var space_bg: ColorRect = $BgLayer/SpaceBackground
@onready var starfield: Node2D = $Starfield
@onready var aesthetics: Node2D = $Aesthetics
@onready var walls: Node2D = $Walls
@onready var puck: RigidBody2D = $Puck
@onready var mallet_bottom: RigidBody2D = $MalletBottom
@onready var mallet_top: RigidBody2D = $MalletTop
@onready var table_fill: Polygon2D = $TableFill
@onready var world_env: WorldEnvironment = $WorldEnvironment
@onready var physics_panel: PanelContainer = $CanvasLayer/TunablesPanel
@onready var aesthetics_panel: PanelContainer = $CanvasLayer/AestheticsPanel


func _ready() -> void:
	var p := TABLE.position
	var s := TABLE.size
	table_fill.polygon = PackedVector2Array([
		p, p + Vector2(s.x, 0), p + s, p + Vector2(0, s.y)
	])
	table_fill.color = Color(0.04, 0.06, 0.12, 0.92)

	space_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	space_bg.color = Color(0.02, 0.03, 0.07, 1.0)

	# P1 bottom (mouse), P2 top (keys).
	mallet_bottom.control_mode = 0 ## MOUSE
	mallet_bottom.play_half = "bottom"
	mallet_bottom.tint = Color(0.25, 0.85, 1.0, 1.0)
	mallet_top.control_mode = 1 ## KEYS
	mallet_top.play_half = "top"
	mallet_top.tint = Color(1.0, 0.4, 0.55, 1.0)

	walls.setup(tunables, TABLE, WALL_THICKNESS, GOAL_WIDTH)
	puck.setup(tunables)
	mallet_bottom.setup(tunables, TABLE)
	mallet_top.setup(tunables, TABLE)
	physics_panel.setup(tunables)
	physics_panel.reset_puck_pressed.connect(_reset_puck)
	aesthetics_panel.setup(tunables)

	starfield.setup(get_viewport_rect().size)
	aesthetics.setup(
		tunables,
		TABLE,
		WALL_THICKNESS,
		GOAL_WIDTH,
		starfield,
		space_bg,
		world_env,
		table_fill,
		walls,
		puck,
		mallet_bottom,
		mallet_top
	)

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
