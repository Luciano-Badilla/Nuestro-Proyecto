extends Node2D

var id
var active = false

func _ready():
	pass

func _process(delta):
	if active:
		get_child(0).play("pressed")
	else:
		get_child(0).play("default")

func _interact():
	get_parent().get_parent().get_parent().get_node("pushBook").play()
	if active:
		active = false
	else:
		active = true
		
func _get_id():
	return id
	
func _is_active():
	return active
		
func _on_touch_screen_button_released():
	_interact()
