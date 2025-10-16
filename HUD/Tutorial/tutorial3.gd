extends Node

func _ready():
	$ShadowIdle.play()
	$ShadowSpike.play()
	$ShadowKitty.play()
	$ShadowBirdo.play()
	$ShadowFrog.play()
	$ConfirmLabel/EnterKey.play()
	$BackButton.grab_focus()
	$BackButton.pressed.connect(back)

func back():
	MusicManager.play_SFX("res://Sounds/entersound.ogg")
	$BackButton.release_focus()
	var pressed_style = $BackButton.get("theme_override_styles/pressed")
	$BackButton.add_theme_stylebox_override("normal", pressed_style)
	FadeAnimation.fade_to_scene("res://HUD/mode_select.tscn")
