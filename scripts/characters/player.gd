extends CharacterBody2D

const SPEED = 360.0

var bullet_scene = preload("res://scenes/projectiles/light_shot.tscn") 
var heavy_bullet_scene = preload("res://scenes/projectiles/heavy_shot.tscn")

var max_health = 400
var current_health = 400
var shoot_cost = 1
var shoot2_cost = 10
var damage_taken = 10
var fire_rate = 0.16
var fire_rate2 = 0.25
var is_charging = false
@onready var health_bar = $CanvasLayer/ProgressBar
@onready var sprite_2d = $Sprite2D
@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound

var can_shoot = true
#-------------------------------------
func _ready():
    health_bar.max_value = max_health
    health_bar.value = current_health
    
func _physics_process(delta: float) -> void:
    var input_vector = Input.get_vector("Left", "Right", "Up", "Down")
    
    if input_vector:
        velocity = input_vector * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, 30)
        velocity.y = move_toward(velocity.y, 0, 30)

    move_and_slide()

    var screen_size = get_viewport_rect().size
    
    var top_limit = screen_size.y / 3.0 
    
    global_position.y = clamp(global_position.y, top_limit, screen_size.y)
    global_position.x = clamp(global_position.x, 0, screen_size.x)
    if velocity.x != 0:
        sprite_2d.flip_h = velocity.x < 0

    
    if is_charging == true:
        sprite_2d.animation = "charging"
    
    if Input.is_action_pressed("Shoot"):
        sprite_2d.animation = "shooting"
        if can_shoot:
            shoot_sound.pitch_scale = randf_range(0.9, 1.1) #changes the tone a bit
            shoot_sound.play()
            shoot()
           
    elif Input.is_action_pressed("Shoot2"):
        sprite_2d.animation = "shooting"
        if can_shoot:
            shoot_sound.pitch_scale = randf_range(0.9, 1.1) #changes the tone a bit
            shoot_sound.play()
            shoot2()
         
    elif velocity.length() > 0: 
        sprite_2d.animation = "running"
        
    else:
        sprite_2d.animation = "default"  
#----------------------------------------------        

func shoot():
    if current_health <= shoot_cost:
        return
    take_damage(shoot_cost)
    
    can_shoot = false 
    
    var bullet = bullet_scene.instantiate()
    bullet.global_position = global_position
    var mouse_pos = get_global_mouse_position()
    var direction_vector = (mouse_pos - global_position).normalized()
    bullet.direction = direction_vector
    get_parent().add_child(bullet)
    
    await get_tree().create_timer(fire_rate).timeout
    
    can_shoot = true
    
func shoot2():
    if current_health <= shoot2_cost:
        return 
        
    take_damage(shoot2_cost)
    can_shoot = false 
    
    var bullet = heavy_bullet_scene.instantiate()
    
    bullet.global_position = global_position
    var mouse_pos = get_global_mouse_position()
    var direction_vector = (mouse_pos - global_position).normalized()
    bullet.direction = direction_vector
    
    get_parent().add_child(bullet)
    
    await get_tree().create_timer(fire_rate2).timeout 
    can_shoot = true
    
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
    
    visible = false

func heal(amount):
    current_health += amount
    sprite_2d.modulate = Color(0.198, 0.582, 0.802, 1.0)
    await get_tree().create_timer(0.1).timeout
    sprite_2d.modulate = Color(1, 1, 1)
    if current_health > max_health:
        current_health = max_health
        
    health_bar.value = current_health

var damage_tick_counter = 0

func _on_timer_timeout():
    take_damage(1)
    var bodies = $Hurtbox.get_overlapping_bodies()
    take_damage(1)
    for body in bodies:
        if body.is_in_group("enemy"):
            
            damage_tick_counter += 1
            
            if damage_tick_counter >= 3:
                sprite_2d.modulate = Color(1.0, 0.213, 0.16, 1.0)
                await get_tree().create_timer(0.05).timeout 
                sprite_2d.modulate = Color(1, 1, 1)
                take_damage(damage_taken)
                damage_tick_counter = 0
                
            return
    
    damage_tick_counter = 0

func _on_hurtbox_body_entered(body):
    if body.is_in_group("enemy"):
        take_damage(damage_taken)
