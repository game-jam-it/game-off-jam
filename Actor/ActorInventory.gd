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
