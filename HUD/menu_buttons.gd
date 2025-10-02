extends VBoxContainer

func _ready():
	$PlayButton.focus_entered.disconnect(_on_play_button_focus_entered)
	$PlayButton.grab_focus()
	$PlayButton.focus_entered.connect(_on_play_button_focus_entered)
	$PlayButton.pressed.connect(play_game)
	$ConfigButton.pressed.connect(config_scene)
	$TutorialButton.pressed.connect(tutorial_scene)

func play_game():
	MusicManager.play_SFX("res://Sounds/entersound.ogg")
	$PlayButton.release_focus()
	var pressed_style = $PlayButton.get("theme_override_styles/pressed")
	$PlayButton.add_theme_stylebox_override("normal", pressed_style)
	FadeAnimation.fade_to_scene("res://Levels/Scenes/main.tscn")

func config_scene():
	MusicManager.play_SFX("res://Sounds/entersound.ogg")
	$ConfigButton.release_focus()
	var pressed_style = $ConfigButton.get("theme_override_styles/pressed")
	$ConfigButton.add_theme_stylebox_override("normal", pressed_style)
	FadeAnimation.fade_to_scene("res://HUD/config_screen.tscn")

func tutorial_scene():
	MusicManager.play_SFX("res://Sounds/entersound.ogg")
	$TutorialButton.release_focus()
	var pressed_style = $TutorialButton.get("theme_override_styles/pressed")
	$TutorialButton.add_theme_stylebox_override("normal", pressed_style)
	FadeAnimation.fade_to_scene("res://HUD/tutorial.tscn")
	
func _on_play_button_focus_entered():
	MusicManager.play_SFX("res://Sounds/selectingsound.ogg")
	
func _on_config_button_focus_entered() -> void:
	MusicManager.play_SFX("res://Sounds/selectingsound.ogg")

func _on_tutorial_button_focus_entered() -> void:
	MusicManager.play_SFX("res://Sounds/selectingsound.ogg")
