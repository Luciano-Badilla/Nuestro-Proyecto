extends Node2D

func visible_particles(area,object,boolean):
	if area.is_in_group("player_interaction"):
		get_node(object).visible = boolean

func _ready():
	pass
	
func _on_area_box_2_area_entered(area):
	visible_particles(area,"box2",true)


func _on_area_box_2_area_exited(area):
	visible_particles(area,"box2",false)


func _on_area_shelf_area_entered(area):
	visible_particles(area,"shelf",true)


func _on_area_shelf_area_exited(area):
	visible_particles(area,"shelf",false)


func _on_area_record_player_area_entered(area):
	visible_particles(area,"recordPlayer",true)


func _on_area_record_player_area_exited(area):
	visible_particles(area,"recordPlayer",false)


func _on_area_bed_area_entered(area):
	visible_particles(area,"bed",true)


func _on_area_bed_area_exited(area):
	visible_particles(area,"bed",false)


func _on_area_clock_area_entered(area):
	visible_particles(area,"clock",true)


func _on_area_clock_area_exited(area):
	visible_particles(area,"clock",false)


func _on_area_dresser_area_entered(area):
	visible_particles(area,"dresser",true)


func _on_area_dresser_area_exited(area):
	visible_particles(area,"dresser",false)
