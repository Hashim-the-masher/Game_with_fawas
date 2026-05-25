extends Control

@onready var arrow = [$SliderSettings/arrows/arrow,$SliderSettings/arrows/arrow2,$SliderSettings/arrows/arrow3]
@onready var title = [$SliderSettings/Titles/Keyboard,$"SliderSettings/Titles/Controler",$SliderSettings/Titles/Quit]
@onready var setting = [null,null,$"SliderSettings/Display value/Quit"]
var setting_no = 2
var on = [false,false]
var back_confirmation_flag = false
var savepath = "user://savedata.json"
var savedata:Dictionary
const ARROW = preload("uid://dyf64kjp5hdow")
const BI_ARROW = preload("uid://d24grgb0ooerg")
const UI_SETTINGS = preload("uid://b4ckevhw0xmal")
const UI_SETTINGS_SELECTED = preload("uid://bu6x8ru5xi2kt")
const UI_SETTINGS_HIDDEN = preload("uid://bi6gm77mgn5ao")
const screen = [1024,512]
@onready var controler: TextureRect = $"../controler"
@onready var keyboard: TextureRect = $"../keyboard"

func _ready() -> void:
	savedata = load_json_file()
	setting_no = int(savedata["setting_no"]["controls"]) 
	title[setting_no].label_settings = UI_SETTINGS_SELECTED
	arrow[setting_no].show()


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
	if event.is_action_pressed("ui_up") and on[1] == false and on[0] == false:
		setting_no -= 1
		setting_no = clampi(setting_no,0,2)
		setting[2].text = ""
		setting[2].label_settings = UI_SETTINGS_HIDDEN
		back_confirmation_flag = false
	if event.is_action_pressed("ui_down") and on[1] == false and on[0] == false:
		setting_no += 1
		setting_no = clampi(setting_no,0,2)
	if back_confirmation_flag == false and on[1] == false and on[0] == false:
		for numbers in 3:
			if numbers == setting_no:
				title[numbers].label_settings = UI_SETTINGS_SELECTED
				arrow[numbers].show()
			else:
				title[numbers].label_settings = UI_SETTINGS
				arrow[numbers].hide()
	if event.is_action_pressed("ui_accept"):
		print(setting_no)
		savedata["setting_no"]["controls"] = setting_no
		match setting_no:
			0:
				if on[0] == true:
					on[0]=false
					title[0].label_settings = UI_SETTINGS_SELECTED
					keyboard.hide()
					return
				if on[0] == false:
					on[0]= true
					title[0].label_settings = UI_SETTINGS
					keyboard.show()
			1:
				if on[1] == true:
					on[1]=false
					title[1].label_settings = UI_SETTINGS_SELECTED
					controler.hide()
					return
				if on[1] == false:
					on[1]= true
					title[1].label_settings = UI_SETTINGS
					controler.show()
			2:
				if back_confirmation_flag == true:
					save_to_json_file()
					get_tree().change_scene_to_file("res://Menus/settings.tscn")
				if back_confirmation_flag == false:
					title[2].label_settings = UI_SETTINGS
					setting[2].text = "You sure?"
					setting[2].label_settings = UI_SETTINGS_SELECTED
					back_confirmation_flag = true
					return
