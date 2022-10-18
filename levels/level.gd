extends Node2D

export var stage_time_in_seconds = 120

onready var stage_timer  = $StageTimer
onready var win_layer  = $Win
onready var game_over_layer  = $GameOver

func _ready():
  stage_timer.wait_time = stage_time_in_seconds
  stage_timer.start()
  var _x = GlobalSignal.connect("ritual_destroyed", self, "_on_gameover")

func _on_StageTimer_timeout():
  if(game_over_layer.visible == false):
    win_layer.visible = true

func _on_gameover():
  if(win_layer.visible == false):
    game_over_layer.visible = true
