extends Area2D

@export var speed = 333
var line_of_fire
func start(pos,the_rotation):
	position = pos
	line_of_fire = the_rotation
	rotate(deg_to_rad(90))
	rotation += the_rotation

func _process(delta):
	position += Vector2(1,0).rotated(line_of_fire)*speed*delta


func _on_enemy(area: Area2D) -> void:
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	queue_free()
