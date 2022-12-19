class_name ActorEntity
extends BaseEntity

signal end_turn(actor)
signal start_turn(actor)

signal free_actor(actor)

export(float) var initiative = 1.0

onready var input: EntityInput = $Input

onready var actions: Node2D = $Actions
onready var sense_area: Area2D = $SenseArea


func _ready():
	if input != null:
		input.initialize(self)
	if actions != null:
		for action in actions.get_children():
			action.initialize(self)
	self.connect("tree_exiting", self, "_on_actor_exiting")

func _on_actor_exiting():
	emit_signal("free_actor", self)


func disable():
	sense_area.monitorable = false
	sense_area.monitoring = false
	input.disable()

func enable():
	sense_area.monitoring = true
	sense_area.monitorable = true
	input.enable(_grid)


func end_turn():
	input.end_turn()

func start_turn(grid):
	emit_signal("start_turn", self)
	input.start_turn(grid)

func choose_target():
	return input.choose_target()

func choose_action():
	return input.choose_action()


func run_turn(grid):
	emit_signal("start_turn", self)
	input.start_turn(grid)
	var target = yield(input.choose_target(), "completed")
	if target == null:
		emit_signal("end_turn", self)
		return
	var action = yield(input.choose_action(), "completed")
	if action == null: 
		emit_signal("end_turn", self)
		return
	yield(action.execute(), "completed")
	emit_signal("end_turn", self)
