@icon("res://addons/QuickTimeEvent/CountdownQTE/IconCountDown.webp")
extends QTE

## CountdownQTE is a Quick Time Event that requires the player to press an Input before time runs out
class_name CountdownQTE

func _physics_process(delta: float) -> void:
	if started:
		counter_time -= delta * ((100 / time_left) * 2)
		counter_time = clamp(counter_time, 0.0, self.max_value)
		self.value = counter_time
		if Input.is_action_just_pressed(selected_input):
			succeed()
