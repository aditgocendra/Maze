extends Node


var cell = []

var grid


func get_neighbours(node):
	var neighbours = []
	
	var relative_nodes = PoolVector3Array([
			Vector3(node.tile_pos.x + 1, node.tile_pos.y, node.tile_pos.z), #right
			Vector3(node.tile_pos.x - 1, node.tile_pos.y, node.tile_pos.z), #left
			Vector3(node.tile_pos.x, node.tile_pos.y, node.tile_pos.z + 1), #bottom
			Vector3(node.tile_pos.x, node.tile_pos.y, node.tile_pos.z - 1) #up
#			Vector2(node.tile_pos.x + 1, node.tile_pos.y + 1), #right bottom
#			Vector2(node.tile_pos.x - 1, node.tile_pos.y - 1), #left up
#			Vector2(node.tile_pos.x - 1, node.tile_pos.y + 1), #left bottom
#			Vector2(node.tile_pos.x + 1, node.tile_pos.y - 1) # right up
		])
	
	for relative in relative_nodes:
		if cell.has(relative):
			neighbours.append(relative)
		
	return neighbours
