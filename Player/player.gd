class_name Player
extends CharacterBody2D

#var jump_anim = $AnimatedSprite2D
#var running_anim = $AnimatedSprite2D
var jump_pressed = false

const SPEED = 100
const JUMP_SPEED = -450
const GRAVITY = 1200
const GRAVITY_WHILE_HOLD = 700

func _physics_process(delta):
	$AnimatedSprite2D.play("Player Idle")
	if jump_pressed and velocity.y < 0:
		velocity.y += GRAVITY_WHILE_HOLD * delta
	else:
		velocity.y += GRAVITY * delta
		
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			$SfxJump.play()
			velocity.y = JUMP_SPEED
			jump_pressed = true
	if Input.is_action_just_released("ui_up"):
		jump_pressed = false
	move_and_slide()
