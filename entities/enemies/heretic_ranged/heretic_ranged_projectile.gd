extends Area2D
class_name SingleTarget

export var speed: int = 200
export var damage: int
export var knockback_strength: float
onready var sprite: Sprite = $Sprite
onready var collision: CollisionShape2D = $CollisionShape2D
var direction = Vector2.ZERO

var ritual_coordinate: Vector2
var origin: Vector2


func _process(delta):
	global_position += speed * direction * delta


func launch():
	var angle = ((global_position - ritual_coordinate).normalized()).angle()
	sprite.rotate(angle)
