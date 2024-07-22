extends CharacterBody2D


var speed = 400
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

	if position.x > 1000:
		speed = -400
	elif position.x <= 0:
		speed = 400
	
	var direction = Vector2.RIGHT
	velocity = direction * speed
		
	move_and_slide()


func hit():
	print('damage')
