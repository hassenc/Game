#open "creature";;
#open "referenceCreature";;
#open "main";;
#open "character";;

exception I_Win;;
exception Game_Over;;
exception Not_Enough_Mana_Life;;
exception Run_Away;;

value accessAction:		Character 	-> 	Creature 	->	Creature 	-> 	FightAction	->	bool	->	unit 
and	hit:				int			->	GameData 	->	Creature	->	unit
and	useItem:			int			->	GameData 	->	Creature	->	unit
and	changeCreature:		int			->	GameData 	->	unit
and	stillAlive:			GameData 	->	bool
and	hitMe:				GameData 	-> 	Creature 	->	Creature 	-> 	int		->	unit
and	gameOver:			unit		->	unit
and	win:				GameData 	->	int			->	unit
and	setRightCreature:	Creature 	->	unit
and	setLeftCreature:	Creature 	->	unit
and run:				int			->	GameData 	->	Creature	->	unit
and deleteCreature:		int			->	GameData 	->	unit
and	win: 				GameData 	->	int			->	unit
;;
