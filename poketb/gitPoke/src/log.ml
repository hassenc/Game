#open "character";;
#open "maps";;
#open "object";;
#open "quests";;
#open "NPC";;
#open "graphicsInterface";;
#open "gameInformation";;
#open "main";;

let log_addTrophyPoints character points =
	let info = getCharacterInformation character in
	addGameInfoTrophyPoints info points;
	showPopupMessage ("You have been granted "^(string_of_int points)^" trophy points.") 3.0;	
	setCharacterPoints (getGameInfoTrophyPoints (getCharacterInformation character));
	;;

let log_getExperience character experience =
	print_string ("Log: Player earned "^(string_of_float experience)^" experience points.");
	print_newline ();
	addGameInfoExperienceObtained (getCharacterInformation character) experience;;

let log_dealDamage character damage =
	print_string ("Log: Player dealt "^(string_of_int damage)^" damage points.");
	print_newline ();
	addGameInfoDamageDealt (getCharacterInformation character) damage;;

let log_earnGold character gold =
	print_string ("Log: Player earned "^(string_of_int gold)^" gold.");
	print_newline ();
	addGameInfoGoldObtained (getCharacterInformation character) gold;;

let log_talkToNPC character questsDatabase a =
	print_string ("Log: Character is talking to npc "^(string_of_int a)^".");
	print_newline ();
	characterTalkToNPC character questsDatabase a;
;;

let log_killCreature character questsDatabase creatureID =
	print_string ("Log: Character killed a "^(string_of_int creatureID)^".");
	print_newline ();
	log_addTrophyPoints character 1;
	addGameInfoKilledCreature (getCharacterInformation character);
	characterKillCreature character questsDatabase creatureID;
;;

let log_captureCreature character questsDatabase creatureRefID =
	print_string ("Log: Character captured a "^(string_of_int creatureRefID)^".");
	print_newline ();
	log_addTrophyPoints character 1;
	(* if this creature hasn't benn captured yet, even more points*)
	if (hasGameInfoBeenCaptured (getCharacterInformation character) creatureRefID) = false then begin
		print_string ("Log: The wym captured has never been captured before. So the player earns 5 more trophy points.");
		print_newline ();
		log_addTrophyPoints character 5;
		addGameInfoCapturedCreature (getCharacterInformation character) creatureRefID;
	end;
	characterCaptureCreature character questsDatabase creatureRefID;
;;

let log_killUnitOnTile character positionX positionY mapIndex =
	print_string ("Log: Killed a unit on a tile.");
	print_newline ();
	addCharacterKillUnitOnTile character positionX positionY mapIndex;
;;

let log_findItemOnTile character questsDatabase positionX positionY mapIndex itemIndex quantity =
	print_string ("Log: Character found "^(string_of_int quantity)^" "^(string_of_int itemIndex)^" on a tile.");
	print_newline ();
	(* special items rewards *)
	
	(* end of special rewarding *)
	characterFindItem character questsDatabase itemIndex;
	addCharacterItemFoundOnTile character positionX positionY mapIndex itemIndex quantity;
;;

let rec findGoldInObjects objDB = function
	| [] -> 0
	| t::q -> if getObjectName (getObjectByIndex objDB t) = "Gold" then (getObjectGivenAmountByID objDB t) + (findGoldInObjects objDB q)  else findGoldInObjects objDB q
	;;

let log_rewardFinishedQuest gameData quest questID =
	print_string ("Log: The quest "^(string_of_int questID)^" is rewarded and stored.");
	print_newline ();
	characterQuestReward gameData.character quest questID;
	log_getExperience gameData.character (float_of_int (getQuestExperienceEarned quest));
	log_earnGold gameData.character (findGoldInObjects (gameData.objectsDatabase) (getQuestObjectsEarned quest));
	log_addTrophyPoints gameData.character (getQuestTrophyPointsEarned quest);
;;

let log_changeMap character questsDatabase mapIndex =
	print_string ("Log: The player is on map "^(string_of_int mapIndex)^".");
	print_newline ();
	characterVisitMap character questsDatabase mapIndex;
;;


