extends Control

# Total points initially set to 12
var total_points = 12

# Define the points cost for each card (corresponding to each TextureButton)
var card_points = [2, 6, 4, 3, 2, 1, 2]

# This function is called when a card is clicked
func _on_card_clicked(card_index: int) -> void:
	var card_cost = card_points[card_index]  # Get the point cost for this card

	if total_points >= card_cost:
		total_points -= card_cost  # Deduct points
		print("Points remaining: ", total_points)

		# Update the points display label
		update_points_display()

		# Disable the card and change its appearance
		var card = $GridContainer.get_child(card_index)
		card.disabled = true  # Disable the card
		card.modulate = Color(0.5, 0.5, 0.5)  # Grey out the card visually

	else:
		print("Not enough points to click this card!")

# Update the points display
func update_points_display():
	var label = $Label  # Assuming you have a label node to show the points
	label.text = "Points: " + str(total_points)  # Update the label text with the current total points

# Connect the signals for each card button
func _ready():
	for i in range(card_points.size()):
		var card = $GridContainer.get_child(i)  # Get the correct child by index
		# Connect the signal to the method using the callable format
		card.connect("pressed", Callable(self, "_on_card_clicked").bind(i))  # Use the Callable format to connect the signal
