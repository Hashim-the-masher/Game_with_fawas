extends CharacterBody2D #there is nothing better than spegetti, i have no clue what the fuck is going on here...
#these first ones are ovious, they are parameters used to rotate the player
var rotaion_velocity:float
@export var rotation_speed:float = .5
@export var max_rotation:float = .1
@export var min_rotation:float = -.1
@export var rotation_friction:float = 1.15

#these are for the character's speed and velocity manipulatuaion
@export var speed:float = 150 #this one is the speed of the movment respective of the player
@export var tank_speed = speed*PI #this one is the speed of the movment irrespective of the player, this one is slower despite having a bigger number because of the braking fiction always applies to this movment mode
@export var max_velocity:float = 250 #this one caps the max velocity above a value
@export var min_velocity:float = 0.1  #this caps the velocity when its under a value
@export var back_slow_mutiplyer:float = .2 #this one slows you down when going backwards
@export var friction:float = 1.03 #this one applies a fiction to the movment
@export var breaking_friction:float = 1.1 #larger firction applied when the character stopped moving(inputing movment)

#These are for accessing the camera and other mislanous stuff
@onready var camera: Camera2D = $Camera2D
@onready var audio_listener: AudioListener2D = $AudioListener2D
@onready var menu_pause: Control = $"../CanvasLayer/menu_pause"
#these are for shooting the various wepons in the dispoal of the player...
var d #this one is for making a dash instance
@onready var area: Area2D = $Area2D #this one is for removing some collitions for the dash
@export var cooldown = 0.25 #this one is a cooldown shared by the smash and the dash
@onready var bullet_scenes = {"bullet":preload("res://Player bullets/Bullet.tscn"),"smash":preload("res://Player bullets/smash.tscn"),"dash":preload("res://Player bullets/dash.tscn")} #this one loads the scenes of the bullets
@onready var timers = {"shoot":$shoot,"smash":$smash,"dash":$dash} #this one gets the timers for bullet life time
var flags = {"dash":false,"smash":false,"shoot":true,"spawn":false,"cooldown":true} #these are all the flags used in this code, the first two are to indicate that the liftime of the bullet is over, the shoot is to indicate when your able to shoot again, the spawn desables movent untill its true,cooldown is the shared colldown of the dash/smash
@onready var meshes = $"Mesh(es)" #this one gets the parent of the meshes for easy access
var current_state:StringName #this one is used to display the current state
var states = {0:"Normal state",1:"Smash state",2:"Dash state"} #dictionary contains all the posible states


func _ready() -> void:#this one makes sure that the state is the normal state and no some other bullshit
	current_state = states[0]
	switch_mesh(current_state)
	switch_ablity(current_state)
	
	

func switch_mesh(state:StringName):#this one switches the mesh to the desired state
	for num in states:
		if state == meshes.get_child(num).name:
			meshes.get_child(num).show()
			print(states[num],"shown")
		elif state != meshes.get_child(num).name:
			meshes.get_child(num).hide()
			print(states[num],"hidden")

func switch_ablity(state:StringName):#this one switches the flags so that a certain bullet will be used for the desired state
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

func _physics_process(delta: float) -> void:#this one is a bit more complex because it contains all the physics procceses
	if menu_pause != null:
		if menu_pause.active == true:
			return
	if Input.is_action_pressed("Shoot") and flags["spawn"] == true:  #this one shoots any bullet
		shoot()
		flags["shoot"]= false
	if current_state == states[2] and flags["dash"] == false: # if the bullet was a dash, then
		if d != null: #it will set the position and rotaion to the dash's pos and dir, and remove some collision with objects
			area.set_collision_mask_value(3,false)
			area.set_collision_mask_value(8,false)
			position = d.position
			rotation = d.rotation
			
		else:# otherwise if the dash was not found then it will exit the dash
			_on_dash_timeout()
	elif flags["spawn"] == true:#and if the playercharacter is not dashing, then
		if Input.get_vector("backwards","forwards","NA","NA"):#forwards/backwards velocity going to where the player is facing and if not then
			if sqrt(velocity.x**2+velocity.y**2) < max_velocity:
				velocity += Input.get_vector("backwards","forwards","NA","NA").rotated(rotation)*speed*delta
				if Input.is_action_pressed("backwards"):#backwards movement is slower than forwards
					velocity -= (Input.get_vector("backwards","forwards","NA","NA").rotated(rotation)*speed*delta)*back_slow_mutiplyer
				velocity /= friction
		elif Input.get_vector("left","right","up","down"):#up down left and right movent, no matter where the playecahracter is moving and 
			velocity += Input.get_vector("left","right","up","down")*tank_speed*delta
			velocity /= breaking_friction
		elif sqrt(velocity.x**2+velocity.y**2)>min_velocity:# if no movment is done then only the breaking fiction is apllied
			velocity /= breaking_friction
		else:pass #othewise if the player character is still it will do nothign
		#then, finnally, it always applies the rotation
		rotaion_velocity += Input.get_vector("NA","NA","turn left","turn right").y*rotation_speed*delta
		rotaion_velocity /= rotation_friction
		rotaion_velocity = clampf(rotaion_velocity,min_rotation,max_rotation)
		rotation += rotaion_velocity
		audio_listener.rotation -= rotaion_velocity

		move_and_slide()#this proccess applies the velocity

#when a enemy is connected, it sends a death signal to make the player change states
func _on_smash_kill() -> void:
	current_state = states[1]
	switch_mesh(current_state)
	switch_ablity(current_state)
func _on_dash_kill() -> void:
	current_state = states[2]
	switch_mesh(current_state)
	switch_ablity(current_state)

func shoot():#ahh the shoot function, it sees wich flag you have and shoots the aporptiate bullets
	if flags["shoot"] == true:#the shoot varriable works differently because it uses the shoot flag as a cooldown, while the dash and smash use the cooldown flag, this is becasuse the smash and dash flags are used are a bullet life time
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

#these kill the player when the inner area of the player comes in contact with anything deadly.
func _on_Enemy_contact(area: Area2D) -> void:
	print("this area killed me:"+area.name)
	Death()
func _on_area_2d_body_entered(body: Node2D) -> void:
	print("this body killed me:"+body.name)
	Death()

func Death():#this one just kills the player by changing scenes, but its a function just in case i wanted to add anyhing when the player dies
	get_tree().change_scene_to_file("res://Effects/Screen effects/Death screen.tscn")

#these are just flags that get activated when a timer is over
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
func _on_dash_timeout() -> void:#the dash is the same but a little more complex because, its not just a bullet, it also effects the player's collisions adn movment
	velocity = clamp(velocity,min_velocity,max_velocity)
	if d != null:
		d.queue_free()
	if current_state == states[2]:
		flags["dash"] = true
	area.set_collision_mask_value(3,true)
	area.set_collision_mask_value(8,true)
