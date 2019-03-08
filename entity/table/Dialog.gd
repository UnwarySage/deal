extends TextureRect

export var present_dialog:String

onready var _dialog_box:Label = find_node("DialogBox",true)
onready var _tween:Tween = find_node("Tween",true)

func say(new_dialog:String)->void:
	_tween.interpolate_property(_dialog_box, "modulate", modulate,Color(0,0,0),.5,Tween.TRANS_QUAD, Tween.EASE_OUT)
	_tween.start()
	yield(_tween,"tween_completed")
	present_dialog = new_dialog
	_dialog_box.text = present_dialog
	_dialog_box.percent_visible = 0
	_dialog_box.modulate = Color(1,1,1)
	_tween.interpolate_property(_dialog_box, "percent_visible", 0,1,1,Tween.TRANS_LINEAR,Tween.EASE_IN)
	_tween.start()