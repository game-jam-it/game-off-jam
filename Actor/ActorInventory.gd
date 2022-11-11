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
var trinkets: Array = []
var consumables: Array = []
var weapons: Array = []

signal trinkets_changed(trinkets)
signal consumables_changed(consumables)
signal weapons_changed(weapons)

func add_trinket(trinket: Trinket) -> void:
	trinkets.append(trinket)
	emit_signal("trinkets_changed", trinkets)

func add_consumable(consumable: ConsumableItem) -> void:
	consumables.append(consumable)
	emit_signal("consumables_changed", consumables)

func consume_item(item_slot: int) -> void:
	if item_slot < consumables.size():
		consumables[item_slot].consume()

func add_weapon(weapon: Weapon) -> void:
	weapons.append(weapon)
	emit_signal("weapons_changed", weapons)

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
