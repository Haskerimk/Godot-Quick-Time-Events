@abstract
@icon("res://addons/GD-QTE/Icons/QTE.webp")
extends TextureProgressBar
class_name QTE

enum InputModes {single, random, sequence}
var selected_input: String
var timer: Timer
var label: RichTextLabel

signal success
signal failed
signal launched

@export_category("Input config")
@export var input_mode: InputModes
@export_group("Single Input")
@export var input: String
@export_group("Random Input")
@export var random_inputs: Array[String]
@export_group("Sequence Input")
@export_category("Time")
@export var remaining_time: float = 1.0
@export var drain_boost: float = 1.0
@export_category("Misc.")
@export var autostart_debug: bool = false
@export var half_value_at_start: bool

func _ready() -> void:
	hide()
	step = 0.001
	timer = Timer.new()
	label = RichTextLabel.new()
	
	add_child(timer)
	add_child(label)
	timer.timeout.connect(fail)
	
	label.bbcode_enabled = true
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.set_anchors_preset(Control.PRESET_CENTER)
	label.size = size
	label.add_theme_font_size_override("normal_font_size", 27)
	
	if input_mode == InputModes.single:
		selected_input = input
		if !Engine.is_editor_hint():
			assert(InputMap.has_action(selected_input), "Unknown Input")
	elif input_mode == InputModes.random:
		if !Engine.is_editor_hint():
			assert(!random_inputs.is_empty(), "Empty Input list")
		selected_input = random_inputs[randi_range(0, random_inputs.size())]
	if autostart_debug:
		launch_qte()

func deactivate() -> void:
	hide()
	timer.stop()
	Engine.set_time_scale(1.0)
	set_process_mode(Node.PROCESS_MODE_DISABLED)
	set_process_input(false)

func launch_qte() -> void:
	show()
	on_launch()
	set_process_mode(Node.PROCESS_MODE_INHERIT)
	max_value = remaining_time / 2
	value = max_value
	if half_value_at_start:
		value /= 2
	Engine.set_time_scale(0.5)
	timer.start(remaining_time / 2)
	await timer.timeout
	fail()

func _physics_process(delta: float) -> void:
	qte_input_handle(delta)

func on_launch() -> void:
	launched.emit()

func fail() -> void:
	failed.emit()
	deactivate()
	
func succeed() -> void:
	success.emit()
	deactivate()
	
func qte_input_handle(delta: float) -> void:
	pass
