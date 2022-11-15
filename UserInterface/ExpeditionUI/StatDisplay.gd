extends NinePatchRect

export(String) var stat_name = ""
export(String) var stat_description = ""
export(Texture) var stat_texture

const tooltip_offset = Vector2(30, 50)

var tooltip: Resource = preload("res://UserInterface/Tooltips/Tooltip.tscn")

onready var texture_display = $HBoxContainer/StatTexture

func _ready():
	texture_display.texture = stat_texture

func _on_StatDisplay_mouse_entered():
	# Don't create another one if one is already open
	var tooltip_node = get_node_or_null("Tooltip")
	if tooltip_node != null:
		return
	
	# Create the tooltip
	var tooltip_instance = tooltip.instance()
	tooltip_instance.header_text = stat_name
	tooltip_instance.description_text = stat_description
	tooltip_instance.rect_position = rect_global_position + tooltip_offset
	add_child(tooltip_instance)
	tooltip_instance.show()

func _on_StatDisplay_mouse_exited():
	# Remove the tooltip popup if it is open
	var tooltip_node = get_node_or_null("Tooltip")
	if tooltip_node != null:
		tooltip_node.queue_free()
