extends CharacterBody2D
@export var max_zoom:float = 50
@export var min_zoom:float = .5
var zoom = 3.1
@export var speed:float = 150
@export var max_velocity:float = 250
@export var min_velocity:float = 0.1  
var current_state:StringName
@onready var area: Area2D = $Area2D
@onready var character: CharacterBody2D = $"."
@onready var camera: Camera2D = $Camera2D
var friction:float = 1.01
var breaking_friction:float = 1.1
var d
@export var cooldown = 0.25

@onready var bullet_scenes = {"bullet":preload("res://Player bullets/player,bullet.tscn"),"smash":preload("res://Player bullets/player,smash.tscn"),"dash":preload("res://Player bullets/player,dash.tscn")}
var flags = {"dash":false,"smash":false,"shoot":true}
var dash_position
var dash_rotation
@onready var meshes = $"Mesh(es)"
var states = {0:"Normal state",1:"Smash state",2:"Dash state"}
@onready var timers = {"smash":$Timer2,"dash":$Timer}

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
	match state:
		"Normal state":
			flags["shoot"] = true
			flags["smash"] = false
			flags["dash"] = false
			return
		"Smash state":
			flags["shoot"] = false
			flags["smash"] = true
			flags["dash"] = false
			return
		"Dash state":
			flags["shoot"] = false
			flags["smash"] = false
			flags["dash"] = true
			return
	get_tree().change_scene_to_file("res://Death screen.tscn")

func _physics_process(delta: float) -> void:
	if current_state == states[2] and flags["dash"] == false:
		if d != null:
			area.set_collision_mask_value(3,false)
			area.set_collision_mask_value(8,false)
			dash_position = d.position
			dash_rotation = d.rotation
			position = dash_position
			rotation = dash_rotation
		else:
			_on_dash_timeout()
	else:
		if Input.get_vector("down","up","left","right"):
			if sqrt(velocity.x**2+velocity.y**2) < max_velocity:
				character.velocity += Input.get_vector("down","up","left","right").rotated(character.rotation)*speed*delta
				character.velocity /= friction
		elif sqrt(velocity.x**2+velocity.y**2)>min_velocity: 
			character.velocity /= breaking_friction
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
	if flags["shoot"] == false:
		return
	var bullet = bullet_scenes["bullet"].instantiate()
	get_tree().root.add_child(bullet)
	bullet.start(position)

func smash():
	if flags["smash"] == false:
		return
	flags["smash"] = false
	timers["smash"].start()
	var bullet = bullet_scenes["smash"].instantiate()
	get_tree().root.add_child(bullet)
	bullet.start(position)


func dash():
	if flags["dash"] == false:
		return
	timers["dash"].start()
	d = bullet_scenes["dash"].instantiate()
	get_tree().root.add_child(d)
	d.start(position)
	flags["dash"] = false


func _on_Enemy_contact(area: Area2D) -> void:
	Death()

func Death():
	get_tree().change_scene_to_file("res://Death screen.tscn")

func _on_dash_timeout() -> void:

	velocity = Vector2.ZERO
	if d != null:
		d.queue_free()
	if current_state == states[2]:
		flags["dash"] = true
	area.set_collision_mask_value(3,true)
	area.set_collision_mask_value(8,true)


func smash_cooldown() -> void: 
	if current_state == states[1]:
		flags["smash"] = true
func _on_area_2d_body_entered(body: Node2D) -> void:
	Death()
