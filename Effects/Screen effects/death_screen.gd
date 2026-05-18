extends Control

@onready var label: Label = $Label
@onready var timer: Timer = $Timer
var cocksize = 64
var savepath = "res://savedata.json"
var savedata:Dictionary

func _ready() -> void:
	savedata = load_json_file()
	savedata["w/l"][1] += 1
	save_to_json_file()

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
	label.label_settings.font_size = lerp(16,cocksize,4.25-timer.time_left)
	label.label_settings.font_color.a8 = lerp(0,255,4.25-timer.time_left)
	
	if 4.25-timer.time_left > 4.2:
		timer.stop()
