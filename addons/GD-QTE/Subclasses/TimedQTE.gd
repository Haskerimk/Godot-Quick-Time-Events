@icon("res://QTEV2/Icons/TimedQTE.webp")
extends QTE
class_name TimedQTE

@export var range: float = 1.0
@export var range_offset: float = 0.0
var in_range: bool = false

func qte_input_handle(delta: float) -> void:
	value += delta * drain_boost
	if value <= 0.0 or value >= max_value:
		drain_boost *= -1
	in_range = value > ((max_value / 2) - range) and value < ((max_value / 2) + range)
	if Input.is_action_just_pressed(selected_input):
		if in_range:
			succeed()
		else:
			fail()
