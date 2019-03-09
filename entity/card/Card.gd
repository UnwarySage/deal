extends Control
class_name Card

signal on_select

export var display_text: String 
export var option_id:String

onready var _card_text:Label = find_node("CardText",true)
onready var _tween:Tween = find_node("Tween",true)
var _fade_amount:float = 0.8
var clicked = false

func _ready():
	modulate = Color(_fade_amount,_fade_amount,_fade_amount)


func setup_card(text:String,id:String)->void:
	_card_text.text = text
	option_id = id

func dissolve()->void:
	_tween.interpolate_property(self, "modulate", modulate, Color(_fade_amount,_fade_amount,_fade_amount,0),.6,Tween.TRANS_QUAD,Tween.EASE_IN)
	_tween.interpolate_property($TextureRect/DissolveParticles, "self_modulate", modulate, Color(1,1,0),7.2,Tween.TRANS_QUAD,Tween.EASE_IN,.1)
	_tween.start()
	$TextureRect/DissolveParticles.emitting = true
	yield(_tween, "tween_completed")
	self.visible = false

func _on_gui_input(event):
	if event.is_action("card_click") and not clicked:
		clicked = true
		emit_signal("on_select", option_id)
		dissolve()


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