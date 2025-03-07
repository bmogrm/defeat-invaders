extends CharacterBody2D

var speed = 400.0

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(Vector2.DOWN * speed * delta)
	if collision:
		var collider = collision.get_collider()
		if collider.has_method("take_damage"):
			collider.take_damage()
			queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
