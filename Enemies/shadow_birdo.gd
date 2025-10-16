extends Area2D

const SPEED = 700

func _ready():
	$AnimatedSprite2D.play()
	
func _process(delta):
	position.x -= SPEED * delta
