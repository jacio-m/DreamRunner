extends VBoxContainer

func _ready():
	$MusicVolume.focus_entered.disconnect(_on_music_volume_focus_entered)
	$MusicVolume.grab_focus()
	$MusicVolume.focus_entered.connect(_on_music_volume_focus_entered)
	$MusicVolume.value = GameData.music_volume
	$SFXVolume.value = GameData.sfx_volume

func _on_music_volume_value_changed(value: float):
	MusicManager.play_SFX("res://Sounds/selectingsound.ogg")
	GameData.music_volume = value
	MusicManager.musicPlayer.volume_db = linear_to_db(value)

func _on_sfx_volume_value_changed(value: float):
	MusicManager.play_SFX("res://Sounds/selectingsound.ogg")
	GameData.sfx_volume = value
	MusicManager.set_sfx_volume(value)

func _on_music_volume_focus_entered() -> void:
	MusicManager.play_SFX("res://Sounds/selectingsound.ogg")

func _on_sfx_volume_focus_entered() -> void:
	MusicManager.play_SFX("res://Sounds/selectingsound.ogg")

func _on_back_button_focus_entered() -> void:
	MusicManager.play_SFX("res://Sounds/selectingsound.ogg")
