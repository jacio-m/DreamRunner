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
	$VolumeSliders/BackButton.disabled = true
	FadeAnimation.fade_to_scene("res://HUD/main_menu.tscn")
