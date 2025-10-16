class_name Player
extends CharacterBody2D

var jump_pressed = false
var double_jump = 0
var input_enabled: bool = true
var shield: bool = false

const SPEED = 100
const JUMP_SPEED = -600
const GRAVITY = 1900
const GRAVITY_WHILE_HOLD = 900

func _physics_process(delta):
	if not input_enabled:
		$AnimatedSprite2D.play("Player Idle")
		return
		
	if jump_pressed and velocity.y < 0:
		velocity.y += GRAVITY_WHILE_HOLD * delta
	elif not is_on_floor() and Input.is_action_pressed("ui_down"):
		velocity.y += GRAVITY * 2 * delta
	else:
		velocity.y += GRAVITY * delta
			
	if is_on_floor():
		$AnimatedSprite2D.play("Player Run")
		if Input.is_action_just_pressed("ui_up"):
			$AnimatedSprite2D.play("Player Jump")
			MusicManager.play_SFX("res://Sounds/sfx_jump.mp3")
			velocity.y = JUMP_SPEED
			jump_pressed = true
			double_jump += 1
			if double_jump > 3:
				double_jump = 3
	else: 
		if double_jump == 3:
			if Input.is_action_just_pressed("ui_up"):
				$AnimatedSprite2D.play("Player Jump")
				MusicManager.play_SFX("res://Sounds/sfx_jump.mp3")
				velocity.y = JUMP_SPEED
				double_jump = 0
					
	if Input.is_action_just_released("ui_up"):
		jump_pressed = false
	
	var direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = direction * 250
	if Input.is_action_just_released("ui_right") or Input.is_action_just_released("ui_left"):
		velocity.x = 0
	
	move_and_slide()
