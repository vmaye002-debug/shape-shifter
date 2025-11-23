extends RigidBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var shapes: Array[MeshInstance2D]
@export var CCircle: CollisionShape2D
@export var CTriangle: CollisionPolygon2D
@export var CSquare: CollisionShape2D 

var on_floor: bool = false
var state_now: String = "C"
var last_state: String = "C"



var forces: Vector2 = Vector2(0,0)
var jump_force: Vector2 = Vector2(0,0)
var rot_force: Vector2 = Vector2(0,0)
var gravity: = Vector2(0,0)

func _ready() -> void:
	for child in get_children():
		if child is MeshInstance2D:
			shapes.append(child)


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	
	
	if Input.is_action_pressed("right"):
		#print("pressing right")
		if state_now != "S":
			forces  += Vector2(50,0)
	if Input.is_action_pressed("left"):
		
		if state_now != "S":
			#print("pressing left")
			forces  += Vector2(-50,0)
		if state_now == "T":
			rot_force +=Vector2(-50,0)
	if Input.is_action_just_pressed("space"):
		if state_now != "S" and on_floor:
			print("yupp")
			jump_force += Vector2(0,-40000)
	
	var i = 0
	if state.get_contact_count()> 0:
		while i < state.get_contact_count():
			#print(state.get_contact_collider_object(i))
			var normal := state.get_contact_local_normal(i)
			on_floor = normal.dot(Vector2.UP) > 0.99 # this can be dialed in
			#print("Floor: ", on_floor)
			i += 1
	else:
		on_floor=false
	#forces = forces - Vector2(-forces/100)
	
	forces.x = clampf(forces.x,-20,20)
	apply_central_force(forces*100) 
	apply_central_force(jump_force)
	
	linear_velocity.limit_length(400)
	print(linear_velocity)
	
	jump_force = Vector2.ZERO
	forces = Vector2.ZERO
	#
	#if state_now != last_state:
		#if on_floor:
			#apply_central_impulse(Vector2.UP*200)
		#last_state = state_now


func _input(event):
	forces = Vector2.ZERO
	if event.is_action_pressed("space"):
		pass
	
		
	if event.is_action_pressed("square"):
		hide_but_one("Square")
		state_now = "S"
		CCircle.disabled = true
		CTriangle.disabled = true
		CSquare.disabled = false
		
		pass
	if event.is_action_pressed("triangle"):
		hide_but_one("Triangle")
		state_now = "T"

		CCircle.disabled = true
		CTriangle.disabled = false
		CSquare.disabled = true

		pass
	if event.is_action_pressed("circle"):
		hide_but_one("Circle")
		state_now = "C"
		CCircle.disabled = false
		CTriangle.disabled = true
		CSquare.disabled = true
		pass
		
	

func hide_but_one(nameToShow: String, shape_list: Array[MeshInstance2D] = shapes ) -> void:
	for x in shape_list:
		x.hide()
		
		if x.name == nameToShow:
			x.show()
			print("Showing: ", x.name)
	
