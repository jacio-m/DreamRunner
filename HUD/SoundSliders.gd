extends VBoxContainer


func _on_music_volume_value_changed(value: float):
	MusicManager.musicPlayer.volume_db = linear_to_db(value)


func _on_sfx_volume_value_changed(value: float) -> void:
	MusicManager.set_sfx_volume(value)
