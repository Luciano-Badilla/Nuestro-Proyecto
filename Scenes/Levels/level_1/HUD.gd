extends Node2D

@export var vitalSings: PackedScene

#Tree nodes
@onready var touch_position = $InvPlayerButton/touchPosition
@onready var player = %player
@onready var ui = %ui
@onready var heart = $heart
@onready var face_sprite = $face/faceSprite
@onready var sanity_bar = $sanity/SanityBar
@onready var heart_sprite = $heart/heartSprite
@onready var openButtonInv = $InvPlayerButton/touchPosition
@onready var ui_instances = %UIInstances

#Controls nodes
var isTouching
var UIOpen = false

func _input(event):
	#Detectar si se esta tocando la pantalla
	if event is InputEventScreenTouch:
		if event.pressed:
			isTouching = true
		else:
			isTouching = false

func _process(delta):
	%fps.text = "fps: " + str(Engine.get_frames_per_second())
	#Asignar Cordura del player a la Barra del UI
	sanity_bar.value = player.sanity
	update_face_animation(player.sanity)
	
	#Volver el boton del inventario a su posicion original
	if !isTouching and openButtonInv.position.x < 1100:
		openButtonInv.position.x = round(openButtonInv.position.x) + 3
	if !isTouching and openButtonInv.position.x > 1100:
		openButtonInv.position.x = round(openButtonInv.position.x) - 1
	
	#Ocular el HUD cuando una UI este abierta
	if ui_instances.get_child_count() != 0:
		visible = false
	else:
		visible = true

##Actualiza las animaciones de la cara del HUD
func update_face_animation(value):
	if value > 75:
		face_sprite.play("phase1")
	elif value > 50 and value <= 75:
		face_sprite.play("phase2")
	elif value > 25 and value <= 50:
		face_sprite.play("phase3")
	elif value >= 0 and value <= 25:
		face_sprite.play("phase4")

func resetVitalSings():
	var vitals = vitalSings.instantiate()
	vitals.position = Vector2(334.46,62.375)
	vitals.scale = Vector2(0.5,0.5)
	heart.add_child(vitals)

##Señales-------------

##Posiciona el boton del inv en la posicion del touch
func _on_input_zone_input_event(viewport, event, shape_idx):
	if event is InputEventScreenDrag:
		touch_position.position.x = event.position.x

##Detecta cuando el boton entra en la zona trigger y abre el inv
func _on_trigger_zone_area_entered(area):
	if area.is_in_group("touchPosition") and !player.inventoryOpen:
		player.inventoryOpen = true
		ui._player_Inventory(player.inventory)
		
func _on_sanity_bar_value_changed(value):
	update_face_animation(value)

##Al cambiar el faceSprite de frame elimina el exceso de vitals, y manda un pulso
func _on_face_sprite_frame_changed():
	var face_sprite = $face/faceSprite
	if get_tree().get_nodes_in_group("heartBeatMonitor").size() > 2:
		get_tree().get_nodes_in_group("heartBeatMonitor")[2].queue_free()
	if face_sprite.frame == 2:
		for i in range(get_tree().get_nodes_in_group("heartBeatMonitor").size()):
			var vitals = get_tree().get_nodes_in_group("heartBeatMonitor")[i]
			vitals.pulse = true
		if face_sprite.animation != "phase1":
			$heart/heartBeat.play()
