extends Node2D
class_name GridObject

enum ObjType {
	Area,
	Path,
}

enum BlockType {
	Blocker,
	Obstical,
}

export(int) var obj_size = 0
export(int) var cell_cost = 1
export(int) var cell_cover = 100

export(ObjType) var obj_type = ObjType.Area
export(BlockType) var block_type = BlockType.Blocker


func get_end():
	if obj_type == ObjType.Path:
		return $End.position
	return position

func get_start():
	if obj_type == ObjType.Path:
		return $Start.position
	return position
