extends Control

# Track the selected cards
var selected_cards = [false, false, false, false, false, false]  # One for each card
var selected_count = 0  # Keep track of how many cards are selected

# This function is called when a card is clicked
func _on_card_clicked(card_index: int) -> void:
	var card = $GridContainer.get_child(card_index)  # Get the clicked card
	if selected_cards[card_index]:  # Deselecting the card
		selected_cards[card_index] = false
		selected_count -= 1
		card.modulate = Color(1, 1, 1, 1)  # Reset appearance
	else:  # Selecting the card
		selected_cards[card_index] = true
		selected_count += 1
		card.modulate = Color(0.5, 0.5, 0.5)  # Highlight the card visually

	print("Selected count:", selected_count)

	# Enable or disable the "Next Page" button
	update_next_page_button_state()

# Update the "Next Page" button state
func update_next_page_button_state():
	var next_page_button = $Button  # Adjust this path if necessary
	next_page_button.disabled = selected_count != 3  # Enable only if exactly 3 cards are selected

# Handle the next page button click
func _on_next_page_button_pressed():
	print("Proceeding to the next page!")  # Debug print
	# Add your logic to move to the next page here, e.g., `change_scene()`

# Connect the signals for each card button
func _ready():
	for i in range(selected_cards.size()):
		var card = $GridContainer.get_child(i)  # Get the correct child by index
		card.connect("pressed", Callable(self, "_on_card_clicked").bind(i))  # Use Callable to bind the card index

	# Initially disable the "Next Page" button
	update_next_page_button_state()


func _on_button_pressed() -> void:
		if GameState.selected_gender == "male":
			get_tree().change_scene_to_file("res://Scenes/road_level_male_8.tscn")  # Male scene path
		elif GameState.selected_gender == "female":
			get_tree().change_scene_to_file("res://Scenes/road_level_female_3.tscn")  # Female scene path
