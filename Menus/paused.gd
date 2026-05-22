extends Control


@onready var resume: Label = $HBoxContainer/VBoxContainer/Resume
@onready var options: Label = $HBoxContainer/VBoxContainer/Options
var savepath = "user://savedata.json"
var savedata:Dictionary
var option_selected:int = 0
var active:bool = false
const screen = [1024,512]
const UI = preload("uid://b5pijvb5s1ujn")
const UI_SELECTED = preload("uid://dvpvf7wdsrfxi")

func _ready() -> void:
	savedata = load_json_file()
	option_selected = savedata["setting_no"]["title"]
	match option_selected:
		1:
			resume.label_settings = UI
			options.label_settings = UI_SELECTED
		0:
			resume.label_settings = UI_SELECTED
			options.label_settings = UI
	DisplayServer.window_set_size(Vector2i(screen[0]*savedata["settings"]["visuals"][0],screen[1]*savedata["settings"]["visuals"][0]))
	get_window().content_scale_factor = savedata["settings"]["visuals"][0]
	match savedata["settings"]["visuals"][1]:
		1.0:
			get_window().content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			print("window fullsckeen")	
		0.0:
			get_window().content_scale_mode = Window.CONTENT_SCALE_MODE_DISABLED
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			print("window windowed")	

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
	if event.is_action_pressed("esc"):
		if active == true:
			active=false
		else:active=true
	if active == false:
		hide()
		return
	show()
	if event.is_action_pressed("ui_down"):
		option_selected =1
		resume.label_settings = UI
		options.label_settings = UI_SELECTED
		resume.text = "Resume"
	if event.is_action_pressed("ui_up"):
		option_selected = 0
		resume.label_settings = UI_SELECTED
		options.label_settings = UI
	if event.is_action_pressed("ui_accept"):
		match option_selected:
			1:
				#make pause settings
				pass
			0:
				active = false
