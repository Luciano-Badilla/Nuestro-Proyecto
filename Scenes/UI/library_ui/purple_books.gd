extends Node2D

func _ready():
	for i in range(get_child_count()):
		get_child(i).id = i
		i += 1


func _process(delta):
	pass
	
func _get_active_books():
	var activeBooks = []
	for i in range(get_child_count()):
		if get_child(i)._is_active():
			activeBooks.append(get_child(i))
		elif !get_child(i)._is_active():
			activeBooks.erase(get_child(i))
		i += 1
	return activeBooks
	
func _get_id_active_books():
	var activeBooks = []
	for i in range(get_child_count()):
		if get_child(i)._is_active():
			activeBooks.append(get_child(i)._get_id())
		elif !get_child(i)._is_active():
			activeBooks.erase(get_child(i)._get_id())
		i += 1
	return activeBooks

func _set_id_active_books(ids:Array):
	for i in range(get_child_count()):
		if get_child(i).id in ids:
			get_child(i).active = true

func _set_id_inactive_books(ids:Array):
	for i in range(get_child_count()):
		if get_child(i).id in ids:
			get_child(i).active = false
