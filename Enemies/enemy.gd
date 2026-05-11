extends CharacterBody2D

@export var hp = 10
@onready var player: CharacterBody2D = $"../player"

func _process(delta: float) -> void:
	rotation = atan2((player.position.y-position.y),(player.position.x-position.x))
