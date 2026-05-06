extends Control

@onready var label: Label = $Label
@onready var timer: Timer = $Timer
var cocksize = 16*10
func _process(delta: float) -> void:
	label.label_settings.font_size = lerp(16,cocksize,2-timer.time_left)
	label.label_settings.font_color.a8 = lerp(0,255,2-timer.time_left)
	
	if 2-timer.time_left > 1.9:
		timer.stop()
