extends Control

func _on_button_pressed() -> void:
	# Reset GameState variables
	GameState.from_level_13 = false
	GameState.total_points = 0
	GameState.selected_cards.clear()
	GameState.selected_card_indices.clear()
	GameState.selected_card_points.clear()
	GameState.selected_gender = ""
	GameState.visited_level_9 = false  # Reset Level 9 visit flag

	# Change to menu scene
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
