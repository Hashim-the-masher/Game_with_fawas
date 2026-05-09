extends Area2D

@export var next_level:String

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		get_tree().change_scene_to_file(next_level)
