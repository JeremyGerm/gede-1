extends Node

var score = 0

@onready var score_label: Label = $ScoreLabel

func add_point():
	score += 1
	score_label.text = "You collected " + str(score) + " coins"
	win()

func win():
	if score >= 3:
		get_tree().change_scene_to_file("res://scenes/win_screen.tscn")
