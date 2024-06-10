extends Control

var activeBooks = [[],[],[]]
var combination = [[2],[4],[5]]
var activeBooksCount = 0
var all_books = [[],[],[]]
@onready var open_box = $openBox
@onready var key_sprite = $openBox/keySprite
@onready var animation_player = $AnimationPlayer
@onready var purple_books = $books/purple_books
@onready var green_books = $books/green_books
@onready var blue_books = $books/blue_books
@onready var take_key = $takeKey
@onready var push_book = $pushBook
@onready var open_safe_box = $openSafeBox
@onready var candle_light = $candleLight


func _ready():
	var library = get_tree().get_nodes_in_group("library")[0]
	_set_active_books(activeBooks)
	for i in range(11):
		all_books[0].append(i)
		all_books[1].append(i)
		all_books[2].append(i)
	
	if library.safeBoxOpen:
		open_box.visible = true
	if library.pickedKey:
		key_sprite.queue_free()
		
func _process(delta):
	var library = get_tree().get_nodes_in_group("library")[0]
	activeBooks = _get_id_active_books()
	activeBooksCount = activeBooks[0].size() + activeBooks[1].size() + activeBooks[2].size()
	_restart_active_books()
	
	if _is_combination_correct() and !library.safeBoxOpen:
		animation_player.play("blackFadeIn")
		library.safeBoxOpen = true
		
	
	
	
func _get_id_active_books():
	var activeBooks = []
	
	var purpleBooks = purple_books._get_id_active_books()
	activeBooks.append(purpleBooks)
	var greenBooks = green_books._get_id_active_books()
	activeBooks.append(greenBooks)
	var blueBooks = blue_books._get_id_active_books()
	activeBooks.append(blueBooks)
	
	return activeBooks

func _set_active_books(ids:Array):
	var purpleBooks = purple_books
	var greenBooks = green_books
	var blueBooks = blue_books
	purpleBooks._set_id_active_books(ids[0])
	greenBooks._set_id_active_books(ids[1])
	blueBooks._set_id_active_books(ids[2])

func _set_inactive_books(ids:Array):
	var purpleBooks = purple_books
	var greenBooks = green_books
	var blueBooks = blue_books
	purpleBooks._set_id_inactive_books(ids[0])
	greenBooks._set_id_inactive_books(ids[1])
	blueBooks._set_id_inactive_books(ids[2])

func _is_combination_correct():
	if activeBooksCount == 3 and activeBooks == combination:
		return true
	else :
		return false

func _restart_active_books():
	if activeBooksCount == 3 and activeBooks != combination or activeBooksCount > 3:
		_set_inactive_books(all_books)
		
func _on_touch_screen_button_released():
	var library = get_tree().get_nodes_in_group("library")[0]
	library.activeBooks = _get_id_active_books()
	library.open = false
	#get_parent().HUDOpen = false
	queue_free()


func _on_sprite_2d_4_released():
	var player = get_tree().get_nodes_in_group("player")[0]
	var library = get_tree().get_nodes_in_group("library")[0]
	player.inventory.append(2)
	library.pickedKey = true
	take_key.play()
	key_sprite.queue_free()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "blackFadeIn":
		open_box.visible = true
		open_safe_box.play()

func _on_open_safe_box_finished():
	animation_player.play("blackFadeOut")


func _on_timer_timeout():
	candle_light.scale = Vector2(randf_range(1.8,2.2),2)
