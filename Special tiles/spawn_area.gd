extends Area2D
@onready var player: CharacterBody2D = $"../player"
@onready var spawn_area_pos: Node2D = $"../spawn area pos"
var finished_spawning_flag = false
@export var custom_spawn_loc:bool
@export var spawn_enemies = {"enemy":[],"location":[]}
var enemy = []
@onready var daddy_node: Node2D = $".."

func _on_body_entered(body: Node2D) -> void:
	if finished_spawning_flag == true:
		return
	if body.name == "player" and spawn_enemies["enemy"].size() > 0:
		
		for n in spawn_enemies["enemy"].size():
			enemy.append(-1)
			enemy[n] = spawn_enemies["enemy"][n].instantiate()
			enemy[n].position = spawn_enemies["location"][n]
			enemy[n].enemy_detected_flag = true
			add_sibling(enemy[n])
		connect_signals()

func connect_signals():
	for child in daddy_node.get_children():
		if child.name.containsn("smash") == true:
			child.connect("kill",player._on_smash_kill)

	if custom_spawn_loc == true:
		player.position = spawn_area_pos.position
		player.velocity = Vector2.ZERO
	
	finished_spawning_flag = true
