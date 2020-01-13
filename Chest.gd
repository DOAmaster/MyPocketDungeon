extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var loreReward = 25
var xpReward = 2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.is_in_group("Hero"):
		print("Hero in chest range")
		myGlobals.dungeonLore = myGlobals.dungeonLore + loreReward
		myGlobals.dungeonXp = myGlobals.dungeonXp + xpReward
		myGlobals.lootCount = myGlobals.lootCount - 1
		get_parent().get_node("ChestDisplay").text = String(myGlobals.lootCount)
		get_parent().get_node("LoreDisplay").text = String(myGlobals.dungeonLore)
		get_parent().get_node("XpDisplay").text = String(myGlobals.dungeonXp)
		queue_free()
	pass # Replace with function body.
