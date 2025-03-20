extends Control

# Scene paths for the next pages
const ACCIDENT_1_PAGE = "res://Scenes/accident_1_car_crash.tscn"
const ACCIDENT_2_PAGE = "res://Scenes/accident_2_cyclone.tscn"

# Reference to the coin TextureRect
@onready var coin_texture = $Backround

func _ready():
	# Connect the "gui_input" signal to the coin
	coin_texture.connect("gui_input", Callable(self, "_on_coin_toss"))

# Handle coin toss logic
func _on_coin_toss(event):
	if event is InputEventMouseButton and event.pressed:
		# Randomly choose the next scene
		var next_scene = ACCIDENT_1_PAGE if randf() < 0.5 else ACCIDENT_2_PAGE
		print("Toss result:", next_scene)
		# Transition to the selected scene
		get_tree().change_scene_to_file(next_scene)
