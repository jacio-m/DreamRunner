extends Node

var dialogue_options = [ "Start your next run with the teddy 
bear, might be life saver!",
"Leaving already?",
"Bye bye!",
"Hey! You can't afford that!",
"Thanks!"]

func _ready():
	MusicManager.play_music("res://Sounds/Takashi Lee - Dream Merch.ogg")
	play_anims()
	$FeatherLabel.text = str(GameData.feather_count)
	$VBoxContainer/HBoxContainer2/TeddyBuy.grab_focus()
	$VBoxContainer/HBoxContainer2/BackButton.pressed.connect(main_menu)
	$VBoxContainer/HBoxContainer2/TeddyBuy.pressed.connect(buy_item)
	$VBoxContainer/HBoxContainer2/TeddyBuy.focus_entered.connect(dialogue)
	$VBoxContainer/HBoxContainer2/BackButton.focus_entered.connect(dialogue)

func main_menu():
	MusicManager.play_SFX("res://Sounds/entersound.ogg")
	$Dialogue.text = dialogue_options[2]
	$VBoxContainer/HBoxContainer2/BackButton.release_focus()
	var pressed_style = $VBoxContainer/HBoxContainer2/BackButton.get("theme_override_styles/pressed")
	$VBoxContainer/HBoxContainer2/BackButton.add_theme_stylebox_override("normal", pressed_style)
	FadeAnimation.fade_to_scene("res://HUD/main_menu.tscn")

func buy_item():
	if $VBoxContainer/HBoxContainer2/TeddyBuy.has_focus():
		if GameData.feather_count >= 50:
			GameData.feather_count -= 50
			$FeatherLabel.text = str(GameData.feather_count)
			#MusicManager.playSFX(itemboughtsound)
			$Dialogue.text = dialogue_options[4]
			var pressed_style = $VBoxContainer/HBoxContainer2/TeddyBuy.get("theme_override_styles/pressed")
			$VBoxContainer/HBoxContainer2/TeddyBuy.add_theme_stylebox_override("focus", pressed_style)
			$VBoxContainer/HBoxContainer2/TeddyBuy.add_theme_stylebox_override("normal", pressed_style)
		else:
			$Dialogue.text = dialogue_options[3]
			#MusicManager.playSFX(puchasefailed)
			 
	
func dialogue():
	if $VBoxContainer/HBoxContainer2/TeddyBuy.has_focus():
		$Dialogue.text = dialogue_options[0]
	elif $VBoxContainer/HBoxContainer2/BackButton.has_focus():
		$Dialogue.text = dialogue_options[1]
		
func play_anims():
	$ConfirmLabel/EnterKey.play()
	$NavigateLabel/UpKey.play()
	$NavigateLabel/DownKey.play()
	$NavigateLabel/LeftKey.play()
	$NavigateLabel/RightKey.play()
	$Heidi.play("Idle")
	$Child.play("Idle")
