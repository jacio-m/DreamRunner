extends VBoxContainer

func _ready():
	$"UpRow/1-1".focus_entered.disconnect(_on__focus_entered)
	$"UpRow/1-1".grab_focus()
	$"UpRow/1-1".focus_entered.connect(_on__focus_entered)
	$"../ConfirmLabel/EnterKey".play()
	$"../NavigateLabel/UpKey".play()
	$"../NavigateLabel/DownKey".play()
	$"../NavigateLabel/LeftKey".play()
	$"../NavigateLabel/RightKey".play()
	$Back/BackButton.pressed.connect(back)
	$"UpRow/1-1".pressed.connect(play1_1)
	lock_stages()
	enable_stages()

func play1_1():
	MusicManager.play_SFX("res://Sounds/entersound.ogg")
	$"UpRow/1-1".release_focus()
	var pressed_style = $"UpRow/1-1".get("theme_override_styles/pressed")
	$"UpRow/1-1".add_theme_stylebox_override("normal", pressed_style)
	FadeAnimation.fade_to_scene("res://HUD/mode_select.tscn")

func back():
	MusicManager.play_SFX("res://Sounds/entersound.ogg")
	$Back/BackButton.release_focus()
	$"UpRow/1-1".disabled = true
	var pressed_style = $Back/BackButton.get("theme_override_styles/pressed")
	$Back/BackButton.add_theme_stylebox_override("normal", pressed_style)
	FadeAnimation.fade_to_scene("res://HUD/mode_select.tscn")

func lock_stages():
	$"UpRow/1-2".disabled = true
	$"UpRow/1-3".disabled = true
	$"UpRow/1-4".disabled = true
	$"UpRow/1-5".disabled = true
	$"DownRow/1-6".disabled = true
	$"DownRow/1-7".disabled = true
	$"DownRow/1-8".disabled = true
	$"DownRow/1-9".disabled = true
	$"DownRow/1-?".disabled = true

func enable_stages():
	if GameData.stage_1_1_clear == true:
		$"UpRow/1-2".disabled = false
	if GameData.stage_1_2_clear == true:
		$"UpRow/1-3".disabled = false
	if GameData.stage_1_3_clear == true:
		$"UpRow/1-4".disabled = false
	if GameData.stage_1_4_clear == true:
		$"UpRow/1-5".disabled = false
	if GameData.stage_1_5_clear == true:
		$"DownRow/1-6".disabled = false
	if GameData.stage_1_6_clear == true:
		$"DownRow/1-7".disabled = false
	if GameData.stage_1_7_clear == true:
		$"DownRow/1-8".disabled = false
	if GameData.stage_1_8_clear == true:
		$"DownRow/1-9".disabled = false
	if GameData.stage_1_9_clear == true:
		$"DownRow/1-?".disabled = false

func _process(delta):
	var focused = get_viewport().gui_get_focus_owner()
	if focused == null or not focused is Button:
		$"UpRow/1-1".grab_focus()

func _unhandled_input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ENTER:
		var focused = get_viewport().gui_get_focus_owner()
		if focused is Button and focused.disabled:
			MusicManager.play_SFX("res://Sounds/purchasefailed.mp3")

func _on__focus_entered():
	MusicManager.play_SFX("res://Sounds/selectingsound.ogg")
