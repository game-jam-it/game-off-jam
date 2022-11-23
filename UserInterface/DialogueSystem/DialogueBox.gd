extends Control

var dialogue_file: String = ""
var dialogue_path: String = "res://Dialogue/%s.json"
export(float) var text_speed = 0.05

var dialogue: Array

var current_phrase: int = -1
var phrase_finished: bool = false

var choice_phrase: bool = false
var selected_choice: int = 1 setget set_selected_choice
var selected_choice_result_method: String = ""

onready var name_label = $NinePatchRect/NameLabel
onready var text_label = $NinePatchRect/TextLabel
onready var text_timer = $TextSpeedTimer
onready var indicator = $NinePatchRect/Indicator

onready var portrait_left = $NinePatchRect/TextureRect/Portraits/PortraitLeft
onready var portrait_right = $NinePatchRect/TextureRect/Portraits/PortraitRight

onready var choice_system = $NinePatchRect/ChoiceSystem
onready var choice_1_label = $NinePatchRect/ChoiceSystem/ChoicesList/Choice1/TextLabel
onready var choice_2_label = $NinePatchRect/ChoiceSystem/ChoicesList/Choice2/TextLabel
onready var choice_1_indicator = $NinePatchRect/ChoiceSystem/ChoicesList/Choice1/TextureRect
onready var choice_2_indicator = $NinePatchRect/ChoiceSystem/ChoicesList/Choice2/TextureRect

func _ready():
	text_timer.wait_time = text_speed
	dialogue = get_dialogue(dialogue_file)
	assert(dialogue, "No dialogue found")
	next_phrase()

func _input(event) -> void:
	if event.is_action_pressed("dialogue_next"):
		if phrase_finished:
			if choice_phrase:
				# Get the method to call
				var choice_array: Array
				var choice_method: String
				var choice_method_parameter: String = ""
				if selected_choice == 1:
					choice_array = dialogue[current_phrase]["Choice1"]
					choice_method = choice_array[1]
					if choice_array.size() >= 3:
						choice_method_parameter = choice_array[2]
				if selected_choice == 2:
					choice_array = dialogue[current_phrase]["Choice2"]
					choice_method = choice_array[1]
					if choice_array.size() >= 3:
						choice_method_parameter = choice_array[2]
				if self.has_method(choice_method):
					if choice_method_parameter != "":
						print(str(choice_method) + " and parameter: " + str(choice_method_parameter))
						call(choice_method, choice_method_parameter)
					else:
						call(choice_method)
				# If the dialogue should be cancelled call close_dialogue as the choice_method
				next_phrase()
			else:
				next_phrase()
		else:
			text_label.visible_characters = len(text_label.text)
	
	# Selecting a choice
	if choice_phrase:
		if event.is_action_pressed("ui_up"):
			self.selected_choice -= 1
		if event.is_action_pressed("ui_down"):
			self.selected_choice += 1

func _process(_delta) -> void:
	if choice_phrase:
		indicator.visible = false
		return
	indicator.visible = phrase_finished

func get_dialogue(filename: String) -> Array:
	var dialogue_file_path: String = dialogue_path % filename
	
	var file = File.new()
	assert(file.file_exists(dialogue_file_path), "Couldn't load dialogue file")
	
	file.open(dialogue_file_path, File.READ)
	var json = file.get_as_text()
	var output = parse_json(json)
	
	if output is Array:
		return output
	else:
		return []

func next_phrase() -> void:
	current_phrase += 1
	
	if current_phrase >= len(dialogue):
		queue_free()
		return
	
	phrase_finished = false
	
	# Setting the dialogue box text and current speaker
	name_label.text = dialogue[current_phrase]["Name"]
	text_label.bbcode_text = dialogue[current_phrase]["Text"]
	text_label.visible_characters = 0
	
	# Change portraits
	var portrait_left_texture: String = dialogue[current_phrase]["PortraitLeft"]
	var portrait_right_texture: String = dialogue[current_phrase]["PortraitRight"]
	var currently_talking: String = dialogue[current_phrase]["Speaking"]
	set_portraits(portrait_left_texture, portrait_right_texture, currently_talking)
	
	# Give choice options
	choice_phrase = dialogue[current_phrase]["Choice"]
	if choice_phrase == false:
		choice_system.hide()
	else:
		choice_1_label.text = dialogue[current_phrase]["Choice1"][0]
		choice_2_label.text = dialogue[current_phrase]["Choice2"][0]
		choice_system.show()
	
	# Slowly increase text visibility
	while text_label.visible_characters < len(text_label.text):
		text_label.visible_characters += 1
		
		text_timer.start()
		yield(text_timer, "timeout")
	
	phrase_finished = true
	return

func set_portraits(portrait_left_texture: String, portrait_right_texture: String, currently_talking: String) -> void:
	# Set the left portrait
	if portrait_left_texture != "":
		var texture_path: String = "res://Dialogue/CharacterPortraits/%s.png" % portrait_left_texture
		var portrait_texture: Resource = load(texture_path)
		if portrait_texture is Texture:
			portrait_left.texture = portrait_texture
		else:
			portrait_left.texture = null
	else:
		portrait_left.texture = null
	
	# Set the right portrait
	if portrait_right_texture != "":
		var texture_path: String = "res://Dialogue/CharacterPortraits/%s.png" % portrait_right_texture
		var portrait_texture: Resource = load(texture_path)
		if portrait_texture is Texture:
			portrait_right.texture = portrait_texture
		else:
			portrait_right.texture = null
	else:
		portrait_right.texture = null
	
	# Set the grayscale for the portraits
	if currently_talking == "left":
		portrait_left.material.set("shader_param/grayscale", false)
		portrait_right.material.set("shader_param/grayscale", true)
	else:
		portrait_left.material.set("shader_param/grayscale", true)
		portrait_right.material.set("shader_param/grayscale", false)

func set_selected_choice(value: int) -> void:
	# Currently 2 choices is the maximum
	selected_choice = clamp(value, 1, 2)
	
	# Set the indicator on the correct choice
	choice_1_indicator.modulate.a = 0
	choice_2_indicator.modulate.a = 0
	
	if selected_choice == 1:
		choice_1_indicator.modulate.a = 1
	if selected_choice == 2:
		choice_2_indicator.modulate.a = 1

func close_dialogue() -> void:
	queue_free()

func show_dialogue(filename: String) -> void:
	DialogueSystem.show_dialogue(filename)
	
	# After opening the new dialogue box close this one
	queue_free()
	
