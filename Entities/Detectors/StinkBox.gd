class_name StinkBox
extends Area2D

onready var entity: BaseEntity = owner

# If a snif box detects a stink box the
# one that smelled it looks for the source.
func _init():
	collision_layer = 2
	collision_mask = 0
