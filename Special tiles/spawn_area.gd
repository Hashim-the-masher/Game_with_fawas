extends Area2D
@onready var player: CharacterBody2D = $"../player"
@onready var spawn_area_pos: Node2D = $"../spawn area pos"
var finished_spawning_flag = false
@export var spawn_enemies = {"enemy":[],"location":[]}
var enemy = []

func _on_body_entered(body: Node2D) -> void:
	if finished_spawning_flag == true:
		return
	if body.name == "player":
		for n in 4:
			enemy.append(-1)
			enemy[n] = spawn_enemies["enemy"][n].instantiate()
			enemy[n].name = "Enemy"+str(n+2)
			enemy[n].position = spawn_enemies["location"][n]
			enemy[n].enemy_detected_flag = true
			add_sibling(enemy[n])
	player.position = spawn_area_pos.position
	player.velocity = Vector2.ZERO
	finished_spawning_flag = true
