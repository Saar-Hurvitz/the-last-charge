extends Area2D

# --- Configuration Variables ---
var speed = 700
# Direction defaults to 1 (Right). It will be changed by the Player script when shooting.
var direction = Vector2.RIGHT

# --- Node References ---
@onready var sprite_2d = $Sprite2D

func _ready():
	# Called when the node enters the scene tree for the first time.
	# We check the direction to flip the sprite correctly.
	look_at(position + direction)

func _physics_process(delta):
	# Update the position every frame.
	# We move along the X axis based on speed and direction.
	# delta ensures smooth movement regardless of frame rate.
	position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	# Signal listener: Called when the bullet leaves the screen.
	# We delete the object to save memory.
	queue_free()
		
func _on_body_entered(body: Node2D) -> void:
	# Call the function on the enemy to reduce their health by 20.
	if body.is_in_group("enemy"):
			body.take_damage(20)
			
			# Destroy the bullet immediately after hitting a valid target.
			queue_free()
