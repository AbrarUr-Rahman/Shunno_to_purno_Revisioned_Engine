extends Control



func _ready():
	# Deduct 1 point from total points
	GameState.total_points -= 1

	# Ensure total points don't drop below 0
	if GameState.total_points < 0:
		GameState.total_points = 0



	# Debugging to confirm points deduction
	print("1 point deducted. Total points now:", GameState.total_points)
	
	


func _on_button_pressed() -> void:
		if GameState.selected_gender == "male":
			get_tree().change_scene_to_file("res://Scenes/road_level_male_10.tscn")  # Male scene path
		elif GameState.selected_gender == "female":
			get_tree().change_scene_to_file("res://Scenes/road_level_female_5.tscn")  # Female scene path
