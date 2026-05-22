extends Control

@onready var menu_pause: Control = $".."
@onready var title = $SliderSettings/Titles
var setting_no:int = 3
const UI_SETTINGS = preload("uid://b4ckevhw0xmal")
const UI_SETTINGS_SELECTED = preload("uid://bu6x8ru5xi2kt")
var back_confirmation_flag = false

func _input(event: InputEvent) -> void:
	if menu_pause.settings == false:
		return
		hide()
	show()
	if event.is_action_pressed("ui_up"):
		setting_no -= 1
		setting_no = clampi(setting_no,0,3)
		back_confirmation_flag = false
		title.get_child(3).text = "Back"
	if event.is_action_pressed("ui_down"):
		setting_no += 1
		setting_no = clampi(setting_no,0,3)
	if back_confirmation_flag == false:
		for numbers in 4:
			if numbers == setting_no:
				title.get_child(numbers).label_settings = UI_SETTINGS_SELECTED
			else:
				title.get_child(numbers).label_settings = UI_SETTINGS
	if event.is_action_pressed("ui_accept"):
		match setting_no:
			0:
				get_tree().change_scene_to_file("res://Menus/sound.tscn")
			1:
				get_tree().change_scene_to_file("res://Menus/visual.tscn")
			2:
				pass
			3:
				if back_confirmation_flag == true:
					pass
				if back_confirmation_flag == false:
					title.get_child(3).text = "All done?"
					back_confirmation_flag = true
					return
