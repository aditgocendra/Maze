extends KinematicBody


const speed = 2.0

var target = null
var velocity = Vector3.ZERO


var pathfinder
var path = null


var jps
var jps_path
var timer

var default_pos_monster


enum STATE {
	IDLE, RUN, CATCH, BACK
}

var state = STATE.IDLE

func _ready():
	default_pos_monster = self.global_transform.origin
	var block = get_parent().get_node("BlockContainer")
	self.set_physics_process(false)
	pathfinder = Pathfinder.new(get_parent(), 1)

	jps = JPS.new(get_parent(), 1, block)
	
	timer = Timer.new()
	timer.wait_time = 1
	add_child(timer)
	timer.connect("timeout", self, "find_path_timer")
	
	

func _physics_process(_delta):
	
	self.look_at(target.global_transform.origin, Vector3.UP)
	
	match state: 
		STATE.IDLE:
			pass
		STATE.RUN:
			if path.size() > 0:
				move_along_path(path)
		STATE.BACK:
			if path.size() > 0:
				move_along_path(path)
	

func move_along_path(path):
	if global_transform.origin.distance_to(path[0]) < 1.0:
		path.remove(0)
		
		if path.size() == 0:
			return
	
	velocity = (path[0] - global_transform.origin).normalized() * speed
	velocity = move_and_slide(velocity)


func set_target(target):
	self.target = target
	self.set_physics_process(true)
	find_path_timer()


func _on_HitboxArea_body_entered(body):
	if body.name ==	 "Player":
		print("hello")


func find_path_timer():
	#astar--------------------------------------
#	path = pathfinder.find_path(global_transform.origin, target.global_transform.origin)

	# end astar----------------------------------
	# jps --------------------------
	var self_pos_map = jps.gridmap.world_to_map(global_transform.origin)
	
	
	var target_pos_map 
	
	if state == STATE.BACK:
		target_pos_map = jps.gridmap.world_to_map(default_pos_monster)
	else : target_pos_map = jps.gridmap.world_to_map(target.global_transform.origin)
	
	
	jps_path = jps.find_path(self_pos_map, target_pos_map)
	path = jps_path
#	#end jps---------------------------------
#	print(path)
	# end jps---------------------------------------
#	print(jps_path)
	path.remove(0)


func _on_AreaRun_body_entered(body):
	if body.name == "Player":
		self.change_state(1)
		timer.start()


func change_state(new_state : int):
	if new_state == 0:
		state = STATE.IDLE
	
	if new_state == 1:
		state = STATE.RUN
	
	if new_state == 2:
		state = STATE.CATCH
	
	if new_state == 3:
		state = STATE.BACK
	

