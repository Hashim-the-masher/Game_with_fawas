extends Area2D

@export var speed = 0
var line_of_fire
func start(pos,the_rotation):
	position = pos
	line_of_fire = the_rotation
	rotation = the_rotation-deg_to_rad(90)

func _process(delta):
	position += Vector2(1,0).rotated(line_of_fire)*speed*delta


func _on_enemy(area: Area2D) -> void:
	print(name+":despawned from hitting:"+str(area))
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
