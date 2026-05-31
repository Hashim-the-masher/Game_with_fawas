extends Control
@onready var label: Label = $Label
var savepath = "res://winning again speech.json"
var savedata:Dictionary
var speech_pos = 0
var characters_visible = 0
@onready var big_timer: Timer = $"big timer"
@onready var small_timer: Timer = $"small timer"
var repeat = 0
var first_time_flag = true
func _ready() -> void:
	savedata = load_json_file()
	label.text = savedata["speech"][speech_pos]

func load_json_file():
	var file = FileAccess.open(savepath, FileAccess.READ)
	var json = file.get_as_text()
	var jsonobject = JSON.new()
	jsonobject.parse(json)
	print("Loaded:"+str(jsonobject.data)+"from file")
	return jsonobject.data


func _on_big_timer_timeout() -> void:
	if first_time_flag == true:
		first_time_flag = false
		big_timer.start()
		return
	if speech_pos == 13:
		repeat +=1
		if repeat == 3:
			speech_pos += 1
	else:speech_pos += 1
	characters_visible = 0
	label.text = savedata["speech"][speech_pos]
	label.visible_characters = characters_visible
	small_timer.start()

func _on_small_timer_timeout() -> void:
	characters_visible += 1
	label.visible_characters = characters_visible
	if characters_visible == label.text.length():
		if speech_pos == 14:
			get_tree().quit()
		big_timer.start()
	else:
		small_timer.start()
		
