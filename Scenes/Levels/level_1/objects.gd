extends Node2D

@export_category("Objects Scenes")
@export var box: PackedScene
@export var library: PackedScene
@onready var boxes = $Boxes


func _ready():
	for i in range(boxes.get_child_count()):
		add_items_to_box(i)

##Funcion para instanciar nuevos objetos
func _instantiateObject(newObject, positionObject, inventory, z):
	var object = newObject.instantiate()
	object.global_position = positionObject
	if inventory != null:
		object.inventory = inventory
	if z != null:
		object.z_index = z
	add_child(object)

func add_items_to_inv_box(i,items:Array[int]):
	boxes.get_child(i).inventory = items
	
func add_items_to_box(i):
	if i == 0:
		add_items_to_inv_box(i,[3,1])
	elif i == 1:
		add_items_to_inv_box(i,[0])
	elif i == 2:
		add_items_to_inv_box(i,[4])
