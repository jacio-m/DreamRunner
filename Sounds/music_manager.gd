extends Node

@onready var musicPlayer = $MusicPlayer
var current_track : String = ""
var sfx_volume : float = 1.0

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
	SFXplayer.volume_db = linear_to_db(sfx_volume)
	add_child(SFXplayer)
	SFXplayer.play()
	SFXplayer.finished.connect(func():
		SFXplayer.queue_free())

func set_sfx_volume(value: float):
	sfx_volume = value
