extends CharacterBody2D

const SPEED = 400.0

@onready var destroy_sound = $AudioStreamPlayer2D

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(Vector2.UP * SPEED * delta)
	if collision:
		var collider = collision.get_collider()
		if collider.has_method("destroy"):
			collider.destroy()
			
		var sound_player = AudioStreamPlayer2D.new()
		sound_player.stream = destroy_sound.stream  # Копируем звук
		sound_player.global_position = global_position  # Переносим в ту же позицию
		get_parent().add_child(sound_player)  # Добавляем в родителя
		sound_player.play()
		
		queue_free()
		sound_player.finished.connect(func(): sound_player.queue_free())


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
