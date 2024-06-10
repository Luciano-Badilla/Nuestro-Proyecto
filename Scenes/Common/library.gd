extends Node2D

var activeBooks = [[],[],[]]
var open = false
var pickedKey = false
var safeBoxOpen = false

@onready var interaction_particle = $interaction_particle
@onready var sprite = $sprite
@onready var player = %player
@onready var UI = %ui


func _ready():
	pass

#controla la animacion de la safeBox
func _process(delta):
	if safeBoxOpen:
		sprite.play("open")

##al interactuar abre la UI del la libreria
func _on_library_area_input_event(viewport, event, shape_idx):
	var interactableArea = player.interactableArea
	if event is InputEventScreenTouch and event.pressed and interactableArea and !open and interaction_particle.visible:
		UI._library(activeBooks)
		open = true

#Controlan ciando se puede interactuar
func _on_library_area_area_entered(area):
	if area.is_in_group("player_interaction"):
		interaction_particle.visible = true


func _on_library_area_area_exited(area):
	if area.is_in_group("player_interaction"):
		interaction_particle.visible = false
