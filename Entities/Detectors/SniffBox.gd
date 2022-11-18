class_name SniffBox
extends Area2D

# If a snif box detects a stink box an
# event is send too look for the source.
func _init():
	collision_layer = 0
	collision_mask = 2

func _ready():
	connect("area_entered", self, "_on_area_entered")

func _on_area_entered(stinkbox: StinkBox):
	if stinkbox == null: 
		return
	print("> %s: Something stinks" % owner.name)
	if owner.has_method("investigate_smell"):
		print("> %s: I have to investigate" % owner.name)	
		owner.investigate_smell(stinkbox.entity)
