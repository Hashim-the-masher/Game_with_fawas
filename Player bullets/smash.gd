extends Area2D

@export var speed = 10
var line_of_fire
func start(pos,the_rotation):
	position = pos
	line_of_fire = the_rotation
	rotation = the_rotation-deg_to_rad(90)

func _process(delta):
	if line_of_fire == null:
		print("no line of fire for"+name)
		return
	position += Vector2(1,0).rotated(line_of_fire)*speed*delta

func _on_timer_timeout() -> void:
	queue_free()
