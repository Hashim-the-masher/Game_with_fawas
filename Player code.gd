extends CharacterBody2D
@export var max_zoom = 50
@export var min_zoom = .5
var zoom = 3.1
@export var speed = 150
@export var max_velocity= 250
@export var min_velocity= 0.1
var current_state:StringName
@onready var character: CharacterBody2D = $"."
@onready var camera: Camera2D = $Camera2D
var friction = 1.1

@export var cooldown = 0.25
@export var bullet_scene : PackedScene
var can_shoot = true
var can_smash = false
var can_dash = false

@onready var meshes = $"Mesh(es)"
var states = {0:"Normal state",1:"Smash state",2:"Dash state"}

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
			print(states[num],"shown")
		elif state != meshes.get_child(num).name:
			meshes.get_child(num).hide()
			print(states[num],"hidden")

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
	if Input.get_vector("down","up","left","right"):
		if sqrt(velocity.x**2+velocity.y**2) < max_velocity:
			character.velocity += Input.get_vector("down","up","left","right").rotated(character.rotation)*speed*delta
	elif sqrt(velocity.x**2+velocity.y**2)>min_velocity: 
		character.velocity /= friction
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
	

func dash():
	if can_dash == false:
		return
	

func _on_Enemy_contact(area: Area2D) -> void:
	Death()

func Death():
	get_tree().change_scene_to_file("res://Death screen.tscn")
