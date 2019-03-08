extends VBoxContainer

onready var _dialog = find_node("DialogSystem",true)
onready var _hand:Hand = find_node("Hand",true)

func _ready():
	_hand.connect("on_choose",self, "round_ended")
	
	play_round({"prompt":"I hate this.",
				"agree":"Me too.",
				"deny":"Yeah, whatever"})

func play_round(round_info:Dictionary):
	_dialog.say(round_info["prompt"])
	round_info.erase("prompt")
	_hand.setup_hand(round_info)

func round_ended(choice:String):
	print("player chose: ", choice)