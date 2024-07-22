extends CharacterBody2D

var can_laser: bool = true
var can_grenade: bool = true
signal  laser_input_pressed(pos, direction)
signal  grenade_input_pressed(pos, direction)

@export var max_speed: int = 500
var speed: int = max_speed

func hit():
	Globals.health -= 10

func _process(_delta):
	var direction = Input.get_vector("left","right","up","down")
	#position += direction * 500 * delta
	velocity = direction * speed
	move_and_slide()
	Globals.player_pos = global_position
	#rotate
	look_at(get_global_mouse_position())
	var player_direction = (get_global_mouse_position() - position).normalized()
	
	#laser shooting input
	if Input.is_action_pressed("primary action") and can_laser and Globals.laser_amount > 0:
		Globals.laser_amount -= 1
		$CPUParticles2D.emitting = true
		
		#randomly selected a marker 2d for laser start
		var laser_markers = $LaserStartPositions.get_children()
		var selected_laser = laser_markers[randi() % laser_markers.size()]
		print(selected_laser)
		can_laser = false
		$LaserReloadTimer.start()
		
		#emit the position we selected
		laser_input_pressed.emit(selected_laser.global_position,player_direction)
		
	if Input.is_action_just_pressed("shoot grenade") and can_grenade and Globals.grenade_amount > 0:
		Globals.grenade_amount -= 1
		can_grenade = false
		$GrenadeReloadTimer.start()
		var pos = $LaserStartPositions.get_children()[0].global_position
		grenade_input_pressed.emit(pos,player_direction)

func _on_timer_timeout():
	can_laser = true 


func _on_grenade_reload_timer_timeout():
	can_grenade = true

