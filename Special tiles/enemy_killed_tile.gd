extends StaticBody2D

@export var number_of_enemies_requred:int

func on_enemy_killed():
	number_of_enemies_requred -=1
	if number_of_enemies_requred == 0:
		queue_free()
