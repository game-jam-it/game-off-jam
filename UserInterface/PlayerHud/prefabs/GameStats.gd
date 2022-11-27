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

onready var challenge = get_node("%ChallengeValue")
onready var challenge_hide = get_node("%HideValue")
onready var challenge_escape = get_node("%EscapeValue")

func _ready():
	TheTown.connect("game_stats_updated", self, "_on_game_stats_updated")

func _on_game_stats_updated(stats):
	lore.text = "%s/%s" % [stats.lore.done, stats.lore.total]

	banish.text = "%s/%s" % [stats.banish.done, stats.banish.total]
	banish_boss.text = "%s/%s" % [stats.banish.boss.done, stats.banish.boss.total]
	banish_drone.text = "%s/%s" % [stats.banish.drone.done, stats.banish.drone.total]

	pickup.text = "%s/%s" % [stats.pickup.done, stats.pickup.total]
	pickup_relic.text = "%s/%s" % [stats.pickup.relic.done, stats.pickup.relic.total]
	pickup_money.text = "%s/%s" % [stats.pickup.money.done, stats.pickup.money.total]
	pickup_weapon.text = "%s/%s" % [stats.pickup.weapon.done, stats.pickup.weapon.total]
	pickup_trinket.text = "%s/%s" % [stats.pickup.trinket.done, stats.pickup.trinket.total]
	pickup_consumable.text = "%s/%s" % [stats.pickup.consumable.done, stats.pickup.consumable.total]

	challenge.text = "%s/%s" % [stats.challenge.done, stats.challenge.total]
	challenge_hide.text = "%s/%s" % [stats.challenge.hide.done, stats.challenge.hide.total]
	challenge_escape.text = "%s/%s" % [stats.challenge.escape.done, stats.challenge.escape.total]
	