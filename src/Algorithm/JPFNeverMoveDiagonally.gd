extends Node
class_name JPFNeverMoveDiagonally
var cell = Autoload.cell

func jump(neigh, current, end_node):
	var x = neigh.x
	var y = neigh.z
	var px = current.x
	var py = current.z
	
	var dX = x - px
	var dY = y - py
	
	if !cell.has(Vector3(x, neigh.y, y)):
		return null

	if Vector3(x, neigh.y, y) == end_node.tile_pos:
		return Vector3(x, neigh.y, y)
	
	#diagonal case
	if dX != 0 :
		if cell.has(Vector3(x, neigh.y, y - 1)) and !cell.has(Vector3(x - dX, neigh.y, y - 1)) or cell.has(
					Vector3(x, neigh.y, y + 1)) and !cell.has(Vector3(x - dX, neigh.y, y + 1)):                                         
					return Vector3(x, neigh.y, y)
	elif dY != 0:
		if cell.has(Vector3(x - 1, neigh.y, y)) and !cell.has(Vector3(x - 1, neigh.y, y - dY)) or cell.has(
					Vector3(x + 1, neigh.y, y)) and !cell.has(Vector3(x + 1, neigh.y, y - dY)):  
					return Vector3(x, neigh.y,y)
		if jump(Vector3(x+1, neigh.y, y), Vector3(x, neigh.y, y), end_node) or jump(
				Vector3(x-1, neigh.y, y), Vector3(x, neigh.y, y), end_node):
				return Vector3(x, neigh.y, y)
	else: return null
	
	return jump(Vector3(x + dX, neigh.y, y + dY), Vector3(x, neigh.y, y), end_node)


func find_neighbours(node):
	var parent = node.parent
	var x = node.tile_pos.x 
	var y = node.tile_pos.z
	var px
	var py
	var nx
	var ny 
	var dx
	var dy
	
	var neighbours = []
	
	if parent:
		px = parent.tile_pos.x
		py = parent.tile_pos.z
		
		dx = (x - px) / max(abs(x - px), 1)
		dy = (y - py) / max(abs(y - py), 1)
		
		if dx != 0:
			if cell.has(Vector3(x, node.tile_pos.y, y - 1)):
				neighbours.append(Vector3(x, node.tile_pos.y, y - 1))
			
			if cell.has(Vector3(x, node.tile_pos.y, y + 1)):
				neighbours.append(Vector3(x , node.tile_pos.y, y + 1))
			
			if cell.has(Vector3(x + dx, node.tile_pos.y, y)):
				neighbours.append(Vector3(x + dx, node.tile_pos.y, y))
				
		elif dy != 0:
			if cell.has(Vector3(x - 1, node.tile_pos.y, y)):
				neighbours.append(Vector3(x - 1, node.tile_pos.y, y))
			if cell.has(Vector3(x + 1, node.tile_pos.y, y)):
				neighbours.append(Vector3(x + 1, node.tile_pos.y, y))
				
			if cell.has(Vector3(x, node.tile_pos.y, y + dy)):
				neighbours.append(Vector3(x, node.tile_pos.y, y + dy))
	else:
		var neighNode = Autoload.get_neighbours(node)
		
		for itr_neigh in neighNode:
			neighbours.append(itr_neigh)
		
	return neighbours
