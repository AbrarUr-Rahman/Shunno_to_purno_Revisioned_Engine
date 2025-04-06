extends Control


@onready var progress_bar = $ProgressBar

var next_scene_path = "res://Scenes/menu.tscn"  # Replace with your main scene path

func _ready():
	await get_tree().create_timer(2.0).timeout
	# Start loading the next scene asynchronously
	var packed_scene = ResourceLoader.load_threaded_get(next_scene_path)
	ResourceLoader.load_threaded_request(next_scene_path)
	if packed_scene:
		get_tree().change_scene_to_packed(packed_scene)
	
func _process(_delta):
	var progress = []
	var status = ResourceLoader.load_threaded_get_status(next_scene_path, progress)
	
	if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		progress_bar.value = progress[0]  # Update progress bar
	elif status == ResourceLoader.THREAD_LOAD_LOADED:
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(next_scene_path))  # Switch scene
