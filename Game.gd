extends Node2D

# Derrick Alden 2020 Just like make a game
var lore = 1
var xp = 10
var slimeCount = 0
var slimeMax = 2
var lootCount = 0
var lootMax = 1
var slimeCost = 2
var lootCost = 5
var expandCost = 100
var expandLevel = 1
var rng = RandomNumberGenerator.new()
var sideUnlocked = 0
var batCount = 0
var batMax = 5
var batCost = 1
var snakeCount = 0
var snakeMax = 3
var snakeCost = 2

var timer

const MySlimeResource = preload("res://Slime.tscn")
const MyLootResource = preload("res://Chest.tscn")
const MyBatResource = preload("res://Bat.tscn")
const MySnakeResource = preload("res://Snake.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("DungeonName").text = String(myGlobals.dungeonName)
	get_node("LoreDisplay").text = String(myGlobals.dungeonLore)
	get_node("XpDisplay").text = String(myGlobals.dungeonXp)
	get_node("SlimeDisplay").text = String(myGlobals.slimeCount)
	get_node("BatDisplay").text = String(myGlobals.batCount)
	get_node("ChestDisplay").text = String(myGlobals.lootCount)
	get_node("HeroesSlainDisplay").text = String(myGlobals.herosSlain)
	get_node("SnakeDisplay").text = String(myGlobals.snakeCount)
	
	get_node("GridContainer/SlimeCostDisplay").text = String(slimeCost)
	get_node("GridContainer/BatCostDisplay").text = String(batCost)
	get_node("GridContainer/ChestCostDisplay").text = String(lootCost)
	get_node("GridContainer/ExpandCostDisplay").text = String(expandCost)
	get_node("GridContainer/SnakeCostDisplay").text = String(snakeCost)
	
	#print(get_filename())
	
	for n in range(myGlobals.slimeCount):
		_on_AddSlime_pressed()
		yield(get_tree().create_timer(.5), "timeout")
	
	for n in range(myGlobals.lootCount):
		_on_AddChest_pressed()
		yield(get_tree().create_timer(.5), "timeout")
	pass # Replace with function body.

func _init():
	rng.randomize()
	timer = Timer.new()
	add_child(timer)
	timer.autostart = true
	timer.wait_time = 15
	timer.connect("timeout", self, "_timeout")
	#get_node("DungeonName").text = myGlobals.dungeonName
	pass # Replace with function body.

const MyGuy1Resource = preload("res://Guy1.tscn")

func _timeout():
	print("Trying to Spawn Hero")
	if (myGlobals.heroCount < myGlobals.heroMax):
		print("spawing Guy1")
		myGlobals.heroCount = myGlobals.heroCount + 1
		#Make instance
		#myGlobals.slimeCount = slimeCount
		var GrabedInstance= MyGuy1Resource.instance()
		#You could now make changes to the new instance if you wanted
		#CurrentEntry.name = "SmokeA"
		var randHeroLoc = rng.randi_range(1, 2)
		if (sideUnlocked):
			if (randHeroLoc == 1):
				GrabedInstance.position = get_node("HeroSpawn").position
			elif (randHeroLoc == 2):
				GrabedInstance.position = get_node("HeroSpawnSide").position
		else:
			GrabedInstance.position = get_node("HeroSpawn").position
		#Attach it to the tree
		#get_node("Hero").text = String(myGlobals.slimeCount)
		self.add_child(GrabedInstance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_DungeonName_text_changed():
	myGlobals.dungeonName = get_node("DungeonName").text 
	pass # Replace with function body.


func _on_AddSlime_pressed():
	if (myGlobals.slimeCount < slimeMax && myGlobals.dungeonXp >= slimeCost):
		print("spawing slime")
		myGlobals.slimeCount = myGlobals.slimeCount + 1
		myGlobals.dungeonXp = myGlobals.dungeonXp - slimeCost
		get_node("XpDisplay").text = String(myGlobals.dungeonXp)
		#Make instance
		#myGlobals.slimeCount = slimeCount
		var GrabedInstance= MySlimeResource.instance()
		#You could now make changes to the new instance if you wanted
		#CurrentEntry.name = "SmokeA"
		var randMobLoc = rng.randi_range(1, 2)
		if (randMobLoc == 1):
			GrabedInstance.position = get_node("MobSpawn").position
		elif (randMobLoc == 2):
			GrabedInstance.position = get_node("MobSpawn2").position
		#Attach it to the tree
		get_node("SlimeDisplay").text = String(myGlobals.slimeCount)
		self.add_child(GrabedInstance)
	pass # Replace with function body.


func _on_AddChest_pressed():
	if (lootCount < lootMax && myGlobals.dungeonXp >= lootCost):
		print("spawing loot")
		lootCount = lootCount + 1
		myGlobals.dungeonXp = myGlobals.dungeonXp - lootCost
		get_node("XpDisplay").text = String(myGlobals.dungeonXp)
		#Make instance
		myGlobals.lootCount = lootCount
		var GrabedInstance= MyLootResource.instance()
		#You could now make changes to the new instance if you wanted
		#CurrentEntry.name = "SmokeA"
		var randLoc = rng.randi_range(1, 8)
		if (randLoc == 1):
			GrabedInstance.position = get_node("LootSpawn1").position
		elif (randLoc == 2):
			GrabedInstance.position = get_node("LootSpawn2").position
		elif (randLoc == 3):
			GrabedInstance.position = get_node("LootSpawn3").position
		elif (randLoc == 4):
			GrabedInstance.position = get_node("LootSpawn4").position
		elif (randLoc == 5):
			GrabedInstance.position = get_node("LootSpawn5").position
		elif (randLoc == 6):
			GrabedInstance.position = get_node("LootSpawn6").position
		elif (randLoc == 7):
			GrabedInstance.position = get_node("LootSpawn7").position
		elif (randLoc == 8):
			GrabedInstance.position = get_node("LootSpawn8").position
		#Attach it to the tree
		get_node("ChestDisplay").text = String(lootCount)
		self.add_child(GrabedInstance)
	pass # Replace with function body.

#expand dungeon to another size, update cost for next expand
func _on_Expand_pressed():
	if (myGlobals.dungeonXp >= expandCost && !sideUnlocked):
		print("expanding dungeon")
		sideUnlocked = 1
		myGlobals.heroMax = 3
		get_node("GridContainer/ExpandCostDisplay").text = "-"
		myGlobals.dungeonXp = myGlobals.dungeonXp - expandCost
		get_node("XpDisplay").text = String(myGlobals.dungeonXp)
		get_node("side torches").visible = true
		myGlobals.sideUnlocked = 1
		#create bigger tile set
		#update expandLevel 
	pass # Replace with function body.


func _on_AddBat_pressed():
	if (myGlobals.batCount < batMax && myGlobals.dungeonXp >= batCost):
		print("spawing Bat")
		myGlobals.batCount = myGlobals.batCount + 1
		myGlobals.dungeonXp = myGlobals.dungeonXp - batCost
		get_node("XpDisplay").text = String(myGlobals.dungeonXp)
		#Make instance
		#myGlobals.slimeCount = slimeCount
		var GrabedInstance= MyBatResource.instance()
		#You could now make changes to the new instance if you wanted
		#CurrentEntry.name = "SmokeA"
		var randMobLoc = rng.randi_range(1, 2)
		if (randMobLoc == 1):
			GrabedInstance.position = get_node("MobSpawn").position
		elif (randMobLoc == 2):
			GrabedInstance.position = get_node("MobSpawn2").position
		#Attach it to the tree
		get_node("BatDisplay").text = String(myGlobals.batCount)
		self.add_child(GrabedInstance)
	pass # Replace with function body.


func _on_AddSnake_pressed():
	if (myGlobals.snakeCount < snakeMax && myGlobals.dungeonXp >= snakeCost):
		print("spawing Snake")
		myGlobals.snakeCount = myGlobals.snakeCount + 1
		myGlobals.dungeonXp = myGlobals.dungeonXp - snakeCost
		get_node("XpDisplay").text = String(myGlobals.dungeonXp)
		#Make instance
		#myGlobals.slimeCount = slimeCount
		var GrabedInstance= MySnakeResource.instance()
		#You could now make changes to the new instance if you wanted
		#CurrentEntry.name = "SmokeA"
		var randMobLoc = rng.randi_range(1, 2)
		if (randMobLoc == 1):
			GrabedInstance.position = get_node("MobSpawn").position
		elif (randMobLoc == 2):
			GrabedInstance.position = get_node("MobSpawn2").position
		#Attach it to the tree
		get_node("SnakeDisplay").text = String(myGlobals.snakeCount)
		self.add_child(GrabedInstance)
	pass # Replace with function body.


func _on_CheckBox_toggled(button_pressed):
	print(button_pressed)
	if(button_pressed):
		get_node("BGM").play()
	else:
		get_node("BGM").stop()
		
	pass # Replace with function body.
