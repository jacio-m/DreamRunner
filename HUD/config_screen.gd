extends Node

func _ready():
	$BackButton.grab_focus()
	$BackButton.pressed.connect(main_menu)

func main_menu():
	$BackButton.release_focus()
	FadeAnimation.fade_to_scene("res://HUD/main_menu.tscn")
