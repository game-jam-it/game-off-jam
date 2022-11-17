extends EntityInput

func choose_action():
	print("%s choose action" % entity.name)
	yield(get_tree(), "idle_frame")
	return null

func choose_target():
	print("%s choose target" % entity.name)
	yield(get_tree(), "idle_frame")
	return null
