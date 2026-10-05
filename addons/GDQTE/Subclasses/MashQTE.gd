@icon("res://QTEV2/Icons/MashQTE.webp")
extends QTE
class_name MashQTE

@export var mash_power: float = 10.0
@export_range(0.01, 1.0, 0.01) var value_margin: float = 1.0

func qte_input_handle(delta: float) -> void:
	value -= delta * drain_boost
	value = clampf(value, 0.0, max_value)
	if value >= max_value - value_margin:
		succeed()
	if Input.is_action_just_pressed(selected_input):
		value += mash_power
