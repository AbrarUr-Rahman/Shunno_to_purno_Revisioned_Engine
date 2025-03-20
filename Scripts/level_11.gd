extends Control

# Reference to the grid container for displaying selected cards
@onready var grid_container = $GridContainer

# Reference to the label for displaying total points
@onready var points_label = $Labels/points

func _ready():
	
	# Retrieve selected card data from the singleton
	var selected_indices = GameState.selected_card_indices
	var selected_points = GameState.selected_card_points

	# Calculate total points
	var total_points = 0
	for point in selected_points:
		total_points += point

	# Update the points label
	points_label.text = str(total_points)

	# Display the selected cards
	for index in selected_indices:
		var card = TextureButton.new()  # Create a new card as TextureButton
		#card.text = "Card " + str(index)  # Example: Display card index
		card.modulate = Color(0.5, 0.5, 0.5)  # Highlight appearance
		grid_container.add_child(card)  # Add the card to the grid container


func _on_button_pressed() -> void:
		if GameState.selected_gender == "male":
			get_tree().change_scene_to_file("res://Scenes/road_level_male_9.tscn")  # Male scene path
		elif GameState.selected_gender == "female":
			get_tree().change_scene_to_file("res://Scenes/road_level_female_4.tscn")  # Female scene path
