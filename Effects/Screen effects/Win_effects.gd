extends Control
var colour
var negative_colour
@onready var color_rect: ColorRect = $ColorRect
@onready var label: Label = $Label

func _physics_process(delta: float) -> void:
	var val1=randi_range(0,225)
	var val2=randi_range(0,225)
	var val3=randi_range(0,225)
	colour = Color8(val1,val2,val3)
	negative_colour = Color8(255-val1,255-val2,255-val3)
	color_rect.color = colour
	label.label_settings.font_color = negative_colour


func _on_timer_timeout() -> void:
	get_tree().quit()
