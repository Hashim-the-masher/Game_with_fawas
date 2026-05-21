extends Control

@onready var arrow = [$SliderSettings/arrows/arrow,$SliderSettings/arrows/arrow2,$SliderSettings/arrows/arrow3]
@onready var title = [$SliderSettings/Titles/Size,$"SliderSettings/Titles/Fullscreen?",$SliderSettings/Titles/Quit]
@onready var setting = [$"SliderSettings/Display value/Size",$"SliderSettings/Display value/Fullscreen?",$"SliderSettings/Display value/Quit"]
var setting_no = 2
var move_mode = 0
var back_confirmation_flag = false
var savepath = "user://savedata.json"
var savedata:Dictionary
const ARROW = preload("uid://dyf64kjp5hdow")
const BI_ARROW = preload("uid://d24grgb0ooerg")
const UI_SETTINGS = preload("uid://b4ckevhw0xmal")
const UI_SETTINGS_SELECTED = preload("uid://bu6x8ru5xi2kt")
const UI_SETTINGS_HIDDEN = preload("uid://bi6gm77mgn5ao")
const screen = [1024,512]
@onready var you_did_it: TextureRect = $"../you_did_it"

func _ready() -> void:
	savedata = load_json_file()
	match savedata["w/l"][0]:
		1.0:
			you_did_it.show()
		0.0:
			you_did_it.hide()
	setting_no = savedata["setting_no"]["visuals"] 
	setting[0].text = str(savedata["settings"]["visuals"][0])
	print("Loaded value"+str(savedata["settings"]["visuals"][0])+"to size")
	setting[1].text  = str(savedata["settings"]["visuals"][1])
	print("Loaded value"+str(savedata["settings"]["visuals"][1])+"to fullscreen")
	
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

func _process(delta: float) -> void:
	match setting[1].text:
			"1.0": setting[1].text = "Yes"
			"0.0": setting[1].text = "No"

func _input(event: InputEvent) -> void:
	if move_mode == 0:
		if event.is_action_pressed("ui_up"):
			setting_no -= 1
			setting_no = clampi(setting_no,0,2)
			setting[2].text = "HI"
			setting[2].label_settings = UI_SETTINGS_HIDDEN
			back_confirmation_flag = false
		if event.is_action_pressed("ui_down"):
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
		if event.is_action_pressed("ui_left"):
			match setting_no:
				0:
					savedata["settings"]["visuals"][setting_no] -=.5
					savedata["settings"]["visuals"][setting_no] = clampf(savedata["settings"]["visuals"][setting_no],0.5,2.0)
				1:
					savedata["settings"]["visuals"][setting_no] -=1
					savedata["settings"]["visuals"][setting_no] = clampf(savedata["settings"]["visuals"][setting_no],0.0,1.0)
			setting[setting_no].text = str(savedata["settings"]["visuals"][setting_no])
		if event.is_action_pressed("ui_right"):
			match setting_no:
				0:
					savedata["settings"]["visuals"][setting_no] +=.5
					savedata["settings"]["visuals"][setting_no] = clampf(savedata["settings"]["visuals"][setting_no],0.5,2.0)
				1:
					savedata["settings"]["visuals"][setting_no] +=1
					savedata["settings"]["visuals"][setting_no] = clampf(savedata["settings"]["visuals"][setting_no],0.0,1.0)
			setting[setting_no].text = str(savedata["settings"]["visuals"][setting_no])
		if event.is_action_pressed("ui_accept"):
			arrow[setting_no].get_children()[0].texture = ARROW
			setting[setting_no].label_settings = UI_SETTINGS
			move_mode=0
			return
	if event.is_action_pressed("ui_accept"):
		savedata["setting_no"]["visuals"] = setting_no
		if setting_no == 2:
			var old_savedata = load_json_file()
			if back_confirmation_flag == true:
				save_to_json_file()
				if old_savedata["settings"]["visuals"][0] != savedata["settings"]["visuals"][0] or old_savedata["settings"]["visuals"][1] != savedata["settings"]["visuals"][1]:
					DisplayServer.window_set_size(Vector2i(screen[0]*savedata["settings"]["visuals"][0],screen[1]*savedata["settings"]["visuals"][0]))
					get_window().content_scale_factor = savedata["settings"]["visuals"][0]
					print("window size changed")
					
					match setting[1].text:
						"Yes":
							get_window().content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT
							DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
							print("window fullsckeen")	
						"No":
							get_window().content_scale_mode = Window.CONTENT_SCALE_MODE_DISABLED
							DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
							print("window windowed")	
				get_tree().change_scene_to_file("res://Menus/settings.tscn")
			if back_confirmation_flag == false:
				if old_savedata["settings"]["visuals"][0] != savedata["settings"]["visuals"][0] or old_savedata["settings"]["visuals"][1] != savedata["settings"]["visuals"][1]:
					title[2].label_settings = UI_SETTINGS
					setting[2].text = "Will apply new visuals"
					setting[2].label_settings = UI_SETTINGS_SELECTED
					back_confirmation_flag = true
				else:
					title[2].label_settings = UI_SETTINGS
					setting[2].text = "You sure?"
					setting[2].label_settings = UI_SETTINGS_SELECTED
					back_confirmation_flag = true
				return
		else:
			if move_mode == 0:
				title[setting_no].label_settings = UI_SETTINGS
				setting[setting_no].text = str(savedata["settings"]["visuals"][setting_no])
				setting[setting_no].label_settings = UI_SETTINGS_SELECTED
				move_mode = 1
				return
