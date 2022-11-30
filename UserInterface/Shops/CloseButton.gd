extends Button

export(NodePath) var shop_ui_path
onready var shop_ui_node = get_node(shop_ui_path)

var custom_font = get("custom_fonts/font")

func _process(_delta):
	if is_hovered():
		custom_font.outline_color = Color.dimgray
	else:
		custom_font.outline_color = Color.black

func _on_CloseButton_pressed():
	# TODO Update Shop to use dictionary script files
	# DialogueSystem.show_dialogue("dialogue_shop_leave")
	# shop_ui_node.queue_free()
	pass
