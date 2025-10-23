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
	$BackButton.disabled = true
	FadeAnimation.fade_to_scene("res://HUD/mode_select.tscn")
