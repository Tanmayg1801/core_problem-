extends CharacterBody2D

const MOVE_LERP_FAC: float = 0.65
const MAX_SPEED: float = 200.0

var current_facing: String = "front"
var pause_anim: bool = false

@export var is_active: bool = true

@onready var anim: Sprite2D = $AnimatedSprite2D
@onready var camera_2d: Camera2D = $Camera2D


func _ready() -> void:
	#anim.play("idle_front")
	pass


func _physics_process(_delta: float) -> void:
	camera_2d.enabled = is_active
	
	if not is_active:
		velocity = velocity.lerp(Vector2.ZERO, MOVE_LERP_FAC)
		move_and_slide()
		return
		
	# 1. Movement Logic (Unchanged)
	var input_dir := Input.get_vector(
		"left", "right", 
		"up", "down"
	)
	
	var target_velocity := input_dir * MAX_SPEED
	velocity = velocity.lerp(target_velocity, MOVE_LERP_FAC)
	move_and_slide()
	
	# 2. Animation Updates
	#if not pause_anim:
		#update_animations(input_dir)


#func update_animations(input_dir: Vector2) -> void:
	## Calculate the direction from the character to the mouse
	#var mouse_pos = get_global_mouse_position()
	#var aim_dir = (mouse_pos - global_position).normalized()
	#
	## Determine facing based on the mouse direction
	#if abs(aim_dir.x) > abs(aim_dir.y):
		#current_facing = "side"
		## Flip the sprite if the mouse is to the left (negative X)
		#anim.flip_h = aim_dir.x < 0
	#else:
		#anim.flip_h = false
		#if aim_dir.y > 0:
			#current_facing = "front" # Mouse is below the player
		#else:
			#current_facing = "back"  # Mouse is above the player
			#
	## Determine if we should play the walk or idle animation
	#var state = "idle"
	#if input_dir != Vector2.ZERO:
		#state = "walk"
		#
	#play_anim(state)
#
#
#func play_anim(state: String) -> void:
	#var anim_name = state + "_" + current_facing
	#
	#if anim.animation != anim_name:
		#anim.play(anim_name)
