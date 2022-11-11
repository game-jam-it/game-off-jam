extends Control

onready var fortitude_value_label = $HBoxContainer/FortitudeDisplay/Value
onready var daring_value_label = $HBoxContainer/DaringDisplay/Value
onready var smarts_value_label = $HBoxContainer/SmartsDisplay/Value

var fortitude: int = 1 setget set_fortitude
var daring: int = 1 setget set_daring
var smarts: int = 1 setget set_smarts

func _ready() -> void:
	self.fortitude = ActorStats.fortitude
	self.daring = ActorStats.daring
	self.smarts = ActorStats.smarts
	
	ActorStats.connect("fortitude_changed", self, "on_fortitude_changed")
	ActorStats.connect("daring_changed", self, "on_daring_changed")
	ActorStats.connect("smarts_changed", self, "on_smarts_changed")

func set_fortitude(value: int) -> void:
	fortitude_value_label.text = str(value)

func set_daring(value: int) -> void:
	daring_value_label.text = str(value)

func set_smarts(value: int) -> void:
	smarts_value_label.text = str(value)

func on_fortitude_changed(value: int) -> void:
	self.fortitude = value

func on_daring_changed(value: int) -> void:
	self.daring = value

func on_smarts_changed(value: int) -> void:
	self.smarts = value
