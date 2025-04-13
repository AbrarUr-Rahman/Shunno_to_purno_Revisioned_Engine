extends Control

signal confirmed

@onready var confirm_button: Button = $Modal/Button  # Change path as per your popup

func _ready():
	confirm_button.pressed.connect(_on_confirm_pressed)

func _on_confirm_pressed():
	emit_signal("confirmed")
	queue_free()  # Hide or remove popup after confirmation
