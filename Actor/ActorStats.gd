extends Node

"""
Actor stats
[Primary]
	Health
	Stress
[Secondary]
	Fortitude
	Daring
	Smarts
"""

var item = preload("res://Items/Consumables/AmmunitionBox.tres")
var item2 = preload("res://Items/Consumables/Apple.tres")

func _input(_event):
	if Input.is_action_just_pressed("test"):
		print("consuming: " + item.name)
		item.consume()
		print("consuming: " + item2.name)
		item2.consume()

# Primary stats
var current_hearts: int = 3 setget set_current_hearts
var max_hearts: int = 5 setget set_max_hearts
var current_stress: int = 4 setget set_current_stress
var max_stress: int = 6 setget set_max_stress

signal hearts_changed(value)
signal max_hearts_changed(value)
signal stress_changed(value)
signal max_stress_changed(value)

func set_current_hearts(value: int) -> void:
	current_hearts = clamp(value, 0, max_hearts)
	emit_signal("hearts_changed", current_hearts)

func set_max_hearts(value: int) -> void:
	max_hearts = max(1, value)
	emit_signal("max_hearts_changed", max_hearts)

func set_current_stress(value: int) -> void:
	current_stress = clamp(value, 0, max_stress)
	emit_signal("stress_changed", current_stress)

func set_max_stress(value: int) -> void:
	max_stress = max(1, value)
	emit_signal("max_stress_changed", max_stress)

# Secondary stats
var fortitude: int = 1 setget set_fortitude
var daring: int = 1 setget set_daring
var smarts: int = 1 setget set_smarts

var base_fortitude: int = 1
var base_daring: int = 1
var base_smarts: int = 1

# Temporary stat boosts (dissapear after the next stat challenge)
var fortitude_boost: int = 0 setget set_fortitude_boost
var daring_boost: int = 0 setget set_daring_boost
var smarts_boost: int = 0 setget set_smarts_boost

signal fortitude_changed(value)
signal daring_changed(value)
signal smarts_changed(value)
signal fortitude_boost_changed(value)
signal daring_boost_changed(value)
signal smarts_boost_changed(value)

func set_fortitude(value: int) -> void:
	base_fortitude = value
	fortitude = value + fortitude_boost
	emit_signal("fortitude_changed", fortitude)

func set_daring(value: int) -> void:
	base_daring = value
	daring = value + daring_boost
	emit_signal("daring_changed", daring)

func set_smarts(value: int) -> void:
	base_smarts = value
	smarts = value + smarts_boost
	emit_signal("smarts_changed", smarts)

func set_fortitude_boost(value: int) -> void:
	fortitude_boost = value
	fortitude = base_fortitude + value
	emit_signal("fortitude_changed", fortitude)
	emit_signal("fortitude_boost_changed", fortitude)

func set_daring_boost(value: int) -> void:
	daring_boost = value
	daring = base_daring + value
	emit_signal("daring_changed", daring)
	emit_signal("daring_boost_changed", daring)

func set_smarts_boost(value: int) -> void:
	smarts_boost = value
	smarts = base_smarts + value
	emit_signal("smarts_changed", smarts)
	emit_signal("smarts_boost_changed", smarts)
