extends PanelContainer

## Live choose/tune for starfield + neon-glow approaches (aesthetics only).

var tunables: PoCTunables
var _option_star: OptionButton
var _option_glow: OptionButton
var _sliders: Dictionary = {}
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
	title.text = "Aesthetics (choose / tune)"
	vbox.add_child(title)

	var star_row := HBoxContainer.new()
	vbox.add_child(star_row)
	var star_l := Label.new()
	star_l.text = "Starfield"
	star_l.custom_minimum_size = Vector2(110, 0)
	star_row.add_child(star_l)
	_option_star = OptionButton.new()
	_option_star.add_item("Static draw dots", 0)
	_option_star.add_item("Twinkle particles", 1)
	_option_star.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_option_star.item_selected.connect(_on_star_approach)
	star_row.add_child(_option_star)

	_add_slider(vbox, "star_density", "Star density", 0.0, 1.0, 0.01)
	_add_slider(vbox, "star_brightness", "Star brightness", 0.05, 1.0, 0.01)
	_add_slider(vbox, "star_twinkle", "Star twinkle", 0.0, 1.0, 0.01)

	var glow_row := HBoxContainer.new()
	vbox.add_child(glow_row)
	var glow_l := Label.new()
	glow_l.text = "Neon glow"
	glow_l.custom_minimum_size = Vector2(110, 0)
	glow_row.add_child(glow_l)
	_option_glow = OptionButton.new()
	_option_glow.add_item("Halo shells", 0)
	_option_glow.add_item("Env bloom", 1)
	_option_glow.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_option_glow.item_selected.connect(_on_glow_approach)
	glow_row.add_child(_option_glow)

	_add_slider(vbox, "glow_intensity", "Glow intensity", 0.0, 1.0, 0.01)
	_add_slider(vbox, "neon_saturation", "Neon saturation", 0.0, 1.0, 0.01)

	var hint := Label.new()
	hint.text = "Godot-native draw only — no image textures. Physics baseline = PoC 1."
	hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(hint)


func _add_slider(parent: VBoxContainer, key: String, label: String, min_v: float, max_v: float, step: float) -> void:
	var row := HBoxContainer.new()
	parent.add_child(row)
	var name_l := Label.new()
	name_l.text = label
	name_l.custom_minimum_size = Vector2(110, 0)
	row.add_child(name_l)
	var slider := HSlider.new()
	slider.min_value = min_v
	slider.max_value = max_v
	slider.step = step
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slider.custom_minimum_size = Vector2(140, 0)
	row.add_child(slider)
	var val_l := Label.new()
	val_l.custom_minimum_size = Vector2(48, 0)
	row.add_child(val_l)
	_sliders[key] = slider
	_value_labels[key] = val_l
	slider.value_changed.connect(func(v: float) -> void: _on_slider(key, v))


func _sync_from_tunables() -> void:
	if tunables == null:
		return
	_option_star.select(tunables.starfield_approach)
	_option_glow.select(tunables.glow_approach)
	_set_slider("star_density", tunables.star_density)
	_set_slider("star_brightness", tunables.star_brightness)
	_set_slider("star_twinkle", tunables.star_twinkle)
	_set_slider("glow_intensity", tunables.glow_intensity)
	_set_slider("neon_saturation", tunables.neon_saturation)


func _set_slider(key: String, v: float) -> void:
	var s: HSlider = _sliders[key]
	s.set_value_no_signal(v)
	(_value_labels[key] as Label).text = "%.2f" % v


func _on_star_approach(idx: int) -> void:
	if tunables == null:
		return
	tunables.starfield_approach = idx
	tunables.notify_aesthetics_changed()


func _on_glow_approach(idx: int) -> void:
	if tunables == null:
		return
	tunables.glow_approach = idx
	tunables.notify_aesthetics_changed()


func _on_slider(key: String, v: float) -> void:
	if tunables == null:
		return
	(_value_labels[key] as Label).text = "%.2f" % v
	match key:
		"star_density":
			tunables.star_density = v
		"star_brightness":
			tunables.star_brightness = v
		"star_twinkle":
			tunables.star_twinkle = v
		"glow_intensity":
			tunables.glow_intensity = v
		"neon_saturation":
			tunables.neon_saturation = v
	tunables.notify_aesthetics_changed()
