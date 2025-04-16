extends Control

signal confirmed

@onready var confirm_button: Button = $Modal/Button  # Change path as per your popup
@onready var label: Label = $Modal/Label

func _ready():
	confirm_button.pressed.connect(_on_confirm_pressed)
	
func set_label_text(text: String) -> void:
	label.text = text

func _on_confirm_pressed():
	emit_signal("confirmed")
	hide()  # Hide or remove popup after confirmation

func style_label(font_size: int, position: Vector2, size: Vector2):
	# Set font size using a new DynamicFont
	var font = LabelSettings.new()
	font.font_size = font_size
	font.font_color = "#000000"
	label.label_settings = font

	# Update position and size
	label.position = position
	label.size = size	
