extends RigidBody2DCollision

class_name RigidBody2DCollisionBall

var reset_state := false

var ray_queries: Array[PhysicsRayQueryParameters2D] = []
var ray_queries_count := 0

var position_previous := position
var collision_previous := false

@onready var position_initial := position
@onready var collision_shape_2d := $CollisionShape2D
@onready var world_2d := get_world_2d()

func reset() -> void:
	
	reset_state = true
	apply_force(Vector2.ZERO)
	
	return

func ray_queries_set() -> void:
	
	ray_queries_count = ceil(collision_shape_2d.shape.radius * 2 / Globals.TilesSize.SOLIDS_REGULAR)
	
	for ray_query_index in ray_queries_count + 1:
		ray_queries.append(PhysicsRayQueryParameters2D.create(Vector2.ZERO, Vector2.ZERO, Globals.SOLIDS_COLLISION_MASK))
	
	return

func collision_update() -> void:
	
	var velocity := (position - position_previous).round()
	position_previous = position
	
	var velocity_normal := velocity.normalized()
	var velocity_orthogonal_normal := velocity_normal.orthogonal()
	var velocity_orthogonal : Vector2 = velocity_orthogonal_normal * collision_shape_2d.shape.radius
	
	var vector_position := position - velocity_orthogonal + velocity_orthogonal_normal
	var vector_position_step := (velocity_orthogonal - velocity_orthogonal_normal) * 2 / ray_queries_count
	
	for ray_query in ray_queries:
		
		ray_query.from = vector_position + velocity_normal * sqrt(pow(collision_shape_2d.shape.radius, 2) - position.distance_squared_to(vector_position))
		ray_query.to = ray_query.from + velocity
		
		if world_2d.direct_space_state.intersect_ray(ray_query):
			
			if collision_previous:
				return
			
			collision_previous = true
			collision.play()
			
			return
		
		vector_position += vector_position_step
	
	collision_previous = false
	
	return

func _ready() -> void:
	
	ray_queries_set()
	
	return

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	
	if not reset_state:
		return
	
	state.angular_velocity = 0
	state.linear_velocity = Vector2.ZERO
	
	state.transform.x = Vector2.RIGHT
	state.transform.y = Vector2.DOWN
	
	state.transform.origin = position_initial
	
	reset_state = false
	
	return

func _physics_process(_delta: float) -> void:
	
	collision_update()
	
	return
