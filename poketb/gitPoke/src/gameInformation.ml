
#open "fileParsing";;
#open "graphicsInterface";;

(* Tropy type 
	enumeration of trophies *)
type Trophy = Wood | Stone | Iron | Copper | Bronze | Silver | Gold | Platinum | Sapphire | Emerald | Ruby | Diamond;;

(* GameInformatiosn type
	damageDealt : damage dealt over the whole game
	fightsWon : fights done over the whole game
	...
	*)
type GameInformation = {
	mutable damageDealt : int;
	mutable fightsWon : int;
	mutable experienceObtained : float;
	mutable goldObtained : int;
	mutable questsDone : int list;
	mutable capturedCreatures : int list;
	mutable trophyPoints : int;
	mutable visitedMaps : int list;
	mutable gatheredTiles : (int*int*int) list;
};;

let getDefaultGameInfo () =
	{damageDealt=0; fightsWon=0; experienceObtained=0.0; goldObtained=0; questsDone=[]; capturedCreatures=[]; trophyPoints=0; visitedMaps=[]; gatheredTiles=[]};;

(* getString4 function
	adds the required number of zeros to a string to be 3 characters long *)
let getString3 data =
	let a = "000" in
	let tmp = string_of_int data in
	(sub_string a 0 (3-(string_length tmp)))^tmp;;

(* getString4 function
	adds the required number of zeros to a string to be 4 characters long *)
let getString4 data =
	let a = "0000" in
	let tmp = string_of_int data in
	(sub_string a 0 (4-(string_length tmp)))^tmp;;

(* stringOfIntList3 function
	converts an int list into a 3*-string *)
let rec stringOfIntList3 = function
	| [] -> ""
	| t::q -> (getString3 t)^(stringOfIntList3 q);;


let ints3OfString3 strin = (int_of_string (sub_string strin 0 3), int_of_string (sub_string strin 3 3), int_of_string (sub_string strin 6 3));;
let string3Of3Ints a b c = (getString3 (a))^(getString3 (b))^(getString3 (c));;

let rec gatheredTilesToString = function
	| [] -> ""
	| (a,b,c)::q -> (string3Of3Ints a b c)^(gatheredTilesToString q);;

let stringToGatheredTiles s = 
	let rec getOne = function 
		| "" -> []
		| str -> (ints3OfString3 (sub_string str 0 9))::(getOne (sub_string str 9 (string_length str - 9)))
	in getOne s;;

(* stringOfIntList4 function
	converts an int list into a 4*-string *)
let rec stringOfIntList4 = function
	| [] -> ""
	| t::q -> (getString4 t)^(stringOfIntList4 q);;

(* saveGameInformations function
	saves GameInformations into a given stream *)
let saveGameInformation stream infos = 
	output_string stream "<GameInformations>\n";
	output_string stream ("	P_Dmg= \""^(string_of_int (infos.damageDealt))^"\"\n");
	output_string stream ("	P_FightsWon= \""^(string_of_int (infos.fightsWon))^"\"\n");
	output_string stream ("	P_XP= \""^(string_of_float (infos.experienceObtained))^"\"\n");
	output_string stream ("	P_Gold= \""^(string_of_int (infos.goldObtained))^"\"\n");
	output_string stream ("	P_Points= \""^(string_of_int (infos.trophyPoints))^"\"\n");
	output_string stream ("	P_Visited= \""^(stringOfIntList3 (infos.visitedMaps))^"\"\n");
	output_string stream ("	P_Quests= \""^(stringOfIntList4 (infos.questsDone))^"\"\n");
	output_string stream ("	P_Captured= \""^(stringOfIntList4  (infos.capturedCreatures))^"\"\n");
	output_string stream ("	P_Gathered= \""^(gatheredTilesToString (infos.gatheredTiles))^"\"\n");
	output_string stream "</GameInformations>\n";
;;

(* readGameInformations function
	opens a file and read GameInformations inside, putting it into gi(parameter of type GameInf..) *)
let readGameInformation file gi =
	try
		let tester = ref false in
		let started = ref false in
		let content = ref "" in
		while (!started <> true) do (* wait to start *)
			content := input_line file;
			if !content = "<GameInformations>" then
				started := true
			else
				failwith "Some data has been jumped by the readGameInformations function.";
		done;
		while (!tester = false) do (* wait to end *)
			content := input_line file;
			if !content = "</GameInformations>" then
				tester := true
			else begin
				let prop,propVal = parseProperty (!content) in
				match prop with
					| "Dmg" 	-> gi.damageDealt 			<- (int_of_string propVal)
					| "FightsWon"-> gi.fightsWon			<- (int_of_string propVal)
					| "XP"		-> gi.experienceObtained 	<- (float_of_string propVal)
					| "Gold" 	-> gi.goldObtained 			<- (int_of_string propVal)
					| "Points" 	-> gi.trophyPoints 			<- (int_of_string propVal)
					| "Visited" 	-> gi.visitedMaps 			<- (intListOfFormatedString 3 propVal)
					| "Quests"  	-> gi.questsDone 			<- (intListOfFormatedString 4 propVal)
					| "Captured"	-> gi.capturedCreatures 	<- (intListOfFormatedString 4 propVal)
					| "Gathered"	-> gi.gatheredTiles 		<- (stringToGatheredTiles propVal)
					| _ -> failwith "An unknown field appeared while readingGameInformations."
			end
			
		done;
		
	with
		| End_of_file -> failwith "Big mistake during readGameInformations file processing : the file shoudln't be ending here.";;

(* getTrophy function
	returns a trophy according to the points that has the player *)
let getTrophy points = 
	let number = int_of_float ( sqrt (float_of_int (points/20))) in
	match number with
		| 0 -> Wood
		| 1 -> Stone
		| 2 -> Iron
		| 3 -> Copper
		| 4 -> Bronze
		| 5 -> Silver
		| 6 -> Gold
		| 7 -> Platinum
		| 8 -> Sapphire
		| 9 -> Emerald
		| 10 -> Ruby
		| 11 -> Diamond
		| _ -> Diamond
;;

let getGameInfoTrophy info =
	getTrophy (info.trophyPoints);;

(* add a map if it hasn't been visited yet *)
let addGameInfoVisitedMap info map = 
	let rec process item = function
		| [] -> [item]
		| h::t -> if h=item then h::t else h::process item t
	in
		info.visitedMaps <- process map (info.visitedMaps);;

let addGameInfoActionDoneTile gameInfo posX posY map =
	gameInfo.gatheredTiles <- ((posX,posY,map)::(gameInfo.gatheredTiles));;
let addGameInfoKilledCreature info = info.fightsWon <- info.fightsWon+1;;
let addGameInfoCapturedCreature info creature = info.capturedCreatures <- creature::info.capturedCreatures;;
let addGameInfoExperienceObtained info xp = 
	
	if info.experienceObtained < 100.0 && info.experienceObtained +. xp >= 100.0 then
		showPopupMessage "Congratulations! You earned more than 100 experience points !!" 4.0;
	if info.experienceObtained < 1000.0 && info.experienceObtained +. xp >= 1000.0 then
		showPopupMessage "Amazing! You have earned more than 1 000 xp. That's something." 5.0;
	if info.experienceObtained < 10000.0 && info.experienceObtained +. xp >= 10000.0 then
		showPopupMessage "Amazing! You've reached 10 000 earned experience !!\nWyms must be terrified." 6.0;
	if info.experienceObtained < 100000.0 && info.experienceObtained +. xp >= 100000.0 then
		showPopupMessage "Impressive. You've earved 100 000 experience points on Ozixya !!\nContinue this way ;)" 6.0;
	if info.experienceObtained < 1000000.0 && info.experienceObtained +. xp >= 1000000.0 then
		showPopupMessage "Congratz! You have gathered more than 1 000 000 experience points.\nGG !! :)" 7.0;

	info.experienceObtained <- info.experienceObtained +. xp;;

let addGameInfoDamageDealt info damage = 
	if info.damageDealt < 100 && info.damageDealt + damage >= 100 then
		showPopupMessage "You did more than 100 damage !! Congratulations." 4.0;
	if info.damageDealt < 1000 && info.damageDealt + damage >= 1000 then
		showPopupMessage "Hey! You dealt over 1 000 damage on Ozixya's Wyms !\n That's great !" 5.0;
	if info.damageDealt < 9000 && info.damageDealt + damage >= 9000 then
		showPopupMessage "Your damage is now over 9000." 5.0;
	if info.damageDealt < 10000 && info.damageDealt + damage >= 10000 then
		showPopupMessage "Amazing! You've reached 10 000 dealt damage !!\nConsider joining the elite forces." 5.0;
	if info.damageDealt < 100000 && info.damageDealt + damage >= 100000 then
		showPopupMessage "Impressive. You've managed to deal more than 100 000 damage !!\nSerial Killer." 6.0;
	if info.damageDealt < 1000000 && info.damageDealt + damage >= 1000000 then
		showPopupMessage "Congratz! You dealt 1 000 000 damage since you're with us.\nIt's freakening." 7.0;
	info.damageDealt <- info.damageDealt + damage;;

let addGameInfoGoldObtained info gold = 
	if info.goldObtained < 100 && info.goldObtained + gold >= 100 then
		showPopupMessage "Congratulations! You earned more than 100 gold !!" 4.0;
	if info.goldObtained < 1000 && info.goldObtained + gold >= 1000 then
		showPopupMessage "Amazing! You earned more than 1 000 gold !\nYou're on a good way to victory." 4.0;
	if info.goldObtained < 10000 && info.goldObtained + gold >= 10000 then
		showPopupMessage "Amazing! You've reached 10 000 earned gold !!\nThere's not a lot of people as good as you." 5.0;
	if info.goldObtained < 100000 && info.goldObtained + gold >= 100000 then
		showPopupMessage "Impressive. You've earved 100 000 gold on Ozixya !!\nThat's not common at all !" 6.0;
	if info.goldObtained < 1000000 && info.goldObtained + gold >= 1000000 then
		showPopupMessage "Congratz! You earned 1 000 000 gold since you're with us.\nAre you in the mafia so that you earn so much money ?" 8.0;

	info.goldObtained <- info.goldObtained + gold;
	;;

let getGameInfoVisitedMaps info = info.visitedMaps;;
let getGameInfoDoneQuests info = info.questsDone;;
let getGameInfoActionDoneTiles info = info.gatheredTiles;;
let getGameInfoTrophyPoints info = info.trophyPoints;;
let getGameInfoHasDoneQuest info i =
	let rec process = function
		| [] -> false
		| t::q -> if t=i then true else process q
	in
		process (info.questsDone);;
let addGameInfoTrophyPoints info points = 
	info.trophyPoints <- info.trophyPoints + points;;
let hasGameInfoBeenCaptured info creatureId = 
	let rec process = function
		| [] -> false
		| t::q -> if t = creatureId then true else process q
	in
		process info.capturedCreatures;;

let setGameInfoVisitedMaps info maps = info.visitedMaps <- maps;;

let gameInfoAddQuest info id = info.questsDone <- id::(info.questsDone);;



