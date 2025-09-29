extends VBoxContainer

func _ready():
	$PlayButton.grab_focus()
	$PlayButton.pressed.connect(play_game)
	$ConfigButton.pressed.connect(config_scene)
	$TutorialButton.pressed.connect(tutorial_scene)

func play_game():
	$"../EnterSound".play()
	FadeAnimation.fade_to_scene("res://Levels/Scenes/main.tscn")

func config_scene():
	$"../EnterSound".play()
	FadeAnimation.fade_to_scene("res://HUD/config_screen.tscn")

func tutorial_scene():
	$"../EnterSound".play()
	FadeAnimation.fade_to_scene("res://HUD/tutorial.tscn")

func _on_play_button_focus_entered():
	$"../SelectingSound".play()

func _on_config_button_focus_entered():
	$"../SelectingSound".play()

func _on_tutorial_button_focus_entered():
	$"../SelectingSound".play()
