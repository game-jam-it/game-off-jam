class_name DialogueBox
extends Control

export(float) var text_speed = 0.025

var dialogue: Array

var current_phrase: int = -1
var phrase_finished: bool = false

var choice_phrase: bool = false
var selected_choice: int = 1 setget set_selected_choice
var selected_choice_result_method: String = ""

# var shop_ui: Resource = preload("res://UserInterface/Shops/ShopUI.tscn")

signal dialogue_event(value)
signal dialogue_closed()

onready var name_label = $NinePatchRect/NameLabel
onready var text_label = $NinePatchRect/TextLabel
onready var text_timer = $TextSpeedTimer
onready var indicator = $NinePatchRect/Indicator

# Jam hack in some extra fluff
onready var hack_it_a = get_node("%HackIt-01")
onready var hack_it_b = get_node("%HackIt-02")
onready var hack_it_c = get_node("%HackIt-03")

onready var slacher_arm = get_node("%SlacherArm")
onready var slacher_body = get_node("%SlacherBody")

onready var portrait_left = get_node("%PortraitLeft")
onready var portrait_right = get_node("%PortraitRight")

onready var choice_system = $NinePatchRect/ChoiceSystem
onready var choice_1_label = $NinePatchRect/ChoiceSystem/ChoicesList/Choice1/TextLabel
onready var choice_2_label = $NinePatchRect/ChoiceSystem/ChoicesList/Choice2/TextLabel
onready var choice_1_indicator = $NinePatchRect/ChoiceSystem/ChoicesList/Choice1/TextureRect
onready var choice_2_indicator = $NinePatchRect/ChoiceSystem/ChoicesList/Choice2/TextureRect

func _ready():
	text_timer.wait_time = text_speed
	assert(dialogue, "No dialogue found")
	assert(dialogue is Array, "No dialogue found")
	self.connect("tree_exiting", self, "_on_tree_exiting")
	hack_it_a.visible = false
	hack_it_b.visible = false
	hack_it_c.visible = false
	indicator.connect("gui_input", self, "_on_input_next")
	choice_1_label.connect("gui_input", self, "_on_input_choice_a")
	choice_1_indicator.connect("gui_input", self, "_on_input_choice_a")
	choice_2_label.connect("gui_input", self, "_on_input_choice_b")
	choice_2_indicator.connect("gui_input", self, "_on_input_choice_b")
	next_phrase()

func _on_input_next(event):
	if !indicator.visible:
		return
	if !phrase_finished:
		text_label.visible_characters = len(text_label.text)
	elif event is InputEventMouseButton and event.pressed:
		next_phrase()
	
func _on_input_choice_a(event):
	if !choice_system.visible:
		return
	if event is InputEventMouseButton and event.pressed:
		print("_on_input_choice_a Clicked on %s" % name)
		# If the dialogue should be cancelled call close_dialogue as the choice_method
		_execute_choise(dialogue[current_phrase]["Choice1"])
		next_phrase()

func _on_input_choice_b(event):
	if !choice_system.visible:
		return
	if event is InputEventMouseButton and event.pressed:
		print("_on_input_choice_b Clicked on %s" % name)
		# If the dialogue should be cancelled call close_dialogue as the choice_method
		_execute_choise(dialogue[current_phrase]["Choice2"])
		next_phrase()

func _input(event) -> void:

	if event.is_action_pressed("dialogue_next"):
		if phrase_finished:
			if choice_phrase:
				if selected_choice == 1:
					_execute_choise(dialogue[current_phrase]["Choice1"])
				elif selected_choice == 2:
					_execute_choise(dialogue[current_phrase]["Choice2"])
				# If the dialogue should be cancelled call close_dialogue as the choice_method
				next_phrase()
			else:
				next_phrase()
		else:
			text_label.visible_characters = len(text_label.text)
	elif !phrase_finished and event is InputEventMouseButton and event.pressed:
		text_label.visible_characters = len(text_label.text)

	# Selecting a choice
	if choice_phrase:
		# FixMe: These need to be clamped
		if event.is_action_pressed("ui_up"):
			self.selected_choice -= 1
		if event.is_action_pressed("ui_down"):
			self.selected_choice += 1

func _process(_delta) -> void:
	if choice_phrase:
		indicator.visible = false
		return
	indicator.visible = phrase_finished


func _execute_choise(command):
	var parameter: String = ""
	var method = command[1]
	if command.size() >= 3:
		parameter = command[2]
	if self.has_method(method):
		if parameter != "":
			print("Calling method: " + method + " with parameter: " + parameter)
			call(method, parameter)
		else:
			call(method)

func _on_tree_exiting():
	self.disconnect("tree_exiting", self, "_on_tree_exiting")
	emit_signal("dialogue_closed")

func connect_signals(target: Node):
	if target == null:
		return
	if target.has_method("on_dialogue_event"):
		self.connect("dialogue_event", target, "on_dialogue_event")
	if target.has_method("on_dialogue_closed"):
		self.connect("dialogue_closed", target, "on_dialogue_closed")

# func get_dialogue(filename: String) -> Array:
# 	var file_path: String = dialogue_path % filename
	
# 	# var file = File.new()
# 	# assert(
# 	# 	file.file_exists(dialogue_file_path), 
# 	# 	"Couldn't load dialogue file: %s" % dialogue_file_path
# 	# )
	
# 	# file.open(dialogue_file_path, File.READ)
# 	# var json = file.get_as_text()
# 	# var output = parse_json(json)
# 	print("[%s] Loading: %s" % [name, file_path])
# 	var info = load(file_path)
# 	if info.data is Array:
# 		return info.data
# 	else:
# 		return []

func next_phrase() -> void:
	current_phrase += 1
	
	if current_phrase >= len(dialogue):
		queue_free()
		return
	
	phrase_finished = false
	
	# Check if extra info needs to be displayed
	var extra_info: String = dialogue[current_phrase]["ShowExtraInfo"]
	var actual_string: String = ""
	
	if extra_info == "ItemWithCost":
		var format_string = dialogue[current_phrase]["Text"]
		actual_string = format_string % [DialogueSystem.selected_item.name, DialogueSystem.selected_item.cost]
	if extra_info == "Item":
		var format_string = dialogue[current_phrase]["Text"]
		actual_string = format_string % DialogueSystem.selected_item.name
	
	if actual_string != "":
		text_label.bbcode_text = actual_string
	else:
		text_label.bbcode_text = dialogue[current_phrase]["Text"]
	
	# Setting the dialogue box text and current speaker
	name_label.text = dialogue[current_phrase]["Name"]
	text_label.visible_characters = 0
	
	# Change portraits
	var portrait_left_texture: String = dialogue[current_phrase]["PortraitLeft"]
	var portrait_right_texture: String = dialogue[current_phrase]["PortraitRight"]
	var currently_talking: String = dialogue[current_phrase]["Speaking"]

	# End Jam Hacked setup
	if dialogue[current_phrase].has("Hack"):
		set_hacked(dialogue[current_phrase]["Hack"], portrait_left_texture)
	else:
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

func set_hacked(step, portrait_left_texture):
	portrait_right.texture = null
	if portrait_left_texture != "":
		var texture_path: String = "res://Dialogue/CharacterPortraits/%s.png" % portrait_left_texture
		var portrait_texture: Resource = load(texture_path)
		if portrait_texture is Texture:
			portrait_left.texture = portrait_texture
		else:
			portrait_left.texture = null
	else:
		portrait_left.texture = null

	match step:
		0: 
			portrait_left.visible = true
			hack_it_a.visible = false
			hack_it_b.visible = false
			hack_it_c.visible = false
			portrait_left.material.set("shader_param/grayscale", false)
			slacher_arm.material.set("shader_param/grayscale", true)
			slacher_body.material.set("shader_param/grayscale", true)
		1:
			portrait_left.visible = false
			hack_it_a.visible = true
			hack_it_b.visible = false
			hack_it_c.visible = false
			hack_it_a.material.set("shader_param/grayscale", false)
			slacher_arm.material.set("shader_param/grayscale", true)
			slacher_body.material.set("shader_param/grayscale", true)
		2:
			portrait_left.visible = false
			hack_it_a.visible = false
			hack_it_b.visible = true
			hack_it_c.visible = false
			hack_it_b.material.set("shader_param/grayscale", false)
			slacher_arm.material.set("shader_param/grayscale", true)
			slacher_body.material.set("shader_param/grayscale", true)
		3:
			portrait_left.visible = false
			hack_it_a.visible = false
			hack_it_b.visible = false
			hack_it_c.visible = true
			hack_it_c.material.set("shader_param/grayscale", false)
			slacher_arm.material.set("shader_param/grayscale", true)
			slacher_body.material.set("shader_param/grayscale", true)
		4:
			portrait_left.visible = false
			hack_it_a.visible = false
			hack_it_b.visible = false
			hack_it_c.visible = true
			hack_it_c.material.set("shader_param/grayscale", true)
			slacher_arm.material.set("shader_param/grayscale", false)
			slacher_body.material.set("shader_param/grayscale", false)
		

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
	selected_choice = int(clamp(value, 1, 2))
	
	# Set the indicator on the correct choice
	choice_1_indicator.modulate.a = 0
	choice_2_indicator.modulate.a = 0
	
	if selected_choice == 1:
		choice_1_indicator.modulate.a = 1
	if selected_choice == 2:
		choice_2_indicator.modulate.a = 1

func close_dialogue() -> void:
	queue_free()

func show_dialogue(value: Array) -> void:
	DialogueSystem.show_dialogue_unsafe(value)
	# FixMe: Reconnect signals
	# After opening the new dialogue box close this one
	queue_free()

# func open_shop(shop_id: String) -> void:
# 	var shop_instance = shop_ui.instance()
# 	shop_instance.shop_id = shop_id
# 	Overlay.add_child(shop_instance)

# func close_shop() -> void:
# 	# Close the shop UI
# 	var shop_node = Overlay.get_node_or_null("ShopUI")
# 	if shop_node != null:
# 		shop_node.queue_free()
	
# 	DialogueSystem.show_dialogue("dialogue_shop_leave")
# 	# FixMe: Reconnect signals

# func purchase_item() -> void:
# 	var selected_item: Item = DialogueSystem.selected_item
# 	if selected_item is Item:
# 		# Check if the player has enough money first
# 		if PlayerInventory.money >= selected_item.cost:
# 			if PlayerInventory.inventory_has_room():
# 				PlayerInventory.add_item(selected_item)
# 				PlayerInventory.money -= selected_item.cost
# 				DialogueSystem.show_dialogue_unsafe("dialogue_shop_successful_purchase")
# 				# FixMe: Reconnect signals
# 			else:
# 				DialogueSystem.show_dialogue_unsafe("dialogue_shop_failed_purchase_inventory_full")
# 				# FixMe: Reconnect signals
# 		else:
# 			DialogueSystem.show_dialogue_unsafe("dialogue_shop_failed_purchase_no_money")
# 			# FixMe: Reconnect signals

func dialogue_event(value: String) -> void:
	emit_signal("dialogue_event", value)

func increase_fortitude(value: String) -> void:
	PlayerStats.fortitude += int(value)

func increase_daring(value: String) -> void:
	PlayerStats.daring += int(value)

func increase_smarts(value: String) -> void:
	PlayerStats.smarts += int(value)

func restore_health(value: String) -> void:
	PlayerStats.current_hearts += int(value)
	if PlayerStats.current_hearts > PlayerStats.max_hearts:
		PlayerStats.current_stress = PlayerStats.max_hearts

func do_long_rest() -> void:
	PlayerStats.current_hearts = PlayerStats.max_hearts
	if PlayerStats.current_stress > 0: PlayerStats.current_stress = -1
