extends EntityInput

func choose_action():
	yield(get_tree(), "idle_frame")
	return null

func choose_target():
	yield(get_tree(), "idle_frame")
	return null
