extends KinematicBody2D

export var speed = 100

func _ready():
	pass # Replace with function body.


func _process(delta):
	if Input.is_action_pressed("right"):
		move_and_slide(Vector2(1,0) * speed) 
	if Input.is_action_pressed("left"):
		move_and_slide(Vector2(-1,0) * speed) 
	if Input.is_action_pressed("down"):
		move_and_slide(Vector2(0,1)*speed) 
	if Input.is_action_pressed("up"):
		move_and_slide(Vector2(0,-1)*speed) 
