extends Area2D

@export var speed = 0
var line_of_fire
func start(pos):
	position = pos
	line_of_fire = atan2(get_global_mouse_position().y-global_position.y,get_global_mouse_position().x-global_position.x)
	rotation = atan2(get_global_mouse_position().y-global_position.y,get_global_mouse_position().x-global_position.x)-90

func _process(delta):
	position += Vector2(1,0).rotated(line_of_fire)*speed*delta


func _on_enemy(area: Area2D) -> void:
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
