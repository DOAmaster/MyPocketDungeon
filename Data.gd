extends Node

const FILE_NAME = "user://game-data.json"

var player = {
	"name": "Untiled Dungeon",
	"lore": 1,
	"xp": 1,
	"slimeCount" : 0,
	"lootCount" : 0
}

func saveGame():
	var file = File.new()
	file.open(FILE_NAME, File.WRITE)
	file.store_string(to_json(player))
	file.close()

func loadGame():
	var file = File.new()
	if file.file_exists(FILE_NAME):
		file.open(FILE_NAME, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			player = data
		else:
			printerr("Corrupted data!")
	else:
		printerr("No saved data!")


func mySaveGame():
	var file = File.new()
	player.name = myGlobals.dungeonName
	player.lore = myGlobals.dungeonLore
	player.xp = myGlobals.dungeonXp
	player.slimeCount = myGlobals.slimeCount
	player.lootCount = myGlobals.lootCount
	file.open(FILE_NAME, File.WRITE)
	file.store_string(to_json(player))
	file.close()
	print("Game saved mySavedGame",player)

func myLoadGame():
	loadGame()
	myGlobals.dungeonName = player.name
	myGlobals.dungeonLore = player.lore
	myGlobals.dungeonXp = player.xp
	myGlobals.slimeCount = player.slimeCount
	myGlobals.lootCount = player.lootCount
	print("name/day Loaded")
	get_tree().change_scene("res://Game.tscn")
	pass # Replace with function body.



func _on_Save_Game_pressed():
	mySaveGame()
	pass # Replace with function body.


func _on_Load_Game_pressed():
	myLoadGame()
	pass # Replace with function body.


func _on_New_Game_pressed():
	get_tree().change_scene("res://Game.tscn")
	pass # Replace with function body.
