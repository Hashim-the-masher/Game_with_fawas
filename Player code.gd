extends CharacterBody2D
@export var max_zoom:float = 50
@export var min_zoom:float = .5
var zoom = 3.1
@export var speed:float = 150
@export var max_velocity:float = 250
@export var min_velocity:float = 0.1
var current_state:StringName
@onready var character: CharacterBody2D = $"."
@onready var HitBox: Area2D = $Area2D
@onready var camera: Camera2D = $Camera2D

@export var friction:float = 1.01
@export var stopping_friction:float = 1.1
var d
@export var cooldown = 0.25
var bullet_scene : PackedScene =preload("uid://bc1dyw233yaa2")
var smash_scene : PackedScene=preload("uid://dj6l43tiggqsb")
var dash_scene : PackedScene=preload("uid://dum66niw41wlj")
var can_shoot = true
var can_smash = false
var can_dash = false
var dash_position
var dash_rotation
@onready var meshes = $"Mesh(es)"
var states = {0:"Normal state",1:"Smash state",2:"Dash state"}
@onready var dash_timer: Timer = $Timer
@onready var smash_timer: Timer = $Timer2


func _ready() -> void:
	current_state = states[0]
	switch_mesh(current_state)

func _input(event: InputEvent) -> void:
	if event.is_action("scroll up"):
		if zoom < max_zoom:
			zoom += .1
			camera.zoom.x = zoom
			camera.zoom.y = zoom
	if event.is_action("scroll down"):
		if zoom > min_zoom:
			zoom -= .1
			camera.zoom.x = zoom
			camera.zoom.y = zoom
	if event.is_action("Shoot"):
		shoot()
		dash()
		smash()



func switch_mesh(state:StringName):
	for num in states:
		if state == meshes.get_child(num).name:
			meshes.get_child(num).show()

		elif state != meshes.get_child(num).name:
			meshes.get_child(num).hide()


func switch_ablity(state:StringName):
	if state == states[0]:
		can_shoot = true
		can_smash = false
		can_dash = false
	elif state == states[1]:
		can_shoot = false
		can_smash = true
		can_dash = false
	elif state == states[2]:
		can_shoot = false
		can_smash = false
		can_dash = true
	else: get_tree().change_scene_to_file("res://Death screen.tscn")

func _physics_process(delta: float) -> void:
	if current_state == states[2] and can_dash == false:
		HitBox.set_collision_mask_value(3,false)
		HitBox.set_collision_mask_value(8,false)
		dash_position = d.position
		dash_rotation = d.rotation
		position = dash_position
		rotation = dash_rotation
	else:
		if Input.get_vector("down","up","left","right"):
			if sqrt(velocity.x**2+velocity.y**2) < max_velocity:
				character.velocity += Input.get_vector("down","up","left","right").rotated(character.rotation)*speed*delta
				character.velocity /= friction
		elif sqrt(velocity.x**2+velocity.y**2)>min_velocity: 
			character.velocity /= stopping_friction
		else: character.velocity = Vector2.ZERO
		character.rotation = atan2(get_global_mouse_position().y-character.global_position.y,get_global_mouse_position().x-character.global_position.x)

	move_and_slide()


func _on_smash_kill() -> void:
	current_state = states[1]
	switch_mesh(current_state)
	switch_ablity(current_state)

func _on_dash_kill() -> void:
	current_state = states[2]
	switch_mesh(current_state)
	switch_ablity(current_state)


func shoot():
	if can_shoot == false:
		return
	var bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)
	bullet.start(position)

func smash():
	if can_smash == false:
		return
	can_smash = false
	smash_timer.start()
	var bullet = smash_scene.instantiate()
	get_tree().root.add_child(bullet)
	bullet.start(position)


func dash():
	if can_dash == false:
		return
	dash_timer.start()
	d = dash_scene.instantiate()
	get_tree().root.add_child(d)
	d.start(position)
	can_dash = false

func _on_dash_timeout() -> void:

	velocity = Vector2.ZERO
	if d != null:
		d.queue_free()
	if current_state == states[2]:
		can_dash = true
	HitBox.set_collision_mask_value(3,true)
	HitBox.set_collision_mask_value(8,true)


func smash_cooldown() -> void: 
	if current_state == states[1]:
		can_smash = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	Death()

func _on_Enemy_contact(area: Area2D) -> void:
	Death()

func Death():
	get_tree().change_scene_to_file("res://Death screen.tscn")
