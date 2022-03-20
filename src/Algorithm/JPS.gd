extends Node
class_name JPS

var open_list

var utils
var JPF

var gridmap : GridMap = null
var block_container : Spatial = null

var nav_id




func _init(gridmap, nav_id, block_container):
	self.gridmap = gridmap
	self.nav_id = nav_id
	self.block_container = block_container
	Autoload.cell = set_nav_tiles()
	


func find_path(start, end):
	JPF = JPFNeverMoveDiagonally.new()
	utils = Utility.new()
	open_list = []
	
	#init node start and end node----
	var start_node = JumpNode.new()
	var end_node = JumpNode.new()

	
	start_node.tile_pos = start
	end_node.tile_pos = end
	
	start_node.gy = 0
	end_node.fy = 0
	#--------------------------------
	
	open_list.append(start_node)
	
	var current_node
	
	while (open_list.size() > 0):
		current_node = open_list.pop_front()
		current_node.closed = true
		
		if current_node.tile_pos == end_node.tile_pos:
			var result = []
			var path = utils.expandPath(utils.backtrace(current_node))
			
			for point in path:
				result.append(gridmap.map_to_world(point.x, point.y, point.z))
			
			return result
			
			
		identify_succresors(current_node, start_node, end_node)

func identify_succresors(current, start_node, end_node):
	
	var neighbours = JPF.find_neighbours(current)
#	var successor = []
	
	for index_neighbour in neighbours:
		var jumpPoint = JPF.jump(index_neighbour, current.tile_pos, end_node)
		
		if jumpPoint != null:
			var jx = jumpPoint.x
			var jy = jumpPoint.z

			var jumpNode = JumpNode.new()
			jumpNode.tile_pos = Vector3(jx, jumpPoint.y ,jy) 

			if jumpNode.closed:
				continue

			var d = utils.octile(abs(jx - current.tile_pos.x), abs(jy - current.tile_pos.z))

			var ng  = current.gy + d

			if !jumpNode.opened or ng < jumpNode.gy:
				jumpNode.gy = ng
				jumpNode.hy = jumpNode.hy or abs(jx - end_node.tile_pos.x) + abs(jy - end_node.tile_pos.x)
				jumpNode.fy = jumpNode.gy + jumpNode.hy
				jumpNode.parent = current

				if !jumpNode.opened:
					open_list.append(jumpNode)
					jumpNode.opened = true
				else:
					open_list = jumpNode


func set_nav_tiles():
	var block_cell = gridmap.world_to_map(get_block()[0])
	var result = []
	
	
	for cell in gridmap.get_used_cells():
		var id_object =  gridmap.get_cell_item(cell.x, cell.y, cell.z)
		if id_object == nav_id:
			if cell != block_cell:
				result.append(Vector3(cell.x, cell.y, cell.z))
		
	return result



# check floor for any mesh block 
func get_block():
	var child = []
	for i in range(block_container.get_child_count()):
		child.append(block_container.get_child(i).global_transform.origin)
		
	return child



