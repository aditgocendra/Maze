extends Node


onready var player = $GridMap/Player
onready var monster = $GridMap/Monster
onready var orb_container = $GridMap/OrbContainer

var collect_orb = 0
var total_orb_count = 0



func _ready():
	monster.set_target(player)
	total_orb_count = orb_container.get_child_count()
	
	player.connect("orb_collected", self, "on_orb_collected")


func _process(delta):
	print(Engine.get_frames_per_second())



func on_orb_collected():
	collect_orb += 1
	if collect_orb >= total_orb_count:
		print("You Wons")
