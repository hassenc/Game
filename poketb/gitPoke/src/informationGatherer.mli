#open "dialogFunctions";;
#open "main";;
#open "character";;

value 	
	 	getOwnedCreaturesList : 	Answer list 	-> GameData 	-> int 	-> Answer list
and 	getOwnedObjectsList : 		Answer list 	-> GameData 	-> int 	-> Answer list
(*									answers added	-> gameData		-> offset *)
and		getVisitedMapList : 		Answer list 	-> GameData 	-> int 	-> Answer list
and		getVisitedMapString : 		GameData 		-> string
and 	addCorrespondingAnswers : 	Answer list 	-> GameData 	-> int	-> DataType	-> Answer list
;;
