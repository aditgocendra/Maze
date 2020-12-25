extends KinematicBody


const speed = 2.0

var target = null
var nav : Navigation = null
var velocity = Vector3.ZERO


func _physics_process(_delta):
	if target == null:
		return
		
	self.look_at(target.global_transform.origin, Vector3.UP)
		
	var path = get_path_to(target.global_transform.origin)
	
	
	if path.size() > 0:
		move_along_path(path)
		

func get_path_to(target):
	return nav.get_simple_path(global_transform.origin, target ) 


func move_along_path(path):
	if path.size() <= 0:
		return
	
	path.remove(0)
	var target = path[0]
	
	if global_transform.origin.distance_to(target) < 0.1:
		path.remove(0)

	velocity = (target - translation).normalized() * speed
	
	velocity = move_and_slide(velocity)


func set_target(target):
	self.target = target
	
	
func set_nav(nav):
	self.nav = nav



func _on_HitboxArea_body_entered(body):
	if body.name ==	 "Player":
		print("hello")
