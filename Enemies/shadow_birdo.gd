extends Area2D

const SPEED = 1000

func _ready():
	MusicManager.play_SFX("res://Sounds/birdSFX.mp3")
	$AnimatedSprite2D.play()
	
func _process(delta):
	position.x -= SPEED * delta
