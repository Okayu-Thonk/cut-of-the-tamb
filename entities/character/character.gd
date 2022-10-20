extends KinematicBody2D
class_name Character

# warning-ignore-all:return_value_discarded

export var friction: float = 0.7
export var acceleration: int = 100

onready var sprite: Sprite = $Sprite
onready var animation: AnimationPlayer = $Animation
onready var faith_label: Label = $CanvasLayer/Control/FaithLabel
onready var weapon_container: Node2D = $Weapon

var movement_key: Dictionary = {"up": false, "down": false, "left": false, "right": false}
var velocity: Vector2 = Vector2.ZERO
var faith: int = 0

var selected_weapon: int = 1


func _ready() -> void:
	GlobalSignal.connect("faith_generated", self, "_on_faith_generated")


func _process(delta: float) -> void:
	_move(delta)
	_sprite_handler()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("1"):
		selected_weapon = 1
		weapon_container.get_node("Tambourine").visible = true
		weapon_container.get_node("BuildTower").visible = false
	elif event.is_action_pressed("2"):
		selected_weapon = 2
		weapon_container.get_node("Tambourine").visible = false
		weapon_container.get_node("BuildTower").visible = true
	if event.is_action_pressed("attack"):
		if selected_weapon == 2 and faith > 150:
			faith -= 150
			weapon_container.get_node("BuildTower").light_attack(
				weapon_container.get_node("BuildTower/Sprite").global_position
			)
		elif selected_weapon == 1:
			weapon_container.get_node("Tambourine").light_attack()
	_listen_to_input_direction(event)


############
# Movement #
############


func _move(delta: float) -> void:
	var input_direction: Vector2 = _get_input_direction()
	velocity = move_and_slide(velocity)
	velocity += acceleration * input_direction * delta * 60
	velocity = lerp(velocity, Vector2.ZERO, friction)


func _get_input_direction() -> Vector2:
	var input_direction: Vector2 = Vector2.ZERO
	input_direction.x = (int(movement_key["right"]) - int(movement_key["left"]))
	input_direction.y = (int(movement_key["down"]) - int(movement_key["up"]))
	input_direction = input_direction.normalized()
	return input_direction


func _listen_to_input_direction(event) -> void:
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


##########
# Sprite #
##########


func _sprite_handler() -> void:
	var mouse_direction: Vector2 = _get_mouse_direction()
	_animation_handler()
	_flip_character_sprite(mouse_direction)


func _flip_character_sprite(mouse_direction: Vector2) -> void:
	if mouse_direction.x < 0 and sign(sprite.scale.x) != sign(mouse_direction.x):
		sprite.scale.x *= -1
		weapon_container.scale.x *= -1
	elif mouse_direction.x > 0 and sign(sprite.scale.x) != sign(mouse_direction.x):
		sprite.scale.x *= -1
		weapon_container.scale.x *= -1


func _animation_handler() -> void:
	if velocity.length() > 10:
		animation.play("move")
	else:
		animation.play("idle")


#########
# Utils #
#########


func get_class() -> String:
	return "Character"


func _get_mouse_direction() -> Vector2:
	return (get_global_mouse_position() - global_position).normalized()


func _on_faith_generated(faith_generated_count: int) -> void:
	faith += faith_generated_count
	if faith < 150:
		weapon_container.get_node("BuildTower").place_color = Color.red
	else:
		weapon_container.get_node("BuildTower").place_color = Color.green
	faith_label.text = "Faith: " + var2str(faith)
