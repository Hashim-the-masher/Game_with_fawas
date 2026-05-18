extends CharacterBody2D
var wait_for_it_flag = true
var enemy_detected_flag = false
@export var rotation_speed =.3
@export var hp = 15
@export var extra_smash_damge = 14
@onready var player: CharacterBody2D = $"../player"
const BULLET = preload("uid://dvxvq2aiuyox4")
signal kill
func _process(delta: float) -> void:
	if enemy_detected_flag == true:
		var desireable_rotation = atan2((player.position.y-position.y),(player.position.x-position.x))
		var tween = get_tree().create_tween()
		tween.tween_property(self, "rotation",lerp_angle(rotation,desireable_rotation, 1),rotation_speed)


func _on_hitbox_area_entered(area: Area2D) -> void:
	enemy_detected_flag = true
	print(name+",took damge from:"+area.name)
	hp -= 1 
	if area.name == "Smash":
		hp -= extra_smash_damge
	if hp <= 0:
		kill.emit()
		queue_free()
	


func _on_timer_timeout() -> void:
	if enemy_detected_flag == true:
		shoot()

func shoot():
	if wait_for_it_flag == true:
		wait_for_it_flag = false
		return
	var bullet = BULLET.instantiate()
	get_tree().root.add_child(bullet)
	bullet.start(position,rotation)


func _on_seeing_radius_body_entered(body: Node2D) -> void:
	enemy_detected_flag = true

func _on_seeing_radius_body_exited(body: Node2D) -> void:
	enemy_detected_flag = false
