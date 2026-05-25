extends Control

@onready var menu_pause: Control = $".."
@onready var titles = [$main/Titles,$sound/SliderSettings/Titles,$visual/SliderSettings/Titles,$controls/SliderSettings/Titles,$controls/SliderSettings/Titles]
var titles_sizes = [[0,0,0,0],[0,0,0],[0,0,0],[0,0,0]]
@onready var values = [null,$"sound/SliderSettings/Display value",$"visual/SliderSettings/Display value",null]
var setting_no = [3,2,2,2]
const UI_SETTINGS = preload("uid://b4ckevhw0xmal")
const UI_SETTINGS_SELECTED = preload("uid://bu6x8ru5xi2kt")
var back_confirmation_flag = false
@onready var asettings = get_children(false)
var current_setting = 0
var on = [false,false]
@onready var keyboard: TextureRect = $keyboard
@onready var controler: TextureRect = $controler

func _input(event: InputEvent) -> void:
	if menu_pause.settings == false:
		asettings[current_setting].hide()
		return
	asettings[current_setting].show()
	if event.is_action_pressed("ui_up") and on[1] == false and on[0] == false:
		setting_no[current_setting] -= 1
		setting_no[current_setting] = clampi(setting_no[current_setting],0,titles_sizes[current_setting].size()-1)
		if current_setting == 0:
			back_confirmation_flag = false
			titles[current_setting].get_child(3).text = "Back"
	if event.is_action_pressed("ui_down") and on[1] == false and on[0] == false:
		setting_no[current_setting] += 1
		setting_no[current_setting] = clampi(setting_no[current_setting],0,titles_sizes[current_setting].size()-1)
	if back_confirmation_flag == false and on[1] == false and on[0] == false:
		for numbers in titles_sizes[current_setting].size():
			if numbers == setting_no[current_setting]:
				titles[current_setting].get_child(numbers).label_settings = UI_SETTINGS_SELECTED
			else:
				titles[current_setting].get_child(numbers).label_settings = UI_SETTINGS
		for nodes in asettings:
			if nodes != asettings[current_setting]:
				nodes.hide()
			else:nodes.show()
	if event.is_action_pressed("ui_accept"):
		print(setting_no)
		match current_setting:
			0:
				match setting_no[current_setting]:
					0:
						current_setting = setting_no[current_setting]+1
						return
					1:
						current_setting = setting_no[current_setting]+1
						return
					2:
						current_setting = setting_no[current_setting]+1
						return
					3:
						menu_pause.ignore = true
						asettings[current_setting].hide()
						menu_pause.settings = false
						return
			1:
				match setting_no[current_setting]:
					0:
						pass
					1:
						pass
					2:
						current_setting = 0
						return
			2:
				match setting_no[current_setting]:
					0:
						pass
					1:
						pass
					2:
						current_setting = 0
						return
			3:
				match setting_no[current_setting]:
					0:
						if on[0] == true:
							on[0]=false
							titles[current_setting].get_child(0).label_settings = UI_SETTINGS_SELECTED
							keyboard.hide()
							return
						if on[0] == false:
							on[0]= true
							titles[current_setting].get_child(0).label_settings = UI_SETTINGS
							keyboard.show()
					1:
						if on[1] == true:
							on[1]=false
							titles[current_setting].get_child(1).label_settings = UI_SETTINGS_SELECTED
							controler.hide()
							return
						if on[1] == false:
							on[1]= true
							titles[current_setting].get_child(1).label_settings = UI_SETTINGS
							controler.show()
					2:
						current_setting = 0
						return
