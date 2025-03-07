extends CanvasLayer

@onready var points_label = $MarginContainer/VBoxContainer/HBoxContainer/Label
@onready var level_counter = $MarginContainer/VBoxContainer/LevelCounter
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.points_changed.connect(update_points)
	Events.level_changed.connect(update_level_count)
	
	Events.level_changed.emit(Globals.game_level)
	
func update_points(points: int):
	points_label.text = str(points)
	
func update_level_count(game_level: int):
	level_counter.text = "LEVEL: " + str(game_level)
