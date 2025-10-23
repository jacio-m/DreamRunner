extends VBoxContainer

func _ready():
	$Button.grab_focus()
	$Button.pressed.connect(restart)
	$MenuButton.pressed.connect(back)

func restart():
	$Button.disabled = true
	$Button.release_focus()
	MusicManager.play_SFX("res://Sounds/entersound.ogg")
	FadeAnimation.fade_to_scene(get_tree().current_scene.scene_file_path)

func back():
	$MenuButton.disabled = true
	$MenuButton.release_focus()
	MusicManager.play_SFX("res://Sounds/entersound.ogg")
	if get_tree().current_scene.scene_file_path == "res://Levels/Scenes/main.tscn":
		FadeAnimation.fade_to_scene("res://HUD/mode_select.tscn")
	else:
		FadeAnimation.fade_to_scene("res://HUD/stage_selection.tscn")
		
func _on_button_focus_entered():
	MusicManager.play_SFX("res://Sounds/selectingsound.ogg")

func _on_menu_button_focus_entered():
	MusicManager.play_SFX("res://Sounds/selectingsound.ogg")
