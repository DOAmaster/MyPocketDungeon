extends Area2D

var speed = 25
var velocity = Vector2()
var timer

var rng = RandomNumberGenerator.new()
var movingDir = 1
var hp = 2

func get_input():
	# Detect up/down/left/right keystate and only move when pressed.
	velocity = Vector2()
	if (movingDir == 1):
		velocity.x += 1
	if (movingDir == 2):
		velocity.x -= 1
	if (movingDir == 3):
		velocity.y += 1
	if (movingDir == 4):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func _init():
	rng.randomize()
	timer = Timer.new()
	add_child(timer)
	timer.autostart = true
	timer.wait_time = 2
	timer.connect("timeout", self, "_timeout")


#timer called every 4 second to update time
func _timeout():
	movingDir = rng.randi_range(1, 4)
	#print("Changing movement")

func _physics_process(delta):
	get_input()
	#move_and_collide(velocity * delta)
