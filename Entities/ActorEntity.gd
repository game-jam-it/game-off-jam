class_name ActorEntity
extends BaseEntity

onready var input: EntityInput = $Input
onready var actions: Node2D = $Actions

onready var sense_area = $SenseArea

func _ready():
	if input != null:
		input.initialize(self)
	if actions != null:
		for action in actions.get_children():
			action.initialize(self)


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

func start_turn():
	input.start_turn()

func choose_target():
	return input.choose_target()

func choose_action():
	return input.choose_action()
