extends Node

func _ready():
	$PlayButton.pressed.connect(play_game)
	$ConfigButton.pressed.connect(config_scene)
	$TutorialButton.pressed.connect(tutorial_scene)


func play_game():
	get_tree().change_scene_to_file("res://Levels/Scenes/main.tscn")

func config_scene():
	get_tree().change_scene_to_file("res://HUD/config_screen.tscn")

func tutorial_scene():
	get_tree().change_scene_to_file("res://HUD/tutorial.tscn")
