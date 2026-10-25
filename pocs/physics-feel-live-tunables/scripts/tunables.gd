extends RefCounted
class_name PoCTunables

## Live physics knobs for the PoC. Shared by arena bodies and the debug panel.

signal changed

var puck_mass: float = 0.35
var puck_bounce: float = 1.0
var puck_linear_damp: float = 0.15
var puck_max_speed: float = 2290.0

var mallet_mass: float = 1.55
var mallet_max_speed: float = 1440.0
var mallet_drive: float = 10300.0 ## follow gain (mapped in mallet controller)
var mallet_linear_damp: float = 16.8 ## extra follow damping (not engine linear_damp)

var wall_bounce: float = 1.0


func notify_changed() -> void:
	changed.emit()
