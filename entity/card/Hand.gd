extends HBoxContainer
class_name Hand

signal on_choose

export var card_scene:PackedScene = null

onready var separator:TextureRect = $Separator

onready var _tween:Tween = find_node("Tween",true)


func _ready():
	pass

func setup_hand(hand_info:Dictionary)->void:
	var keys = hand_info.keys()
	var spawn:Card = null
	var seperators_remaining:int = len(keys) - 1
	
	separator.visible = true
	for option_id in keys:
		spawn = card_scene.instance()
		add_child(spawn)
		if 0 <  seperators_remaining:
			add_child(separator.duplicate())
			seperators_remaining -= 1
		spawn.setup_card(hand_info[option_id], option_id)
		spawn.connect("on_select",self,"on_choose")
	separator.visible = false
	
	
func on_choose(id:String)->void:
	emit_signal("on_choose", id)
	for child in get_children():
		if child is Card:
			child.dissolve()
		elif child != separator:
			_tween.interpolate_property(child, "modulate",modulate, Color(1,1,1,0), 2, Tween.TRANS_QUAD, Tween.EASE_OUT)
	_tween.start()
	yield(_tween,"tween_completed")
	for child in get_children():
		if child != separator:
			child.queue_free()

	