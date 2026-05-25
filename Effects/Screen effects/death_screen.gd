extends Control

@onready var label: Label = $Label
@onready var timer: Timer = $Timer
var cocksize = 64
var savepath = "user://savedata.json"
var savedata:Dictionary
var ttime = 3.405

func _ready() -> void:
	savedata = load_json_file()
	savedata["w/l"][1] += 1
	save_to_json_file()
	timer.wait_time = ttime

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
	label.label_settings.font_size = lerp(16,cocksize,ttime-timer.time_left)
	label.label_settings.font_color.a8 = lerp(0,255,ttime-timer.time_left)
	if ttime-timer.time_left > ttime-0.05:
		timer.stop()
		get_tree().quit()
