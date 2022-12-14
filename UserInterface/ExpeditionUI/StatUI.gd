extends Control

# Secondary stats
onready var fortitude_value_label = $HBoxContainer/StatDisplay/HBoxContainer/Value
onready var daring_value_label = $HBoxContainer/StatDisplay2/HBoxContainer/Value
onready var smarts_value_label = $HBoxContainer/StatDisplay3/HBoxContainer/Value
onready var fortitude_boost_value_label = $HBoxContainer/StatDisplay/HBoxContainer/ValueBoost
onready var daring_boost_value_label = $HBoxContainer/StatDisplay2/HBoxContainer/ValueBoost
onready var smarts_boost_value_label = $HBoxContainer/StatDisplay3/HBoxContainer/ValueBoost
# Supplies
onready var ammo_label = $AmmoLabel
onready var money_label = $MoneyLabel

func _ready() -> void:
	# Secondary stats
	on_fortitude_changed(PlayerStats.fortitude)
	on_daring_changed(PlayerStats.daring)
	on_smarts_changed(PlayerStats.smarts)
	on_fortitude_boost_changed(PlayerStats.fortitude_boost)
	on_daring_boost_changed(PlayerStats.daring_boost)
	on_smarts_boost_changed(PlayerStats.smarts_boost)
	
	PlayerStats.connect("fortitude_changed", self, "on_fortitude_changed")
	PlayerStats.connect("daring_changed", self, "on_daring_changed")
	PlayerStats.connect("smarts_changed", self, "on_smarts_changed")
	PlayerStats.connect("fortitude_boost_changed", self, "on_fortitude_boost_changed")
	PlayerStats.connect("daring_boost_changed", self, "on_daring_boost_changed")
	PlayerStats.connect("smarts_boost_changed", self, "on_smarts_boost_changed")
	
	# Supplies
	on_ammo_changed(PlayerInventory.ammo)
	on_money_changed(PlayerInventory.money)
	
	PlayerInventory.connect("ammo_changed", self, "on_ammo_changed")
	PlayerInventory.connect("money_changed", self, "on_money_changed")

# Secondary stats
func on_fortitude_changed(value: int) -> void:
	fortitude_value_label.text = str(value)

func on_daring_changed(value: int) -> void:
	daring_value_label.text = str(value)

func on_smarts_changed(value: int) -> void:
	smarts_value_label.text = str(value)

func on_fortitude_boost_changed(value: int) -> void:
	var label_text = ""
	if value > 0:
		label_text = "(+%s)" % value
	
	fortitude_boost_value_label.text = label_text

func on_daring_boost_changed(value: int) -> void:
	var label_text = ""
	if value > 0:
		label_text = "(+%s)" % value
	
	daring_boost_value_label.text = label_text

func on_smarts_boost_changed(value: int) -> void:
	var label_text = ""
	if value > 0:
		label_text = "(+%s)" % value
	
	smarts_boost_value_label.text = label_text

# Supplies
func on_ammo_changed(value: int) -> void:
	var label_text = "Ammo: %s"
	ammo_label.text = label_text % value

func on_money_changed(value: int) -> void:
	var label_text = "Money: %s"
	money_label.text = label_text % value
