extends Control

@onready var menu_pause: Control = $".."
@onready var titles = [$main/Titles,$sound/SliderSettings/Titles,$visual/SliderSettings/Titles,$controls/SliderSettings/Titles,$controls/SliderSettings/Titles]
var titles_sizes = [[0,0,0,0],[0,0,0],[0,0,0],[0,0,0]]
@onready var values = [null,$"sound/SliderSettings/Display value",$"visual/SliderSettings/Display value",null]
@onready var arrows = [[$main/arrows/arrow/arrow, $main/arrows/arrow2/arrow2, $main/arrows/arrow3/arrow3, $main/arrows/arrow4/arrow3],[$sound/SliderSettings/arrows/arrow/arrow, $sound/SliderSettings/arrows/arrow2/arrow2, $sound/SliderSettings/arrows/arrow3/arrow3],[$visual/SliderSettings/arrows/arrow/arrow, $visual/SliderSettings/arrows/arrow2/arrow2, $visual/SliderSettings/arrows/arrow3/arrow3],[$controls/SliderSettings/arrows/arrow/arrow, $controls/SliderSettings/arrows/arrow2/arrow2, $controls/SliderSettings/arrows/arrow3/arrow3]]
@onready var level: Node2D = $"../../.."
@onready var player: CharacterBody2D = $"../../../player"
var setting_no = [3,2,2,2]
const UI_SETTINGS = preload("uid://b4ckevhw0xmal")
const UI_SETTINGS_SELECTED = preload("uid://bu6x8ru5xi2kt")
var back_confirmation_flag = false
@onready var asettings = get_children(false)
var current_setting = 0
var on = [false,false]
@onready var keyboard: TextureRect = $keyboard
@onready var controler: TextureRect = $controler
const LIGHT_BI_ARROW = preload("uid://pjnv4b1w6ef7")
const LIGHT_ARROW = preload("uid://cv5f0412ftkvv")
var move_mode = 0
var savepath = "user://savedata.json"
var savedata:Dictionary
const screen = [1024,512]
func _ready() -> void: 
	savedata = load_json_file()
	values[1].get_child(0).text =  str(savedata["settings"]["sounds"][0])
	values[1].get_child(1).text =  str(savedata["settings"]["sounds"][1])
	values[2].get_child(0).text = str(savedata["settings"]["visuals"][0])
	values[2].get_child(1).text = str(savedata["settings"]["visuals"][1])
	match values[2].get_child(1).text:
		"1.0":
			values[2].get_child(1).text = "Yes"
		"0.0":
			values[2].get_child(1).text = "No"

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
	if move_mode == 1:
		titles[current_setting].get_child(setting_no[current_setting]).label_settings = UI_SETTINGS
		values[current_setting].get_child(setting_no[current_setting]).label_settings = UI_SETTINGS_SELECTED
		match current_setting:
			1:
				if event.is_action_pressed("ui_left"):
					savedata["settings"]["sounds"][setting_no[current_setting]] -=.1
					savedata["settings"]["sounds"][setting_no[current_setting]] = clampf(savedata["settings"]["sounds"][setting_no[current_setting]],0.0,1.0)
					values[current_setting].get_child(setting_no[current_setting]).text = str(savedata["settings"]["sounds"][setting_no[current_setting]])
				if event.is_action_pressed("ui_right"):
					savedata["settings"]["sounds"][setting_no[current_setting]] +=.1
					savedata["settings"]["sounds"][setting_no[current_setting]] = clampf(savedata["settings"]["sounds"][setting_no[current_setting]],0.0,1.0)
					values[current_setting].get_child(setting_no[current_setting]).text = str(savedata["settings"]["sounds"][setting_no[current_setting]])
				if event.is_action_pressed("ui_accept"):
					values[current_setting].get_child(setting_no[current_setting]).label_settings = UI_SETTINGS
					move_mode=0
					save_to_json_file()
					level.reset_volume()
					player.reset_volume()
					return
			2:
				if event.is_action_pressed("ui_left"):
					match setting_no[current_setting]:
						0:
							savedata["settings"]["visuals"][setting_no[current_setting]] -=.5
							savedata["settings"]["visuals"][setting_no[current_setting]] = clampf(savedata["settings"]["visuals"][setting_no[current_setting]],0.5,2.0)
						1:
							savedata["settings"]["visuals"][setting_no[current_setting]] -=1
							savedata["settings"]["visuals"][setting_no[current_setting]] = clampf(savedata["settings"]["visuals"][setting_no[current_setting]],0,1.0)
					values[current_setting].get_child(setting_no[current_setting]).text = str(savedata["settings"]["visuals"][setting_no[current_setting]])
					match values[current_setting].get_child(1).text:
						"1.0":
							values[current_setting].get_child(1).text = "Yes"
						"0.0":
							values[current_setting].get_child(1).text = "No"
				if event.is_action_pressed("ui_right"):
					match setting_no[current_setting]:
						0:
							savedata["settings"]["visuals"][setting_no[current_setting]] +=.5
							savedata["settings"]["visuals"][setting_no[current_setting]] = clampf(savedata["settings"]["visuals"][setting_no[current_setting]],0.5,2.0)
						1:
							savedata["settings"]["visuals"][setting_no[current_setting]] +=1
							savedata["settings"]["visuals"][setting_no[current_setting]] = clampf(savedata["settings"]["visuals"][setting_no[current_setting]],0,1.0)
					values[current_setting].get_child(setting_no[current_setting]).text = str(savedata["settings"]["visuals"][setting_no[current_setting]])
					match values[current_setting].get_child(1).text:
						"1.0":
							values[current_setting].get_child(1).text = "Yes"
						"0.0":
							values[current_setting].get_child(1).text = "No"
				if event.is_action_pressed("ui_accept"):
					values[current_setting].get_child(setting_no[current_setting]).label_settings = UI_SETTINGS
					move_mode=0
					save_to_json_file()
					return
		return
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
				arrows[current_setting][numbers].show()
			else:
				titles[current_setting].get_child(numbers).label_settings = UI_SETTINGS
				arrows[current_setting][numbers].hide()
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
						move_mode = 1
					1:
						move_mode = 1
					2:
						current_setting = 0
						return
			2:
				match setting_no[current_setting]:
					0:
						move_mode = 1
					1:
						move_mode = 1
					2:
						DisplayServer.window_set_size(Vector2i(screen[0]*savedata["settings"]["visuals"][0],screen[1]*savedata["settings"]["visuals"][0]))
						match values[2].get_child(1).text:
							"Yes":
								DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
								print("window fullsckeen")	
							"No":
								DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
								print("window windowed")	
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

func exit_settings():
	on[0] = false
	on[1] = false
	current_setting = 0
	move_mode = 0 
	keyboard.hide()
	controler.hide()
	for node in asettings:
		node.hide()
