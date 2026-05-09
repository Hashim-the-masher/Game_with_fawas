extends Area2D

@export var speed = 333

var line_of_fire
func start(pos,The_rotaion):
	position = pos
	line_of_fire = The_rotaion
	rotation = The_rotaion

func _process(delta):
	position += Vector2(1,0).rotated(line_of_fire)*speed*delta


func _on_body_entered(body: Node2D) -> void:
	queue_free()
