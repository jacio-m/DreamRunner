extends Node

var shadow_blob = preload("res://Enemies/shadow_blob.tscn")
var shadow_blob2 = preload("res://Enemies/shadow_blob2.tscn")
#maybe some other enemies later on
var obstacle_types := [shadow_blob, shadow_blob2]
var obstacles : Array

const PLAYER_START_POS := Vector2i(150, 515)
const CAM_START_POS := Vector2i(576, 324)

var speed : float
const START_SPEED : float = 5.0
const MAX_SPEED : int = 15.0
var screen_size : Vector2i
var ground_height : int
const SPEED_MODIFIER: int = 10000
var distance : int
const DISTANCE_MODIFIER: int = 100
var last_obs

func _ready():
	$"DreamSweet (main)".play()
	screen_size = get_viewport().get_visible_rect().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	new_game()
	
func new_game():
	distance = 0
	$Player.position = PLAYER_START_POS 
	$Player.velocity = Vector2i(0, 0)
	$Camera2D.position = CAM_START_POS
	$Ground.position = Vector2i(0, 0)

func _input(InputEvent):
	if Input.is_action_just_pressed("ui_down"):
		get_tree().reload_current_scene()
	
func _process(delta):
	speed = START_SPEED + distance / SPEED_MODIFIER
	if speed > MAX_SPEED:
		speed = MAX_SPEED
		
	generate_obs()
		
	
	$Player.position.x += speed
	$Camera2D.position.x += speed
	
	distance += speed
	show_distance()
	
	if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
		$Ground.position.x += screen_size.x
		
	for obs in obstacles:
		if obs.position.x < ($Camera2D.position.x - screen_size.x):
			remove_obs(obs)

func generate_obs():
	if obstacles.is_empty() or last_obs.position.x < distance + randi_range(200, 600):
		var obstacle_type = obstacle_types[randi() % obstacle_types.size()]
		var obs
		obs = obstacle_type.instantiate()
		var obs_height = obs.get_node("Sprite2D").texture.get_height()
		var obs_scale = obs.get_node("Sprite2D").scale
		var obs_x : int = screen_size.x + distance + 100
		var obs_y : int = screen_size.y - ground_height - (obs_height * obs_scale.y / 2) + 15
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
	$HUD.get_node("DistanceLabel").text = "Distance: " + str(distance / DISTANCE_MODIFIER) + " m"
	
func hit_obs(body):
	if body.name == "Player":
		print("funcionando")
