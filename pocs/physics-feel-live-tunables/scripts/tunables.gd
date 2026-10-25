extends RefCounted
class_name PoCTunables

## Live physics knobs for the PoC. Shared by arena bodies and the debug panel.

signal changed

var puck_mass: float = 0.35
var puck_bounce: float = 0.92
var puck_linear_damp: float = 0.15
var puck_max_speed: float = 1400.0

var mallet_mass: float = 2.0
var mallet_max_speed: float = 900.0
var mallet_drive: float = 3200.0 ## spring stiffness; controller adds critical damping
var mallet_linear_damp: float = 6.0 ## extra follow damping (not engine linear_damp)

var wall_bounce: float = 0.85


func notify_changed() -> void:
	changed.emit()
