extends PanelContainer

## Debug UI: sliders that push into PoCTunables immediately.

signal reset_puck_pressed

var tunables: PoCTunables
var _sliders: Dictionary = {} ## name -> HSlider
var _value_labels: Dictionary = {}


func setup(t: PoCTunables) -> void:
	tunables = t
	_build_ui()
	_sync_from_tunables()


func _build_ui() -> void:
	for c in get_children():
		c.queue_free()
	_sliders.clear()
	_value_labels.clear()

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 10)
	margin.add_theme_constant_override("margin_right", 10)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_bottom", 8)
	add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 4)
	margin.add_child(vbox)

	var title := Label.new()
	title.text = "Physics (PoC 1 baseline — live)"
	vbox.add_child(title)

	_add_slider(vbox, "puck_mass", "Puck mass", 0.05, 2.0, 0.01)
	_add_slider(vbox, "puck_bounce", "Puck bounce", 0.0, 1.0, 0.01)
	_add_slider(vbox, "puck_linear_damp", "Puck linear damp", 0.0, 4.0, 0.01) ## 0 = no flight bleed
	_add_slider(vbox, "puck_max_speed", "Puck max speed", 200.0, 3000.0, 10.0)

	_add_slider(vbox, "mallet_mass", "Mallet mass", 0.2, 8.0, 0.05)
	_add_slider(vbox, "mallet_max_speed", "Mallet max speed", 100.0, 2000.0, 10.0)
	_add_slider(vbox, "mallet_drive", "Mallet drive", 500.0, 16000.0, 50.0)
	_add_slider(vbox, "mallet_linear_damp", "Mallet linear damp", 0.0, 20.0, 0.1)

	_add_slider(vbox, "wall_bounce", "Wall bounce", 0.0, 1.0, 0.01)

	var reset_btn := Button.new()
	reset_btn.text = "Reset puck"
	reset_btn.pressed.connect(func() -> void: reset_puck_pressed.emit())
	vbox.add_child(reset_btn)

	var hint := Label.new()
	hint.text = "P1 mouse (bottom) | P2 WASD/arrows (top) | R reset puck + mallets"
	hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(hint)


func _add_slider(parent: VBoxContainer, key: String, label: String, min_v: float, max_v: float, step: float) -> void:
	var row := HBoxContainer.new()
	parent.add_child(row)
	var name_l := Label.new()
	name_l.text = label
	name_l.custom_minimum_size = Vector2(150, 0)
	row.add_child(name_l)
	var slider := HSlider.new()
	slider.min_value = min_v
	slider.max_value = max_v
	slider.step = step
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slider.custom_minimum_size = Vector2(180, 0)
	row.add_child(slider)
	var val_l := Label.new()
	val_l.custom_minimum_size = Vector2(56, 0)
	row.add_child(val_l)
	_sliders[key] = slider
	_value_labels[key] = val_l
	slider.value_changed.connect(func(v: float) -> void: _on_slider(key, v))


func _sync_from_tunables() -> void:
	if tunables == null:
		return
	_set_slider("puck_mass", tunables.puck_mass)
	_set_slider("puck_bounce", tunables.puck_bounce)
	_set_slider("puck_linear_damp", tunables.puck_linear_damp)
	_set_slider("puck_max_speed", tunables.puck_max_speed)
	_set_slider("mallet_mass", tunables.mallet_mass)
	_set_slider("mallet_max_speed", tunables.mallet_max_speed)
	_set_slider("mallet_drive", tunables.mallet_drive)
	_set_slider("mallet_linear_damp", tunables.mallet_linear_damp)
	_set_slider("wall_bounce", tunables.wall_bounce)


func _set_slider(key: String, v: float) -> void:
	var s: HSlider = _sliders[key]
	s.set_value_no_signal(v)
	(_value_labels[key] as Label).text = "%.2f" % v


func _on_slider(key: String, v: float) -> void:
	if tunables == null:
		return
	(_value_labels[key] as Label).text = "%.2f" % v
	match key:
		"puck_mass":
			tunables.puck_mass = v
		"puck_bounce":
			tunables.puck_bounce = v
		"puck_linear_damp":
			tunables.puck_linear_damp = v
		"puck_max_speed":
			tunables.puck_max_speed = v
		"mallet_mass":
			tunables.mallet_mass = v
		"mallet_max_speed":
			tunables.mallet_max_speed = v
		"mallet_drive":
			tunables.mallet_drive = v
		"mallet_linear_damp":
			tunables.mallet_linear_damp = v
		"wall_bounce":
			tunables.wall_bounce = v
	tunables.notify_changed()
