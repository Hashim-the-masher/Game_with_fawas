extends Control

@onready var arrow = [$SliderSettings/arrows/arrow,$SliderSettings/arrows/arrow2,$SliderSettings/arrows/arrow3]
@onready var title = [$SliderSettings/Titles/Music,$SliderSettings/Titles/Sounds,$SliderSettings/Titles/Quit]
@onready var setting = [$"SliderSettings/Display value/Music",$"SliderSettings/Display value/Sounds",$"SliderSettings/Display value/Quit"]
var setting_no = 2
var move_mode = 0
var back_confirmation_flag = false
var savepath = "res://savedata.json"
var savedata:Dictionary
const ARROW = preload("uid://dyf64kjp5hdow")
const BI_ARROW = preload("uid://d24grgb0ooerg")
const UI_SETTINGS = preload("uid://b4ckevhw0xmal")
const UI_SETTINGS_SELECTED = preload("uid://bu6x8ru5xi2kt")
const UI_SETTINGS_HIDDEN = preload("uid://bi6gm77mgn5ao")


func _ready() -> void:
	savedata = load_json_file()
	setting[0].text = str(savedata["settings"][0])
	print("Loaded value"+str(savedata["settings"][0])+"to music")
	setting[1].text  = str(savedata["settings"][1])
	print("Loaded value"+str(savedata["settings"][1])+"to sounds")
	
	title[2].label_settings = UI_SETTINGS_SELECTED
	arrow[2].show()

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

func _input(event: InputEvent) -> void:
	if move_mode == 0:
		if event.is_action_pressed("up"):
			setting_no -= 1
			setting_no = clampi(setting_no,0,2)
			setting[2].text = "HI"
			setting[2].label_settings = UI_SETTINGS_HIDDEN
			back_confirmation_flag = false
		if event.is_action_pressed("down"):
			setting_no += 1
			setting_no = clampi(setting_no,0,2)
		if back_confirmation_flag == false:
			for numbers in 3:
				if numbers == setting_no:
					title[numbers].label_settings = UI_SETTINGS_SELECTED
					arrow[numbers].show()
				else:
					title[numbers].label_settings = UI_SETTINGS
					arrow[numbers].hide()
	if move_mode == 1:
		arrow[setting_no].get_children()[0].texture = BI_ARROW
		if event.is_action_pressed("left"):
			savedata["settings"][setting_no] -=.1
			savedata["settings"][setting_no] = clampf(savedata["settings"][setting_no],0.0,1.0)
		if event.is_action_pressed("right"):
			savedata["settings"][setting_no] +=.1
			savedata["settings"][setting_no] = clampf(savedata["settings"][setting_no],0.0,1.0)
		setting[setting_no].text = str(savedata["settings"][setting_no])
		if event.is_action_pressed("enter"):
			arrow[setting_no].get_children()[0].texture = ARROW
			setting[setting_no].label_settings = UI_SETTINGS
			move_mode=0
			save_to_json_file()
			return
	if event.is_action_pressed("enter"):
		if setting_no == 2:
			if back_confirmation_flag == true:
				get_tree().change_scene_to_file("res://Menus/Title_screen.tscn")
			if back_confirmation_flag == false:
				title[2].label_settings = UI_SETTINGS
				setting[2].text = "You sure?"
				setting[2].label_settings = UI_SETTINGS_SELECTED
				back_confirmation_flag = true
				return
		else:
			if move_mode == 0:
				title[setting_no].label_settings = UI_SETTINGS
				setting[setting_no].text = str(savedata["settings"][setting_no])
				setting[setting_no].label_settings = UI_SETTINGS_SELECTED
				move_mode = 1
				return
