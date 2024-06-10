extends CharacterBody2D

var maxSpeed = 100
var acceleration = 750
var friction = 1200
var axis = Vector2.ZERO

var current_world_id = 1
var current_zone_id = 1

var interactableArea = false

var waiting = false
var waiting_down = false
var waiting_up = false
var deltaGlobal

var inventory = []
var inventoryOpen = false

var sanity = 100

func _process(delta):
	if sanity > 25:
		sanity -= 0.001
	deltaGlobal = delta
	_animation(_get_state())
	_flip_sprite()
	update_camera_limits(current_world_id,current_zone_id)
	
	if get_joystick_coords() != Vector2.ZERO:
		_no_afk()
	
	_update_sanity_screen(sanity)
	
func _physics_process(delta):
	move(delta)
	
func _afk():
	waiting = true
	$Sprite2D.play("waiting_down")
	waiting_down = true
	$timers/afkTImer.stop()
	
func _no_afk():
	$timers/afkTImer.start()
	if $Sprite2D.animation == "waiting":
		$Sprite2D.play("waiting_up")
		waiting_up = true
	
func _flip_sprite():
	if waiting == false:
		if get_input_axis().x > 0:
			$Sprite2D.flip_h = false
		elif get_input_axis().x < 0:
			$Sprite2D.flip_h = true
		
func _animation(animation):
	$Sprite2D.play(animation)
		
func _get_state():
	if velocity == Vector2.ZERO:
		if waiting and waiting_down and !waiting_up:
			return "waiting_down"
		elif waiting and !waiting_down and waiting_up:
			return "waiting_up"
		elif waiting and !waiting_down and !waiting_up:
			return "waiting"
		return "idle"
	elif velocity != Vector2.ZERO:
		return "walking"

func get_input_axis():
	var axis_local = Vector2(Input.get_axis("move_left","move_right"),Input.get_axis("move_up","move_down"))
	return axis_local.normalized()
	
func move(delta):
	if waiting == false:
		axis = get_input_axis()
		
		if axis == Vector2.ZERO:
			apply_friction(friction * delta)
		else:
			apply_movement(axis * acceleration * delta)
		
		
		move_and_slide()
	
func apply_friction(amount):
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	
	else:
		velocity = Vector2.ZERO
		
func apply_movement(accel):
	velocity += accel
	velocity = velocity.limit_length(maxSpeed)
	
func get_joystick_coords():
	return %VirtualJoystick.get_joystick_coords()

func update_camera_limits(idWorld, idZone):
	if idWorld == 1:
		if idZone == 1:
			$Camera2D.limit_top = -10
			$Camera2D.limit_left = -183
			$Camera2D.limit_bottom = 860
			$Camera2D.limit_right = 1870
		elif idZone == 2:
			$Camera2D.limit_top = 0
			$Camera2D.limit_left = 980
			$Camera2D.limit_bottom = 539
			$Camera2D.limit_right = 2470

func _on_interactable_area_area_entered(area):
	if area.is_in_group("interactable_area"):
		interactableArea = true


func _on_interactable_area_area_exited(area):
	if area.is_in_group("interactable_area"):
		interactableArea = false

func _on_afk_t_imer_timeout():
	_afk()


func _on_sprite_2d_animation_finished():
	if $Sprite2D.animation == "waiting_down":
		$Sprite2D.play("waiting")
		waiting_down = false
	if $Sprite2D.animation == "waiting_up":
		waiting = false
		waiting_up = false

func _add_item_to_inventory(id):
	inventory.append(id)

func _remove_item_to_inventory(id):
	inventory.erase(id)


func _update_sanity_screen(value):
	var x = sanity/10
	$SanityBlaackground.scale = Vector2(x,x)
	if value > 75:
		$Sprite2D.speed_scale = 1
	elif value > 50 and value <= 75:
		$Sprite2D.speed_scale = 1.50
	elif value > 25 and value <= 50:
		$Sprite2D.speed_scale = 1.75
	elif value >= 0 and value <= 25:
		$Sprite2D.speed_scale = 2.15
	
	if value == 80:
		$SanityBlaackground.visible = false
	else:
		$SanityBlaackground.visible = true
	
