extends CharacterBody2D
var wait_for_it_flag = true
var enemy_detected_flag = false
@export var rotation_speed =3
@export var hp = 10
@onready var player: CharacterBody2D = $"../player"
const BULLET = preload("uid://dvxvq2aiuyox4")

func _process(delta: float) -> void:
	if enemy_detected_flag == true:
		if rotation >= atan2((player.position.y-position.y),(player.position.x-position.x)):
			rotation -= rotation_speed*delta
		else: rotation += rotation_speed*delta

func _on_hitbox_area_entered(area: Area2D) -> void:
	print(name+",took damge from:"+area.name)
	if hp == 1:
		queue_free()
	else: hp -= 1 


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
