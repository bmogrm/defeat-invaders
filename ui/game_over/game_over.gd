extends CanvasLayer

@onready var score = $MarginContainer/VBoxContainer/Label2

func _ready() -> void:
	Events.level_changed.connect(update_game_over_text)
	update_game_over_text()
	
func update_game_over_text():
	score.text = "You Survived - " + str(Globals.game_level) + " lvl"

func _on_button_pressed() -> void:
	get_tree().paused = false
	_reset_game()
	_restart_scene()

func _reset_game():
	Globals.lives = 3
	Globals.points = 0
	Globals.game_level = 1

func _restart_scene():
	var current_scene = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file(current_scene)  # Загружаем заново
