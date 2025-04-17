#extends Control
#
## Reference to the grid container for displaying selected cards
#@onready var grid_container = $GridContainer
#
## Reference to the label for displaying total points
#@onready var points_label = $Labels/points
#func _ready():
	#
	## Retrieve selected card data from the singleton
	#var selected_indices = GameState.selected_card_indices
	#var selected_points = GameState.selected_card_points
#
	## Calculate total points
	#var total_points = 0
	#for point in selected_points:
		#total_points += point
#
	## Update the points label
	##points_label.text =  convert_number_to_bangla(total_points)+' পয়েন্ট পেয়েছেন'
	#points_label.text =  EnglishToBanglaNumberConverter.convert_number_to_bangla(total_points)+' পয়েন্ট পেয়েছেন'
#
	## Display the selected cards
	#for index in selected_indices:
		#var card = TextureButton.new()  # Create a new card as TextureButton
		##card.text = "Card " + str(index)  # Example: Display card index
		#card.modulate = Color(0.5, 0.5, 0.5)  # Highlight appearance
		#grid_container.add_child(card)  # Add the card to the grid container
#
#
#func _on_button_pressed() -> void:
		#if GameState.selected_gender == "male":
			#get_tree().change_scene_to_file("res://Scenes/road_level_male_9.tscn")  # Male scene path
		#elif GameState.selected_gender == "female":
			#get_tree().change_scene_to_file("res://Scenes/road_level_female_4.tscn")  # Female scene path

#extends Control
#
#@onready var grid_container = $GridContainer
#@onready var points_label = $Labels/points
#
#func _ready():
	#var selected_indices = GameState.selected_card_indices
	#var selected_points = GameState.selected_card_points
#
	## Display total points
	#var total_points = 0
	#for point in selected_points:
		#total_points += point
	#points_label.text = EnglishToBanglaNumberConverter.convert_number_to_bangla(total_points) + " পয়েন্ট পেয়েছেন"
#
	## Load the card textures into the pre-existing TextureButtons
	#for i in range(min(selected_indices.size(), grid_container.get_child_count())):
		#var card_index = selected_indices[i]
		#var texture_path = "res://assets/images/selection_page-1//card %d.png" % card_index
		#var texture = load(texture_path)
#
		#if texture:
			#var card_button = grid_container.get_child(i)
			#card_button.texture_normal = texture
			#card_button.expand = true
			#card_button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		#else:
			#print("⚠️ Could not load texture for card index", card_index)
extends Control

@onready var grid_container = $GridContainer
@onready var points_label = $Labels/points
@onready var text = $Backround/text2/text

func _ready():
	var selected_indices = GameState.selected_card_indices
	var selected_points = GameState.selected_card_points

	# Display total points
	var total_points = 0
	for point in selected_points:
		total_points += point
	points_label.text = EnglishToBanglaNumberConverter.convert_number_to_bangla(total_points) + " পয়েন্ট পেয়েছেন"
	text.text='আপনি '+EnglishToBanglaNumberConverter.convert_number_to_bangla(total_points)+'পয়েন্ট পেয়েছেন।'
	# Apply textures to the existing TextureButtons
	for i in range(min(selected_indices.size(), grid_container.get_child_count())):
		var card_index = selected_indices[i]
		var texture_path = "res://assets/images/selection_page-3//card %d point.webp" % (card_index+1)
		var texture = load(texture_path)

		if texture:
			var card_button = grid_container.get_child(i) as TextureButton
			card_button.texture_normal = texture
			card_button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		else:
			print("⚠️ Could not load texture for card index", card_index)
			
func _on_button_pressed() -> void:
		if GameState.selected_gender == "male":
			get_tree().change_scene_to_file("res://Scenes/road_level_male_10.tscn")  # Male scene path
		elif GameState.selected_gender == "female":
			get_tree().change_scene_to_file("res://Scenes/road_level_female_4.tscn")  # Female scene path
