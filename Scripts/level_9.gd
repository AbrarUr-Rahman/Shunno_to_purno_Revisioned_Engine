extends Control

# Hidden point values for each card
var card_points = [5, 3, 0, 4, 5, 3, 2, 0, 5, 2, 1, 5]

# Tracks whether each card is selected
var selected_cards = []
var selected_card_indices = []  # Indices of selected cards

# Number of cards that need to be selected
const INITIAL_SELECTION_LIMIT = 5
const MAX_SELECTION = 6
var selected_count = 0

# Reference nodes
@onready var grid_container = $GridContainer
@onready var next_button = $Button

func _ready():
	# Initialize selection and connect signals
	for i in range(card_points.size()):
		selected_cards.append(false)
		var card = grid_container.get_child(i)
		card.modulate = Color(1, 1, 1, 1)

		if card.is_connected("pressed", Callable(self, "_on_card_clicked")):
			card.disconnect("pressed", Callable(self, "_on_card_clicked"))

		card.connect("pressed", Callable(self, "_on_card_clicked").bind(i))

	# Restore previous selections
	selected_card_indices.clear()
	for i in GameState.selected_card_indices:
		selected_cards[i] = true
		selected_card_indices.append(i)
		selected_count += 1
		grid_container.get_child(i).modulate = Color(0.5, 0.5, 0.5)

	update_next_page_button_state()

	if not next_button.is_connected("pressed", Callable(self, "_on_next_page_pressed")):
		next_button.connect("pressed", Callable(self, "_on_next_page_pressed"))

func _on_card_clicked(card_index: int) -> void:
	var card = grid_container.get_child(card_index)

	var max_limit = INITIAL_SELECTION_LIMIT
	if GameState.has_tried_purno:
		max_limit += 1  # Allow one more card after returning from Level 12

	if selected_cards[card_index]:
		selected_cards[card_index] = false
		selected_count -= 1
		selected_card_indices.erase(card_index)
		card.modulate = Color(1, 1, 1, 1)
		GameState.total_points -= card_points[card_index]
		print("Removed points for the card:", card_points[card_index])
	else:
		if selected_count < max_limit:
			selected_cards[card_index] = true
			selected_count += 1
			selected_card_indices.append(card_index)
			card.modulate = Color(0.5, 0.5, 0.5)
			GameState.total_points += card_points[card_index]
			print("Added points for the card:", card_points[card_index])
		else:
			print("You have reached the selection limit!")

	print("Selected count:", selected_count)
	print("Selected card indices:", selected_card_indices)

	update_next_page_button_state()

func update_next_page_button_state():
	var required_count = INITIAL_SELECTION_LIMIT
	if GameState.has_tried_purno:
		required_count += 1
	next_button.disabled = selected_count != required_count

func _on_next_page_pressed() -> void:
	var required_count = INITIAL_SELECTION_LIMIT
	if GameState.has_tried_purno:
		required_count += 1

	if selected_count == required_count:
		GameState.selected_card_indices = selected_card_indices.duplicate()
		GameState.selected_card_points = []
		for index in selected_card_indices:
			GameState.selected_card_points.append(card_points[index])

		print("Selected card indices:", selected_card_indices)
		print("Selected card points:", GameState.selected_card_points)
		print("Total points collected:", GameState.total_points)

		if GameState.has_tried_purno == false:
			get_tree().change_scene_to_file("res://Scenes/level_11.tscn")
			print("Going to level 11")
		else:
			get_tree().change_scene_to_file("res://Scenes/level_13.tscn")
			print("Going to level 13")
	else:
		print("You must select exactly %d cards to proceed!" % required_count)

func _on_return_to_level_9():
	if GameState.has_tried_purno:
		GameState.has_tried_purno = false
		print("Returning to Level 9. You can now select 1 more card.")

	# Reset local state from GameState
	selected_card_indices = GameState.selected_card_indices.duplicate()
	selected_count = selected_card_indices.size()

	for i in range(card_points.size()):	
		var card = grid_container.get_child(i)

		if card.is_connected("pressed", Callable(self, "_on_card_clicked")):
			card.disconnect("pressed", Callable(self, "_on_card_clicked"))
		card.connect("pressed", Callable(self, "_on_card_clicked").bind(i))

		if i in selected_card_indices:
			selected_cards[i] = true
			card.modulate = Color(0.5, 0.5, 0.5)
		else:
			selected_cards[i] = false
			card.modulate = Color(1, 1, 1, 1)

	update_next_page_button_state()
	print("Previously selected:", selected_card_indices)
	print("You may now select one more card.")
