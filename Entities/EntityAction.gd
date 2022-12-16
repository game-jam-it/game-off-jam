class_name EntityAction
extends Node2D

var entity: BaseActor

onready var tween = $Tween

func initialize(ent: BaseActor) -> void:
	entity = ent

func execute():
	print("%s missing overwrite of the action.execute() method" % name)
	return false
