class_name EntityAction
extends Node2D

var entity: Entity

onready var tween = $Tween

func initialize(ent: Entity) -> void:
	entity = ent

func execute():
	print("%s missing overwrite of the action.execute method" % name)
	return false
