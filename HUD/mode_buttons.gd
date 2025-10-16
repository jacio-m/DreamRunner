extends VBoxContainer

func _ready():
	$CampaignButton.focus_entered.disconnect(_on_campaign_button_focus_entered)
	$CampaignButton.grab_focus()
	$CampaignButton.focus_entered.connect(_on_campaign_button_focus_entered)
	$CampaignButton.pressed.connect(play_campaign)
	$EndlessButton.pressed.connect(play_endless)
	$TutorialButton.pressed.connect(tutorial_scene)

func play_campaign():
	MusicManager.play_SFX("res://Sounds/entersound.ogg")
	$CampaignButton.release_focus()
	var pressed_style = $CampaignButton.get("theme_override_styles/pressed")
	$CampaignButton.add_theme_stylebox_override("normal", pressed_style)
	FadeAnimation.fade_to_scene("res://HUD/mode_select.tscn")
	
func play_endless():
	MusicManager.play_SFX("res://Sounds/entersound.ogg")
	$EndlessButton.release_focus()
	var pressed_style = $EndlessButton.get("theme_override_styles/pressed")
	$EndlessButton.add_theme_stylebox_override("normal", pressed_style)
	FadeAnimation.fade_to_scene("res://Levels/Scenes/main.tscn")

func tutorial_scene():
	MusicManager.play_SFX("res://Sounds/entersound.ogg")
	$TutorialButton.release_focus()
	var pressed_style = $TutorialButton.get("theme_override_styles/pressed")
	$TutorialButton.add_theme_stylebox_override("normal", pressed_style)
	FadeAnimation.fade_to_scene("res://HUD/Tutorial/tutorial1.tscn")
	
func _on_campaign_button_focus_entered():
	MusicManager.play_SFX("res://Sounds/selectingsound.ogg")

func _on_endless_button_focus_entered():
	MusicManager.play_SFX("res://Sounds/selectingsound.ogg")
	
func _on_tutorial_button_focus_entered():
	MusicManager.play_SFX("res://Sounds/selectingsound.ogg")
