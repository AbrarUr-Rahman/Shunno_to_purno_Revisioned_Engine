extends Button

var original_position: Vector2

func _ready() -> void:
	# Properly store the full original position
	original_position = position  
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

	# Connect signals
	pressed.connect(_on_pressed)
	button_up.connect(_on_released)

func _on_pressed() -> void:
	var tween = create_tween()
	tween.tween_property(self, "position", self.position + Vector2(0, 2), 0.05)

func _on_released() -> void:
	var tween = create_tween()
	tween.tween_property(self, "position", original_position, 0.05)
