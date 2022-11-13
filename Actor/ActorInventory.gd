extends Node

"""
Actor Inventory
[Items]
	Trinkets (Passive effects to the player)
	Consumables (Healing, buffing, etc)
	Weapons
[Supplies]
	Money
	Ammo (Only one type which all weapons will use)
"""

# If no weapon is active
var base_weapon = preload("res://Items/Weapons/Fists.tres")

# Active weapon
var current_weapon: Weapon = null setget set_current_weapon, get_current_weapon

signal current_weapon_changed(weapon)

func set_current_weapon(new_weapon: Weapon) -> Weapon:
	var old_weapon: Weapon = current_weapon
	current_weapon = new_weapon
	
	emit_signal("current_weapon_changed", current_weapon)
	return old_weapon

func get_current_weapon() -> Weapon:
	if current_weapon == null:
		return base_weapon
	else:
		return current_weapon

# Items
var inventory: Array = []

signal inventory_changed(inventory)

func add_item(item: Item) -> void:
	inventory.append(item)
	emit_signal("inventory_changed", inventory)

func remove_item(item_slot: int) -> void:
	if item_slot > inventory.size() - 1:
		return
	
	inventory.remove(item_slot)
	emit_signal("inventory_changed", inventory)

func consume_item(item_slot: int) -> void:
	if item_slot > inventory.size() - 1:
		return
	
	var item = inventory[item_slot]
	# Make sure the item is a consumable and consume + remove it
	if item is ConsumableItem:
		item.consume()
		inventory.remove(item_slot)
		emit_signal("inventory_changed", inventory)

# Supplies
var money: int = 0 setget set_money
var ammo: int = 0 setget set_ammo

signal money_changed(value)
signal ammo_changed(value)

func set_money(value: int) -> void:
	money = value
	emit_signal("money_changed", money)

func set_ammo(value: int) -> void:
	ammo = value
	emit_signal("ammo_changed", ammo)
