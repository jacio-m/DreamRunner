extends Node

func _ready():
	MusicManager.play_music("res://Sounds/Takashi Lee - Dream sweet-(intro cutted).ogg")
	if get_tree().paused == true:
		get_tree().paused = false
	$NavigateLabel/UpKey.play()
	$NavigateLabel/DownKey.play()
	$ConfirmLabel/EnterKey.play()
	$ModeButtons/CampaignButton.grab_focus()
