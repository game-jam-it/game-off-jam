extends EntityAction

var target

func execute():
	if entity == null:
		return false
	print("%s execute not implemented" % name)
	return true