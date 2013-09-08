

type Trophy;;

type GameInformation;;

value	getDefaultGameInfo:				unit 			-> GameInformation 	
and 	getString3: 					int 			-> string
and 	getString4:						int				-> string 
and 	stringOfIntList3: 				int list 		-> string
and 	stringOfIntList4: 				int list		-> string
and 	saveGameInformation: 			out_channel		-> GameInformation -> unit
and 	readGameInformation: 			in_channel		-> GameInformation -> unit
and 	getTrophy:						int 			-> Trophy

and 	addGameInfoVisitedMap:			GameInformation -> int 		-> unit
and 	addGameInfoActionDoneTile:		GameInformation -> int 		-> int 	-> int 	-> unit
and 	addGameInfoTrophyPoints:		GameInformation -> int 		-> unit
and 	addGameInfoKilledCreature:		GameInformation -> unit
and 	addGameInfoCapturedCreature:	GameInformation -> int 		-> unit
and 	addGameInfoExperienceObtained:	GameInformation -> float 	-> unit
and 	addGameInfoDamageDealt:			GameInformation -> int 		-> unit
and 	addGameInfoGoldObtained:		GameInformation -> int 		-> unit

and 	getGameInfoTrophyPoints:		GameInformation -> int 		
and 	getGameInfoVisitedMaps:			GameInformation -> int list
and 	getGameInfoDoneQuests:			GameInformation -> int list
and 	setGameInfoVisitedMaps:			GameInformation -> int list -> unit
and 	getGameInfoHasDoneQuest:		GameInformation -> int 		-> bool
and 	getGameInfoActionDoneTiles:		GameInformation -> (int*int*int) list
and		hasGameInfoBeenCaptured:		GameInformation	-> int		-> bool

and 	gameInfoAddQuest:				GameInformation	-> int		-> unit
;; 



