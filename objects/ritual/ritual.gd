extends Node2D


export var health: int = 10000 setget set_health

onready var health_bar = $CanvasLayer/Control/VBoxContainer/ProgressBar

func _ready():
  health_bar.value = health

func set_health(new_health: int) -> void:
  health = new_health
  health_bar.value = health

