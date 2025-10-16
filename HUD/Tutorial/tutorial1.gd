extends Node

func _ready():
	$ConfirmLabel/EnterKey.play()
	$BackButton.grab_focus()
	$BackButton.pressed.connect(next)
	$ChildJump.play()
	$UpKey.play()
	$ChildRun.play()
	$RightKey.play()
	$LeftKey.play()
	$DownKey.play()

func next():
	MusicManager.play_SFX("res://Sounds/entersound.ogg")
	$BackButton.release_focus()
	var pressed_style = $BackButton.get("theme_override_styles/pressed")
	$BackButton.add_theme_stylebox_override("normal", pressed_style)
	FadeAnimation.fade_to_scene("res://HUD/Tutorial/tutorial2.tscn")
