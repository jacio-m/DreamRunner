extends Node

const PLAYER_START_POS := Vector2i(150, 515)
const CAM_START_POS := Vector2i(576, 324)

var speed : float
const START_SPEED : float = 5.0
const MAX_SPEED : int = 15.0
var screen_size : Vector2i
const SPEED_MODIFIER: int = 10000
var distance : int
const DISTANCE_MODIFIER: int = 100

func _ready():
	$"DreamSweet (main)".play()
	screen_size = get_window().size
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
	$Player.position.x += speed
	$Camera2D.position.x += speed
	
	distance += speed
	show_distance()
	
	if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
		$Ground.position.x += screen_size.x

func show_distance():
	$HUD.get_node("DistanceLabel").text = "Distance: " + str(distance / DISTANCE_MODIFIER) + " m"
