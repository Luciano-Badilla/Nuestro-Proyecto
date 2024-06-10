extends Node2D

@export_category("Empty Dialgoues")
@export var emptyBoxDialogues: Array[String]
@export var shelfDialogues: Array[String]
@export var clockDialogues: Array[String]
@export var bedDialogues: Array[String]
@export var recordPlayerDialogues: Array[String]
@export var dresserDialogues: Array[String]
@onready var box_2 = %box2
@onready var shelf = %shelf
@onready var record_player = %recordPlayer
@onready var bed = %bed
@onready var clock = %clock
@onready var dresser = %dresser


##Dialogos sobre objetos vacios

func _empty_box_dialogues():
	var UI = %ui
	UI._dialogue(emptyBoxDialogues.pick_random())
	
func _shelf_dialogues():
	var UI = %ui
	UI._dialogue(shelfDialogues.pick_random())

func _record_player_dialogues():
	var UI = %ui
	UI._dialogue(recordPlayerDialogues.pick_random())

func _bed_dialogues():
	var UI = %ui
	UI._dialogue(bedDialogues.pick_random())

func _clock_dialogues():
	var UI = %ui
	UI._dialogue(clockDialogues.pick_random())

func _dresser_dialogues():
	var UI = %ui
	UI._dialogue(dresserDialogues.pick_random())

##Funcion multiuso para todas las cajas vacias.

func interaction_empty_box(viewport, event, shape_idx):
	var interactableArea = %player.interactableArea
	if event is InputEventScreenTouch and event.pressed and interactableArea:
		_empty_box_dialogues()

##Señales de interaccion

func _on_area_shelf_input_event(viewport, event, shape_idx):
	var interactableArea = get_tree().get_nodes_in_group("player")[0].interactableArea
	if event is InputEventScreenTouch and event.pressed and interactableArea and shelf.visible:
		_shelf_dialogues()

func _on_area_record_player_input_event(viewport, event, shape_idx):
	var interactableArea = get_tree().get_nodes_in_group("player")[0].interactableArea
	if event is InputEventScreenTouch and event.pressed and interactableArea and record_player.visible:
		_record_player_dialogues()

func _on_area_bed_input_event(viewport, event, shape_idx):
	var interactableArea = get_tree().get_nodes_in_group("player")[0].interactableArea
	if event is InputEventScreenTouch and event.pressed and interactableArea and bed.visible:
		_bed_dialogues()

func _on_area_clock_input_event(viewport, event, shape_idx):
	var interactableArea = get_tree().get_nodes_in_group("player")[0].interactableArea
	if event is InputEventScreenTouch and event.pressed and interactableArea and clock.visible:
		_clock_dialogues()


func _on_area_dresser_input_event(viewport, event, shape_idx):
	var interactableArea = get_tree().get_nodes_in_group("player")[0].interactableArea
	if event is InputEventScreenTouch and event.pressed and interactableArea and dresser.visible:
		_dresser_dialogues()
