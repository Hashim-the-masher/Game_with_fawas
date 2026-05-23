extends Node2D
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect
var savepath = "user://savedata.json"
var savedata:Dictionary


func _ready() -> void:
	color_rect.show()
	savedata = load_json_file()
	for child in get_children():
		if child.name.containsn("mus"):
			child.volume_db = linear_to_db(savedata["settings"]["sounds"][0])
	for child in get_children():
		if child.name.containsn("sfx"):
			child.volume_db = linear_to_db(savedata["settings"]["sounds"][1])
	var tween = get_tree().create_tween()
	tween.tween_property(color_rect, "color", Color.TRANSPARENT, 1.0)
	tween.play()
	await tween.finished
	tween.kill()


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
