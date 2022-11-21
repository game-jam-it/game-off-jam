class_name EntityAction
extends Node2D

var entity: EntityObject

onready var tween = $Tween

func initialize(ent: EntityObject) -> void:
	entity = ent

func execute():
	print("%s missing overwrite of the action.execute method" % name)
	return false
