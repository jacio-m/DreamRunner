extends VBoxContainer

func _ready():
	$PlayButton.grab_focus()
	$PlayButton.pressed.connect(play_game)
	$ConfigButton.pressed.connect(config_scene)
	$TutorialButton.pressed.connect(tutorial_scene)

func play_game():
	FadeAnimation.fade_to_scene("res://Levels/Scenes/main.tscn")

func config_scene():
	FadeAnimation.fade_to_scene("res://HUD/config_screen.tscn")

func tutorial_scene():
	FadeAnimation.fade_to_scene("res://HUD/tutorial.tscn")
