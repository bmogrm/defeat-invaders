extends CharacterBody2D

const ROCKET_SCENE = preload("res://elements/rocket/rocket.tscn")
const SPEED = 300.0

@onready var shot_sound = $AudioStreamPlayer2D
@onready var sprite = $AnimatedSprite2D
@onready var shot_time = $Timer

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		shot()
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		_update_ship_animation(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		sprite.play("idle")
	move_and_slide()
	
func _update_ship_animation(direction: float):
	if direction < 0:
		sprite.play("left")
	elif direction > 0:
		sprite.play("right")
		
func shot():
	if shot_time.time_left > 0:
		return
	shot_sound.play()
	var rocket = ROCKET_SCENE.instantiate()
	rocket.global_position = global_position + Vector2(0, - 62)
	add_child(rocket)
	shot_time.start()
	
func take_damage():
	Globals.change_lives(-1)
