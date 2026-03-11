@icon("res://addons/QuickTimeEvent/QTEBase.webp")
@abstract
extends TextureProgressBar

## Abstract class for Quick Time Event Nodes, it containss the base variables such as time limit, input settings and signals
class_name QTE

## When set to true, it starts the process
var started: bool = false

## The Node can either select a random Input key from the list or set a single input up to your choice
@export_category("Input")

## Single Input that the Node will use
@export var input: String = "f"

## A label that is created in-script which displays what key you need to press
var label: Label

@export_category("Time")
## This is the value that defines how much time the player has to press the Input
@export var time_left: float = 10.0

## A Timer that is created in-script which will count down from the given time
var timer: Timer

## When the Quick Time Event starts, the game will slow down by half
var slowdown_time: float = 0.5

## At ready the times variable gets the value of the progress bars max value, since the progress bar's value can't directly be changed, times gets subtracted and then assigned back to the progress bars value
var counter_time: float

## When the node gets Instantiated, a random key from the Input array gets selected
var selected_input: String

## The Signal will be emitted if the player presses the correct prompt on time
signal success
## The signal will be emitted if the player fails to press the prompt
signal failed

## Starts the Event, it is a part of the abstract class since it will be the same thing for both QTE nodes
func start_qte() -> void:
	show()
	started = true
	selected_input = input
	
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(fail)
	counter_time = self.max_value
	self.value = counter_time
	Engine.time_scale = slowdown_time
	timer.start(time_left / 2)
	
	# Creates a Label
	label = Label.new()
	add_child(label)
	label.size = size
	label.horizontal_alignment = 1 # Center
	label.vertical_alignment = 1 # Center
	label.text = selected_input
	
## Upon failing the Quick Time Event, the failed signal gets emitted before the node deletes itself and resets the game's speed back to normal
func fail() -> void:
	Engine.time_scale = 1
	failed.emit()
	hide()
	started = false
	timer.stop()

## Upon succeeding the Quick Time Event, the success signal gets emitted before the node deletes itself and resets the game's speed back to normal
func succeed() -> void:
	Engine.time_scale = 1
	success.emit()
	hide()
	started = false
	timer.stop()
