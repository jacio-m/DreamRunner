extends VBoxContainer

func _process(delta):
	if $".".visible == true:
		$NextButton.grab_focus()

func _on_menu_button_focus_entered():
	MusicManager.play_SFX("res://Sounds/selectingsound.ogg")

func _on_next_button_focus_entered():
	MusicManager.play_SFX("res://Sounds/selectingsound.ogg")
