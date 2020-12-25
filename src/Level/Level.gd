extends Spatial

onready var player = $Navigation/Player
onready var monster = $Navigation/Monster
onready var nav = $Navigation


func _ready():
	monster.set_nav(nav)
	monster.set_target(player)

