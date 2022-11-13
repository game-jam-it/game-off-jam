extends Popup

var header_text: String = ""
var description_text: String = ""

export(NodePath) var headerLabelPath
onready var headerLabelNode = get_node(headerLabelPath)
export(NodePath) var descriptionLabelPath
onready var descriptionLabelNode = get_node(descriptionLabelPath)

func _ready():
	headerLabelNode.text = header_text
	descriptionLabelNode.text = description_text
