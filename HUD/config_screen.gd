extends Node

func _ready():
	$BackButton.pressed.connect(main_menu)

func main_menu():
	get_tree().change_scene_to_file("res://HUD/main_menu.tscn")
