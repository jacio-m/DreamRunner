extends Area2D

const JUMP_HEIGHT = -250
const DURATION = 0.3
var start_position: Vector2

func _ready():
	start_position = position
	$AnimatedSprite2D.play("Enemy Idle")
	var jump_delay = randf_range(1.5,4.0)
	add_to_group("shadow_frog")
	
	var sound_timer = Timer.new()
	sound_timer.wait_time = jump_delay - 0.8
	sound_timer.one_shot = true
	sound_timer.timeout.connect(func(): 
		if $VisibleOnScreenNotifier2D.is_on_screen():
			MusicManager.play_SFX("res://Sounds/frogSFX.ogg"))
	add_child(sound_timer)
	sound_timer.start()
	
	var waiting = Timer.new()
	waiting.wait_time = jump_delay
	waiting.one_shot = true
	waiting.timeout.connect(jump)
	add_child(waiting)
	waiting.start()

func jump():
	var jumping = create_tween()
	jumping.tween_property(self, "position:y", position.y + JUMP_HEIGHT, 0.2)
	jumping.tween_property(self, "position:y", start_position.y, 0.1)
