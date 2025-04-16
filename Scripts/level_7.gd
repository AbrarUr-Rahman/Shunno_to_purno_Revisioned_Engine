
extends Control
var total_points = 12
var card_points = [2, 6, 4, 3, 2, 1, 2]
var selected_cards = [false, false, false, false, false, false, false]
# This function is called when a card is clicked
func _on_card_clicked(card_index: int) -> void:
	var card_cost = card_points[card_index]
	var card = $GridContainer.get_child(card_index)
	var shadow = card.get_child(0)

	if selected_cards[card_index]:  # Deselection
		total_points += card_cost
		print("Deselected card. Points restored: ", total_points)
		#card.modulate = Color(1, 1, 1, 1)
		shadow.visible = false
		selected_cards[card_index] = false
		pop_up_card(card, false)
		


	else:
		if total_points >= card_cost:
			total_points -= card_cost
			print("Points remaining: ", total_points)
			#card.modulate = Color(0.5, 0.5, 0.5)
			shadow.visible = true
			selected_cards[card_index] = true
			pop_up_card(card, true)

		else:
			print("Not enough points to click this card!")

	update_points_display()
	update_button_state()

# Pop-up animation for card selection/deselection
func pop_up_card(card: Control, pop_up: bool) -> void:
	var tween = create_tween()
	if pop_up:
		tween.tween_property(card, "scale", Vector2(1.02, 1.02), 0.1)

	else:
		tween.tween_property(card, "scale", Vector2(1, 1), 0.1)


# Update the points display
func update_points_display():
	var label = $GridContainer/TextureRect/Label
	label.text = convert_number_to_bangla(total_points)+' পয়েন্ট বাকি'
func convert_number_to_bangla(number: int) -> String:
	var bangla_digits = {
		"0": "০", "1": "১", "2": "২", "3": "৩", "4": "৪",
		"5": "৫", "6": "৬", "7": "৭", "8": "৮", "9": "৯"
	}
	var english_str = str(number)
	var bangla_str = ""
	for char in english_str:
		if bangla_digits.has(char):
			bangla_str += bangla_digits[char]
		else:
			bangla_str += char
	return bangla_str
# Enable/Disable button based on remaining points
func update_button_state():
	var next_button = $Button
	next_button.disabled = total_points != 0

# Setup signal connections
func _ready():
	for i in range(card_points.size()):
		var card = $GridContainer.get_child(i)
		card.get_child(0).visible = false
		card.connect("pressed", Callable(self, "_on_card_clicked").bind(i))

	update_button_state()

# Handle "Next" button click
func _on_button_pressed() -> void:
	if total_points == 0:
		if GameState.selected_gender == "male":
			get_tree().change_scene_to_file("res://Scenes/road_level_male_8.tscn")
		elif GameState.selected_gender == "female":
			get_tree().change_scene_to_file("res://Scenes/road_level_female_2.tscn")
	else:
		print("You must use all points before proceeding!")
