extends Node

func _ready():
	$BackButton.pressed.connect(main_menu)

func main_menu():
	FadeAnimation.fade_to_scene("res://HUD/main_menu.tscn")
