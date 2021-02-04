extends KinematicBody


const speed = 2.0

var target = null
var velocity = Vector3.ZERO
var pathfinder
var path = null

var jps
var jps_path

func _ready():
	self.set_physics_process(false)
	pathfinder = Pathfinder.new(get_parent(), 1)
	jps = JPS.new(get_parent(), 1)
	
	var timer = Timer.new()
	timer.wait_time = 1
	add_child(timer)
	timer.connect("timeout", self, "find_path_timer")
	timer.start()

func _physics_process(_delta):
		
	self.look_at(target.global_transform.origin, Vector3.UP)
	
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
	path = pathfinder.find_path(global_transform.origin, target.global_transform.origin)

	# end astar----------------------------------
	# jps --------------------------
#	var self_pos_map = jps.gridmap.world_to_map(global_transform.origin)
#	var target_pos_map = jps.gridmap.world_to_map(target.global_transform.origin)
#	jps_path = jps.find_path(self_pos_map, target_pos_map)
#	path = jps_path
#	#end jps---------------------------------
#	print(path)
	# end jps---------------------------------------
#	print(jps_path)
	path.remove(0)
