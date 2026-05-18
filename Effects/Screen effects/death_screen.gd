extends Control

@onready var label: Label = $Label
@onready var timer: Timer = $Timer
var cocksize = 64
func _process(delta: float) -> void:
	label.label_settings.font_size = lerp(16,cocksize,4.25-timer.time_left)
	label.label_settings.font_color.a8 = lerp(0,255,4.25-timer.time_left)
	
	if 4.25-timer.time_left > 4.2:
		timer.stop()
