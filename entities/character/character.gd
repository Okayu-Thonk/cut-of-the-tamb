extends KinematicBody2D
class_name Character

# warning-ignore-all:return_value_discarded

export var friction: float = 0.7
export var acceleration: int = 100
export var hp: int = 10 setget set_hp
export var max_hp: int = 10

onready var sprite: Sprite = $Sprite
onready var animation: AnimationPlayer = $Animation
onready var faith_label: Label = $CanvasLayer/Control/Container/FaithLabel
onready var hp_bar: ProgressBar = $CanvasLayer/Control/Container/HpBar
onready var hp_label: Label = $CanvasLayer/Control/Container/HpLabel
onready var weapon_container: Node2D = $Weapon
onready var tambourine_outline: TextureRect = get_node("%OutlineT")
onready var hammer_outline: TextureRect = get_node("%OutlineH")

var movement_key: Dictionary = {"up": false, "down": false, "left": false, "right": false}
var velocity: Vector2 = Vector2.ZERO
var faith: int = 0

var selected_weapon: int = 1


func _ready() -> void:
	_init_ui()
	GlobalSignal.connect("faith_generated", self, "_on_faith_generated")


func _process(delta: float) -> void:
	_move(delta)
	_sprite_handler()


func _unhandled_input(event: InputEvent) -> void:
	_listen_to_weapon_change(event)
	_listen_to_attack(event)
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


func _listen_to_input_direction(event: InputEvent) -> void:
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
# Combat #
##########


func set_hp(new_hp: int) -> void:
	hp = new_hp
	if hp <= 0:
		visible = false
		GlobalSignal.emit_signal("player_died")
	_init_ui()


func _on_Hurtbox_area_entered(area: Area2D) -> void:
	if area.get_class() == "Projectile":
		set_hp(hp - area.damage)

# Not the best way of doing it but since we have a finite amount of weapon
# It's acceptable
func _listen_to_weapon_change(event: InputEvent):
	if event.is_action_pressed("1"):
		selected_weapon = 1
		weapon_container.get_node("Tambourine").visible = true
		weapon_container.get_node("BuildTower").visible = false
		tambourine_outline.visible = true
		hammer_outline.visible = false
	elif event.is_action_pressed("2"):
		selected_weapon = 2
		weapon_container.get_node("Tambourine").visible = false
		weapon_container.get_node("BuildTower").visible = true
		tambourine_outline.visible = false
		hammer_outline.visible = true


func _listen_to_attack(event: InputEvent):
	if event.is_action_pressed("attack"):
		if selected_weapon == 2 and faith >= 150:
			faith -= 150
			weapon_container.get_node("BuildTower").light_attack(
				weapon_container.get_node("BuildTower/Sprite").global_position
			)
		elif selected_weapon == 2 and faith < 150:
			Ui.send_notif("Not Enough Faith bosq", global_position)
		elif selected_weapon == 1:
			weapon_container.get_node("Tambourine").light_attack()


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


func _init_ui() -> void:
	faith_label.text = "Faith: " + var2str(faith)
	hp_label.text = "HP: " + var2str(hp) + "/" + var2str(max_hp)
	hp_bar.max_value = max_hp
	hp_bar.value = hp


func _get_mouse_direction() -> Vector2:
	return (get_global_mouse_position() - global_position).normalized()


func _on_faith_generated(faith_generated_count: int) -> void:
	faith += faith_generated_count
	if faith < 150:
		weapon_container.get_node("BuildTower").place_color = Color.red
	else:
		weapon_container.get_node("BuildTower").place_color = Color.green
	faith_label.text = "Faith: " + var2str(faith)
