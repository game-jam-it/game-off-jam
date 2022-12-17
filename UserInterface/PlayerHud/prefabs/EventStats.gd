extends Control

onready var lore = get_node("%LoreValue")

onready var banish = get_node("%BanishValue")
onready var banish_boss = get_node("%BossValue")
onready var banish_drone = get_node("%DroneValue")

onready var pickup = get_node("%PickupValue")
onready var pickup_relic = get_node("%RelicValue")
onready var pickup_money = get_node("%MoneyValue")
onready var pickup_trinket = get_node("%TrinketValue")
onready var pickup_weapon = get_node("%WeaponValue")
onready var pickup_consumable = get_node("%ConsumableValue")

func _ready():
	TheTown.connect("map_goals_updated", self, "_on_map_goals_updated")

func _on_map_goals_updated(goals):
	lore.text = "%s/%s" % [goals.event.lore.done, goals.event.lore.total]

	banish.text = "%s/%s" % [goals.banish.done, goals.banish.total]
	banish_boss.text = "%s/%s" % [goals.banish.boss.done, goals.banish.boss.total]
	banish_drone.text = "%s/%s" % [goals.banish.drone.done, goals.banish.drone.total]

	pickup.text = "%s/%s" % [goals.pickup.done, goals.pickup.total]
	pickup_relic.text = "%s/%s" % [goals.pickup.relic.done, goals.pickup.relic.total]
	pickup_money.text = "%s/%s" % [goals.pickup.money.done, goals.pickup.money.total]
	pickup_weapon.text = "%s/%s" % [goals.pickup.weapon.done, goals.pickup.weapon.total]
	pickup_trinket.text = "%s/%s" % [goals.pickup.trinket.done, goals.pickup.trinket.total]
	pickup_consumable.text = "%s/%s" % [goals.pickup.consumable.done, goals.pickup.consumable.total]

