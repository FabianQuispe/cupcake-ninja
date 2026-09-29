class_name Jugador
extends Personaje

signal movimiento_terminado(direccion: Vector2)
signal ataque_realizado(posicion: Vector2, direccion: Vector2, alcance: float, danio: int)

enum Estado { IDLE, SLIDING }

@export var tamano_casilla := 48.0
@export var velocidad_deslizamiento := 240.0
@export var alcance_ataque := 96.0

var estado := Estado.IDLE
var direccion := Vector2.RIGHT
var power_up_disponible: PowerUp
var escudo_activo := false
var turnos_escudo := 0
var raycast_trayectoria: RayCast2D
var raycast_ataque: RayCast2D
var _origen_deslizamiento := Vector2.ZERO
var _toque_inicial := Vector2.ZERO
var _hay_toque := false
var _destello_ataque := 0.0
var _tiempo_invulnerable := 0.0


func _ready() -> void:
	nombre = "Jugador"
	vida = 100
	var forma := CollisionShape2D.new()
	var circulo := CircleShape2D.new()
	circulo.radius = 16.0
	forma.shape = circulo
	add_child(forma)

	raycast_trayectoria = RayCast2D.new()
	raycast_trayectoria.name = "RayCastTrayectoria"
	raycast_trayectoria.enabled = true
	raycast_trayectoria.collide_with_areas = true
	raycast_trayectoria.collision_mask = 1
	add_child(raycast_trayectoria)

	raycast_ataque = RayCast2D.new()
	raycast_ataque.name = "RayCastAtaque"
	raycast_ataque.enabled = true
	raycast_ataque.collision_mask = 1
	add_child(raycast_ataque)
	queue_redraw()


func _physics_process(delta: float) -> void:
	if estado == Estado.SLIDING:
		_deslizar_hasta_colision(delta)
	_tiempo_invulnerable = maxf(_tiempo_invulnerable - delta, 0.0)
	if _destello_ataque > 0.0:
		_destello_ataque -= delta
		queue_redraw()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		var direccion_tecla := _direccion_de_tecla(event.keycode)
		if direccion_tecla != Vector2.ZERO:
			iniciar_deslizamiento(direccion_tecla)
		elif event.keycode == KEY_A:
			realizar_ataque()
	elif event is InputEventScreenTouch:
		if event.pressed:
			_toque_inicial = event.position
			_hay_toque = true
		elif _hay_toque:
			_hay_toque = false
			var desplazamiento: Vector2 = event.position - _toque_inicial
			if desplazamiento.length() >= tamano_casilla * 0.35:
				iniciar_deslizamiento(_direccion_de_deslizamiento(desplazamiento))


func _direccion_de_tecla(tecla: Key) -> Vector2:
	match tecla:
		KEY_LEFT:
			return Vector2.LEFT
		KEY_RIGHT:
			return Vector2.RIGHT
		KEY_UP:
			return Vector2.UP
		KEY_DOWN:
			return Vector2.DOWN
	return Vector2.ZERO


func _direccion_de_deslizamiento(desplazamiento: Vector2) -> Vector2:
	if absf(desplazamiento.x) > absf(desplazamiento.y):
		return Vector2.RIGHT if desplazamiento.x > 0.0 else Vector2.LEFT
	return Vector2.DOWN if desplazamiento.y > 0.0 else Vector2.UP


func iniciar_deslizamiento(nueva_direccion: Vector2) -> void:
	if nueva_direccion == Vector2.ZERO:
		return
	direccion = nueva_direccion
	raycast_trayectoria.target_position = direccion * tamano_casilla
	raycast_trayectoria.force_raycast_update()
	if estado == Estado.IDLE and not raycast_trayectoria.is_colliding():
		estado = Estado.SLIDING


func _deslizar_hasta_colision(delta: float) -> void:
	var distancia := velocidad_deslizamiento * delta
	raycast_trayectoria.target_position = direccion * maxf(distancia + 4.0, 8.0)
	raycast_trayectoria.force_raycast_update()
	if raycast_trayectoria.is_colliding():
		var punto_colision := raycast_trayectoria.get_collision_point()
		global_position = punto_colision - direccion * 18.0
		finalizar_deslizamiento()
		return
	var colision := move_and_collide(direccion * distancia)
	if colision != null:
		finalizar_deslizamiento()


func finalizar_deslizamiento() -> void:
	estado = Estado.IDLE
	global_position = _ajustar_a_casilla(global_position)
	movimiento_terminado.emit(direccion)
	_consumir_turno()


func _ajustar_a_casilla(posicion: Vector2) -> Vector2:
	return Vector2(round(posicion.x / tamano_casilla) * tamano_casilla, round(posicion.y / tamano_casilla) * tamano_casilla)


func realizar_ataque() -> void:
	_destello_ataque = 0.14
	queue_redraw()
	raycast_ataque.target_position = direccion * alcance_ataque
	raycast_ataque.force_raycast_update()
	var alcance_real := alcance_ataque
	if raycast_ataque.is_colliding():
		var punto_bloqueo := raycast_ataque.get_collision_point()
		alcance_real = global_position.distance_to(punto_bloqueo) - 18.0
	ataque_realizado.emit(global_position, direccion, maxf(alcance_real, 0.0), maxi(danio_disparo, 35))
	_consumir_turno()


func _consumir_turno() -> void:
	if not escudo_activo:
		return
	turnos_escudo -= 1
	if turnos_escudo <= 0:
		escudo_activo = false
		queue_redraw()


func recibir_dano(cantidad: int) -> void:
	if escudo_activo or _tiempo_invulnerable > 0.0:
		return
	_tiempo_invulnerable = 0.35
	super.recibir_dano(cantidad)


func usar_power_up(power_up: PowerUp) -> void:
	if power_up_disponible != null:
		power_up_disponible.usar(self)
		power_up_disponible = null
	else:
		power_up.usar(self)


func activar_escudo(duracion: float) -> void:
	escudo_activo = true
	turnos_escudo = maxi(ceili(duracion), 1)
	queue_redraw()


func _draw() -> void:
	var color := Color("5ee1a7") if not escudo_activo else Color("6bc7ff")
	draw_circle(Vector2.ZERO, 19.0, color)
	draw_circle(Vector2.ZERO, 9.0, Color("182338"))
	if _destello_ataque > 0.0:
		draw_line(Vector2.ZERO, direccion * alcance_ataque, Color("fff0a8"), 8.0)
		draw_circle(direccion * alcance_ataque, 10.0, Color("fff0a8"))
	if escudo_activo:
		draw_arc(Vector2.ZERO, 28.0, 0.0, TAU, 32, Color("b4ecff"), 3.0)
