extends Node2D

const ROW_STEP = 30.0
const SPEED_BOOST = 10.0
const GAME_OVER_Y = 550
const GAME_OVER_SCENE = preload("res://ui/game_over/game_over.tscn")
const ENEMY_SCENES = [
	preload("res://elements/enemy/enemy.tscn"),
	preload("res://elements/enemy/enemy_type_1.tscn"),
	preload("res://elements/enemy/enemy_type_2.tscn")
]

@onready var block_timer = $BlockTimer
@onready var shot_timer = $ShotTimer

var direction := Vector2.RIGHT
var speed := 80.0

func _ready():
	Events.enemy_died.connect(_check_enemies_left)  # Подписываемся на сигнал
	spawn_enemies(Globals.game_level)
	print(global_position)

func _process(delta: float) -> void:
	global_position += direction * speed * delta
	
func spawn_enemies(level: int):
	var columns = 2 + level
	var rows = 1 + (level / 2)
	
	if columns > 5:
		columns = 5
	if rows > 4:
		rows = 4
	
	var start_x = columns * 50 / 2
	var start_y = 50
	
	for row in range(rows):
		for col in range(columns):
			var enemy_scene = ENEMY_SCENES.pick_random()
			var enemy = enemy_scene.instantiate()
			enemy.global_position = Vector2(start_x + col * 60, start_y + row * 50)
			add_child(enemy)
		
func change_direction():
	if block_timer.time_left > 0:
		return
	direction = Vector2.LEFT if direction == Vector2.RIGHT else Vector2.RIGHT
	global_position.y += ROW_STEP
	speed += SPEED_BOOST
	block_timer.start()
	if global_position.y >= GAME_OVER_Y:
		add_child(GAME_OVER_SCENE.instantiate())
		get_tree().paused = true

func _on_shot_timer_timeout() -> void:
	var enemies = get_tree().get_nodes_in_group("enemy")
	if enemies.size() > 0:
		enemies.pick_random().shot()
		
func _check_enemies_left():
	if get_tree().get_nodes_in_group("enemy").size() == 1:
		_on_all_enemies_cleared()
		
func _on_all_enemies_cleared():
	Globals.game_level += 1
	Events.level_changed.emit(Globals.game_level)
	speed = 80
	if Globals.lives < 3:
		Globals.change_lives(1)
	global_position = Vector2(-31.0, 51)
	spawn_enemies(Globals.game_level)
