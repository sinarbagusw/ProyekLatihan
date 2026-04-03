extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var move_speed : float = 45.0
var state : String = "idle"

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite_2d : Sprite2D = $Sprite2D

func _ready():
	animation_player.play("idle_down")   # pastikan animasi ini ada di AnimationPlayer

func _process(delta):
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	velocity = direction * move_speed
	
	var changed_dir = SetDirection()
	var changed_state = SetState()
	
	if changed_dir or changed_state:
		UpdateAnimation()

func _physics_process(delta):
	move_and_slide()  

func SetDirection() -> bool:
	if direction == Vector2.ZERO:
		return false
	
	if abs(direction.x) > abs(direction.y):
		cardinal_direction = Vector2.RIGHT if direction.x > 0 else Vector2.LEFT
	else:
		cardinal_direction = Vector2.DOWN if direction.y > 0 else Vector2.UP
	
	return true

func SetState() -> bool:
	var new_state : String = "idle" if direction == Vector2.ZERO else "walk"
	if new_state == state:
		return false
	state = new_state 
	return true

func UpdateAnimation() -> void:
	var anim_name = state + "_" + AnimDirection()
	if animation_player.has_animation(anim_name):   # cek dulu biar aman
		animation_player.play(anim_name)

func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	elif cardinal_direction == Vector2.LEFT:
		return "left"
	elif cardinal_direction == Vector2.RIGHT:
		return "right"
	return "down"
