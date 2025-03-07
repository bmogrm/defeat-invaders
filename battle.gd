extends Node2D

const GAME_OVER_SCENE = preload("res://ui/game_over/game_over.tscn")

var f_paused = 0

@onready var music = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music.play()
	Events.lives_changed.connect(func(lives): check_game_over())
	Events.enemy_died.connect(check_game_over)
	
func _unhandled_input(event):	
	if event.is_action_pressed("ui_end"):
		f_paused = !f_paused  # Переключаем состояние (0 -> 1, 1 -> 0)
		get_tree().paused = f_paused  # Устанавливаем или убираем паузу

func check_game_over():
	var enemies = get_tree().get_nodes_in_group("enemy")
	if Globals.lives <= 0:
		print(Globals.game_level)
		music.stop()
		var game_over_instance = GAME_OVER_SCENE.instantiate()
		get_tree().current_scene.add_child(game_over_instance)
		game_over_instance.update_game_over_text()
		get_tree().paused = true
