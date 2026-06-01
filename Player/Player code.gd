extends CharacterBody2D 
var rotaion_velocity:float
@export var rotation_speed:float = .5
@export var max_rotation:float = .1
@export var min_rotation:float = -.1
@export var rotation_friction:float = 1.15

@export var speed:float = 150 
@export var tank_speed = speed*PI 
@export var max_velocity:float = 250
@export var min_velocity:float = 0.1  
@export var back_slow_mutiplyer:float = .2 
@export var friction:float = 1.03 
@export var breaking_friction:float = 1.1 

@onready var camera: Camera2D = $Camera2D
@onready var audio_listener: AudioListener2D = $AudioListener2D
@onready var menu_pause: Control = $"../CanvasLayer/menu_pause"

var d 
@onready var area: Area2D = $Area2D 
@export var cooldown = 0.25 
@onready var bullet_scenes = {"bullet":preload("res://Player bullets/Bullet.tscn"),"smash":preload("res://Player bullets/smash.tscn"),"dash":preload("res://Player bullets/dash.tscn")} 
@onready var timers = {"shoot":$shoot,"smash":$smash,"dash":$dash} 
var flags = {"dash":false,"smash":false,"shoot":true,"spawn":false,"cooldown":true,"hit?":false} 
@onready var meshes = $"Mesh(es)" 
var current_state:StringName 
var states = {0:"Normal state",1:"Smash state",2:"Dash state"} 
var bullet_volume
var savepath = "user://savedata.json"
var savedata:Dictionary

func _ready() -> void:
	savedata = load_json_file()
	current_state = states[0]
	switch_mesh(current_state)
	switch_ablity(current_state)
	bullet_volume = linear_to_db(savedata["settings"]["sounds"][1])

func reset_volume():
	savedata = load_json_file()
	bullet_volume = linear_to_db(savedata["settings"]["sounds"][1])

func load_json_file():
	var file = FileAccess.open(savepath, FileAccess.READ)
	var json = file.get_as_text()
	var jsonobject = JSON.new()
	jsonobject.parse(json)
	print("Loaded:"+str(jsonobject.data)+"from file")
	return jsonobject.data

func save_to_json_file():
	var file = FileAccess.open(savepath, FileAccess.ModeFlags.WRITE)
	var json_text = JSON.stringify(savedata)
	print("written:"+json_text+"to file")
	file.store_string(json_text)

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
	print("died from a lack of choice, Player code")
	Death()

func _physics_process(delta: float) -> void:
	if menu_pause != null:
		if menu_pause.active == true:
			return
	if Input.is_action_pressed("Shoot") and flags["spawn"] == true:  
		shoot()
		flags["shoot"]= false
	if current_state == states[2] and flags["dash"] == false: 
		if d != null: 
			area.set_collision_mask_value(3,false)
			area.set_collision_mask_value(8,false)
			position = d.position
			rotation = d.rotation
			
		else:
			_on_dash_timeout()
	elif flags["spawn"] == true:
		if Input.get_vector("backwards","forwards","NA","NA"):
			if sqrt(velocity.x**2+velocity.y**2) < max_velocity:
				velocity += Input.get_vector("backwards","forwards","NA","NA").rotated(rotation)*speed*delta
				if Input.is_action_pressed("backwards"):
					velocity -= (Input.get_vector("backwards","forwards","NA","NA").rotated(rotation)*speed*delta)*back_slow_mutiplyer
				velocity /= friction
		elif Input.get_vector("left","right","up","down"):
			velocity += Input.get_vector("left","right","up","down")*tank_speed*delta
			velocity /= breaking_friction
		elif sqrt(velocity.x**2+velocity.y**2)>min_velocity:
			velocity /= breaking_friction
		else:pass 
		rotaion_velocity += Input.get_vector("NA","NA","turn left","turn right").y*rotation_speed*delta
		rotaion_velocity /= rotation_friction
		rotaion_velocity = clampf(rotaion_velocity,min_rotation,max_rotation)
		rotation += rotaion_velocity
		audio_listener.rotation -= rotaion_velocity

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
		bullet.start(position,rotation,bullet_volume)
	elif flags["smash"] == true and flags["cooldown"] == false:
		flags["cooldown"] = true
		flags["smash"] = false
		timers["smash"].start()
		var bullet = bullet_scenes["smash"].instantiate()
		get_tree().root.add_child(bullet)
		bullet.start(position,rotation,bullet_volume)
	elif flags["dash"] == true and flags["cooldown"] == false:
		flags["cooldown"] = true
		timers["dash"].start()
		d = bullet_scenes["dash"].instantiate()
		get_tree().root.add_child(d)
		d.start(position,rotation)
		flags["dash"] = false
	else: return


func _on_Enemy_contact(area: Area2D) -> void:
	if flags["hit?"] == true:
		return
	
	print("this area killed me:"+area.name)
	Death()
	flags["hit?"] = true
func _on_area_2d_body_entered(body: Node2D) -> void:
	if flags["hit?"] == true:
		return
	print("this body killed me:"+body.name)
	Death()
	flags["hit?"] = true

func Death():
	get_tree().change_scene_to_file("res://Effects/Screen effects/Death screen.tscn")


func smash_cooldown() -> void: 
	if current_state == states[1]:
		flags["smash"] = true
func _on_shoot_cooldown() -> void:
	if current_state == states[0]:
		flags["shoot"] = true
func _on_spawn_timeout() -> void:
	flags["spawn"] = true
func _on_cooldown_timeout() -> void:
	flags["cooldown"] = false
func _on_dash_timeout() -> void:
	velocity = clamp(velocity,min_velocity,max_velocity)
	if d != null:
		d.queue_free()
	if current_state == states[2]:
		flags["dash"] = true
	area.set_collision_mask_value(3,true)
	area.set_collision_mask_value(8,true)
