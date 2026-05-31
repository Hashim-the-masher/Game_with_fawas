extends Control
var colour
var negative_colour
@onready var color_rect: ColorRect = $ColorRect
@onready var layers = [$"VBoxContainer/0", $"VBoxContainer/1", $"VBoxContainer/2", $"VBoxContainer/3",$"VBoxContainer/4", $"VBoxContainer/5",$"VBoxContainer/6",$"VBoxContainer/7",$"VBoxContainer/8",$"VBoxContainer/9",$"VBoxContainer/10"]
const UI = preload("uid://b5pijvb5s1ujn")
const CREDITS = preload("uid://crx8iflknyvf")
@onready var music: AudioStreamPlayer = $"../AudioStreamPlayer"

var savepath = "res://credits.json"
var savepath2 = "user://savedata.json"
var savedata:Dictionary
var savedata2:Dictionary
var progress:int = -1

func _ready() -> void:
	if name != "???":
		return
	savedata = load_json_file()[0]
	savedata2 = load_json_file()[1]
	if music != null:
		music.volume_linear = savedata2["settings"]["sounds"][0]
		music.play(0)

func load_json_file():
	var file = FileAccess.open(savepath, FileAccess.READ)
	var file2 = FileAccess.open(savepath2, FileAccess.READ)
	if file2 != null:
		var json = file.get_as_text()
		var json2 = file2.get_as_text()
		var jsonobject = JSON.new()
		var jsonobject2 = JSON.new()
		jsonobject.parse(json)
		jsonobject2.parse(json2)
		print("Loaded:"+str(jsonobject.data)+"from file")
		print("Loaded:"+str(jsonobject2.data)+"from file")
		return [jsonobject.data,jsonobject2.data]
	return null

func _physics_process(delta: float) -> void:
	if name != "???":
		return
	var val1=randi_range(0,100)
	var val2=randi_range(0,100)
	var val3=randi_range(200,255)
	colour = Color8(val1,val2,val3)
	if layers[0] != null:
		for layer in layers:
			negative_colour = Color8(255-val1,255-val2,255-val3)
			for label in layer.get_children():
				var tween = get_tree().create_tween()
				tween.tween_property(label.label_settings,"font_color",negative_colour,1)
		var tween = get_tree().create_tween()
		tween.tween_property(color_rect,"color",colour,1)
		if progress <= 15 and progress > -1:
			if progress<11:
				layers[0+progress].get_child(1).text = savedata["credits"][1][0]
				layers[-1+progress].get_child(1).text = savedata["credits"][1][1]
			if progress>=11:
				layers[10].get_child(1).text = savedata["credits"][1][1]
				layers[0].get_child(1).text = savedata["credits"][1][1]
			match progress:
				9:
					layers[0+progress-9].get_child(1).text = savedata["credits"][1][2]
				10:
					layers[0+progress-9].get_child(1).text = savedata["credits"][1][2]
					layers[0+progress-10].get_child(1).text = savedata["credits"][1][3]
				11:
					layers[0+progress-9].get_child(1).text = savedata["credits"][1][2]
					layers[0+progress-10].get_child(1).text = savedata["credits"][1][3]
					layers[0+progress-11].get_child(1).text = savedata["credits"][1][4]
				12:
					layers[0+progress-9].get_child(1).text = savedata["credits"][1][2]
					layers[0+progress-10].get_child(1).text = savedata["credits"][1][3]
					layers[0+progress-11].get_child(1).text = savedata["credits"][1][4]
					layers[0+progress-12].get_child(1).text = ""
				13:
					layers[0+progress-9].get_child(1).text = savedata["credits"][1][2]
					layers[0+progress-10].get_child(1).text = savedata["credits"][1][3]
					layers[0+progress-11].get_child(1).text = savedata["credits"][1][4]
					layers[0+progress-12].get_child(1).text = ""
					layers[0+progress-13].get_child(1).text = savedata["credits"][1][5]
				14:
					layers[0+progress-9].get_child(1).text = savedata["credits"][1][2]
					layers[0+progress-10].get_child(1).text = savedata["credits"][1][3]
					layers[0+progress-11].get_child(1).text = savedata["credits"][1][4]
					layers[0+progress-12].get_child(1).text = ""
					layers[0+progress-13].get_child(1).text = savedata["credits"][1][5]
					layers[0+progress-14].get_child(1).text = savedata["credits"][1][6]
				15:
					clear_text()
					layers[0].get_child(1).text = ""
					layers[0].get_child(0).label_settings = UI
					layers[0].get_child(0).text = savedata["credits"][0][15]
					progress = 16
					return
			for layer in layers:
				layer.get_child(0).text = savedata["credits"][0][progress-int(layer.name)]
				if int(layer.name) > progress:
					layer.hide()
				else:layer.show()
	else: pass

func clear_text():
	for layer in layers:
		for label in layer.get_children():
			label.text = ""

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if progress == 16:
			get_tree().quit()



func _on_timer_timeout() -> void:
	if layers[0] == null or progress == 16:
		return
	layers[0].get_child(0).label_settings = CREDITS
	progress+=1
