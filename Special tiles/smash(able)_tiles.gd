extends StaticBody2D

@onready var cracking_audio: AudioStreamPlayer2D = $"../cracking, sound effects"

func _on_area_2d_area_entered(area: Area2D) -> void:
	cracking_audio.play()
	queue_free()
