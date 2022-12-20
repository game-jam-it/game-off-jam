extends Control

signal actor_selected

onready var _game_over = $GameOver
onready var _game_pause = $GamePause
onready var _player_info = $PlayerInfoBox

onready var _town_box = get_node("%TownSelectBox")
onready var _actor_box = get_node("%ActorSelectBox")

onready var _actor_select = get_node("%ActorSelector")
onready var _actor_select_list = get_node("%ActorSelectList")

onready var _label_name = get_node("%BaseName")
onready var _label_stats = get_node("%BaseStats")
onready var _label_skills = get_node("%BaseSkills")

onready var _game_over_button = get_node("%ExitGameOver")
onready var _town_select_button = get_node("%TownSelectButton")

var intro_norman = preload("res://Dialogue/norman/act2/intro-teens.gd")
var ActorBoxPrefab = preload("res://UserInterface/PlayerHud/prefabs/ActorViewBox.tscn")

func _ready():
	self._setup_actors_list()
	self._on_actor_hover(null)
	_game_over.visible = false
	_game_pause.visible = false
	_player_info.visible = false
	_actor_select.visible = false
	_actor_box.visible = false
	_town_box.visible = false
	_game_over_button.connect("pressed", self, "_game_over_pressed")
	_town_select_button.connect("pressed", self, "_town_select_pressed")

func enable():
	visible = true

func disable():
	visible = false

func restart():
	_actor_box.visible = false
	_town_box.visible = false
	_actor_select.visible = true
	_player_info.visible = false
	_game_pause.visible = false
	_game_over.visible = false
	visible = true

func show_actor_info():
	_actor_select.visible = false
	_player_info.visible = true
	_actor_box.visible = false
	_town_box.visible = false


func open_game_intro():
	match TheTown.get_act():
		TheTown.Act.Into: _open_actor_selection()
		TheTown.Act.Teens: _run_teens_intro_dialog()

func open_town_selection():
	_actor_select.visible = true
	_actor_box.visible = false
	_town_box.visible = true

"""
	Game Over
"""

func open_game_over():
	_game_pause.visible = false
	_game_over.visible = true

func close_game_over():
	_game_over.visible = false

func _game_over_pressed():
	self.close_game_over()
	TheTown.restart_game()

"""
	Game Paused
"""

func open_game_paused():
	_game_pause.visible = true

func close_game_paused():
	_game_pause.visible = false

"""
	Actor Selection
"""

func _town_select_pressed():
	self.open_game_intro()

func _open_actor_selection():
	_actor_select.visible = true
	_actor_box.visible = true
	_town_box.visible = false

func _run_teens_intro_dialog():
	# TODO Fix Hardcoded actor variable,
	# works because only one is available
	var box = DialogueSystem.show_dialogue(intro_norman.dialogue)
	if box != null: box.connect_signals(self)

func on_dialogue_closed():
	_town_box.visible = false
	_actor_box.visible = false
	_actor_select.visible = false
	_player_info.visible = true
	emit_signal("actor_selected")

func _setup_actors_list():
	# FIXME: This a is fast cheat setup
	var actor = ActorBoxPrefab.instance()
	actor.set_info({
		"active": false,
		"flip": true,
		"name": "Paul",
		"data": preload("res://Actor/Player/resources/Paul.tres"),
		"texture": preload("res://UserInterface/assets/the-cast/the-cast-paul.png")
	})
	actor.connect("actor_selected", self, "_on_actor_selected")
	actor.connect("actor_hover", self, "_on_actor_hover")
	_actor_select_list.add_child(actor)

	actor = ActorBoxPrefab.instance()
	actor.set_info({
		"active": false,
		"flip": true,
		"name": "Vanessa",
		"data": preload("res://Actor/Player/resources/Vanessa.tres"),
		"texture": preload("res://UserInterface/assets/the-cast/the-cast-vanessa.png")
	})
	actor.connect("actor_selected", self, "_on_actor_selected")
	actor.connect("actor_hover", self, "_on_actor_hover")
	_actor_select_list.add_child(actor)

	actor = ActorBoxPrefab.instance()
	actor.set_info({
		"active": true,
		"flip": false,
		"name": "Norman",
		"data": preload("res://Actor/Player/resources/Norman.tres"),
		"texture": preload("res://UserInterface/assets/the-cast/the-cast-norman.png")
	})
	actor.connect("actor_selected", self, "_on_actor_selected")
	actor.connect("actor_hover", self, "_on_actor_hover")
	_actor_select_list.add_child(actor)

	actor = ActorBoxPrefab.instance()
	actor.set_info({
		"active": false,
		"flip": true,
		"name": "Stacy",
		"data": preload("res://Actor/Player/resources/Stacy.tres"),
		"texture": preload("res://UserInterface/assets/the-cast/the-cast-stacy.png")
	})
	actor.connect("actor_selected", self, "_on_actor_selected")
	actor.connect("actor_hover", self, "_on_actor_hover")
	_actor_select_list.add_child(actor)

	actor = ActorBoxPrefab.instance()
	actor.set_info({
		"active": false,
		"flip": false,
		"name": "Brandon",
		"data": preload("res://Actor/Player/resources/Brandon.tres"),
		"texture": preload("res://UserInterface/assets/the-cast/the-cast-brandon.png")
	})
	actor.connect("actor_selected", self, "_on_actor_selected")
	actor.connect("actor_hover", self, "_on_actor_hover")
	_actor_select_list.add_child(actor)

func _on_actor_selected(info):
	if info == null:
		return
	# FixMe set the resource, atm default to norman
	print("> Selected Friend: %s" % info.name)
	_town_box.visible = false
	_actor_box.visible = false
	_actor_select.visible = false
	_player_info.visible = true
	emit_signal("actor_selected")

func _on_actor_hover(info):
	if info == null:
		_label_skills.text = ">>"
		_label_stats.text = "<<"
		_label_name.text = "space for a new map"
		return
	_label_skills.text = "strength: %s | daring: %s | smarts: %s" % [
		info.data.fortitude, info.data.daring, info.data.smarts
	]
	_label_stats.text = "health: %s | speed: %s" % [
		info.data.max_hp, info.data.speed
	]
	_label_name.text = info.data.name
