extends Area2D

@export var heal_amount = 4
var player_inside = null

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_inside = body
		$Timer.start()

func _on_body_exited(body):
	if body == player_inside:
		player_inside = null
		$Timer.stop()

func _on_timer_timeout():
	if player_inside != null and player_inside.has_method("heal"):
		player_inside.heal(heal_amount)
