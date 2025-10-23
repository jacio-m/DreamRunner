extends Node

func _ready():
	$BackButton.grab_focus()
	$BackButton.pressed.connect(next)
	$ConfirmLabel/EnterKey.play()

func next():
	MusicManager.play_SFX("res://Sounds/entersound.ogg")
	$BackButton.release_focus()
	$BackButton.disabled = true
	FadeAnimation.fade_to_scene("res://HUD/Tutorial/tutorial3.tscn")
