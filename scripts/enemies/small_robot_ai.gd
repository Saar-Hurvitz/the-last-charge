extends CharacterBody2D

const SPEED = 100.0
var player : Node2D
var max_health = 100
var current_health = 100
@onready var health_bar = $ProgressBar
@onready var sprite_2d = $Sprite2D

func _ready():
	health_bar.max_value = max_health
	health_bar.value = current_health

func _physics_process(delta: float) -> void:
	#where is the player
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * SPEED
	move_and_slide()

func take_damage(amount):
	current_health -= amount
	health_bar.value = current_health
	if current_health <= 0:
		die()
		
	sprite_2d.modulate = Color(1.0, 0.125, 0.086, 1.0)
	await get_tree().create_timer(0.1).timeout
	sprite_2d.modulate = Color(1, 1, 1)
		
func die():
	queue_free()
