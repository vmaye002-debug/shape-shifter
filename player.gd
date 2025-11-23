extends RigidBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var shapes: Array[MeshInstance2D]
@export var CCircle: CollisionShape2D
@export var CTriangle: CollisionPolygon2D
@export var CSquare: CollisionShape2D 

var on_floor: bool = false
var state_now: String = "S"
var last_state: String = "S"



var forces: Vector2 = Vector2(0,0)
var gravity: = Vector2(0,0)

func _ready() -> void:
	for child in get_children():
		if child is MeshInstance2D:
			shapes.append(child)


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var i = 0
	if state.get_contact_count()> 0:
		while i < state.get_contact_count():
			print(state.get_contact_collider_object(i))
			var normal := state.get_contact_local_normal(i)
			on_floor = normal.dot(Vector2.UP) > 0.99 # this can be dialed in
			print("Floor: ", on_floor)
			i += 1
	else:
		on_floor=false
	apply_central_impulse(forces) 
	
	if state_now != last_state:
		if on_floor:
			apply_central_impulse(Vector2.UP*200)
		last_state = state_now
	
	
	


func _physics_process(delta: float) -> void:
	if not on_floor:
		gravity += get_gravity() * delta
	else:
		gravity = Vector2.ZERO
	
	
	
func _process(delta: float) -> void:
	pass



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
		
	if Input.is_action_just_pressed("right"):
		print("pressing right")
		forces  += Vector2(50,0)
	if Input.is_action_just_pressed("left"):
		print("pressing left")
		forces  += Vector2(-50,0)
	

func hide_but_one(nameToShow: String, shape_list: Array[MeshInstance2D] = shapes ) -> void:
	for x in shape_list:
		x.hide()
		
		if x.name == nameToShow:
			x.show()
			print("Showing: ", x.name)
	
