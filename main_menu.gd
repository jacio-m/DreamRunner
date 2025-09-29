extends Node

func _ready():
	if get_tree().paused == true:
		get_tree().paused = false
	MusicManager.play_music("res://Sounds/Takashi Lee - Dream sweet-(intro cutted).ogg")
	$ChildIdle.play("Child Idle")
	$ShadowIdle.play("Shadow Idle")
	$Title.play("Title Animation")
