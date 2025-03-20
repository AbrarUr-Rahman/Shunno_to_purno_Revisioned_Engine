extends Control

# Points required for each card
var card_costs = [4, 3, 3, 4]  # Example costs for the cards (same as your original)

# Track whether each card is selected
var selected_cards = [false, false, false, false]  # Matches the number of cards
var selected_count = 0  # Count of selected cards

# Reference to the grid container, points label, and next page button
@onready var grid_container = $GridContainer
@onready var points_label = $Backround/TextureRect/points
@onready var next_page_button = $Button

func _ready():
	# Retrieve total points from GameState
	points_label.text = str(GameState.total_points)

	# Disable the next page button initially
	next_page_button.disabled = true

	# Connect the pressed signals for each card
	for i in range(card_costs.size()):
		var card = grid_container.get_child(i)  # Get existing card
		# Connect the card's "pressed" signal
		card.connect("pressed", Callable(self, "_on_card_clicked").bind(i))

	# Connect the next page button's signal
	next_page_button.connect("pressed", Callable(self, "_on_next_page_pressed"))

# Handle card clicks
func _on_card_clicked(index: int) -> void:
	var card = grid_container.get_child(index)  # Get the clicked card

	# If the card is already selected, deselect it
	if selected_cards[index]:
		selected_cards[index] = false
		selected_count -= 1
		GameState.total_points += card_costs[index]  # Refund points
		card.modulate = Color(1, 1, 1, 1)  # Reset the card's appearance
		print("Deselected card", index, ". Points refunded:", card_costs[index])
	else:
		# Check if the player has enough points to select the card
		if GameState.total_points < card_costs[index]:
			print("Not enough points to select this card!")

			# Check if it's the first time they don't have enough points
			if GameState.has_tried_purno == false:
				# Allow the player another chance to gather points (e.g., send them to level 9)
				get_tree().change_scene_to_file("res://Scenes/level_9.tscn")
				GameState.has_tried_purno = true  # Mark that the player has tried purno before
			else:
				# If they already tried purno, go to fail scene
				if GameState.selected_gender == "male":
					get_tree().change_scene_to_file("res://Scenes/man_fail.tscn")
				elif GameState.selected_gender == "female":
					get_tree().change_scene_to_file("res://Scenes/woman_fail.tscn")
			return  # Exit the function if points are not enough

		# Prevent selecting more than two cards
		if selected_count >= 2:
			print("You can only select up to two cards!")
			return

		# Select the card
		selected_cards[index] = true
		selected_count += 1
		GameState.total_points -= card_costs[index]  # Deduct points
		card.modulate = Color(0.5, 0.5, 0.5)  # Highlight the card visually
		print("Selected card", index, ". Points spent:", card_costs[index])

	# Update points label and next page button state
	points_label.text = str(GameState.total_points)
	update_next_page_button_state()

# Update the next page button state
func update_next_page_button_state():
	# Enable the button only if exactly 2 cards are selected
	print("Selected count:", selected_count, "Total points:", GameState.total_points)
	if selected_count == 2:
		print("Enabling Next Button!")
		next_page_button.disabled = false
	else:
		print("Disabling Next Button!")
		next_page_button.disabled = true

# Handle next page button press
func _on_next_page_pressed() -> void:
	# Ensure exactly 2 cards are selected and total points are 6 or more
	print("Selected count on Next Button Press:", selected_count)
	print("Total points on Next Button Press:", GameState.total_points)
	
	if selected_count == 2:
		print("Two cards selected with enough points! Proceeding to the next page.")
		
		# Check the selected gender and load the appropriate scene
		if GameState.selected_gender == "male":
			get_tree().change_scene_to_file("res://Scenes/man_purno.tscn")  # Success scene for male
		elif GameState.selected_gender == "female":
			get_tree().change_scene_to_file("res://Scenes/woman_purno.tscn")  # Success scene for female
		else:
			print("No gender selected, unable to proceed!")
	else:
		print("You must select exactly two cards to proceed!")

		# Check if it's the first time they don't have enough points
		if GameState.has_tried_purno == false:
			# Redirect to level 9 if they haven't tried purno yet
			get_tree().change_scene_to_file("res://Scenes/level_9.tscn")
			GameState.has_tried_purno = true  # Mark that the player has tried purno
		else:
			# If they already tried purno, go to fail scene
			if GameState.selected_gender == "male":
				get_tree().change_scene_to_file("res://Scenes/man_fail.tscn")  # Failure scene for male
			elif GameState.selected_gender == "female":
				get_tree().change_scene_to_file("res://Scenes/woman_fail.tscn")  # Failure scene for female
			else:
				print("No gender selected, unable to proceed!")
