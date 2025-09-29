extends Node

func _ready():
	if get_tree().paused == true:
		get_tree().paused = false
	$ChildIdle.play("Child Idle")
	$ShadowIdle.play("Shadow Idle")
	$Title.play("Title Animation")
	$MenuButtons/PlayButton.pressed.connect(play_game)
	$MenuButtons/ConfigButton.pressed.connect(config_scene)
	$MenuButtons/TutorialButton.pressed.connect(tutorial_scene)

func play_game():
	FadeAnimation.fade_to_scene("res://Levels/Scenes/main.tscn")

func config_scene():
	FadeAnimation.fade_to_scene("res://HUD/config_screen.tscn")

func tutorial_scene():
	FadeAnimation.fade_to_scene("res://HUD/tutorial.tscn")
