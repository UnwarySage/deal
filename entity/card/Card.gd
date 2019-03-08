extends Control
class_name Card

signal on_select

export var display_text: String 
export var option_id:String

onready var _card_text:Label = find_node("CardText",true)
onready var _tween:Tween = find_node("Tween",true)
var _fade_amount:float = 0.8

func _ready():
	modulate = Color(_fade_amount,_fade_amount,_fade_amount)


func setup_card(text:String,id:String)->void:
	_card_text.text = text
	option_id = id

func _on_gui_input(event):
	if event.is_action("card_click"):
		print("whoa nelly")
		emit_signal("on_select", option_id)


func _on_mouse_entered()-> void:
	_tween.interpolate_property(self, "modulate", modulate,
	 Color(1,1,1),.2,Tween.TRANS_QUAD,Tween.EASE_IN)
	
#	_tween.interpolate_property(self, "margin_bottom", margin_bottom,
#	 4,.2,Tween.TRANS_QUAD,Tween.EASE_IN)
	_tween.start()

func _on_mouse_exited()-> void:
	_tween.interpolate_property(self, "modulate", modulate,
	 Color(_fade_amount,_fade_amount,_fade_amount),.2,Tween.TRANS_QUAD,Tween.EASE_IN)
	
#	_tween.interpolate_property(self, "margin_bottom", margin_bottom,
#	 4,.2,Tween.TRANS_QUAD,Tween.EASE_IN)
	_tween.start()

func _on_TextureRect_gui_input(event):
	print("mee")