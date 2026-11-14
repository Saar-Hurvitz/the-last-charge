extends Area2D

var max_health = 400
var current_health = 400
@onready var health_bar = $CanvasLayer/ProgressBar
@onready var sprite_2d = $Sprite2D
@export var damage_amount = 5 
@export var heal_amount = 25 
@onready var timer: Timer = $"../CanvasLayer/Label/Timer"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.max_value = max_health
	health_bar.value = current_health
	$Timer.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func take_damage(amount):
	current_health -= amount
	health_bar.value = current_health
	
	if current_health <= 0:
		die()

func die():
	set_physics_process(false) 
	set_process_input(false)
	collision_layer = 0
	collision_mask = 0
	
	call_deferred("reload_level_safe")

func reload_level_safe():
	var game_over_screen = get_tree().root.find_child("GameOver", true, false)
	
	if game_over_screen != null:
		game_over_screen.show_game_over()
	
	
func heal(amount):
	current_health += amount
	if current_health > max_health:
		current_health = max_health
	health_bar.value = current_health
	
	sprite_2d.modulate = Color(0, 1, 0)
	await get_tree().create_timer(0.1).timeout
	sprite_2d.modulate = Color(1, 1, 1)
	
func _on_timer_timeout():	
	var sec = ceil(timer.time_left)
	if(sec <= 250):
		take_damage(3)
	else:
		take_damage(2)
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		if body.is_in_group("enemy"):
			take_damage(damage_amount)
			
			sprite_2d.modulate = Color(1.0, 0.194, 0.144, 0.867) 
			
		elif body.is_in_group("player"):
			heal(heal_amount)
			
	if bodies.size() > 0:
		await get_tree().create_timer(0.1).timeout
		sprite_2d.modulate = Color(1, 1, 1)

func _on_body_entered(body):
	pass

func _on_body_exited(body):
	pass
