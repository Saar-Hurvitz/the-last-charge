extends CanvasLayer

@onready var label = $Label
@onready var timer = $Label/Timer
@onready var rain_particles: GPUParticles2D = $"../RainParticles"

func _process(delta):
	var time_left = int(timer.time_left)
	
	if time_left <= 540 and rain_particles.emitting == false:
		start_rain()
	var minutes = time_left / 60
	var seconds = time_left % 60 # Modulo
	

	label.text = "%02d:%02d" % [minutes, seconds]

func _on_timer_timeout() -> void:
	var win_screen = get_tree().root.find_child("WinScreen", true, false)
	
	if win_screen != null:
		win_screen.show_win()

func start_rain():
	rain_particles.emitting = true
