extends Control

# Path to the final page
const FINAL_PAGE = "res://Scenes/game_over.tscn"

func _ready():
	print("Waiting for 3 seconds before transitioning to the final page...")
	# Use await to wait for 3 seconds
	await get_tree().create_timer(3.0).timeout
	transition_to_final_page()

# Function to transition to the final page
func transition_to_final_page():
	print("Transitioning to the final page.")
	get_tree().change_scene_to_file(FINAL_PAGE)
