@icon("res://QTEV2/Icons/SequenceQTE.webp")
extends QTE
class_name SequenceQTE
@export_category("Sequence")
@export var sequence: Array[String]
@export var retry_on_wrong_letter: bool = false
@export var mix_inputs_on_retry: bool = false
var index: int = 0

func on_launch() -> void:
	if !Engine.is_editor_hint():
			assert(input_mode == InputModes.sequence, "Node Input Mode is not sequence")
			assert(!sequence.is_empty(), "Empty Sequence list")
	label.text = ""
	for s: String in sequence:
		label.text += s
	index = 0
	set_process_input(true)

func qte_input_handle(delta: float) -> void:
	set_value_no_signal(timer.time_left)
	
func _input(event: InputEvent) -> void:
	if event.is_pressed() and event is InputEventKey:
		if InputMap.action_has_event(sequence[index], event):
			if index < sequence.size():
				label.text = label.text.replace(sequence[index], "[color=green]" + sequence[index] + "[/color]")
				index += 1
				if index == sequence.size():
					set_process_input(false)
					succeed()
		else:
			if retry_on_wrong_letter:
				if mix_inputs_on_retry:
					sequence.shuffle()
				launch_qte()
				on_launch()
			else:
				set_process_input(true)
				fail()
