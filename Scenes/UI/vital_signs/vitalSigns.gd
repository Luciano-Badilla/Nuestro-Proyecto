extends Line2D

@export var endGradient: Gradient

var local_points = []
var time = 0.0
var speed = 1.0  # Controla la velocidad de la "onda"
var pulse = false
var cycle: float
var timerTime = 0.2
var timerStart = false
var canStartRemove = false
var canDraw = true
@onready var timer = $Timer


func _process(delta):
	if pulse:
		cycle = timerTime
		timer.wait_time = timerTime
		if !timerStart:
			timerStart = true
			timer.start()
	else:
		cycle = 0
	
	time += delta * speed
	var x = fmod(time * 50, 520) # Largo de signos vitales
	var y = generate_ecg_wave(time)
	if canDraw:
		local_points.append(Vector2(x, y))
	
	if round(x) >= 519:
		gradient = endGradient
		canDraw = false
		canStartRemove = true
		get_tree().get_first_node_in_group("hud_node").resetVitalSings()
	
	if local_points.size() > 1:
		points = local_points
		
	if local_points.size() == 0:
		queue_free()
			
	if canStartRemove and local_points.size() != 0:
		local_points.remove_at(0)
		points = local_points
	
func generate_ecg_wave(t):
	var amplitude = 25  # Ajusta la amplitud de la onda
	var value = -320 # Posición vertical base de la línea
	# Simulación de diferentes partes de un ciclo ECG
	var cycle_time = fmod(t, cycle)  # Un ciclo completo cada 1.5 segundos

	if cycle_time < 0.1:
		value += sin(cycle_time * 2 * PI / 0.1) * amplitude  # Onda P
	elif cycle_time < 0.2:
		value += sin((cycle_time - 0.1) * 2 * PI / 0.1) * -amplitude / 4  # Segmento Q
	elif cycle_time < 0.3:
		value += sin((cycle_time - 0.2) * 2 * PI / 0.1) * amplitude * 1.5  # Onda R
	elif cycle_time < 0.4:
		value += sin((cycle_time - 0.3) * 2 * PI / 0.1) * -amplitude / 4  # Segmento S
	elif cycle_time < 0.5:
		value += sin((cycle_time - 0.4) * 2 * PI / 0.1) * amplitude / 2  # Onda T
	return value


func _on_timer_timeout():
	pulse = false
	timerStart = false
