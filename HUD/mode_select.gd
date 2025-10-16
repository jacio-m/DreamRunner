extends Node

func _ready():
	$NavigateLabel/UpKey.play()
	$NavigateLabel/DownKey.play()
	$ConfirmLabel/EnterKey.play()
	$ModeButtons/CampaignButton.grab_focus()
