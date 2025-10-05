extends Node

func _ready():
	$ConfirmLabel/EnterKey.play()
	$NavigateLabel/UpKey.play()
	$NavigateLabel/DownKey.play()
	$NavigateLabel/LeftKey.play()
	$NavigateLabel/RightKey.play()
	$FeatherLabel.text = str(GameData.feather_count)
	$VBoxContainer/HBoxContainer2/Button.grab_focus()
	$Heidi.play("Idle")
	$Child.play("Idle")
	$VBoxContainer/HBoxContainer2/BackButton.pressed.connect(main_menu)

func main_menu():
	MusicManager.play_SFX("res://Sounds/entersound.ogg")
	$VBoxContainer/HBoxContainer2/BackButton.release_focus()
	var pressed_style = $VBoxContainer/HBoxContainer2/BackButton.get("theme_override_styles/pressed")
	$VBoxContainer/HBoxContainer2/BackButton.add_theme_stylebox_override("normal", pressed_style)
	FadeAnimation.fade_to_scene("res://HUD/main_menu.tscn")
