extends Node

var shadow_blob = preload("res://Enemies/shadow_blob.tscn")
var shadow_spike = preload("res://Enemies/shadow_spike.tscn")
var shadow_kitty = preload("res://Enemies/shadow_kitty.tscn")
var shadow_frog = preload("res://Enemies/shadow_frog.tscn")
var shadow_birdo = preload("res://Enemies/shadow_birdo.tscn")
#maybe some other enemies later on
var pillow_item = preload("res://Items/Scenes/pillow.tscn")
var feather_item = preload("res://Items/Scenes/feather.tscn")
var teddy_bear_item = preload("res://Items/Scenes/teddy_bear.tscn")
var lollipop_item = preload("res://Items/Scenes/lollipop.tscn")
var chocolatebar_item = preload("res://Items/Scenes/chocolatebar.tscn")
var jawbreaker_item = preload("res://Items/Scenes/jawbreaker.tscn")
var item_effects := {}

var flying_obstacles_types := [shadow_birdo]
var flying_obstacles: Array
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
var last_flying_obs
var game_running : bool
var current_progress: float = 0.0
var progress_smoothing : float = 5.0
var lollipop_effect : bool
var jawbreaker_effect : bool
var chocolatebar_effect : bool

func _ready():
	item_effects = {
		feather_item.resource_path: func(item):
			MusicManager.play_SFX("res://Sounds/item_collected.ogg")
			GameData.feather_count += 2 if lollipop_effect else 1,
			
		pillow_item.resource_path: func(item):
			MusicManager.play_SFX("res://Sounds/item_collected.ogg")
			GameData.feather_count += 20 if lollipop_effect else 10,
		
		teddy_bear_item.resource_path: func(item):
			MusicManager.play_SFX("res://Sounds/squeaky-toy.mp3")
			$Player.shield = true
			$HUD.get_node("ShieldOn").visible = true,
			
		lollipop_item.resource_path: func(item):
			MusicManager.play_SFX("res://Sounds/candycollected.ogg")
			lollipop_effect = true
			var duration = Timer.new()
			duration.wait_time = 15.0
			duration.one_shot = true
			duration.timeout.connect(func(): lollipop_effect = false)
			add_child(duration)
			duration.start(),
		
		chocolatebar_item.resource_path: func(_item):
			chocolatebar_effect = true
			MusicManager.play_SFX("res://Sounds/candycollected.ogg")
			var tween_in = create_tween()
			tween_in.tween_property(Engine, "time_scale", 0.5, 0.3)
			tween_in.tween_property(MusicManager.get_node("MusicPlayer"), "pitch_scale", 0.5, 0.3)
			await get_tree().create_timer(7).timeout
			chocolatebar_effect = false
			var tween_out = create_tween()
			tween_out.tween_property(Engine, "time_scale", 1.0, 0.5)
			tween_out.tween_property(MusicManager.get_node("MusicPlayer"), "pitch_scale", 1.0, 0.5),
		
		jawbreaker_item.resource_path: func(_item):
			jawbreaker_effect = true
			MusicManager.play_SFX("res://Sounds/candycollected.ogg")
			var timer = Timer.new()
			timer.wait_time = 10.0
			timer.one_shot = true
			timer.timeout.connect(func(): jawbreaker_effect = false)
			add_child(timer)
			timer.start()}
	
	var flying_spawn_timer := Timer.new()
	flying_spawn_timer.one_shot = true
	add_child(flying_spawn_timer)
	flying_spawn_timer.timeout.connect(func(): 
		generate_flying_obs()
		flying_spawn_timer.wait_time = randf_range(4.0, 8.0)
		flying_spawn_timer.start())
	flying_spawn_timer.wait_time = randf_range(4.0, 8.0)
	flying_spawn_timer.start()
			
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
	game_running = false
	get_tree().paused = false
	$Player.input_enabled = false
	$Player.shield = false
	enable_items()
	update_HUD()
	
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
	#await get_tree().create_timer(5).timeout
	#spawn_test()
	
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
		
		if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
			$Ground.position.x += screen_size.x
			
		if $Player.is_on_floor():
			$CloudParticle.position = $Player.position
			$CloudParticle.position.y += 40
			$CloudParticle.emitting = true
			
		for obs in obstacles:
			if obs.position.x < ($Camera2D.position.x - screen_size.x):
				remove_obs(obs)
				
		for flying_obs in flying_obstacles:
			if flying_obs.position.x < ($Camera2D.position.x - screen_size.x):
				remove_flying_obs(flying_obs)
		
		for item in items:
			if item.position.x < ($Camera2D.position.x - screen_size.x):
				remove_item(item)
		
		if jawbreaker_effect == true:
			apply_jawbreaker_effect(delta)
				
		var final_progress = float($Player.double_jump) / 3 * 100
		current_progress = lerp(current_progress, final_progress, delta * progress_smoothing)
		update_HUD()
		
	else:
		if Input.is_action_just_pressed("ui_accept"):
			game_running = true
			$Player.input_enabled = true
			$HUD.get_node("StartLabel").visible = false

#= 
func generate_obs():
	if obstacles.is_empty() or last_obs.position.x < $Camera2D.position.x + 50 + randi_range(0, 400):
		var obstacle_type 
		var obs_prob = randi() % 101
		if obs_prob < 90:
			obstacle_type = obstacle_types[randi() % obstacle_types.size()]
		else:
			obstacle_type = shadow_frog
		var obs = obstacle_type.instantiate()
		var obs_height = obs.get_node("AnimatedSprite2D").sprite_frames.get_frame_texture("Enemy Idle", 0).get_size().y
		var obs_scale = obs.get_node("AnimatedSprite2D").scale
		var obs_x : int = $Camera2D.position.x + screen_size.x + 100
		var obs_y : int = screen_size.y - ground_height - (obs_height * obs_scale.y / 2) + 25
		last_obs = obs
		add_obs(obs, obs_x, obs_y)
		
func generate_flying_obs():
		var obs_flying_type = flying_obstacles_types[randi() % flying_obstacles_types.size()]
		var flying_obs = obs_flying_type.instantiate()
		var fly_x: int = $Camera2D.position.x + screen_size.x + randi_range(1000, 2000)
		var fly_y: int = $Camera2D.position.y - randi_range(20, 80)
		last_flying_obs = flying_obs
		add_flying_obs(flying_obs, fly_x, fly_y)
	

func generate_items():
	if items.is_empty() or last_item.position.x < $Camera2D.position.x + randi_range(100, 500):
		var item_type
		var item_prob = randi() % 100
		if item_prob < 89:
			item_type = feather_item
		elif item_prob < 98:
			item_type = pillow_item
		else:
			item_type = [teddy_bear_item, lollipop_item, chocolatebar_item, jawbreaker_item][randi() % 4]
		var item = item_type.instantiate()
		var item_x: int = $Camera2D.position.x + screen_size.x + randi_range(300, 2000)
		var item_y: int = $Camera2D.position.y - randi_range(10, 30)
		last_item = item
		add_item(item, item_x, item_y)
		
func add_item(item, x, y):
	item.position = Vector2i(x, y)
	
	item.body_entered.connect(func(body):
		if body.name == "Player":
			remove_item(item)
			if item_effects.has(item.scene_file_path):
				await item_effects[item.scene_file_path].call(item))
				
	add_child(item)
	items.append(item)
	
func add_obs(obs, x, y):
	obs.position = Vector2i(x, y)
	obs.body_entered.connect(hit_obs)
	add_child(obs)
	obstacles.append(obs)

func add_flying_obs(obs, x, y):
	obs.position = Vector2i(x, y)
	obs.body_entered.connect(hit_obs)
	add_child(obs)
	flying_obstacles.append(obs)

func remove_obs(obs):
	obs.queue_free()
	obstacles.erase(obs)
	
func remove_flying_obs(flying_obs):
	flying_obs.queue_free()
	flying_obstacles.erase(flying_obs)
	
func remove_item(item):
	item.queue_free()
	items.erase(item)
	
func hit_obs(body):
	if body.name == "Player":
			if $Player.shield == false:
				game_over()
			else:
				MusicManager.play_SFX("res://Sounds/squeaky-toy.mp3")
				$Player.shield = false

func game_over():
	lollipop_effect = false
	game_running = false
	$Player.input_enabled = false
	if Engine.time_scale != 1:
		var tween_out = create_tween()
		tween_out.tween_property(Engine, "time_scale", 1.0, 0.1)
		tween_out.tween_property(MusicManager.get_node("MusicPlayer"), "pitch_scale", 1.0, 0.1)
		await tween_out.finished
	get_tree().paused = true
	$GameOver.visible = true
	MusicManager.play_SFX("res://Sounds/gameover.mp3")
	$GameOver.get_node("VBoxContainer/Button").grab_focus()

func enable_items():
	if GameData.teddy_bought == true:
			MusicManager.play_SFX("res://Sounds/squeaky-toy.mp3")
			$Player.shield = true
			GameData.teddy_bought = false

func apply_jawbreaker_effect(delta):
	for item in items:
		var direction = ($Player.position - item.position).normalized()
		item.position += direction * 300 * delta

func update_HUD():
	var displayed_distance = distance / DISTANCE_MODIFIER
	$HUD.get_node("DistanceLabel").text = "DISTANCE: " + str(displayed_distance) + " m"
	$HUD.get_node("FeatherLabel").text = str(GameData.feather_count)
	$HUD.get_node("ShieldOn").visible = $Player.shield
	$HUD.get_node("JawbreakerOn").visible = jawbreaker_effect
	$HUD.get_node("LollipopOn").visible = lollipop_effect
	$HUD.get_node("ChocolateBarOn").visible = chocolatebar_effect
	$HUD.get_node("DoubleJump").value = current_progress

#for testing new items
func spawn_test():
		var test = chocolatebar_item.instantiate()
		var test2 = lollipop_item.instantiate()
		var test3 = jawbreaker_item.instantiate()
		var test4 = teddy_bear_item.instantiate()
		var x = $Camera2D.position.x + 300
		var y = $Camera2D.position.y - 20
		add_item(test, x, y)
		add_item(test2, x, y)
		add_item(test3, x, y)
		add_item(test4, x, y)
