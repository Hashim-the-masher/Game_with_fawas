extends Control
#
@onready var arrow: Control = $HBoxContainer/VBoxContainer2/arrow
@onready var arrow_2: Control = $HBoxContainer/VBoxContainer2/arrow2
@onready var start: Label = $HBoxContainer/VBoxContainer/Start
@onready var options: Label = $HBoxContainer/VBoxContainer/Options
@onready var sure_flag = false

var option_selected:int = 0

const UI = preload("uid://b5pijvb5s1ujn")
const UI_SELECTED = preload("uid://dvpvf7wdsrfxi")

func _ready() -> void:
	start.label_settings = UI_SELECTED
	options.label_settings = UI
	arrow.show()
	arrow_2.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("down"):
		option_selected =1
		start.label_settings = UI
		options.label_settings = UI_SELECTED
		sure_flag = false
		start.text = "Start"
		arrow.hide()
		arrow_2.show()
	if event.is_action_pressed("up"):
		option_selected = 0
		start.label_settings = UI_SELECTED
		options.label_settings = UI
		arrow.show()
		arrow_2.hide()
	if event.is_action_pressed("enter"):
		match option_selected:
			1:
				get_tree().change_scene_to_file("res://Menus/Settings.tscn")
			0:
				match sure_flag:
					true:
						get_tree().change_scene_to_file("res://Levels/level_1.tscn")
					false:
						sure_flag = true
						start.text = "You sure?"
