#open "dialogFunctions";;
#open "fightDialogFunctions";;
#open "main";;
#open "character";;
#open "creature";;

value	getAvaiableActionsList : 	FightAnswer list 	-> GameData 	-> int 	-> FightAnswer list
and 	getAvaiableCreaturesList : 	FightAnswer list 	-> GameData 	-> int 	-> FightAnswer list
and	getAvaiableItemsList : 		FightAnswer list 	-> GameData 	-> int 	-> FightAnswer list
and 	getAllCreaturesList : 	FightAnswer list 	-> GameData 	-> int 	-> FightAnswer list
and 	addCorrespondingAnswers2 : 	FightAnswer list 	-> GameData 	-> int	-> DataFightType	-> FightAnswer list
and	getSelectedAction: 		int			->GameData 		-> string
and	getSelectedCreature: 		GameData		->	string
and	getSelectedEnemy: 		Creature		->	string
and	getSelectedItem: 		int			->GameData 		-> string
;;
