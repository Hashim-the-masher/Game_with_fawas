extends CharacterBody2D
signal kill
func _on_area_2d_area_entered(area: Area2D) -> void:
	kill.emit()
	queue_free()


func _on_smash_kill() -> void:
	pass # Replace with function body.
