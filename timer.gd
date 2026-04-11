extends Node2D

@onready var timer_label: Label = $CanvasLayer/Control/timer_count
var timer_value = 0

func _ready():
	$Timer.timeout.connect(_on_timer_timeout)
	
func _on_timer_timeout():
	timer_value += 1
	timer_label.text = str(timer_value)
