extends Node

@onready var musicPlayer = $MusicPlayer
var current_track : String = ""

func play_music(path : String):
	if current_track == path:
		return
	current_track = path
	musicPlayer.stream = load(path)
	musicPlayer.stream.loop = true
	musicPlayer.play()
