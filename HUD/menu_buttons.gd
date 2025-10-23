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
	$PlayButton.disabled = true
	FadeAnimation.fade_to_scene("res://HUD/mode_select.tscn")
	
func shop_scene():
	MusicManager.play_SFX("res://Sounds/entersound.ogg")
	$ShopButton.release_focus()
	$ShopButton.disabled = true
	FadeAnimation.fade_to_scene("res://HUD/shop.tscn")

func config_scene():
	MusicManager.play_SFX("res://Sounds/entersound.ogg")
	$ConfigButton.release_focus()
	$ConfigButton.disabled = true
	FadeAnimation.fade_to_scene("res://HUD/config_screen.tscn")
	
func quit_game():
	MusicManager.play_SFX("res://Sounds/entersound.ogg")
	$QuitButton.release_focus()
	$QuitButton.disabled = true
	FadeAnimation.quit_game()
	
func _on_play_button_focus_entered():
	MusicManager.play_SFX("res://Sounds/selectingsound.ogg")
	
func _on_config_button_focus_entered():
	MusicManager.play_SFX("res://Sounds/selectingsound.ogg")

func _on_shop_button_focus_entered():
	MusicManager.play_SFX("res://Sounds/selectingsound.ogg")

func _on_quit_button_focus_entered():
	MusicManager.play_SFX("res://Sounds/selectingsound.ogg")
