extends Control

var coords = null

signal start_expedition()
signal cancel_expedition()

onready var title_txt = get_node('%TitleLabel')
onready var descr_txt = get_node('%DescrLabel')

onready var start_btn = get_node('%ExploreButton')
onready var cancel_btn = get_node('%LeaveButton')

func _ready():
	start_btn.connect("pressed", self, "on_start_pressed")
	cancel_btn.connect("pressed", self, "on_cancel_pressed")

func _input(input):
	if not self.visible:
		return
	if input.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		self.visible = false
		emit_signal("cancel_expedition")

func set_info(title, descr):
	title_txt.text = title
	descr_txt.text = descr

func on_start_pressed():
	emit_signal("start_expedition")

func on_cancel_pressed():
	self.visible = false
	emit_signal("cancel_expedition")

func popup():
	self.visible = true
	yield(get_tree(), "idle_frame")
	start_btn.grab_focus()