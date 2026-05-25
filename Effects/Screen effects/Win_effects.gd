extends Control
var colour
var negative_colour
@onready var color_rect: ColorRect = $ColorRect
@onready var label: Label = $Label
var savepath = "user://savedata.json"
var savedata:Dictionary

func _ready() -> void:
	savedata = load_json_file()
	savedata["w/l"][0] = 1
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

func _physics_process(delta: float) -> void:
	var val1=randi_range(0,225)
	var val2=randi_range(0,225)
	var val3=randi_range(0,225)
	colour = Color8(val1,val2,val3)
	negative_colour = Color8(255-val1,255-val2,255-val3)
	color_rect.color = colour
	label.label_settings.font_color = negative_colour


func _on_timer_timeout() -> void:
	get_tree().quit()
