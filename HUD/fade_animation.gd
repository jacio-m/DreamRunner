extends CanvasLayer

@onready var anim = $AnimationPlayer
@onready var rect = $ColorRect

func _ready():
	rect.modulate.a = 0.0

func fade_in():
	anim.play("Fade In")
	
func fade_out():
	anim.play("Fade Out")
	
func fade_to_scene(scene_path: String):
	anim.play("Fade Out")
	await anim.animation_finished
	get_tree().change_scene_to_file(scene_path)
	anim.play("Fade In")

func quit_game():
	anim.play("Fade Out")
	await anim.animation_finished
	get_tree().quit()
