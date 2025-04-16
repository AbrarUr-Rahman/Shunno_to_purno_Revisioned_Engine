
extends Control

# Track the selected cards
var selected_cards = [false, false, false, false, false, false]  # One for each card
var selected_count = 0  # Keep track of how many cards are selected

# This function is called when a card is clicked
func _on_card_clicked(card_index: int) -> void:
	var card = $GridContainer.get_child(card_index)  # Get the clicked card
	var shadow = card.get_child(0)
	print(shadow,"print")
	# If the card is already selected, deselect it
	if selected_cards[card_index]:
		selected_cards[card_index] = false
		selected_count -= 1
		#card.modulate = Color(1, 1, 1, 1)  # Reset card appearance
		shadow.visible = false
		# Reset scale if deselected
		pop_up_card(card, false)
		print("Deselected card:", card_index)
	else:
		# If selecting a new card, check if the maximum limit is reached
		if selected_count >= 3:
			print("You can only select up to 3 cards!")
			return  # Prevent selecting more than 3 cards

		# Select the card
		selected_cards[card_index] = true
		selected_count += 1
		shadow.visible = true
		#card.modulate = Color(0.5, 0.5, 0.5)  # Highlight the card visually
		pop_up_card(card, true)
		print("Selected card:", card_index)

	print("Selected count:", selected_count)

	# Update the state of the "Next Page" button
	update_next_page_button_state()

# Pop-up animation
func pop_up_card(card: Control, pop_up: bool) -> void:
	var tween = create_tween()
	if pop_up:
		tween.tween_property(card, "scale", Vector2(1.02, 1.02), 0.1)
	else:
		tween.tween_property(card, "scale", Vector2(1, 1), 0.1)

# Update the "Next Page" button state
func update_next_page_button_state():
	var next_page_button = $Button  # Adjust this path if necessary
	next_page_button.disabled = selected_count != 3  # Enable only if exactly 3 cards are selected

# Handle the next page button click
func _on_button_pressed():
	print("Proceeding to the next page!")  # Debug message

	# Logic to transition to the next scene based on gender
	if GameState.selected_gender == "male":
		get_tree().change_scene_to_file("res://Scenes/road_level_male_9.tscn")  # Male scene path
	elif GameState.selected_gender == "female":
		get_tree().change_scene_to_file("res://Scenes/road_level_female_3.tscn")  # Female scene path
	else:
		print("Error: No gender selected!")  # Handle unexpected cases

# Connect the signals for each card button
func _ready():
	# Connect each card button's "pressed" signal
	for i in range(selected_cards.size()):
		var card = $GridContainer.get_child(i)  # Get the correct child by index
		card.get_child(0).visible = false
		card.connect("pressed", Callable(self, "_on_card_clicked").bind(i))  # Use Callable to bind the card index

	# Initially disable the "Next Page" button
	update_next_page_button_state()
