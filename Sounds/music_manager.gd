extends Node

@onready var musicPlayer = $MusicPlayer
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
	var SFXplayer = AudioStreamPlayer.new()
	SFXplayer.stream = load(path)
	add_child(SFXplayer)
	SFXplayer.play()
	SFXplayer.finished.connect(func():
		SFXplayer.queue_free())
