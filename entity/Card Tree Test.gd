extends Node2D

#the current decision tree being used
#trees are each stored in their own file and are loaded as needed
var tree

#points to the current question/card set 
var index

#example world state variables. Could (and should) be stored better. 
var friendliness = 0
var cooperation = 0

#Called when the node enters the scene tree for the first time.
func _ready():
	#don't mind me, just connecting some buttons up.
	get_child(1).connect("pressed", self, "_option_1")
	get_child(2).connect("pressed", self, "_option_2")
	get_child(3).connect("pressed", self, "_option_3")
	
	#the game should start with the first tree, as it has the opening dialogue
	#NOTE: this tree should then be excluded from consideration for the rest of the game
	tree = get_root_card(0)
	display_card()


#load in a new tree and display the first question/card node
#trees are numerically indexed in my example, but the index could 
#theoretically be any unique string
func get_root_card(tree_index):
	
	#get filepath
	#trees are stored in their own folder and are named "tree_#.json"
	# where "#" is the index
	var tree_name = str("res://entity/trees/tree_", tree_index, ".json")
	
	#open the file and get the data as text
	var file = File.new()
	file.open(tree_name, File.READ)
	var file_text = file.get_as_text()
	file.close()
	
	# parse tree and get results as an array
	var tree_data = JSON.parse(file_text).result["tree"]
	
	#reset the index (trees always start at the root node)
	index = 0
	
	#return the tree array
	return tree_data

#This is a placeholder function
#But in the full version, it will be the place where the new tree is chosen
#Based on a random generator and the world state
#We may need another storage file to determine the hard requirements 
#For what trees can be selected when
# (That way we can decide what tree to use without having to load all the trees)
func get_new_tree():
	#right now, we just get this arbitrary new tree, to show that it works
	tree = get_root_card(1)
	display_card()

#Called at the end of a tree
#Also possibly called if a branch node affects the world state itself
# It just updates all of the variables used to keep track of the world state
func update_world_state():
	
	# get the current node
	var card = tree[index]
	
	#state keys are present in the dictionary if that card changes the
	#particular state variable. So we can go through the list of state variables
	#and check whether each is changed, making the necessary modification as we go.
	
	if card.has("friendliness"):
		print("updating friendliness score")
		friendliness = friendliness + card["friendliness"]
		print(friendliness)
	
	if card.has("cooperation"):
		print("updating cooperation score")
		cooperation = cooperation + card["cooperation"]
		print(cooperation)
	

# display the current card
func display_card():
	# get the current node
	var card = tree[index]
	
	#set the dialogue text
	get_child(0).text = card["q_text"]
	
	#if the node is a leaf:
	if card["is_leaf"]:
		
		#no card options to display
		for i in range(3):
			get_child(i+1).text = "  "
		
		#wait for a few seconds so the text can be read
		yield(get_tree().create_timer(2.0), "timeout")
		
		#update the world state
		update_world_state()
		
		#select a new tree to use
		get_new_tree()
		
	else: #node is not a leaf
		
		# get card option text for all options
		var num_options = card["options"].size()	
		for i in range(num_options):
			get_child(i+1).text = card["options"][i]
		
		# the rest of the buttons are set to blank
		for i in range(num_options, 3):
			get_child(i+1).text = "   "

#probably a more space efficient way to deal with button presses,
#but this is fine for the tester scene

#button 1 pressed
func _option_1():
	
	#update the index to follow the branch along to the next node
	index = tree[index]["branch"][0]
	
	#update display
	display_card()
	

#button 2 pressed
func _option_2():
	index = tree[index]["branch"][1]
	display_card()

#button 3 pressed
func _option_3():
	index = tree[index]["branch"][2]
	display_card()
