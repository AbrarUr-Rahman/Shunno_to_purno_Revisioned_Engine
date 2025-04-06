extends Control

# Hidden point values for each card
var card_points = [5, 3, 0, 4, 5, 3, 2, 0, 5, 2, 1, 5]

# Tracks whether each card is selected
var selected_cards = []
var selected_card_indices = []  # Indices of selected cards

# Number of cards that need to be selected
const INITIAL_SELECTION_LIMIT = 5  # Limit of 5 cards when starting the level
const MAX_SELECTION = 6  # Max limit of 6 cards when returning to the level
var selected_count = 0  # Current count of selected cards

# Reference nodes
@onready var grid_container = $GridContainer
@onready var next_button = $Button

func _ready():
	# Initialize the selected_cards array properly
	for i in range(card_points.size()):
		selected_cards.append(false)

		# Connect card signals
		var card = grid_container.get_child(i)
		if card.is_connected("pressed", Callable(self, "_on_card_clicked")):
			card.disconnect("pressed", Callable(self, "_on_card_clicked"))
		card.connect("pressed", Callable(self, "_on_card_clicked").bind(i))

	# Initially disable the next page button
	update_next_page_button_state()

	# Connect the "Next Page" button to its handler
	next_button.connect("pressed", Callable(self, "_on_next_page_pressed"))

	# Restore previously selected cards from GameState when returning to the scene
	for i in GameState.selected_card_indices:
		selected_cards[i] = true
		selected_count += 1
		var card = grid_container.get_child(i)
		card.modulate = Color(0.5, 0.5, 0.5)  # Highlight previously selected cards

# Handles card click events
func _on_card_clicked(card_index: int) -> void:
	var card = grid_container.get_child(card_index)

	# If the card is already selected, deselect it
	if selected_cards[card_index]:
		selected_cards[card_index] = false
		selected_count -= 1
		selected_card_indices.erase(card_index)
		card.modulate = Color(1, 1, 1, 1)  # Reset appearance
		GameState.total_points -= card_points[card_index]  # Deduct points when deselected
		print("Removed points for the card:", card_points[card_index])
	else:
		# Allow selection within limit
		var max_limit = MAX_SELECTION if GameState.has_tried_purno else INITIAL_SELECTION_LIMIT
		if selected_count < max_limit:
			selected_cards[card_index] = true
			selected_count += 1
			selected_card_indices.append(card_index)
			card.modulate = Color(0.5, 0.5, 0.5)  # Highlight the card
			GameState.total_points += card_points[card_index]  # Add points when selected
			print("Added points for the card:", card_points[card_index])
		else:
			print("You have reached the selection limit!")

	print("Selected count:", selected_count)
	print("Selected card indices:", selected_card_indices)

	# Update the next page button state
	update_next_page_button_state()

# Update the next page button state
func update_next_page_button_state():
	# Enable the "Next Page" button only when the required number of cards is selected
	if selected_count == INITIAL_SELECTION_LIMIT or (GameState.has_tried_purno and selected_count == MAX_SELECTION):
		next_button.disabled = false
	else:
		next_button.disabled = true

# Handles "Next Page" button press
func _on_next_page_pressed() -> void:
	if selected_count == INITIAL_SELECTION_LIMIT:
		print("Proceeding to the next page with selected cards!")

		# Update GameState with the selected data
		GameState.selected_card_indices = selected_card_indices
		GameState.selected_card_points = []  # FIXED: List comprehension issue
		for index in selected_card_indices:
			GameState.selected_card_points.append(card_points[index])  # FIXED

		print("Selected card indices:", selected_card_indices)
		print("Selected card points:", GameState.selected_card_points)
		print("Total points collected:", GameState.total_points)

		# Proceed to the next scene
		if GameState.has_tried_purno == false:
			get_tree().change_scene_to_file("res://Scenes/level_11.tscn")
			print("Going to level 11")
		else:
			get_tree().change_scene_to_file("res://Scenes/level_13.tscn")
			print("Going to level 13")
	else:
		print("You must select exactly 5 cards to proceed!")

func _on_return_to_level_9():
	if GameState.has_tried_purno:
		# Reset the flag to allow selection of additional cards
		GameState.has_tried_purno = false
		print("Returning to Level 9. You can now select 1 more card.")
		
	# Reset selected states
	for i in range(card_points.size()):
		var card = grid_container.get_child(i)

		# Disconnect signal to prevent multiple bindings
		if card.is_connected("pressed", Callable(self, "_on_card_clicked")):
			card.disconnect("pressed", Callable(self, "_on_card_clicked"))

		# Reconnect the signal
		card.connect("pressed", Callable(self, "_on_card_clicked").bind(i))

		# Restore visual state for selected cards
		if selected_cards[i]:
			card.modulate = Color(0.5, 0.5, 0.5)  # Keep selected cards grayed out
		else:
			card.modulate = Color(1, 1, 1, 1)  # Reset unselected cards to default

	# Ensure `selected_count` is correctly updated
	selected_count = len(GameState.selected_card_indices)

	# Update the next page button state to reflect changes
	update_next_page_button_state()
