extends CharacterBody2D

const PlayerCode = preload("uid://c1yq5e3ldovvc")

signal kill
func _on_area_2d_area_entered(area: Area2D) -> void:
	
	kill.emit()
	queue_free()
