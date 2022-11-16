class_name EntityInput
extends Node2D

var entity: Entity = null

func initialize(ent: Entity) -> void:
	entity = ent

func choose_action():
	print("%s missing overwrite of the input.choose_action method" % name)
	pass

func choose_target():
	print("%s missing overwrite of the input.choose_target method" % name)
	pass
