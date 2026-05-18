extends Control
#
@onready var arrow: Control = $HBoxContainer/VBoxContainer2/arrow
@onready var arrow_2: Control = $HBoxContainer/VBoxContainer2/arrow2
@onready var start: Label = $HBoxContainer/VBoxContainer/Start
@onready var options: Label = $HBoxContainer/VBoxContainer/Options
@onready var sure_flag = false
var savepath = "res://savedata.json"
var savedata:Dictionary
var option_selected:int = 0

const UI = preload("uid://b5pijvb5s1ujn")
const UI_SELECTED = preload("uid://dvpvf7wdsrfxi")

func _ready() -> void:
	savedata = load_json_file()
	option_selected = savedata["setting_no"]["title"]
	match option_selected:
		1:
			start.label_settings = UI
			options.label_settings = UI_SELECTED
			arrow.hide()
			arrow_2.show()
		0:
			start.label_settings = UI_SELECTED
			options.label_settings = UI
			arrow.show()
			arrow_2.hide()

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
	if event.is_action_pressed("ui_down"):
		option_selected =1
		start.label_settings = UI
		options.label_settings = UI_SELECTED
		sure_flag = false
		start.text = "Start"
		arrow.hide()
		arrow_2.show()
	if event.is_action_pressed("ui_up"):
		option_selected = 0
		start.label_settings = UI_SELECTED
		options.label_settings = UI
		arrow.show()
		arrow_2.hide()
	if event.is_action_pressed("ui_accept"):
		match option_selected:
			1:
				savedata["setting_no"]["title"] = option_selected
				save_to_json_file()
				get_tree().change_scene_to_file("res://Menus/settings.tscn")
			0:
				match sure_flag:
					true:
						savedata["setting_no"]["title"] = option_selected
						save_to_json_file()
						get_tree().change_scene_to_file("res://Levels/level_1.tscn")
					false:
						sure_flag = true
						start.text = "You sure?"
