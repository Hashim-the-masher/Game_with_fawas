extends CharacterBody2D
@export var rotation_speed =.3
var enemy_detected_flag = false
var hp = 20
signal kill
@onready var player: CharacterBody2D = $"../player"
func _on_hitbox_area_entered(area: Area2D) -> void:
	enemy_detected_flag = true
	print(name+",took damge from:"+area.name)
	if hp <= 1:
		kill.emit()
		queue_free()
	else: hp -= 1 

func _process(delta: float) -> void:
	if enemy_detected_flag == true:
		var desireable_rotation = atan2((player.position.y-position.y),(player.position.x-position.x))
		var tween = get_tree().create_tween()
		tween.tween_property(self, "rotation",lerp_angle(rotation,desireable_rotation, 1),rotation_speed)



func _on_smash_kill() -> void:
	pass # Replace with function body.
