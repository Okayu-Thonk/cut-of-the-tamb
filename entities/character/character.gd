extends KinematicBody2D

export var acceleration = 100
export var friction = 0.7

onready var animation: AnimationPlayer = $Animation
onready var sprite: Sprite = $Sprite
onready var faith_label: Label = $CanvasLayer/Control/FaithLabel

var movement_key: Dictionary = {"up": false, "down": false, "left": false, "right": false}
var velocity: Vector2 = Vector2.ZERO
var faith: int  = 0

func _ready()->void:
  GlobalSignal.connect("faith_generated", self ,"_on_faith_generated")

func _on_faith_generated(faith_generated_count: int)->void:
  faith += faith_generated_count
  faith_label.text = "Faith: " + var2str(faith)


func _process(delta):
	move(delta)
	_sprite_handler()

func _unhandled_input(event):
	listen_to_input_direction(event)


func _sprite_handler():
	var mouse_direction: Vector2 = get_mouse_direction()
	if velocity.length() > 10:
		animation.play("move")
	else:
		animation.play("idle")
	_flip_character_sprite(mouse_direction)


func get_mouse_direction() -> Vector2:
	return (get_global_mouse_position() - global_position).normalized()


func move(delta: float) -> void:
	var input_direction: Vector2 = get_input_direction()
	velocity = move_and_slide(velocity)
	velocity += acceleration * input_direction * delta * 60
	velocity = lerp(velocity, Vector2.ZERO, friction)


func _flip_character_sprite(mouse_direction):
	if mouse_direction.x < 0 and sign(sprite.scale.x) != sign(mouse_direction.x):
		sprite.scale.x *= -1
	elif mouse_direction.x > 0 and sign(sprite.scale.x) != sign(mouse_direction.x):
		sprite.scale.x *= -1


func listen_to_input_direction(event) -> void:
	if event.is_action_pressed("up"):
		movement_key["up"] = true
	if event.is_action_pressed("down"):
		movement_key["down"] = true
	if event.is_action_pressed("left"):
		movement_key["left"] = true
	if event.is_action_pressed("right"):
		movement_key["right"] = true
	if event.is_action_released("up"):
		movement_key["up"] = false
	if event.is_action_released("down"):
		movement_key["down"] = false
	if event.is_action_released("left"):
		movement_key["left"] = false
	if event.is_action_released("right"):
		movement_key["right"] = false


func get_input_direction() -> Vector2:
	var input_direction: Vector2 = Vector2.ZERO
	input_direction.x = (int(movement_key["right"]) - int(movement_key["left"]))
	input_direction.y = (int(movement_key["down"]) - int(movement_key["up"]))
	input_direction = input_direction.normalized()
	return input_direction
