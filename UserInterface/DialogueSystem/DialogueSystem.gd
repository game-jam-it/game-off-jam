extends Control

export(String) var dialogue_path = ""
export(float) var text_speed = 0.05

var dialogue: Array

var current_phrase: int = 0
var finished: bool = false

onready var name_label = $NinePatchRect/NameLabel
onready var text_label = $NinePatchRect/TextLabel
onready var text_timer = $TextSpeedTimer
onready var indicator = $NinePatchRect/Indicator
onready var portrait_left = $NinePatchRect/TextureRect/Portraits/PortraitLeft
onready var portrait_right = $NinePatchRect/TextureRect/Portraits/PortraitRight

func _ready():
	text_timer.wait_time = text_speed
	dialogue = get_dialogue()
	assert(dialogue, "No dialogue found")
	next_phrase()

func _input(event) -> void:
	if event.is_action_pressed("dialogue_next"):
		if finished:
			next_phrase()
		else:
			text_label.visible_characters = len(text_label.text)

func _process(_delta) -> void:
	indicator.visible = finished

func get_dialogue() -> Array:
	var file = File.new()
	assert(file.file_exists(dialogue_path), "Couldn't load dialogue file")
	
	file.open(dialogue_path, File.READ)
	var json = file.get_as_text()
	var output = parse_json(json)
	
	if output is Array:
		return output
	else:
		return []

func next_phrase() -> void:
	if current_phrase >= len(dialogue):
		queue_free()
		return
	
	finished = false
	
	name_label.bbcode_text = dialogue[current_phrase]["Name"]
	text_label.bbcode_text = dialogue[current_phrase]["Text"]
	text_label.visible_characters = 0
	
	# Change portraits
	var portrait_left_texture: String = dialogue[current_phrase]["PortraitLeft"]
	var portrait_right_texture: String = dialogue[current_phrase]["PortraitRight"]
	set_portraits(portrait_left_texture, portrait_right_texture)
	
	while text_label.visible_characters < len(text_label.text):
		text_label.visible_characters += 1
		
		text_timer.start()
		yield(text_timer, "timeout")
	
	finished = true
	current_phrase += 1
	return

func set_portraits(portrait_left_texture: String, portrait_right_texture: String) -> void:
	if portrait_left_texture != "":
		var texture_path: String = "res://Dialogue/CharacterPortraits/%s.png" % portrait_left_texture
		var portrait_texture: Resource = load(texture_path)
		if portrait_texture is Texture:
			portrait_left.texture = portrait_texture
		else:
			portrait_left.texture = null
	else:
		portrait_left.texture = null
	
	if portrait_right_texture != "":
		var texture_path: String = "res://Dialogue/CharacterPortraits/%s.png" % portrait_right_texture
		var portrait_texture: Resource = load(texture_path)
		if portrait_texture is Texture:
			portrait_right.texture = portrait_texture
		else:
			portrait_right.texture = null
	else:
		portrait_right.texture = null
