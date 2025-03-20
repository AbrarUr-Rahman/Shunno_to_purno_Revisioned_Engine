extends Control

# Total points initially set to 12
var total_points = 12

# Define the points cost for each card (corresponding to each TextureButton)
var card_points = [2, 6, 4, 3, 2, 1, 2]

# Keep track of selected cards (true if selected, false otherwise)
var selected_cards = [false, false, false, false, false, false, false]

# This function is called when a card is clicked
func _on_card_clicked(card_index: int) -> void:
	var card_cost = card_points[card_index]  # Get the point cost for this card
	var card = $GridContainer.get_child(card_index)  # Get the card node

	if selected_cards[card_index]:  # If the card is already selected (deselecting)
		total_points += card_cost  # Restore the points
		print("Deselected card. Points restored: ", total_points)

		# Unhighlight the card visually
		card.modulate = Color(1, 1, 1, 1)  # Reset to original appearance
		selected_cards[card_index] = false  # Mark the card as deselected
	else:  # If the card is not selected (selecting)
		if total_points >= card_cost:
			total_points -= card_cost  # Deduct points
			print("Points remaining: ", total_points)

			# Highlight the card visually
			card.modulate = Color(0.5, 0.5, 0.5)  # Grey out the card visually
			selected_cards[card_index] = true  # Mark the card as selected
		else:
			print("Not enough points to click this card!")

	# Update the points display
	update_points_display()
	update_button_state()  # Check if the button should be enabled

# Update the points display
func update_points_display():
	var label = $GridContainer/TextureRect/Label  # Assuming you have a label node to show the points
	label.text = str(total_points)   # Update the label text with the current total points

# Enable or disable the button based on total_points
func update_button_state():
	var next_button = $Button  # Adjust to the actual path of the button
	next_button.disabled = total_points != 0  # Enable the button only when total_points == 0

# Connect the signals for each card button
func _ready():
	for i in range(card_points.size()):
		var card = $GridContainer.get_child(i)  # Get the correct child by index
		# Connect the signal to the method using the callable format
		card.connect("pressed", Callable(self, "_on_card_clicked").bind(i))  # Use the Callable format to connect the signal
	
	update_button_state()  # Disable the button initially

# Handle the next page button press
func _on_button_pressed() -> void:
	if total_points == 0:  # Ensure all points are used before proceeding
		if GameState.selected_gender == "male":
			get_tree().change_scene_to_file("res://Scenes/road_level_male_7.tscn")  # Male scene path
		elif GameState.selected_gender == "female":
			get_tree().change_scene_to_file("res://Scenes/road_level_female_2.tscn")  # Female scene path
	else:
		print("You must use all points before proceeding!")
