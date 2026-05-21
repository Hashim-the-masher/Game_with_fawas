extends Control
var colour
var negative_colour
@onready var color_rect: ColorRect = $ColorRect
@onready var layers = [$VBoxContainer/HBoxContainer, $VBoxContainer/HBoxContainer2, $VBoxContainer/HBoxContainer3, $VBoxContainer/HBoxContainer4, $VBoxContainer/HBoxContainer5, $VBoxContainer/HBoxContainer6]

var savepath = "/home/haal/.local/share/Game with fawas/savedata.json"
var savedata:Dictionary
var progress:int = -1

func _ready() -> void:
	savedata = load_json_file()
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
	var val1=randi_range(0,100)
	var val2=randi_range(0,100)
	var val3=randi_range(200,255)
	colour = Color8(val1,val2,val3)
	if layers[0] != null:
		for label in layers[0].get_children():
			negative_colour = Color8(255-val1,255-val2,255-val3)
			var tween = get_tree().create_tween()
			tween.tween_property(label.label_settings,"font_color",negative_colour,1)
		var tween = get_tree().create_tween()
		tween.tween_property(color_rect,"color",colour,1)
		if progress <= 15 and progress > -1:
			layers[0].get_child(0).text = savedata["credits"][0][progress]
	else: pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		progress+=1
