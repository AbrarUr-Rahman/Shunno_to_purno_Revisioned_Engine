extends Control

# Variables to track the selected card
var selected_card = null

@onready var button: Button = $Button
@onready var male_button: TextureButton = $Cards/MaleButton
@onready var female_button: TextureButton = $Cards/FemaleButton

func _ready():
	# Connect the "pressed" signals for the texture buttons using Callable
	$Cards/MaleButton.connect("pressed", Callable(self, "_on_male_button_pressed"))
	$Cards/FemaleButton.connect("pressed", Callable(self, "_on_female_button_pressed"))
	$Button.connect("pressed", Callable(self, "_on_next_step_pressed"))

# Male button pressed handler
func _on_male_button_pressed():
	selected_card = "male"
	_highlight_selected_card()

# Female button pressed handler
func _on_female_button_pressed():
	selected_card = "female"
	_highlight_selected_card()

# Highlight the selected card
func _highlight_selected_card():
	# Reset the styles for both cards
	$Cards/MaleButton.modulate = Color(1, 1, 1, 1) # Normal color
	$Cards/FemaleButton.modulate = Color(1, 1, 1, 1) # Normal color

	# Highlight the selected card
	if selected_card == "male":
		$Cards/MaleButton.modulate = Color(0.8, 0.8, 1, 1) # Highlighted color
	elif selected_card == "female":
		$Cards/FemaleButton.modulate = Color(0.8, 0.8, 1, 1) # Highlighted color

# When the "Next" button is pressed
func _on_button_pressed():
	if selected_card == "male":
		GameState.selected_gender = "male"  # Store selected gender in GameState
		get_tree().change_scene_to_file("res://Scenes/male_level_5.tscn")  # Transition to male scene
	elif selected_card == "female":
		GameState.selected_gender = "female"  # Store selected gender in GameState
		get_tree().change_scene_to_file("res://Scenes/female_level_6.tscn")  # Transition to female scene
	else:
		print("No card selected!")
