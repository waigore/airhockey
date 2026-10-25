extends RefCounted
class_name PoCTunables

## Live physics knobs (PoC 1 preferred defaults) plus aesthetics approach selection.

signal changed
signal aesthetics_changed

# --- Physics (locked baseline from physics-feel-live-tunables preferred set) ---
var puck_mass: float = 0.35
var puck_bounce: float = 1.0
var puck_linear_damp: float = 0.15
var puck_max_speed: float = 2290.0

var mallet_mass: float = 1.55
var mallet_max_speed: float = 1440.0
var mallet_drive: float = 12000.0 ## follow gain (mapped in mallet controller)
var mallet_linear_damp: float = 15.7 ## extra follow damping (not engine linear_damp)

var wall_bounce: float = 1.0

# --- Aesthetics (selectable approaches + intensity) ---
## 0 = static _draw() dots, 1 = twinkle CPUParticles2D
var starfield_approach: int = 0
var star_density: float = 0.55 ## 0..1
var star_brightness: float = 0.35 ## 0..1 faint by default
var star_twinkle: float = 0.6 ## used by particles approach

## 0 = tight ring shells (rapid falloff), 1 = focused WorldEnvironment bloom (needs hdr_2d)
var glow_approach: int = 0
var glow_intensity: float = 0.7 ## 0..1 — bright core; keep falloff short
var neon_saturation: float = 1.0 ## 0..1


func notify_changed() -> void:
	changed.emit()


func notify_aesthetics_changed() -> void:
	aesthetics_changed.emit()
