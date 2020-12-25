extends Spatial

onready var level = preload("res://src/Level/Level.tscn")

onready var fader = $CanvasLayer/Fader


func _ready():
	fader.connect("fade_finish", self, "on_fade_finish")


func _on_StartButton_pressed():
	$HoverButton.play()
	fader.fade_out()


func _on_QuitButton_pressed():
	$HoverButton.play()
	get_tree().quit()


func on_fade_finish():
	get_tree().change_scene_to(level)
