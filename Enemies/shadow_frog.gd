extends Area2D

const JUMP_HEIGHT = -250
const DURATION = 0.3
var start_position: Vector2

func _ready():
	start_position = position
	$AnimatedSprite2D.play("Enemy Idle")
	
	var waiting = Timer.new()
	waiting.wait_time = randf_range(0.1,5)
	waiting.one_shot = true
	if waiting.time_left <= 0.1:
		MusicManager.play_SFX("res://Sounds/frogSFX.ogg")
	waiting.timeout.connect(jump)
	add_child(waiting)
	waiting.start()

func jump():
	var jumping = create_tween()
	jumping.tween_property(self, "position:y", position.y + JUMP_HEIGHT, DURATION)
	jumping.tween_property(self, "position:y", start_position.y, DURATION)
