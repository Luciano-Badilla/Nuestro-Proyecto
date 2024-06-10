extends CanvasLayer

##UI nodes
@export_category("UIs Scenes")
@export var letterUI: PackedScene
@export var dialogueUI: PackedScene
@export var dialogueTouchUI: PackedScene
@export var objectUI: PackedScene
@export var libraryUI: PackedScene
@export var playerInventoryUI: PackedScene
@export var flashbacks: Array[PackedScene]
@export var inspectionUI: PackedScene


@export_category("UIs Textures")
@export var inspectionTextures: Array[CompressedTexture2D]
@export var letter0: CompressedTexture2D
@export var letter1: CompressedTexture2D
@export var fragPhoto1: CompressedTexture2D

#Tree nodes
@onready var ui_instances = $UIInstances
@onready var dialogue_instances = $dialogueInstances

##Abrir UI de la libreria
func _library(ids):
	var newLibrary = libraryUI.instantiate()
	newLibrary.activeBooks = ids
	ui_instances.add_child(newLibrary)

##Abrir UI de las cartas o notas
func _letter(texture, keyText, parent):
	if parent == "UI":
		parent = ui_instances
	elif parent == "inspectionZone":
		parent = get_tree().get_nodes_in_group("inspectionZone")[0]
	var newLetter = letterUI.instantiate()
	newLetter.get_child(1).texture = texture
	newLetter.get_child(3).text = tr(keyText)
	parent.add_child(newLetter)

func inspectObject(id, letterText, subText: Array):
	var parent = get_tree().get_first_node_in_group("inspectionZone")
	for child in parent.get_children():
		parent.remove_child(child)
		
	var newObject = inspectionUI.instantiate()
	newObject.get_child(1).texture = inspectionTextures[id]
	newObject.get_child(3).text = tr(letterText)
	newObject.id = id
	newObject.texts = subText
	parent.add_child(newObject)

func _flashback(nFlashback):
	var parent = ui_instances
	var newflashback = flashbacks[nFlashback].instantiate()
	parent.add_child(newflashback)

##Abrir UI de los dialogos
func _dialogue(keyText):
	var newDialogue = dialogueUI.instantiate()
	newDialogue.get_child(1).text = tr(keyText)
	dialogue_instances.add_child(newDialogue)

##Abrir UI de los dialogos touch
func _dialogue_touch(texts: Array, parent):
	if parent == "dialogue_instances":
		parent = dialogue_instances
	elif parent == "inspectionZone":
		parent = get_tree().get_nodes_in_group("inspectionZone")[0]
	var textCount = texts.size() - 1
	var newDialogue = dialogueTouchUI.instantiate()
	newDialogue.textCount = textCount
	newDialogue.texts = texts
	parent.add_child(newDialogue)

##Abrir UI del inventario de las cajas/objetos
func _container_ui(objects:Array, uiTexture, uiTextureRect):
	var newObjectUI = objectUI.instantiate()
	newObjectUI._add_items(objects, "container")
	newObjectUI.get_child(1).texture = uiTexture
	newObjectUI.get_child(1).region_rect = uiTextureRect
	ui_instances.add_child(newObjectUI)

##Abrir UI del Inv del player
func _player_Inventory(objects:Array):
	var newPlayerInventory = playerInventoryUI.instantiate()
	newPlayerInventory._add_items(objects, "playerInventory")
	ui_instances.add_child(newPlayerInventory)

func _on_button_button_up():
	var player = get_tree().get_nodes_in_group("player")[0]
	player.sanity = 100


func _on_button_2_button_up():
	var player = get_tree().get_nodes_in_group("player")[0]
	player.sanity = 75


func _on_button_3_button_up():
	var player = get_tree().get_nodes_in_group("player")[0]
	player.sanity = 50


func _on_button_4_button_up():
	var player = get_tree().get_nodes_in_group("player")[0]
	player.sanity = 25
