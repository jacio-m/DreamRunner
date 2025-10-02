extends Node

func _ready():
	$ConfirmLabel/EnterKey.play()
	$NavigateLabel/UpKey.play()
	$NavigateLabel/DownKey.play()
	$NavigateLabel/LeftKey.play()
	$NavigateLabel/RightKey.play()
	$VolumeSliders/MusicVolume.grab_focus()
	$VolumeSliders/BackButton.pressed.connect(main_menu)

func main_menu():
	MusicManager.play_SFX("res://Sounds/entersound.ogg")
	$VolumeSliders/BackButton.release_focus()
	var pressed_style = $VolumeSliders/BackButton.get("theme_override_styles/pressed")
	$VolumeSliders/BackButton.add_theme_stylebox_override("normal", pressed_style)
	FadeAnimation.fade_to_scene("res://HUD/main_menu.tscn")
