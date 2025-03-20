extends Node

# Global variables to store game state
var from_level_13 : bool = false
var total_points : int = 0  # Default total points
var selected_cards : Array = []  # Stores selected cards
var selected_card_indices : Array = []  # Stores selected card indices
var selected_card_points : Array = []  # Stores points of selected cards
var has_tried_purno = false
var visited_level_9: bool = false


# Store the selected gender (male or female)
var selected_gender : String = ""
