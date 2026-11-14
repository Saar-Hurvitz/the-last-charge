extends CanvasLayer

func _ready():
	visible = false

func _input(event):
	if visible == true:
		if event.is_action_pressed("Restart"):
			restart_game()

func show_game_over():
	visible = true
	get_tree().paused = true

func restart_game():
	get_tree().paused = false
	get_tree().reload_current_scene()
