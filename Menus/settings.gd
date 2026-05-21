extends Control

@onready var arrow = [$SliderSettings/arrows/arrow,$SliderSettings/arrows/arrow2,$SliderSettings/arrows/arrow3,$SliderSettings/arrows/arrow4]
@onready var title = $SliderSettings/Titles
var setting_no:int = 3
var back_confirmation_flag = false
var savepath = "user://savedata.json"
var savedata:Dictionary
const ARROW = preload("uid://dyf64kjp5hdow")
const UI_SETTINGS = preload("uid://b4ckevhw0xmal")
const UI_SETTINGS_SELECTED = preload("uid://bu6x8ru5xi2kt")
@onready var you_did_it: TextureRect = $"../you_did_it"


func _ready() -> void:
	savedata = load_json_file()
	match savedata["w/l"][0]:
		1.0:
			you_did_it.show()
		0.0:
			you_did_it.hide()
	setting_no = int(savedata["setting_no"]["settings"])
	title.get_child(setting_no).label_settings = UI_SETTINGS_SELECTED
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
				arrow[numbers].show()
			else:
				title.get_child(numbers).label_settings = UI_SETTINGS
				arrow[numbers].hide()
	if event.is_action_pressed("ui_accept"):
		savedata["setting_no"]["settings"] = setting_no
		save_to_json_file()
		print(setting_no)
		match setting_no:
			0:
				get_tree().change_scene_to_file("res://Menus/sound.tscn")
			1:
				get_tree().change_scene_to_file("res://Menus/visual.tscn")
			2:
				pass
			3:
				if back_confirmation_flag == true:
					get_tree().change_scene_to_file("res://Menus/Title_screen.tscn")
				if back_confirmation_flag == false:
					title.get_child(3).text = "All done?"
					back_confirmation_flag = true
					return
