extends Node2D

const PLAYER_START_POS := Vector2i(150, 485)
const CAM_START_POS := Vector2i(576, 324)

var speed: float
const START_SPEED : float = 10.0
const MAX_SPEED : int = 25
var screen_size : Vector2i

func _ready():
	screen_size = get_window().size
	new_game()
	
func new_game():
	$Player.position = PLAYER_START_POS
	$Player.velocity = Vector2i(0, 0)
	$Ground.position = Vector2i(0, 0)
	
func _process(delta):
	pass
