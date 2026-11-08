extends Node2D

@export var enemy_prefab : PackedScene
@export var enemy_prefab2 : PackedScene
@export var target : Node2D
@export var target2 : Node2D
@onready var watch: Timer = $"../CanvasLayer/Label/Timer"
@onready var timer: Timer = $Timer
var release_big_robot = false
var release_enemies = false

func _process(delta: float) -> void:
	var sec = ceil(watch.time_left)
	if sec <= 480.0 :
		release_enemies = true
	if sec <= 440 :
		release_big_robot = true
	if sec <= 300:
		if timer.wait_time != 5.6:
			timer.wait_time = 5.6

func _on_timer_timeout() -> void:
	if release_enemies == true:
		
		var enemy
		var booli1 = randf() < 0.5
		var booli2 = randf() < 0.5
		
		if booli1 == true and release_big_robot == true:
			enemy = enemy_prefab2.instantiate()
		else:
			enemy = enemy_prefab.instantiate()
		
		if booli2 == true:
			enemy.player = target
		else:
			enemy.player = target2
		
		add_child(enemy)
