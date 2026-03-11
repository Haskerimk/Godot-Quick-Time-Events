@icon("res://addons/QuickTimeEvent/MashQTE/IconMash.webp")
extends QTE
class_name MashQTE

@export var speed: float = 1.2
@export var mash_power: float = 10.0

func _physics_process(delta: float) -> void:
	if started:
		counter_time -= delta * (50 * 2)
		counter_time = clamp(counter_time, 0.0, self.max_value)
		self.value = counter_time
		
		if self.value >= self.max_value:
			succeed()
		
		if Input.is_action_just_pressed(selected_input):
			counter_time += mash_power
