class_name TownEvents
extends Node2D

signal game_stats_updated(stats)
signal event_stats_updated(stats)

signal pause_explore_event(coords)

var stats = {}
var scenes = {}
var active = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func clear():
	scenes.clear()
	for node in self.get_children():
		node.queue_free()

func get_scene(coords):
	if scenes.has(coords):
		return scenes[coords]
	return null

func handle_input(input):
	if active != null:
		return
	if input.is_action_pressed("ui_cancel"):
		print_debug("Eventmap -> pause_explore_event")
		emit_signal("pause_explore_event")

func initialize_stats():
	self._compute_total_stats()


func end_event(_coords):
	if active != null:
		active.disconnect("stats_updated", self, "_on_stats_updated")
		active.end_event()
		active = null

func start_event(coords):
	if active != null:
		active.end_event()
		active = null
	if scenes.has(coords):
		active = scenes[coords]
		active.connect("stats_updated", self, "_on_stats_updated")
		active.start_event()
		return active.type()


func _on_stats_updated(stats):
	emit_signal("event_stats_updated", stats)
	# TODO: Check map finished state ...
	self._compute_total_stats()

func _compute_total_stats():
	self.stats = EventMap.new_goals()
	for scn in self.get_children():
		if scn is EventMap:
			var goals = scn.goals()
			if goals != null:
				# FixMe Cleaner events can fix this
				self.stats.lore.done += goals.lore.done
				self.stats.lore.total += goals.lore.total

				self.stats.banish.done += goals.banish.done
				self.stats.banish.total += goals.banish.total
				self.stats.banish.boss.done += goals.banish.boss.done
				self.stats.banish.boss.total += goals.banish.boss.total
				self.stats.banish.drone.done += goals.banish.drone.done
				self.stats.banish.drone.total += goals.banish.drone.total

				self.stats.pickup.done += goals.pickup.done
				self.stats.pickup.total += goals.pickup.total
				self.stats.pickup.relic.done += goals.pickup.relic.done
				self.stats.pickup.relic.total += goals.pickup.relic.total
				self.stats.pickup.money.done += goals.pickup.money.done
				self.stats.pickup.money.total += goals.pickup.money.total
				self.stats.pickup.weapon.done += goals.pickup.weapon.done
				self.stats.pickup.weapon.total += goals.pickup.weapon.total
				self.stats.pickup.trinket.done += goals.pickup.trinket.done
				self.stats.pickup.trinket.total += goals.pickup.trinket.total
				self.stats.pickup.consumable.done += goals.pickup.consumable.done
				self.stats.pickup.consumable.total += goals.pickup.consumable.total

				self.stats.challenge.done += goals.challenge.done
				self.stats.challenge.total += goals.challenge.total
				self.stats.challenge.hide.done += goals.challenge.hide.done
				self.stats.challenge.hide.total += goals.challenge.hide.total
				self.stats.challenge.escape.done += goals.challenge.escape.done
				self.stats.challenge.escape.total += goals.challenge.escape.total

	emit_signal("game_stats_updated", self.stats)
