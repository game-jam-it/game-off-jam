class_name TownEvents
extends Node2D

signal map_goals_updated(goals)
signal game_goals_updated(goals)

signal pause_explore_event(coords)

var _goals = {}
var scenes = {}
var active = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func clear():
	scenes.clear()
	for node in get_children():
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

func initialize_goals():
	# Compute the total of all maps
	self._compute_goal_total()
	for map in get_children():
		if map.has_method("initialize"):
			map.initialize()

func end_event(_coords):
	if active != null:
		active.disconnect("goals_updated", self, "_on_goals_updated")
		var type = active.type()
		active.end_event()
		active = null
		return type
	return EventMap.Type.None

func start_event(coords):
	if active != null:
		active.end_event()
		active = null
	if scenes.has(coords):
		active = scenes[coords]
		active.connect("goals_updated", self, "_on_goals_updated")
		active.start_event()
		return active.type()
	return EventMap.Type.None

func get_cam_target(coords) -> Vector2:
	if scenes.has(coords):
		var scene = scenes[coords]
		return scene.get_cam_target()
	return Vector2.ZERO

func _on_goals_updated(value):
	emit_signal("map_goals_updated", value)
	_compute_goal_total()

func _compute_goal_total():
	_goals = EventMap.new_goals()
	_goals.merge({
		"maps": {"done": 0, "total": 0}
	})
	for map in get_children():
		if map is EventMap:
			if map.is_complete():
				_goals.maps.done += 1
			_goals.maps.total += 1
			var goals = map.goals()
			if goals != null:
				_goals.event.done += goals.event.done
				_goals.event.total += goals.event.total
				_goals.event.dare.done += goals.event.dare.done
				_goals.event.dare.total += goals.event.dare.total
				_goals.event.lore.done += goals.event.lore.done
				_goals.event.lore.total += goals.event.lore.total

				_goals.banish.done += goals.banish.done
				_goals.banish.total += goals.banish.total
				_goals.banish.boss.done += goals.banish.boss.done
				_goals.banish.boss.total += goals.banish.boss.total
				_goals.banish.drone.done += goals.banish.drone.done
				_goals.banish.drone.total += goals.banish.drone.total

				_goals.pickup.done += goals.pickup.done
				_goals.pickup.total += goals.pickup.total
				_goals.pickup.relic.done += goals.pickup.relic.done
				_goals.pickup.relic.total += goals.pickup.relic.total
				_goals.pickup.money.done += goals.pickup.money.done
				_goals.pickup.money.total += goals.pickup.money.total
				_goals.pickup.weapon.done += goals.pickup.weapon.done
				_goals.pickup.weapon.total += goals.pickup.weapon.total
				_goals.pickup.trinket.done += goals.pickup.trinket.done
				_goals.pickup.trinket.total += goals.pickup.trinket.total
				_goals.pickup.consumable.done += goals.pickup.consumable.done
				_goals.pickup.consumable.total += goals.pickup.consumable.total

	emit_signal("game_goals_updated", _goals)
