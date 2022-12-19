extends MarginContainer

onready var _info_box = get_node("%InfoBox")

onready var _name_label = get_node("%NameValue")
onready var _index_label = get_node("%IndexValue")
onready var _health_label = get_node("%HealthValue")
onready var _portrait_texture = get_node("%PortraitTexture")


func _ready():
	_info_box.connect("gui_input", self, "on_gui_input")
	_info_box.connect("mouse_exited", self, "on_mouse_exited")
	_info_box.connect("mouse_entered", self, "on_mouse_entered")

func initialize(enemy: EnemyActor):
	if _name_label == null:
		_name_label = get_node("%NameValue")
	if _index_label == null:
		_index_label = get_node("%IndexValue")
	if _health_label == null:
		_health_label = get_node("%HealthValue")
	if _portrait_texture == null:
		_portrait_texture = get_node("%PortraitTexture")
	_name_label.text = enemy.enemy_name
	_index_label.text = "(%s)" % enemy.get_index()
	_health_label.text = "%s/%s" % [enemy.current_hearts, enemy.max_hearts]
	_portrait_texture.texture = enemy.portrait_base
	pass
	enemy.connect("free_entity", self, "on_free_entity")
	enemy.connect("hearts_changed", self, "on_health_changed")


func on_mouse_exited():
	print("Mouse Exited %s" % name)

func on_mouse_entered():
	print("Mouse Entered %s" % name)

func on_gui_input(event):  
	if event is InputEventMouseButton and event.doubleclick:
		print("Mouse Double Clicked %s" % name)


func on_free_entity(_entity):
	self.queue_free()

func on_health_changed(entity):
	var max_hearts = entity.max_hearts
	var current_hearts = entity.current_hearts
	_health_label.text = "%s/%s" % [current_hearts, max_hearts]
