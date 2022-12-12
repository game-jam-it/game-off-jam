class_name EventGrid
extends Node2D

const radius: int = 32

enum CellState {
	Empty,
	Entity,
	Blocker,
	Obstical,
}

export var size = 24

var hexgrid = null

var map = {}
var obj_map = {}
var view_map = {}
var entity_map = {}

var HexCell = preload("res://TheTown/HexMap/HexCell.gd")
var HexGrid = preload("res://TheTown/HexMap/HexGrid.gd")

var TownHex = preload("res://TheTown/EventMap/prefabs/EventHex.tscn")

# func _ready():
# 	_init_grid()
# 	_init_objects()

func clear():
	_init_grid()
	_init_objects()

"""
	Grid Lookups
"""

func get_coords(location: Vector2):
	var hex = hexgrid.pixel_to_hex(location)
	return hex.get_axial_coords()

func get_location(coords: Vector2):
	var hex = HexCell.new(coords)
	return hexgrid.hex_to_pixel(hex)

func get_cell_state(coords: Vector2):
	# FixMe: New entity types might need a list
	# as they could be hiding enemies that moved
	# A solution would be to split static from dynamic
	for key in entity_map:
		var entity = entity_map[key]
		var hex = entity.get_grid_cell()
		if coords == hex.get_axial_coords():
			return {
				"state": CellState.Entity,
				"entity": entity
			}
	if obj_map.has(coords):
		return obj_map[coords]
	return {
		"state": CellState.Empty
	}

func get_line_of_sight(start, target):
	return start.line_to(target)

func get_line_of_sight_cover(start, target):
	var path = start.line_to(target)
	# pop the start tile off
	path.pop_front()
	var cover = 0
	for hex in path:
		var coords = hex.get_axial_coords()
		if view_map.has(coords):
			cover += view_map[coords]
	return cover

"""
	Grid State Updates
"""

func add_object(object: GridObject):
	if object != null:
		match object.obj_type:
			GridObject.ObjType.Area:
				_init_area_object(object)
			GridObject.ObjType.Path:
				_init_path_object(object)

func clear_object(object: GridObject):
	if object != null:
		match object.obj_type:
			GridObject.ObjType.Area:
				_clear_area_object(object)
			GridObject.ObjType.Path:
				_clear_path_object(object)

func add_entity(entity: BaseEntity):
	entity_map[entity.id()] = entity

func clear_entity(entity: BaseEntity):
	entity_map.erase(entity.id())

func add_cell_blocker(coords: Vector2):
	hexgrid.add_path_obstacles([coords], 10)
	obj_map[coords] = {
		"state": CellState.Blocker,
	}

func add_cell_cover(coords: Vector2, percent: int):
	view_map[coords] = percent

func add_cell_obstical(coords: Vector2, cost: int):
	hexgrid.add_path_obstacles([coords], cost)
	obj_map[coords] = {
		"state": CellState.Obstical,
		"cost": cost
	}

func clear_cell(coords: Vector2):
	hexgrid.remove_path_obstacles([coords])
	view_map.erase(coords)
	obj_map.erase(coords)


"""
	Grid State Initializer
"""

func _init_grid():
	map.clear()
	obj_map.clear()
	view_map.clear()
	entity_map.clear()

	var length = size * 2
	hexgrid = HexGrid.new(Vector2(radius, radius))
	hexgrid.set_bounds(Vector2(-length, -length), Vector2(length, length))

	var location = position
	# FIXME: This depends on radius 
	# being set to double tile size.
	# print_debug(size / (radius * 0.5))
	var distance = round(abs(size / 2.0) - 0.1) - 1

	var hex = hexgrid.pixel_to_hex(location)
	var coords = hex.get_axial_coords()
	var node = TownHex.instance()
	node.set_color(Color.darkorange)
	node.set_coords(coords)
	map[coords] = node
	self.add_child(node)

	var list = hex.get_all_within(distance)
	for h in list:
		coords = h.get_axial_coords()
		if !map.has(coords):
			hex = HexCell.new(coords)
			location = hexgrid.hex_to_pixel(hex)
			node = TownHex.instance()
			node.set_location(location)
			node.set_coords(coords)
			map[coords] = node
			self.add_child(node)

func _init_objects():
	for obj in $Nodes.get_children():
		if obj is GridObject:
			match obj.obj_type:
				GridObject.ObjType.Area:
					_init_area_object(obj)
				GridObject.ObjType.Path:
					_init_path_object(obj)

func _init_area_object(obj: GridObject):
	var hex = hexgrid.pixel_to_hex(obj.global_position - get_parent().position)
	var hexes = hex.get_all_within(obj.obj_size)
	self._init_hex_array_for(obj, hexes)

func _init_path_object(obj: GridObject):
	var end = hexgrid.pixel_to_hex(obj.get_end())
	var start = hexgrid.pixel_to_hex(obj.get_start())
	var hexes = start.line_to(end)
	hexes.append(end)
	hexes.append(start)
	self._init_hex_array_for(obj, hexes)

func _init_hex_array_for(obj: GridObject, hexes: Array):
	match obj.block_type:
		GridObject.BlockType.Blocker:
			for hex in hexes:
				var coords = hex.get_axial_coords()
				self.add_cell_blocker(coords)
				if map.has(coords): map[coords].set_color(Color(0.64, 0.40, 0.64))
				if obj.cell_cover > 0: self.add_cell_cover(coords, obj.cell_cover)
		GridObject.BlockType.Obstical:
			for hex in hexes:
				var coords = hex.get_axial_coords()
				self.add_cell_obstical(coords, obj.cell_cost)
				if map.has(coords): map[coords].set_color(Color(0.40, 0.64, 0.64))
				if obj.cell_cover > 0: self.add_cell_cover(coords, obj.cell_cover)

func _clear_area_object(obj: GridObject):
	var center = hexgrid.pixel_to_hex(obj.global_position - get_parent().position)
	var hexes = center.get_all_within(obj.obj_size)
	for hex in hexes:
		var coords = hex.get_axial_coords()
		self.clear_cell(coords)
		map.erase(coords)

func _clear_path_object(obj: GridObject):
	var end = hexgrid.pixel_to_hex(obj.get_end())
	var start = hexgrid.pixel_to_hex(obj.get_start())
	var hexes = start.line_to(end)
	hexes.append(start)
	hexes.append(end)
	for hex in hexes:
		var coords = hex.get_axial_coords()
		self.clear_cell(coords)
		if map.has(coords): map[coords].set_color(Color(0.16, 0.16, 0.16))
