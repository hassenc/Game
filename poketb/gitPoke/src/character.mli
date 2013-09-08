
#open "gameInformation";;
#open "creature";;
#open "quests";;
#open "object";;

(* Position type
	x is the position on the x-axis (horizontal)
	y is the position on the y-axis (vertical) *)
type Position = { mutable x : float; mutable y : float};;

type Character;;

value	getDefaultCharacter: 	unit 			-> Character 	
and 	getStringPosition: 		Position 		-> string
and 	positionOfString: 		string			-> Position
and		creatureDataString: 	Creature 		-> string
and 	creaturesDataString: 	Creature vect 	-> string
and 	inventoryDataString: 	(int*int) vect 	-> string
and 	saveCharacter: 			string 			-> Character 		-> unit
and 	readCreature: 			string 			-> Creature
and 	readCreatures: 			string 			-> Creature vect
and 	readQuests: 			string 			-> (int*(bool vect)) list
and 	readInventory: 			string 			-> (int*int) vect
and 	loadCharacter: 			string 			-> Character

and getCharacterCreatures:		Character 		-> Creature vect
and getCharacterInformation:	Character 		-> GameInformation
and getCharacterPosition:		Character 		-> Position
and getCharacterInventory:		Character 		-> (int*int) vect
and getCharacterMaxCreatureLvl: Character 		-> int
and getCharacterQuests:			Character		-> int list
and getCharacterQuestActions:	Character		-> int 				-> bool vect
and getCharacterQuestState: 	Character 		-> int 				-> string
and getCharacterActionDoneTiles:Character 		-> (int*int*int) list

and setCharacterPosition:		Character 		-> Position 		-> unit
and setCharacterName:			Character 		-> string 			-> unit
and setCharacterInventory:Character 		-> (int*int) vect 			-> unit

and addItemInInventory:			Character 		-> int 				-> int 		-> unit
and addItemsInInventory:		Character 		-> int list			-> unit
and searchItemIndex: 			Character		-> int				-> int
and biggerInventory:int ->(int*int) vect  -> (int*int) vect 
and addExperienceToCreatures:	Character		-> float			-> unit
and removeItemsFromInventory:	Character 		-> int				-> int		-> unit
and removeItemFromInventory:	Character 		-> int				-> unit
and addCreature:				Character		-> Creature			-> unit
and addCreatures:				Character		-> int	list		-> unit
and eraseCreature:				Character 		-> int				-> unit
and characterStartQuest:		Character		-> Quest			-> int		-> unit

and addCharacterItemFoundOnTile:Character 		-> int 				-> int 		-> int 	-> int -> int -> unit
and addCharacterKillUnitOnTile:	Character 		-> int 				-> int 		-> int 	-> unit
and characterTalkToNPC:			Character 		-> QuestsDatabase	-> int		-> unit
and characterKillCreature:		Character 		-> QuestsDatabase	-> int		-> unit
and characterCaptureCreature:	Character 		-> QuestsDatabase	-> int		-> unit
and	characterVisitMap:			Character		-> QuestsDatabase	-> int		-> unit
and	characterFindItem:			Character		-> QuestsDatabase	-> int		-> unit
and characterQuestReward:		Character 		-> Quest			-> int		-> unit
and characterBroughtObjects:	Character		-> QuestsDatabase	-> int		-> int	-> int	-> unit
and	characterProcessBringObjects:Character		-> QuestsDatabase	-> ObjectDatabase 	-> int	-> unit
;;	

value printQuests : Character -> unit;;	


