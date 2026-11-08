extends Control

var waiting_for_input = false
var game_level = preload("res://Node.tscn")

@onready var start_button: TextureButton = $TextureButton
@onready var info_screen: ColorRect = $InfoScreen

func _ready():
	start_button.visible = true
	info_screen.visible = false

func _on_texture_button_pressed():
	start_button.visible = false
	
	info_screen.visible = true
	
	waiting_for_input = true

func _input(event):
	
	if waiting_for_input == true:
		if event is InputEventKey and event.pressed:
			start_game()

func start_game():
	get_tree().change_scene_to_packed(game_level)
