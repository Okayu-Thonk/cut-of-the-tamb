extends Node2D
class_name Level

# warning-ignore-all:return_value_discarded

export var stage_time_in_seconds = 120

onready var ysort: YSort = $YSort
onready var north: Node2D = $North
onready var west: Node2D = $West
onready var east: Node2D = $East
onready var south: Node2D = $South
onready var win_layer: CanvasLayer = $Win
onready var game_over_layer: CanvasLayer = $GameOver
onready var wave_timer: Timer = $WaveTimer
onready var stage_timer: Timer = $StageTimer
onready var spawn_timer: Timer = $SpawnTimer
onready var wave_duration_timer: Timer = $WaveDuration
onready var warning_top: TextureRect = $Warning/Control/WarningTop
onready var warning_left: TextureRect = $Warning/Control/WarningLeft
onready var warning_right: TextureRect = $Warning/Control/WarningRight
onready var warning_bottom: TextureRect = $Warning/Control/WarningBottom

var spawn_locations: Array
var spawn_location: Node2D

var enemies: Array = [
	preload("res://entities/enemies/heretic_ranged/heretic_ranged.tscn"),
	preload("res://entities/enemies/heretic_ranged/heretic_ranged.tscn")
]


func _ready() -> void:
	stage_timer.wait_time = stage_time_in_seconds
	stage_timer.start()
	GlobalSignal.connect("ritual_destroyed", self, "_on_gameover")
	GlobalSignal.connect("player_died", self, "_on_gameover")
	spawn_locations = [north, west, east, south]
	spawn_location = spawn_locations[0]


func _on_StageTimer_timeout() -> void:
	if game_over_layer.visible == false:
		win_layer.visible = true


func _on_gameover() -> void:
	if win_layer.visible == false:
		game_over_layer.visible = true


func _on_SpawnTimer_timeout() -> void:
	# TOOD: Randomly pick enemy
	var enemy = enemies[0].instance()
	enemy.global_position = spawn_location.global_position
	$YSort.add_child(enemy)


func _on_WaveTimer_timeout() -> void:
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


func _on_WaveDuration_timeout() -> void:
	wave_timer.start()
	spawn_timer.stop()
