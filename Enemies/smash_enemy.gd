extends CharacterBody2D
@export var rotation_speed =.3
@export var speed = 300
@export var friction = 1.015
var enemy_detected_flag = false
@export var hp = 40
@export var extra_smash_damge = 19
signal kill
@onready var player: CharacterBody2D = $"../player"
func _on_hitbox_area_entered(area: Area2D) -> void:
	enemy_detected_flag = true
	print(name+",took damge from:"+area.name)
	hp -= 1 
	if area.name == "Smash":
		hp -= extra_smash_damge
	if hp <= 0:
		kill.emit()
		queue_free()

func _process(delta: float) -> void:
	if enemy_detected_flag == true:
		var desireable_rotation = atan2((player.position.y-position.y),(player.position.x-position.x))
		var tween = get_tree().create_tween()
		tween.tween_property(self, "rotation",lerp_angle(rotation,desireable_rotation, 1),rotation_speed)
		velocity += Vector2(1,0).rotated(rotation)*delta*speed
		velocity /= friction
		move_and_slide()
