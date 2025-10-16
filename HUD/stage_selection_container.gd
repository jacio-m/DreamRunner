extends VBoxContainer

func _ready():
	$"../ConfirmLabel/EnterKey".play()
	$"../NavigateLabel/UpKey".play()
	$"../NavigateLabel/DownKey".play()
	$"../NavigateLabel/LeftKey".play()
	$"../NavigateLabel/RightKey".play()
	$"UpRow/1-1".grab_focus()
	$Back/BackButton.pressed.connect(back)

func back():
	MusicManager.play_SFX("res://Sounds/entersound.ogg")
	$Back/BackButton.release_focus()
	$"UpRow/1-1".disabled = true
	var pressed_style = $Back/BackButton.get("theme_override_styles/pressed")
	$Back/BackButton.add_theme_stylebox_override("normal", pressed_style)
	FadeAnimation.fade_to_scene("res://HUD/mode_select.tscn")

func _process(delta):
	var focused = get_viewport().gui_get_focus_owner()
	if focused == null or not focused is Button:
		$"UpRow/1-1".grab_focus()

func _on__focus_entered():
	MusicManager.play_SFX("res://Sounds/selectingsound.ogg")
