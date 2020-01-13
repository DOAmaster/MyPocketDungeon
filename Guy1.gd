extends KinematicBody2D

var speed = 25
var velocity = Vector2()
var timer
var runTimer
var hearthTimer

var rng = RandomNumberGenerator.new()
var movingDir = 1
var hp = 3
var stopMoving = 0

var slimeLoreReward = 10
var slimeXpReward = 10
var batLoreReward = 4
var batXpReward = 2
var snakeLoreReward = 2
var snakeXpReward = 8

func get_input():
	# Detect up/down/left/right keystate and only move when pressed.
	velocity = Vector2()
	if (movingDir == 1):
		velocity.x += 1
	if (movingDir == 2):
		velocity.x -= 1
	if (movingDir == 3 || movingDir == 5 || movingDir == 6):
		velocity.y += 1
	if (movingDir >= 4):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func _init():
	rng.randomize()
	timer = Timer.new()
	runTimer = Timer.new()
	hearthTimer = Timer.new()
	add_child(runTimer)
	add_child(timer)
	runTimer.autostart = true
	runTimer.wait_time = 20
	runTimer.connect("timeout", self, "_runTimerout")
	timer.autostart = true
	timer.wait_time = 1
	timer.connect("timeout", self, "_timeout")
	hearthTimer.autostart = true
	hearthTimer.wait_time = 3
	hearthTimer.connect("timeout", self, "_hearthTimer")

func _ready():
	#spawn rangers upgrade if player unlocked side
	var rangerChange = rng.randi_range(1, 10)
	if(myGlobals.sideUnlocked == 1 && rangerChange == 1 ):
		get_node("AnimatedSprite").set_animation("ranger")
		runTimer.wait_time = 25
		speed = 50
		hp = 4
	pass

func _runTimerout():
	print("Guy hearthing")
	stopMoving = 1
	add_child(hearthTimer)

	get_node("CPUParticles2D").emitting = true

func _hearthTimer():
	print("Guy leaving")
	myGlobals.heroCount = myGlobals.heroCount - 1
	queue_free()

#timer called every 4 second to update time
func _timeout():
	movingDir = rng.randi_range(1, 6)
	#print("Changing movement")

func _physics_process(delta):
	get_input()
	if !stopMoving:
		move_and_collide(velocity * delta)


func _on_Area2D_body_entered(body):
	if body.is_in_group("Slime"):
		print("Slime has entered Guy range")
		var guystempHp = hp - 1
		hp = guystempHp
		print("GuysHp: ",guystempHp)
		var tempHp = body.hp - 1
		if guystempHp <= 0:
			print("Killing Guy1")
			myGlobals.dungeonLore = myGlobals.dungeonLore + slimeLoreReward
			myGlobals.dungeonXp = myGlobals.dungeonXp + slimeXpReward
			myGlobals.heroCount = myGlobals.heroCount - 1
			myGlobals.herosSlain = myGlobals.herosSlain + 1
			get_parent().get_node("LoreDisplay").text = String(myGlobals.dungeonLore)
			get_parent().get_node("XpDisplay").text = String(myGlobals.dungeonXp)
			queue_free()
		if tempHp <= 0:
			myGlobals.dungeonXp = myGlobals.dungeonXp + slimeXpReward
			get_parent().get_node("XpDisplay").text = String(myGlobals.dungeonXp)
			myGlobals.slimeCount = myGlobals.slimeCount - 1
			get_parent().get_node("SlimeDisplay").text = String(myGlobals.slimeCount)
			body.queue_free()
		else:
			body.hp = tempHp
			print("Slimes new HP: ", tempHp)
			
	elif body.is_in_group("Bat"):
		print("Bat has entered Guy range")
		var guystempHp = hp - 1
		hp = guystempHp
		#print("GuysHp: ",guystempHp)
		var tempHp = body.hp - 1
		if guystempHp <= 0:
			print("Killing Guy1")
			myGlobals.dungeonLore = myGlobals.dungeonLore + batLoreReward
			myGlobals.dungeonXp = myGlobals.dungeonXp + batXpReward
			myGlobals.heroCount = myGlobals.heroCount - 1
			myGlobals.herosSlain = myGlobals.herosSlain + 1
			get_parent().get_node("LoreDisplay").text = String(myGlobals.dungeonLore)
			get_parent().get_node("XpDisplay").text = String(myGlobals.dungeonXp)
			queue_free()
		if tempHp <= 0:
			myGlobals.dungeonXp = myGlobals.dungeonXp + batXpReward
			get_parent().get_node("XpDisplay").text = String(myGlobals.dungeonXp)
			myGlobals.batCount = myGlobals.batCount - 1
			get_parent().get_node("BatDisplay").text = String(myGlobals.batCount)
			body.queue_free()
		else:
			body.hp = tempHp
			print("Bats new HP: ", tempHp)
	elif body.is_in_group("Snake"):
		print("Snake has entered Guy range")
		var guystempHp = hp - 1
		hp = guystempHp
		#print("GuysHp: ",guystempHp)
		var tempHp = body.hp - 1
		if guystempHp <= 0:
			print("Killing Guy1")
			myGlobals.dungeonLore = myGlobals.dungeonLore + snakeLoreReward
			myGlobals.dungeonXp = myGlobals.dungeonXp + snakeXpReward
			myGlobals.heroCount = myGlobals.heroCount - 1
			myGlobals.herosSlain = myGlobals.herosSlain + 1
			get_parent().get_node("LoreDisplay").text = String(myGlobals.dungeonLore)
			get_parent().get_node("XpDisplay").text = String(myGlobals.dungeonXp)
			queue_free()
		if tempHp <= 0:
			myGlobals.dungeonXp = myGlobals.dungeonXp + snakeXpReward
			get_parent().get_node("XpDisplay").text = String(myGlobals.dungeonXp)
			myGlobals.snakeCount = myGlobals.snakeCount - 1
			get_parent().get_node("SnakeDisplay").text = String(myGlobals.snakeCount)
			body.queue_free()
		else:
			body.hp = tempHp
			print("Snake new HP: ", tempHp)
	pass # Replace with function body.
