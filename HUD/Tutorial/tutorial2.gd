extends Node

func _ready():
	$BackButton.grab_focus()
	$BackButton.pressed.connect(next)

func next():
	MusicManager.play_SFX("res://Sounds/entersound.ogg")
	$BackButton.release_focus()
	var pressed_style = $BackButton.get("theme_override_styles/pressed")
	$BackButton.add_theme_stylebox_override("normal", pressed_style)
	FadeAnimation.fade_to_scene("res://HUD/Tutorial/tutorial3.tscn")
