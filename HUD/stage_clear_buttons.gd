extends VBoxContainer

func _ready():
	$NextButton.pressed.connect(next)
	$MenuButton.pressed.connect(stages)

func next():
	MusicManager.play_SFX("res://Sounds/entersound.ogg")
	$NextButton.release_focus()
	var pressed_style = $NextButton.get("theme_override_styles/pressed")
	$NextButton.add_theme_stylebox_override("normal", pressed_style)
	FadeAnimation.fade_to_scene("res://HUD/mode_select.tscn")
	#change this up here later to stage 1-2

func stages():
	MusicManager.play_SFX("res://Sounds/entersound.ogg")
	$MenuButton.release_focus()
	var pressed_style = $MenuButton.get("theme_override_styles/pressed")
	$MenuButton.add_theme_stylebox_override("normal", pressed_style)
	FadeAnimation.fade_to_scene("res://HUD/stage_selection.tscn")	

func _on_next_button_focus_entered():
	MusicManager.play_SFX("res://Sounds/selectingsound.ogg")

func _on_menu_button_focus_entered():
	MusicManager.play_SFX("res://Sounds/selectingsound.ogg")
