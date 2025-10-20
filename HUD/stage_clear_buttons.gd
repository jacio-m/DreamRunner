extends VBoxContainer

var stage_num: String

func _ready():
	if get_tree().current_scene.scene_file_path == "res://Levels/Scenes/1_1.tscn":
		stage_num = "2"
	if get_tree().current_scene.scene_file_path == "res://Levels/Scenes/1_2.tscn":
		stage_num = "3"
	if get_tree().current_scene.scene_file_path == "res://Levels/Scenes/1_3.tscn":
		stage_num = "4"
	if get_tree().current_scene.scene_file_path == "res://Levels/Scenes/1_4.tscn":
		stage_num = "5"
	if get_tree().current_scene.scene_file_path == "res://Levels/Scenes/1_5.tscn":
		stage_num = "6"
	if get_tree().current_scene.scene_file_path == "res://Levels/Scenes/1_6.tscn":
		stage_num = "7"
	if get_tree().current_scene.scene_file_path == "res://Levels/Scenes/1_7.tscn":
		stage_num = "8"
	if get_tree().current_scene.scene_file_path == "res://Levels/Scenes/1_8.tscn":
		stage_num = "9"
	$NextButton.pressed.connect(next)
	$MenuButton.pressed.connect(stages)

func next():
	MusicManager.play_SFX("res://Sounds/entersound.ogg")
	$NextButton.release_focus()
	var pressed_style = $NextButton.get("theme_override_styles/pressed")
	$NextButton.add_theme_stylebox_override("normal", pressed_style)
	FadeAnimation.fade_to_scene("res://Levels/Scenes/1_"+stage_num+".tscn")
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
