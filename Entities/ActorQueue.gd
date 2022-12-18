class_name ActorQueue
extends Node


"""
A turn queue for actors that can run team based rounds
or rounds where every actors acts on his own turn.

Actor Queue
~~~
	Start Round
	For actor in queue
		Start Turn
			Run actor
		End Turn
~~~

Team Queue
~~~
	Start Round
		Start Turn
		For player in players
			Run player
		End Turn
		Start Turn
		For enemy in enemies
			Run enemy
		End Turn
~~~
"""

var _grid

var _queue: Array
var _enemies: Array
var _players: Array

var _enemies_done: Array
var _players_done: Array

var _run_ended: bool
var _run_paused: bool
var _run_active: bool

var _resume_args: int
var _resume_method: String



signal queue_run(queue)
signal queue_stop(queue)
signal queue_pause(queue)
signal queue_resume(queue)
signal queue_updated(queue)

signal turn_ended(queue)
signal turn_starting(queue)
signal round_starting(queue)



func is_stoped() -> bool:
	return _run_ended

func is_paused() -> bool:
	return _run_paused

func is_active() -> bool:
	return _run_active

func get_actors() -> Array:
	return _queue.duplicate()

func get_enemies() -> Array:
	return _enemies.duplicate()

func get_players() -> Array:
	return _players.duplicate()



func run(grid, team_queue: bool = true):
	if _queue.size() == 0: _error("run: empty")
	if !_run_ended: return _error("run: ended")
	_resume_method = ""
	_resume_args = -1
	_run_active = true
	_run_paused = false
	_run_ended = false
	_grid = grid
	emit_signal("queue_run", self)
	if team_queue: _run_team_queue()
	else: _run_actors_queue(0)

func stop():
	if !_run_ended: return _error("stop: ended")
	_run_active = false
	_run_ended = true

func pause():
	if !_run_active: return _error("pause: not active")
	if _run_paused: return _error("pause: paused")
	if _run_ended: return _error("pause: ended")
	_run_paused = true

func resume():
	if !_run_paused: return _error("resume: paused")
	if _run_ended: return _error("resume: ended")
	_run_paused = false
	if !_resume_method.empty():
		emit_signal("queue_resume", self)
		if _resume_args < 0: call(_resume_method)
		else: call(_resume_method, _resume_args)
		_resume_method = ""
		_resume_args = -1


func sort():
	_players.sort_custom(self, 'sort_actor_queue')
	_enemies.sort_custom(self, 'sort_actor_queue')
	_queue.sort_custom(self, 'sort_actor_queue')
	emit_signal('queue_updated', self)

func clear():
	_run_active = false
	_run_ended = true
	# for actor in _players:
	# 	actor.disconnect("end_turn", self, "_end_actors_turn")
	# 	actor.disconnect("end_turn", self, "_end_players_turn")
	# for actor in _enemies:
	# 	actor.disconnect("end_turn", self, "_end_actors_turn")
	# 	actor.disconnect("end_turn", self, "_end_enemies_turn")
	_enemies.clear()
	_players.clear()
	_queue.clear()

func _run_actors_queue(index: int = 0):
	if _run_ended || 0 == _queue.size():
		emit_signal("queue_stop", self)
		_run_active = false
		return # Break turn loop
	if _pause_queue("_run_actors_queue", index):
		emit_signal("queue_pause", self)
		return # Pause turn loop
	var next = index % _queue.size()
	if next == 0: 
		emit_signal("round_starting", self)
	_start_actors_turn(_queue[next])

func _start_actors_turn(actor: ActorEntity):
	actor.connect("end_turn", self, "_end_actors_turn")
	emit_signal("turn_starting", self)
	actor.run_turn(_grid)

func _end_actors_turn(actor: ActorEntity):
	actor.disconnect("end_turn", self, "_end_actors_turn")
	emit_signal("turn_ended", self)
	var i = _queue.find(actor)
	_run_actors_queue(i + 1)


func _run_team_queue():
	if _run_ended || 0 == _queue.size():
		emit_signal("queue_stop", self)
		_run_active = false
		return # Break turn loop
	emit_signal("round_starting", self)
	_start_players_turn()

func _start_players_turn():
	if _pause_queue("_start_players_turn", -1):
		emit_signal("queue_pause", self)
		return # Pause turn loop
	emit_signal("turn_starting", self)
	_players_done.clear()
	for actor in _players:
		actor.connect("end_turn", self, "_end_players_turn")
		actor.run_turn(_grid)

func _end_players_turn(actor: ActorEntity):
	actor.disconnect("end_turn", self, "_end_players_turn")
	_players_done.append(actor)
	if _players.size() == _players_done.size():
		emit_signal("turn_ended", self)
		_start_enemies_turn()

func _start_enemies_turn():
	if _pause_queue("_start_enemies_turn", -1):
		emit_signal("queue_pause", self)
		return # Pause turn loop
	emit_signal("turn_starting", self)
	_enemies_done.clear()
	for actor in _enemies:
		actor.connect("end_turn", self, "_end_enemies_turn")
		actor.run_turn(_grid)

func _end_enemies_turn(actor: ActorEntity):
	actor.disconnect("end_turn", self, "_end_enemies_turn")
	_enemies_done.append(actor)
	if _enemies.size() <= _enemies_done.size():
		emit_signal("turn_ended", self)
		_run_team_queue()



func add_actor(actor: ActorEntity, do_sort: bool = false):
	if actor is EnemyActor:
		_add_enemy_actor(actor, do_sort)
	elif actor is PlayerActor:
		_add_player_actor(actor, do_sort)
	elif actor != null:
		_actor_error("unknown actor type", actor)
	else:
		push_warning("[Warn] %s: skipped null actor" % [name])

func _add_enemy_actor(actor: EnemyActor, do_sort: bool):
	actor.connect("free_actor", self, "_remove_enemy_actor")
	_enemies.append(actor)
	_queue.append(actor)
	if do_sort:
		_enemies.sort_custom(self, 'sort_actor_queue')
		_queue.sort_custom(self, 'sort_actor_queue')
	emit_signal('queue_updated', self)

func _add_player_actor(actor: PlayerActor, do_sort: bool):
	actor.connect("free_actor", self, "_remove_player_actor")
	_players.append(actor)
	_queue.append(actor)
	if do_sort:
		_players.sort_custom(self, 'sort_actor_queue')
		_queue.sort_custom(self, 'sort_actor_queue')
	emit_signal('queue_updated', self)


func remove_actor(actor: ActorEntity):
	if actor is EnemyActor:
		_remove_enemy_actor(actor)
	elif actor is PlayerActor:
		_remove_player_actor(actor)
	elif actor != null:
		_actor_warn("unknown actor group", actor)
	else:
		push_warning("[Warn] %s: skipped null actor" % [name])		

func _remove_enemy_actor(actor: EnemyActor):
	actor.disconnect("free_actor", self, "_remove_enemy_actor")
	_enemies_done.erase(actor)
	_enemies.erase(actor)
	_queue.erase(actor)
	emit_signal('queue_updated', self)

func _remove_player_actor(actor: PlayerActor):
	actor.disconnect("free_actor", self, "_remove_player_actor")
	_players_done.erase(actor)
	_players.erase(actor)
	_queue.erase(actor)
	emit_signal('queue_updated', self)



func _pause_queue(method: String, value: int):
	if !_run_paused: return false
	_resume_method = method
	_resume_args = value
	return true


static func sort_actor_queue(a: ActorEntity, b: ActorEntity) -> bool:
	return a.initiative < b.initiative


func _error(message: String):
	push_error("[Error] %s: %s" % [name, message])

func _actor_warn(message: String, actor: ActorEntity):
	push_warning("[Warn] %s: %s: %s - %s" % [name, message, actor.name, actor.group])
	actor.queue_free()

func _actor_error(message: String, actor: ActorEntity):
	push_error("[Error] %s: %s: %s - %s" % [name, message, actor.name, actor.group])
	actor.queue_free()
