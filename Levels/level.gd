extends Node

var shadow_blob = preload("res://Enemies/shadow_blob.tscn")
var shadow_spike = preload("res://Enemies/shadow_spike.tscn")
var shadow_kitty = preload("res://Enemies/shadow_kitty.tscn")
#maybe some other enemies later on
var pillow_item = preload("res://Items/Scenes/pillow.tscn")
var feather_item = preload("res://Items/Scenes/feather.tscn")
var teddy_bear_item = preload("res://Items/Scenes/teddy_bear.tscn")
var lollipop_item = preload("res://Items/Scenes/lollipop.tscn")
var chocolatebar_item = preload("res://Items/Scenes/chocolatebar.tscn")

var obstacle_types := [shadow_blob, shadow_spike, shadow_kitty]
var obstacles : Array
var item_types := [feather_item, pillow_item, teddy_bear_item, lollipop_item, chocolatebar_item]
var items: Array

const PLAYER_START_POS := Vector2i(155, 550)
const CAM_START_POS := Vector2i(576, 324)

var speed : float
const START_SPEED : float = 800.0
const MAX_SPEED : float = 1400.0
var screen_size : Vector2i
var ground_height : int
const SPEED_MODIFIER: int = 400
var distance : int
var distance_gain : int
const DISTANCE_MODIFIER: int = 100
var last_obs
var last_item
var game_running : bool
var current_progress: float = 0.0
var progress_smoothing : float = 5.0
var lollipop_effect : bool

func _ready():
	MusicManager.play_music("res://Sounds/Takashi Lee - Dream sweet-(main cutted).ogg")
	screen_size = get_viewport().get_visible_rect().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	$GameOver.get_node("VBoxContainer/Button").pressed.connect(func():
		MusicManager.play_SFX("res://Sounds/entersound.ogg")
		await FadeAnimation.fade_to_scene(get_tree().current_scene.scene_file_path))
	$GameOver.get_node("VBoxContainer/MenuButton").pressed.connect(func():
		MusicManager.play_SFX("res://Sounds/entersound.ogg")
		await FadeAnimation.fade_to_scene("res://HUD/main_menu.tscn"))
	new_game()
	
func new_game():
	distance = 0
	show_distance()
	game_running = false
	get_tree().paused = false
	$Player.input_enabled = false
	$Player.shield = false
	enable_items()
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
	
	#for testing new items
	await get_tree().create_timer(10).timeout
	spawn_test()
	
func _process(delta):
	if game_running:
		speed = START_SPEED + distance / SPEED_MODIFIER 
		if speed > MAX_SPEED:
			speed = MAX_SPEED
			
		generate_obs()
		generate_items()
		
		$Player.position.x += speed * delta
		$Camera2D.position.x += speed * delta
		
		var cam_left = $Camera2D.position.x - screen_size.x / 2 + 30
		var cam_right = $Camera2D.position.x + screen_size.x / 2 - 30
		$Player.position.x = clamp($Player.position.x, cam_left, cam_right)
		
		distance_gain = speed * delta
		if lollipop_effect == true:
			distance_gain *= 2
		distance += distance_gain
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
		
		for item in items:
			if item.position.x < ($Camera2D.position.x - screen_size.x):
				remove_item(item)
				
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

func generate_items():
	if items.is_empty() or last_item.position.x < $Camera2D.position.x + randi_range(100, 500):
		var item_type
		var item_prob = randi() % 100
		if item_prob < 89:
			item_type = feather_item
		elif item_prob < 98:
			item_type = pillow_item
		else:
			item_type = [teddy_bear_item, lollipop_item][randi() % 2]
		var item = item_type.instantiate()
		var item_x: int = $Camera2D.position.x + screen_size.x + randi_range(300, 2000)
		var item_y: int = $Camera2D.position.y - randi_range(10, 30)
		last_item = item
		add_item(item, item_x, item_y)
		
func add_item(item, x, y):
	item.position = Vector2i(x, y)
	if item.scene_file_path == feather_item.resource_path: 
		item.body_entered.connect(func(body):
			if body.name == "Player":
				MusicManager.play_SFX("res://Sounds/item_collected.ogg")
				if lollipop_effect == true:
					GameData.feather_count += 2
				else: 
					GameData.feather_count += 1
				remove_item(item))
	elif item.scene_file_path == pillow_item.resource_path:
		item.body_entered.connect(func(body):
			if body.name == "Player":
				MusicManager.play_SFX("res://Sounds/item_collected.ogg")
				if lollipop_effect == true:
					GameData.feather_count += 20
				else:
					GameData.feather_count += 10
				remove_item(item))
	elif item.scene_file_path == teddy_bear_item.resource_path:
		item.body_entered.connect(func(body):
			if body.name == "Player":
				MusicManager.play_SFX("res://Sounds/squeaky-toy.mp3")
				$Player.shield = true
				$HUD.get_node("ShieldOn").visible = true
				remove_item(item))
	elif item.scene_file_path == lollipop_item.resource_path:
		item.body_entered.connect(func(body):
			if body.name == "Player":
				MusicManager.play_SFX("res://Sounds/item_collected.ogg")
				lollipop_effect = true
				var duration = Timer.new()
				duration.wait_time = 15.0
				duration.one_shot = true
				duration.timeout.connect(func():
					lollipop_effect = false)
				add_child(duration)
				duration.start()
				remove_item(item))
	elif item.scene_file_path == chocolatebar_item.resource_path:
		item.body_entered.connect(func(body):
			if body.name == "Player":
				MusicManager.play_SFX("res://Sounds/item_collected.ogg")
				Engine.time_scale = 0.5
				var duration = Timer.new()
				duration.wait_time = 15.0
				duration.one_shot = true
				duration.timeout.connect(func():
					Engine.time_scale = 1.0)
				add_child(duration)
				duration.start()
				remove_item(item))
	add_child(item)
	items.append(item)
	
func add_obs(obs, x, y):
	obs.position = Vector2i(x, y)
	obs.body_entered.connect(hit_obs)
	add_child(obs)
	obstacles.append(obs)

func remove_obs(obs):
	obs.queue_free()
	obstacles.erase(obs)
	
func remove_item(item):
	item.queue_free()
	items.erase(item)

func show_distance():
	var displayed_distance = distance / DISTANCE_MODIFIER
	$HUD.get_node("DistanceLabel").text = "DISTANCE: " + str(displayed_distance) + " m"
	$HUD.get_node("FeatherLabel").text = str(GameData.feather_count)
	
func hit_obs(body):
	if body.name == "Player":
			if $Player.shield == false:
				game_over()
			else:
				MusicManager.play_SFX("res://Sounds/squeaky-toy.mp3")
				$Player.shield = false
				$HUD.get_node("ShieldOn").visible = false

func game_over():
	get_tree().paused = true
	game_running = false
	$GameOver.visible = true
	MusicManager.play_SFX("res://Sounds/gameover.mp3")
	$GameOver.get_node("VBoxContainer/Button").grab_focus()

func enable_items():
	if GameData.teddy_bought == true:
			MusicManager.play_SFX("res://Sounds/squeaky-toy.mp3")
			$Player.shield = true
			$HUD.get_node("ShieldOn").visible = true
			GameData.teddy_bought = false

#for testing new items
func spawn_test():
		var test = chocolatebar_item.instantiate()
		var x = $Camera2D.position.x + 300
		var y = $Camera2D.position.y - 20
		add_item(test, x, y)
