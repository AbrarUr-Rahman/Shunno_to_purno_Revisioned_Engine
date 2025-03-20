extends Control

# Hidden point values for each card
var card_points = [5, 3, 0, 4, 5, 3, 2, 0, 5, 2, 1, 5]

# Tracks whether each card is selected
var selected_cards = [false, false, false, false, false, false, false, false, false, false, false, false]
var selected_card_indices = []  # Indices of selected cards

# Number of cards that need to be selected
const INITIAL_SELECTION_LIMIT = 5  # Limit of 5 cards when starting the level
const MAX_SELECTION = 6  # Max limit of 6 cards when returning to the level
var selected_count = 0  # Current count of selected cards

# Reference nodes
@onready var grid_container = $GridContainer
@onready var next_button = $Button
#@onready var points_label = $PointsLabel  # Optional, to display total points

# Variable to check if the player has moved to the next scene
 #GameState.has_tried_purno = false

func _ready():
	# Connect card signals and initialize UI
	for i in range(card_points.size()):
		var card = grid_container.get_child(i)
		card.connect("pressed", Callable(self, "_on_card_clicked").bind(i))
		#print("This is the card variable: ",card)
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

	# Optional: Initialize points label
	#points_label.text = str(GameState.total_points)

# Handles card click events
func _on_card_clicked(card_index: int) -> void:
	var card = grid_container.get_child(card_index)

	# If we haven't moved to the next scene, limit to 5 cards
	if !GameState.has_tried_purno:
		# Allow selection if there are fewer than the initial limit
		if selected_count < INITIAL_SELECTION_LIMIT:
			if selected_cards[card_index]:
				# Deselect the card
				selected_cards[card_index] = false
				selected_count -= 1
				selected_card_indices.erase(card_index)
				card.modulate = Color(1, 1, 1, 1)  # Reset appearance
			else:
				# Select the card
				selected_cards[card_index] = true
				selected_count += 1
				selected_card_indices.append(card_index)
				card.modulate = Color(0.5, 0.5, 0.5)  # Highlight the card
		else:
			print("You can only select 5 cards initially!")
	else:
		# Once you've moved to the next scene, allow 6 cards
		if selected_count==8 or selected_count==9:
			if selected_cards[card_index]:
				# Deselect the card
				selected_cards[card_index] = false
				selected_count -= 1
				selected_card_indices.erase(card_index)
				card.modulate = Color(1, 1, 1, 1)  # Reset appearance
			else:
				# Select the card
				selected_cards[card_index] = true
				selected_count += 1
				selected_card_indices.append(card_index)
				card.modulate = Color(0.5, 0.5, 0.5)  # Highlight the card
				GameState.total_points += card_points[card_index]
				print("Added points for the 6th card:", card_points[card_index])
				print("New total points:", GameState.total_points)
				next_button.disabled = false
				print("deselect card selected_count:  ",selected_count)
		else:
			print("You can only select 6 cards!")

	print("Selected  count:", selected_count)
	print("Selected card indices:", selected_card_indices)
	print("Max Count: ",MAX_SELECTION)

	# Update the next page button state
	update_next_page_button_state()

# Update the next page button state
func update_next_page_button_state():
	# Enable the "Next Page" button only when the maximum number of cards is selected
	if selected_count == INITIAL_SELECTION_LIMIT or (GameState.has_tried_purno and selected_count == MAX_SELECTION):
		next_button.disabled = false
	#else:
		#next_button.disabled = true

# Handles "Next Page" button press
func _on_next_page_pressed() -> void:
	if selected_count == INITIAL_SELECTION_LIMIT:
		print("Proceeding to the next page with selected cards!")

		# Calculate total points from selected cards
		var selected_points = []
		var total_points = GameState.total_points
		for index in selected_card_indices:
			selected_points.append(card_points[index])
			total_points += card_points[index]

		# Update GameState with the selected data
		GameState.selected_card_indices = selected_card_indices
		GameState.selected_card_points = selected_points
		GameState.total_points = total_points

		print("Selected card indices:", selected_card_indices)
		print("Selected card points:", selected_points)
		print("Total points collected:", total_points)

		# Mark as moved to the next scene
		#GameState.has_tried_purno = true

		# Proceed to the next scene
		if GameState.has_tried_purno==false:
			get_tree().change_scene_to_file("res://Scenes/level_11.tscn")
			print("Going to level 11")  # Adjust the path
		#elif GameState.has_tried_purno==true:
			#get_tree().change_scene_to_file("res://Scenes/level_13.tscn")
			#print("Going to level 13")
	else:
		if(selected_count==9):
			get_tree().change_scene_to_file("res://Scenes/level_13.tscn")
		#print("You must select exactly 5 cards to proceed!")
		print("Going Back to level 13")
		print("Selected Count: ",selected_count)
		print("Ponts remaining: ",GameState.total_points)

# When returning to level_9, allow selecting 1 more card (total 6)
func _on_return_to_level_9():
	if GameState.has_tried_purno:
		# Reset the flag to allow selection of additional cards
		#GameState.has_tried_purno = false
		print("Returning to Level 9. You can now select 1 more card.")
		
		# Set selected_count based on previously selected cards
		selected_count = len(GameState.selected_card_indices)  # Adjust selected count based on the previously selected cards

		# Highlight previously selected cards when returning
		for i in range(card_points.size()):
			if selected_cards[i]:
				var card = grid_container.get_child(i)
				card.modulate = Color(0.5, 0.5, 0.5)  # Highlight the card as selected

		# Enable the selection of up to 6 cards
		update_next_page_button_state()

	# Reset the selected_cards and selected_card_indices if returning from a level after moving forward
	for i in range(card_points.size()):
		if not selected_cards[i]:
			var card = grid_container.get_child(i)
			card.modulate = Color(1, 1, 1, 1)  # Reset all non-selected cards appearance
