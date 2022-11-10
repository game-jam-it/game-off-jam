extends PopupDialog

var active = false

signal start_expedition()
signal cancel_expedition()

onready var title_txt = get_node('%TitleLabel')
onready var descr_txt = get_node('%DescrLabel')

onready var start_btn = get_node('%ExploreButton')
onready var cancel_btn = get_node('%LeaveButton')

func _ready():
	connect("popup_hide", self, "on_hide_popup")
	start_btn.connect("pressed", self, "on_start_pressed")
	cancel_btn.connect("pressed", self, "on_cancel_pressed")


func set_info(title, descr):
	title_txt.text = title
	descr_txt.text = descr

func on_start_pressed():
	emit_signal("start_expedition")

func on_hide_popup():
	emit_signal("cancel_expedition")

func on_cancel_pressed():
	self.visible = false
