extends Node

func _ready():
	$ConfirmLabel/EnterKey.play()
	$BackButton.grab_focus()
	$BackButton.pressed.connect(main_menu)

func main_menu():
	MusicManager.play_SFX("res://Sounds/entersound.ogg")
	$BackButton.release_focus()
	var pressed_style = $BackButton.get("theme_override_styles/pressed")
	$BackButton.add_theme_stylebox_override("normal", pressed_style)
	FadeAnimation.fade_to_scene("res://HUD/main_menu.tscn")
