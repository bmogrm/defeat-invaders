extends Node

var points = 0
var lives = 3
var game_level = 1

func change_points(diff: int):
	points += diff
	Events.points_changed.emit(points)
	
func change_lives(diff: int):
	lives += diff
	Events.lives_changed.emit(lives)
