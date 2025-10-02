extends Node

@onready var musicPlayer = $MusicPlayer
@onready var SFXPlayer = $SFXPlayer
var current_track : String = ""
var current_sfx: String = ""

func play_music(path : String):
	if current_track == path:
		return
	current_track = path
	musicPlayer.stream = load(path)
	musicPlayer.stream.loop = true
	musicPlayer.play()

func play_SFX(path: String):
	current_sfx = path
	SFXPlayer.stream = load(path)
	SFXPlayer.play()
