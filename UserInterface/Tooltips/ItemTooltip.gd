extends Tooltip

var shown_item: Item

func _ready():
	headerLabelNode.text = header_text
	descriptionLabelNode.text = description_text
	
	if shown_item is ConsumableItem:
		descriptionLabelNode.text += "\n\nConsumable (double-click to use): "
		descriptionLabelNode.text += shown_item.effect_description
