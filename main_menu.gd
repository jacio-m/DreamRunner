extends Node

func _ready():
	if get_tree().paused == true:
		get_tree().paused = false
	$ChildIdle.play("Child Idle")
	$ShadowIdle.play("Shadow Idle")
	$Title.play("Title Animation")
