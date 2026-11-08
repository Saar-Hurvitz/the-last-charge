extends CanvasLayer

func _ready():
	visible = false

func _input(event):
	if event.is_action_pressed("Pause"):
		toggle_pause()

	if event.is_action_pressed("Restart"):
		restart_game()

func toggle_pause():
	var is_paused = not get_tree().paused
	get_tree().paused = is_paused
	
	visible = is_paused

func restart_game():
	get_tree().paused = false
	get_tree().reload_current_scene()
