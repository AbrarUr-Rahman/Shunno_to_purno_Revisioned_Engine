extends Control

# On ready variables for the UI elements
@onready var male_button: TextureButton = $Cards/MaleButton
@onready var female_button: TextureButton = $Cards/FemaleButton
@onready var male_border: ColorRect = $Cards/MaleButton/BorderGlow
@onready var female_border: ColorRect = $Cards/FemaleButton/BorderGlow

# Variables to track the selected card
var selected_card = null

func _ready():
	# Connect the "pressed" signals for the texture buttons
	$Cards/MaleButton.connect("pressed", Callable(self, "_on_male_button_pressed"))
	$Cards/FemaleButton.connect("pressed", Callable(self, "_on_female_button_pressed"))
	$Button.connect("pressed", Callable(self, "_on_next_step_pressed"))
	
	# Initially hide the borders
	male_border.visible = false
	female_border.visible = false

# Male button pressed handler
func _on_male_button_pressed():
	selected_card = "male"
	_highlight_selected_card()
	_pop_up_card(male_button)

# Female button pressed handler
func _on_female_button_pressed():
	selected_card = "female"
	_highlight_selected_card()
	_pop_up_card(female_button)

# Highlight the selected card
func _highlight_selected_card():
	# Reset the styles for both cards
	var tween = create_tween()
	male_button.modulate = Color(1, 1, 1, 1)  # Normal color
	female_button.modulate = Color(1, 1, 1, 1)  # Normal color

	# Highlight the selected card
	if selected_card == "male":
		male_button.modulate = Color(0.8, 0.8, 1, 1)  # Highlighted color
		#male_button. = Color(0.8, 0.8, 1, 1)
		male_border.visible = true
		female_border.visible = false
		male_border.size.x = 830
	elif selected_card == "female":
		female_button.modulate = Color(0.8, 0.8, 1, 1)  # Highlighted color
		male_border.visible = false
		female_border.visible = true

# Pop-up animation for the selected card using create_tween()
func _pop_up_card(card: TextureButton):
	var tween = create_tween()  # Create a new tween dynamically
	#tween.tween_property(card, "scale", Vector2(1, 1), 0.1)
	if selected_card == "male":
		tween.tween_property(card, "scale", Vector2(1.02, 1.02), 0.1)
		tween.tween_property(male_border, "scale", Vector2(1.02, 1.02), 0.1)
		tween.tween_property(female_button, "scale", Vector2(1, 1), 0.1)
	elif selected_card == "female":
		tween.tween_property(card, "scale", Vector2(1.02, 1.02), 0.1)	
		tween.tween_property(female_border, "scale", Vector2(1.02, 1.02), 0.1)
		tween.tween_property(male_button, "scale", Vector2(1, 1), 0.1)
	

# When the "Next" button is pressed
func _on_next_step_pressed():
	if selected_card == "male":
		GameState.selected_gender = "male"  # Store selected gender in GameState
		get_tree().change_scene_to_file("res://Scenes/male_level_5.tscn")  # Transition to male scene
	elif selected_card == "female":
		GameState.selected_gender = "female"  # Store selected gender in GameState
		get_tree().change_scene_to_file("res://Scenes/female_level_6.tscn")  # Transition to female scene
	else:
		print("No card selected!")
