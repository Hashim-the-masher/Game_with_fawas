extends CharacterBody2D
var rotaion_velocity:float
@export var speed:float = 150
@export var rotation_speed:float = .5
@export var max_rotation:float = .1
@export var min_rotation:float = -.1
@export var max_velocity:float = 250
@export var min_velocity:float = 0.1  
@export var back_slow_mutiplyer:float = .2
var current_state:StringName
@onready var area: Area2D = $Area2D
@onready var character: CharacterBody2D = $"."
@onready var camera: Camera2D = $Camera2D
@export var friction:float = 1.03
@export var rotation_friction:float = 1.15
@export var breaking_friction:float = 1.1
var d
@export var cooldown = 0.25
@onready var bullet_scenes = {"bullet":preload("res://Player bullets/Bullet.tscn"),"smash":preload("res://Player bullets/smash.tscn"),"dash":preload("res://Player bullets/dash.tscn")}
var flags = {"dash":false,"smash":false,"shoot":true,"spawn":false,"cooldown":true}
var dash_position
var dash_rotation
@onready var meshes = $"Mesh(es)"
var states = {0:"Normal state",1:"Smash state",2:"Dash state"}
@onready var timers = {"shoot":$shoot,"smash":$smash,"dash":$dash}

func _ready() -> void:
	current_state = states[0]
	switch_mesh(current_state)
	

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
	Death()
	print("died from a lack of choice, Player code 58")

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("Shoot"):  
		shoot()
		flags["shoot"]= false
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
	elif flags["spawn"] == true:
		if Input.get_vector("down","up","NA","NA"):
			if sqrt(velocity.x**2+velocity.y**2) < max_velocity:
				character.velocity += Input.get_vector("down","up","NA","NA").rotated(character.rotation)*speed*delta
				if Input.is_action_pressed("down"):
					character.velocity -= (Input.get_vector("down","up","NA","NA").rotated(character.rotation)*speed*delta)*back_slow_mutiplyer
				character.velocity /= friction
		elif sqrt(velocity.x**2+velocity.y**2)>min_velocity: 
			character.velocity /= breaking_friction
		else: pass
		rotaion_velocity += Input.get_vector("NA","NA","left","right").y*rotation_speed*delta
		rotaion_velocity /= rotation_friction
		rotaion_velocity = clampf(rotaion_velocity,min_rotation,max_rotation)
		character.rotation += rotaion_velocity

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
	if flags["shoot"] == true:
		var bullet = bullet_scenes["bullet"].instantiate()
		get_tree().root.add_child(bullet)
		bullet.start(position,rotation)
	elif flags["smash"] == true and flags["cooldown"] == false:
		flags["cooldown"] = true
		flags["smash"] = false
		timers["smash"].start()
		var bullet = bullet_scenes["smash"].instantiate()
		get_tree().root.add_child(bullet)
		bullet.start(position,rotation)
	elif flags["dash"] == true and flags["cooldown"] == false:
		flags["cooldown"] = true
		timers["dash"].start()
		d = bullet_scenes["dash"].instantiate()
		get_tree().root.add_child(d)
		d.start(position,rotation)
		flags["dash"] = false
	else: return


func _on_Enemy_contact(area: Area2D) -> void:
	print("this area killed me:"+str(area))
	Death()

func Death():
	get_tree().change_scene_to_file("res://Effects/Screen effects/Death screen.tscn")

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
	print("this body killed me:"+str(body))
	Death()


func _on_shoot_cooldown() -> void:
	if current_state == states[0]:
		flags["shoot"] = true


func _on_spawn_timeout() -> void:
	flags["spawn"] = true


func _on_cooldown_timeout() -> void:
	flags["cooldown"] = false
