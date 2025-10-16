extends VBoxContainer

func _ready():
	$PlayButton.focus_entered.disconnect(_on_play_button_focus_entered)
	$PlayButton.grab_focus()
	$PlayButton.focus_entered.connect(_on_play_button_focus_entered)
	$PlayButton.pressed.connect(play_game)
	$ShopButton.pressed.connect(shop_scene)
	$ConfigButton.pressed.connect(config_scene)
	$QuitButton.pressed.connect(quit_game)

func play_game():
	MusicManager.play_SFX("res://Sounds/entersound.ogg")
	$PlayButton.release_focus()
	var pressed_style = $PlayButton.get("theme_override_styles/pressed")
	$PlayButton.add_theme_stylebox_override("normal", pressed_style)
	FadeAnimation.fade_to_scene("res://HUD/mode_select.tscn")
	
func shop_scene():
	MusicManager.play_SFX("res://Sounds/entersound.ogg")
	$ShopButton.release_focus()
	var pressed_style = $ShopButton.get("theme_override_styles/pressed")
	$ShopButton.add_theme_stylebox_override("normal", pressed_style)
	FadeAnimation.fade_to_scene("res://HUD/shop.tscn")

func config_scene():
	MusicManager.play_SFX("res://Sounds/entersound.ogg")
	$ConfigButton.release_focus()
	var pressed_style = $ConfigButton.get("theme_override_styles/pressed")
	$ConfigButton.add_theme_stylebox_override("normal", pressed_style)
	FadeAnimation.fade_to_scene("res://HUD/config_screen.tscn")
	
func quit_game():
	MusicManager.play_SFX("res://Sounds/entersound.ogg")
	$QuitButton.release_focus()
	var pressed_style = $ConfigButton.get("theme_override_styles/pressed")
	$QuitButton.add_theme_stylebox_override("normal", pressed_style)
	FadeAnimation.quit_game()
	
func _on_play_button_focus_entered():
	MusicManager.play_SFX("res://Sounds/selectingsound.ogg")
	
func _on_config_button_focus_entered():
	MusicManager.play_SFX("res://Sounds/selectingsound.ogg")

func _on_shop_button_focus_entered():
	MusicManager.play_SFX("res://Sounds/selectingsound.ogg")

func _on_quit_button_focus_entered():
	MusicManager.play_SFX("res://Sounds/selectingsound.ogg")
