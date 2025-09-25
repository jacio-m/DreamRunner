extends Node

var shadow_blob = preload("res://Enemies/shadow_blob.tscn")
var shadow_blob2 = preload("res://Enemies/shadow_blob2.tscn")
#maybe some other enemies later on
var obstacle_types := [shadow_blob, shadow_blob2]
var obstacles : Array

const PLAYER_START_POS := Vector2i(155, 535)
const CAM_START_POS := Vector2i(576, 324)

var speed : float
const START_SPEED : float = 7.0
const MAX_SPEED : int = 15.0
var screen_size : Vector2i
var ground_height : int
const SPEED_MODIFIER: int = 10000
var distance : int
const DISTANCE_MODIFIER: int = 100
var last_obs
var game_running : bool

func _ready():
	$"DreamSweet (main)".stream.loop = true
	$"DreamSweet (main)".play()
	screen_size = get_viewport().get_visible_rect().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	$GameOver.get_node("Button").pressed.connect(new_game)
	new_game()
	
func new_game():
	distance = 0
	show_distance()
	game_running = false
	get_tree().paused = false
	$Player.input_enabled = false
	
	for obs in obstacles:
		obs.queue_free()
	obstacles.clear()
	
	
	$Player.position = PLAYER_START_POS 
	$Player.velocity = Vector2i(0, 0)
	$Camera2D.position = CAM_START_POS
	$Ground.position = Vector2i(0, 0)
	$Player.double_jump = 0
	
	$HUD.get_node("StartLabel").visible = true
	$HUD.get_node("DoubleJump").value = 0
	$GameOver.visible = false
	
func _process(delta):
	if game_running:
		speed = START_SPEED + distance / SPEED_MODIFIER
		if speed > MAX_SPEED:
			speed = MAX_SPEED
			
		generate_obs()
		
		$Player.position.x += speed
		$Camera2D.position.x += speed
		
		var cam_left = $Camera2D.position.x - screen_size.x / 2 + 30
		var cam_right = $Camera2D.position.x + screen_size.x / 2
		$Player.position.x = clamp($Player.position.x, cam_left, cam_right)
		
		distance += speed
		show_distance()
		
		if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
			$Ground.position.x += screen_size.x
			
		for obs in obstacles:
			if obs.position.x < ($Camera2D.position.x - screen_size.x):
				remove_obs(obs)
		
		$HUD.get_node("DoubleJump").value = $Player.double_jump
		
	else:
		if Input.is_action_just_pressed("ui_accept"):
			game_running = true
			$Player.input_enabled = true
			$HUD.get_node("StartLabel").visible = false

func generate_obs():
	if obstacles.is_empty() or last_obs.position.x < distance + randi_range(20, 200):
		var obstacle_type = obstacle_types[randi() % obstacle_types.size()]
		var obs
		obs = obstacle_type.instantiate()
		var obs_height = obs.get_node("AnimatedSprite2D").sprite_frames.get_frame_texture("Enemy Idle", 0).get_size().y
		var obs_scale = obs.get_node("AnimatedSprite2D").scale
		var obs_x : int = screen_size.x + distance + 100
		var obs_y : int = screen_size.y - ground_height - (obs_height * obs_scale.y / 2) + 25
		last_obs = obs
		add_obs(obs, obs_x, obs_y)
		
func add_obs(obs, x, y):
	obs.position = Vector2i(x, y)
	obs.body_entered.connect(hit_obs)
	add_child(obs)
	obstacles.append(obs)

func remove_obs(obs):
	obs.queue_free()
	obstacles.erase(obs)

func show_distance():
	$HUD.get_node("DistanceLabel").text = "DISTANCE: " + str(distance / DISTANCE_MODIFIER) + " m"
	
func hit_obs(body):
	if body.name == "Player":
		game_over()

func game_over():
	get_tree().paused = true
	game_running = false
	$GameOver.visible = true
	$GameOverSound.play()
	$GameOver.get_node("Button").grab_focus()
