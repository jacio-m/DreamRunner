extends Node

var shadow_blob = preload("res://Enemies/shadow_blob.tscn")
var shadow_spike = preload("res://Enemies/shadow_spike.tscn")
var shadow_kitty = preload("res://Enemies/shadow_kitty.tscn")
var feather_item = preload("res://Items/feather.tscn")
#maybe some other enemies later on
var obstacle_types := [shadow_blob, shadow_spike, shadow_kitty]
var obstacles : Array
var feathers: Array

const PLAYER_START_POS := Vector2i(155, 550)
const CAM_START_POS := Vector2i(576, 324)

var speed : float
const START_SPEED : float = 800.0
const MAX_SPEED : float = 1400.0
var screen_size : Vector2i
var ground_height : int
const SPEED_MODIFIER: int = 400
var distance : int
const DISTANCE_MODIFIER: int = 100
var last_obs
var last_feather
var game_running : bool
var current_progress: float = 0.0
var progress_smoothing : float = 5.0

func _ready():
	MusicManager.play_music("res://Sounds/Takashi Lee - Dream sweet-(main cutted).ogg")
	screen_size = get_viewport().get_visible_rect().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	$GameOver.get_node("VBoxContainer/Button").pressed.connect(func():
		$EnterSound.play()
		await FadeAnimation.fade_to_scene(get_tree().current_scene.scene_file_path))
	$GameOver.get_node("VBoxContainer/MenuButton").pressed.connect(func():
		$EnterSound.play()
		await FadeAnimation.fade_to_scene("res://HUD/main_menu.tscn"))
	new_game()
	
func new_game():
	distance = 0
	show_distance()
	game_running = false
	get_tree().paused = false
	$Player.input_enabled = false
	$HUD.get_node("DoubleJump").value = current_progress
	
	for obs in obstacles:
		obs.queue_free()
	obstacles.clear()
	
	
	$Player.position = PLAYER_START_POS 
	$Player.velocity = Vector2i(0, 0)
	$Camera2D.position = CAM_START_POS
	$Ground.position = Vector2i(0, 0)
	$Player.double_jump = 0
	
	$HUD.get_node("StartLabel").visible = true
	$GameOver.visible = false
	FadeAnimation.fade_in()
	
func _process(delta):
	if game_running:
		speed = START_SPEED + distance / SPEED_MODIFIER 
		if speed > MAX_SPEED:
			speed = MAX_SPEED
			
		generate_obs()
		generate_feathers()
		
		$Player.position.x += speed * delta
		$Camera2D.position.x += speed * delta
		
		var cam_left = $Camera2D.position.x - screen_size.x / 2 + 30
		var cam_right = $Camera2D.position.x + screen_size.x / 2 - 30
		$Player.position.x = clamp($Player.position.x, cam_left, cam_right)
		
		distance += speed * delta
		show_distance()
		
		if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
			$Ground.position.x += screen_size.x
			
		if $Player.is_on_floor():
			$CloudParticle.position = $Player.position
			$CloudParticle.position.y += 40
			$CloudParticle.emitting = true
			
		for obs in obstacles:
			if obs.position.x < ($Camera2D.position.x - screen_size.x):
				remove_obs(obs)
		
		for feather in feathers:
			if feather.position.x < ($Camera2D.position.x - screen_size.x):
				remove_feather(feather)
				
		var final_progress = float($Player.double_jump) / 3 * 100
		current_progress = lerp(current_progress, final_progress, delta * progress_smoothing)
		$HUD.get_node("DoubleJump").value = current_progress
		
	else:
		if Input.is_action_just_pressed("ui_accept"):
			game_running = true
			$Player.input_enabled = true
			$HUD.get_node("StartLabel").visible = false

func generate_obs():
	if obstacles.is_empty() or last_obs.position.x < $Camera2D.position.x + 50 + randi_range(0, 400):
		var obstacle_type = obstacle_types[randi() % obstacle_types.size()]
		var obs
		obs = obstacle_type.instantiate()
		var obs_height = obs.get_node("AnimatedSprite2D").sprite_frames.get_frame_texture("Enemy Idle", 0).get_size().y
		var obs_scale = obs.get_node("AnimatedSprite2D").scale
		var obs_x : int = $Camera2D.position.x + screen_size.x + 100
		var obs_y : int = screen_size.y - ground_height - (obs_height * obs_scale.y / 2) + 25
		last_obs = obs
		add_obs(obs, obs_x, obs_y)

func generate_feathers():
	if feathers.is_empty() or last_feather.position.x < $Camera2D.position.x + randi_range(100, 500):
		var feather = feather_item.instantiate()
		var feather_x: int = $Camera2D.position.x + screen_size.x + randi_range(300, 1000)
		var feather_y: int = $Camera2D.position.y - randi_range(10, 30)
		last_feather = feather
		add_feather(feather, feather_x, feather_y)
		
func add_feather(feather, x, y):
	feather.position = Vector2i(x, y)
	feather.body_entered.connect(func(body):
		if body.name == "Player":
			GameData.feather_count += 1
			remove_feather(feather))
	add_child(feather)
	feathers.append(feather)
	
func add_obs(obs, x, y):
	obs.position = Vector2i(x, y)
	obs.body_entered.connect(hit_obs)
	add_child(obs)
	obstacles.append(obs)

func remove_obs(obs):
	obs.queue_free()
	obstacles.erase(obs)
	
func remove_feather(feather):
	feather.queue_free()
	feathers.erase(feather)

func show_distance():
	$HUD.get_node("DistanceLabel").text = "DISTANCE: " + str(distance / DISTANCE_MODIFIER) + " m"
	$HUD.get_node("FeatherLabel").text = str(GameData.feather_count)
	
func hit_obs(body):
	if body.name == "Player":
		game_over()

func game_over():
	get_tree().paused = true
	game_running = false
	$GameOver.visible = true
	$GameOverSound.play()
	$GameOver.get_node("VBoxContainer/Button").grab_focus()
