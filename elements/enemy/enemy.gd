extends CharacterBody2D

const ROCKET_SCENE = preload("res://elements/rocket/enemy_rocket.tscn")

@onready var raycast_left := $RayCastLeft
@onready var raycast_right := $RayCastRight
@onready var enemy_shot_sound = $AudioStreamPlayer2D

func _physics_process(delta: float) -> void:
	if raycast_left.is_colliding() or raycast_right.is_colliding():
		get_tree().call_group("enemy_group", "change_direction")

func destroy():
	Globals.change_points(1)
	Events.enemy_died.emit()
	queue_free()

func shot():
	var rocket = ROCKET_SCENE.instantiate()
	rocket.global_position += global_position + Vector2(0, 10.0)
	enemy_shot_sound.play()
	get_tree().current_scene.add_child(rocket)
