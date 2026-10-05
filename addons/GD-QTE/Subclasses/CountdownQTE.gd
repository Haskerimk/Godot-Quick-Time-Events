@icon("res://QTEV2/Icons/CountdownQTE.webp")
extends QTE
class_name CountdownQTE

func on_launch() -> void:
	max_value = remaining_time

func qte_input_handle(delta: float) -> void:
	set_value_no_signal(timer.time_left)
	if Input.is_action_just_pressed(input):
		succeed()
