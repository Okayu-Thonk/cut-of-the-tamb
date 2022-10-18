extends Node2D

export var stage_time_in_seconds = 120

onready var stage_timer = $StageTimer
onready var win_layer = $Win
onready var game_over_layer = $GameOver
onready var spawn_timer = $SpawnTimer
onready var wave_timer = $WaveTimer
onready var wave_duration_timer = $WaveDuration
onready var north: Node2D = $North
onready var west: Node2D = $West
onready var east: Node2D = $East
onready var south: Node2D = $South

onready var warning_top: TextureRect = $Warning/Control/WarningTop
onready var warning_left: TextureRect = $Warning/Control/WarningLeft
onready var warning_right: TextureRect = $Warning/Control/WarningRight
onready var warning_bottom: TextureRect = $Warning/Control/WarningBottom

var spawn_locations = [north, west, east, south]
var spawn_location = spawn_locations[0]

var enemies = [
	preload("res://entities/enemies/heretic_ranged/heretic_ranged.tscn"),
	preload("res://entities/enemies/heretic_ranged/heretic_ranged.tscn")
]


func _ready():
	stage_timer.wait_time = stage_time_in_seconds
	stage_timer.start()
	var _x = GlobalSignal.connect("ritual_destroyed", self, "_on_gameover")
	spawn_locations = [north, west, east, south]
	spawn_location = spawn_locations[0]


func _on_StageTimer_timeout():
	if game_over_layer.visible == false:
		win_layer.visible = true


func _on_gameover():
	if win_layer.visible == false:
		game_over_layer.visible = true


func _on_SpawnTimer_timeout():
	# TOOD: Randomly pick enemy
	var enemy = enemies[0].instance()
	enemy.global_position = spawn_location.global_position
	$YSort.add_child(enemy)


func _on_WaveTimer_timeout():
	randomize()
	var random = randi() % spawn_locations.size()
	spawn_location = spawn_locations[random]
	if random == 0:
		warning_top.visible = true
		yield(get_tree().create_timer(3), "timeout")
		warning_top.visible = false
	elif random == 1:
		warning_left.visible = true
		yield(get_tree().create_timer(3), "timeout")
		warning_left.visible = false
	elif random == 2:
		warning_right.visible = true
		yield(get_tree().create_timer(3), "timeout")
		warning_right.visible = false
	else:
		warning_bottom.visible = true
		yield(get_tree().create_timer(3), "timeout")
		warning_bottom.visible = false

	spawn_timer.start()
	wave_duration_timer.start()


func _on_WaveDuration_timeout():
	wave_timer.start()
	spawn_timer.stop()
