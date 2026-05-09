extends Node2D
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect

func _ready() -> void:
	color_rect.show()
	var tween = get_tree().create_tween()
	tween.tween_property(color_rect, "color", Color.TRANSPARENT, 1.0)
	tween.play()
	await tween.finished
	tween.kill()
