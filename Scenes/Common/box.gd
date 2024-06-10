extends StaticBody2D

@onready var interaction_particle = $interaction_particle
@onready var player = %player
@onready var UI = %ui
@onready var emptyDialogue = %interactions
@onready var box_sprite = $boxSprite
@onready var open_box = $openBox
@onready var timer = $Timer


var inventory: Array
var open = false

##Al interactuar abre la interfaz de su inventario
func _on_box_area_input_event(viewport, event, shape_idx):
	var interactableArea = player.interactableArea
	if event is InputEventScreenTouch and event.pressed and interactableArea and !open and interaction_particle.visible:
		if inventory.size() != 0:
			open_box.play()
			timer.start()
		else:
			emptyDialogue._empty_box_dialogues()
		
func _open_inv():
	UI._container_ui(inventory, box_sprite.texture, box_sprite.region_rect)
	open = true
	
##Dos funciones para controlar cuando puede interactuar
func _on_box_area_area_entered(area):
	if area.is_in_group("player_interaction"):
		interaction_particle.visible = true

func _on_box_area_area_exited(area):
	if area.is_in_group("player_interaction"):
		interaction_particle.visible = false

func _on_timer_timeout():
	_open_inv()
