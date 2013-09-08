
#open "gameInformation";;
#open "fileParsing";;
#open "creature";;
#open "quests";;
#open "graphicsInterface";;
#open "object";;

(* Character type :
	information are the GameInformations (statistics
	name is the name of the character
	creatures is a list of the creatures that the character owns
	position is the position of the character
	quests is a list of the current quests, with their states
	inventory is a vect containing indexes of items the character owns and their count *)
type Character = {
			information : GameInformation;
	mutable name : string;
	mutable creatures : Creature vect;
	mutable position : Position;
	mutable quests : (int*(bool vect)) list; (* (questIndex, vector of alreadyDone actions *)
	mutable inventory : (int*int) vect; (* reference,quantity *)
};;

let getDefaultCharacter () = {information=getDefaultGameInfo (); name=""; creatures=[||]; position={x=0.;y=0.}; quests=[]; inventory=[||];};;

(* getStringPosition function
	returns a string like "XXXXYYY" according to a given position *)
let getStringPosition position =
	let foo,bar = string_of_int (int_of_float position.x), string_of_int (int_of_float position.y) in
	let model = "0000" in
	(sub_string model 0 (4-(string_length foo)))^foo^(sub_string model 0 (3-(string_length bar)))^bar;;

(* positionOfString function
	returns a position related to a given string like "XXXXYYY" *)
let positionOfString str =
	{ x=float_of_int (int_of_string (sub_string str 0 4)); y=float_of_int (int_of_string (sub_string str 4 3)) };;

(* creatureDataString function
	creates a (9.9.9.9) string containing a creature's information *)
let creatureDataString creature =
	(getString9 (getCreatureLife creature) 9)^(getString9 (getCreatureMana creature) 9)^(getString9 (int_of_float (getCreatureExperience creature)) 9)^(getString9 (getCreatureReference creature) 9);;

(* creaturesDataString function
	returns a string encoding a vector of creatures *)
let creaturesDataString v = 
	let size = vect_length v in
	let rec process = function
		| i when i=size -> ""
		| i 			-> (creatureDataString v.(i))^(process (i+1))
	in 
		process 0;;

(* inventoryDataString function
	returns a string encoding a vector representing inventory (4.9 ref.count)*)
let inventoryDataString v =
	let s = vect_length v in
	let rec process = function
		| i when i=s 	-> ""
		| i 			-> let a,b = v.(i) in (getString9 a 4)^(getString9 b 9)^(process (i+1))
	in
		process 0;;

let questWritingString (id, vect) =
	let n = vect_length vect - 1 in
	let ret = ref "[" in	
	ret := !ret^(string_of_int (n+1));
	ret := !ret^";";
	for i = 0 to n do
		ret := !ret^(if vect.(i)=true then "1" else "0");
	done;
	ret := !ret^";";
	ret := !ret^(string_of_int id);
	ret := !ret^"]";
	!ret;
	;;

let rec questsWritingString = function
	| [] -> ""
	| t::[] -> questWritingString t
	| t::q::r -> (questWritingString t)^" "^(questsWritingString (q::r))
	;;

(* saveCharacter function
	writes a character according to a given filename *)
let saveCharacter filename personnage =
	let stream = open_out filename in
	output_string stream "<Character>\n";
	output_string stream "	P_Name= \"Nimur\"\n";
	output_string stream ("	P_Position= \""^(getStringPosition (personnage.position))^"\"\n"); (* 4 3 ints represent the XXXX*YYY pos *)
	output_string stream ("	P_Creatures= \""^(creaturesDataString (personnage.creatures))^"\"\n");
	output_string stream ("	P_Quests= \""^(questsWritingString (personnage.quests))^"\"\n");
	output_string stream ("	P_Inventory= \""^(inventoryDataString (personnage.inventory))^"\"\n");
	output_string stream "GAMEINFOS=\n";
	saveGameInformation stream (personnage.information);
	output_string stream "</Character>\n";
	close_out stream;
	;;

(* readCreature function
	reads a Creature from a 9.9.9.9-string *)
let readCreature str =
	let creature = getDefaultCreature () in
	match intListOfFormatedString 9 str with
		| a::b::c::d::_ -> begin
			setCreatureLife creature a;
			setCreatureMana creature b;
			setCreatureExperience creature (float_of_int c);
			setCreatureReference creature d;
			creature
			end
		| _ -> failwith "Error while running readCreature function. Lack of data.";;

(* readCreatures function
	read a vect of creatures from a (9.9.9.9)*-string *)
let readCreatures str =
	let nb = (string_length str)/36 in
	let v = make_vect nb (getDefaultCreature ()) in
	let rec read i = function
		| "" -> v
		| s  -> begin 
				v.(i) <- (readCreature (sub_string s 0 36));
				(read (i+1) (sub_string s 36 (string_length s - 36)))
			end
	in
	read 0 str;;

(* readQuests function
	reads a character's quests : the form is 
	P_Quests= "[actionsNumber;actionsNumber booleans to say if the actions were done or not;quest ID] [otherquest...] [...] ..."
	P_Quests= "[5;01011;1]" *)
let rec readQuests str = 
	let n = string_length str - 1 in
	let step = ref 0 in
	let tmp = ref "" in
	let retVect = ref [||] in
	let retIndex = ref 0 in
	let cnt = ref 0 in
	let retList = ref [] in
	for i=0 to n do
		if nth_char str i = `[`  && !step = 0 then begin
			step := 1;
			cnt := 0;
		end else if nth_char str i = `;` && !step = 1 then begin
			retVect := make_vect (int_of_string !tmp) false;
			tmp := "";
			step := 2;
		end else if nth_char str i = `;` && !step = 2 then begin
			tmp := "";
			step := 3;
		end else if nth_char str i = `]` && !step = 3 then begin
			retIndex := int_of_string !tmp;
			step := 0;
			tmp := "";
			retList := (!retIndex, !retVect)::(!retList);
		end else if !step = 2 then begin
			!retVect.(!cnt) <- if nth_char str i = `0` then false else true;
			cnt := !cnt + 1;
		end else if !step = 1 or !step = 3 then begin
			tmp := !tmp^(string_of_char (nth_char str i));
		end
	done;
	!retList;	
	;;

(* readInventory function
	reads an inventory from (4.9)*-string *)
let readInventory str = 
	let nb = (string_length str)/(4+9) in
	let v = make_vect nb (0,0) in
	let rec process l1 l2 i = function
		| "" -> v
		| s -> begin
				v.(i) <- ((int_of_string (sub_string s 0 l1)),(int_of_string (sub_string s l1 l2)));
				(process l1 l2 (i+1) (sub_string s (l1+l2) (string_length s - l1 - l2)));
			end
	in process 4 9 0 str;;

(* loadCharacter function
	loads a character from a given filename *)
let loadCharacter filename =
	let stream = open_in filename in
	try
		let character = { name=""; position={x=0.;y=0.}; creatures=[||]; quests=[]; inventory=[||]; information=getDefaultGameInfo () } in
		let tester = ref false in
		let started = ref false in
		let content = ref "" in
		while (!started <> true) do (* wait a <Character> flag to begin reading *)
			content := input_line stream;
			if !content = "<Character>" then
				started := true
			else
				failwith "Some data has been jumped by the loadCharacter function.";
		done;
		while (!tester = false) do (* process until we find </Character> *)
			content := input_line stream;
			if !content = "</Character>" then (* if we find a </Character> flag, stop reading and return read char *)
				tester := true
			else if !content = "GAMEINFOS=" then (* else, read character global informations and specific ones *) begin
				readGameInformation stream (character.information);
			end else begin
				let prop,propVal = parseProperty (!content) in
				match prop with
					| "Name"		-> character.name 		<- propVal
					| "Position" 	-> character.position 	<- (positionOfString propVal)
					| "Creatures" 	-> character.creatures 	<- (readCreatures propVal)
					| "Quests" 		-> character.quests 	<- (readQuests propVal)
					| "Inventory" 	-> character.inventory 	<- (readInventory propVal)
					| _ -> failwith "Undeclared field found while running loadCharacter function."
			end 
			
		done;
		character
	with
		| End_of_file -> failwith "Big mistake during loadCharacter file processing : the file shoudln't be ending here.";;


let biggerInventory size v2 =
	let n2 = vect_length v2 in
	let newVect = make_vect size (-1,-1) in
	for i=0 to n2 - 1 do
		newVect.(i) <- v2.(i);
	done;
	newVect;
	;;

(*searchs for an item index in the inventory and returns (-1) if it doesn't exist or its place in the inventory if it exists*)
let searchItemIndex character index=
let p=ref (-1) and n=vect_length (character.inventory) in
	for i=0 to (n-1) do
		let (a,b)=(character.inventory).(i) in
			if  index=a then p:=i
	done;!p;;



let getCharacterCreatures character = character.creatures;; 
let getCharacterInformation character = character.information;;
let getCharacterPosition character = character.position;;
let getCharacterInventory character = character.inventory;;
let getCharacterMaxCreatureLvl character =
	let v = character.creatures in
	let n = vect_length v - 1 in
	let max = ref 0 in
	for i = 0 to n do
		if Lvl v.(i) > !max then
			max := Lvl v.(i);
	done;
	!max;;
let getCharacterActionDoneTiles character = getGameInfoActionDoneTiles (character.information);;

let getCharacterQuests character = 
	let rec getIndexes = function
		| [] -> []
		| (a,_)::q -> a::(getIndexes q)
	in
		getIndexes (character.quests);;

let getCharacterQuestState character questID =
	let rec finished v = function
		| -1 -> true
		| i -> if v.(i) = false then false else finished v (i-1)
	in
	let rec isDoing = function
		| [] -> "tbs"
		| (a, b)::q -> if a=questID then if finished b (vect_length b - 1) then "finished" else "tbd" else isDoing q
	in
	let rec hasDone = function
		| [] -> "tbs"
		| a::q -> if a=questID then "done" else hasDone q
	in
	let foo = isDoing (character.quests)in
	if foo <> "tbs" then foo  
	else hasDone (getGameInfoDoneQuests (character.information))
;;	

let getCharacterQuestActions character questID =
	let rec getIt = function
		| [] -> [||]
		| (id,vect)::q -> if id = questID then vect else getIt q
	in
		getIt (character.quests)
;;

let setCharacterPosition character position = character.position <- position;;
let setCharacterName character name = character.name <- name;;
let setCharacterInventory character vect=character.inventory<- vect;;

let addItemInInventory character index number = 
	let realIndex = (if index >= 10 && index < 20 then 10 (* it's gold *) else index) in
	let pocket=(searchItemIndex character realIndex) in
		if pocket=(-1) then
			begin
			if (vect_length (character.inventory))<9 then
				begin
				let ret = biggerInventory (vect_length (character.inventory) + 1) (character.inventory) in
				ret.(vect_length (character.inventory)) <- (realIndex, number);
				character.inventory <- ret;
				end
			else showPopupMessage ("You did not receive the object because \n your inventory is full") 1.0		
			end
		else  let (a,b)=(character.inventory).(pocket) in (character.inventory).(pocket)<-(realIndex,b+number)
	;;
let rec addItemsInInventory character = function
	| [] -> ()
	| t::q -> begin addItemInInventory character t 1; addItemsInInventory character q end;;


let addCharacterItemFoundOnTile character positionX positionY mapIndex itemIndex quantity =
	addItemInInventory character itemIndex quantity;
	addGameInfoActionDoneTile character.information positionX positionY mapIndex;;
let addCharacterKillUnitOnTile character positionX positionY mapIndex =
	addGameInfoActionDoneTile character.information positionX positionY mapIndex;;

exception OutOfLoop;;
let removeItemsFromInventory character objId amount = 
	let n = vect_length (character.inventory) - 1 in
	try
		for i=0 to n do
			let (a,b)=(character.inventory).(i) in
			if a = objId then begin
				if b>amount then begin
					(character.inventory).(i)<-(a,b-amount); 
					raise OutOfLoop;
				end else begin
					let newVect=make_vect n (-1,-1) in
					for j= 0 to (i-1) do newVect.(j)<-(character.inventory).(j) done;
					for j= i+1 to n do newVect.(j-1)<-(character.inventory).(j) done;
					character.inventory <- newVect;
					raise OutOfLoop;
				end
			end;
		done;
	with
		| OutOfLoop -> ()
	;;

let removeItemFromInventory character pocket= 
	let (a,b)=(character.inventory).(pocket) in
			if b>1 then  (character.inventory).(pocket)<-(a,b-1)
			else begin
				let n=vect_length (character.inventory) in
				let newVect=make_vect (n-1) (-1,-1) in
				for i= 0 to (pocket-1) do newVect.(i)<-(character.inventory).(i) done;
				for i= pocket to (n-2) do newVect.(i)<-(character.inventory).(i+1) done;
				character.inventory <- newVect;
			end
	;;

let biggerCreatureVect size v2 =
	let n2 = vect_length v2 in
	let newVect = make_vect size (getDefaultCreature ()) in
	for i=0 to n2 - 1 do
		newVect.(i) <- v2.(i);
	done;
	newVect;
	;;

let addCreature character creature=
			let ret = biggerCreatureVect (vect_length (character.creatures) + 1) (character.creatures) in
			ret.(vect_length (character.creatures)) <- creature;
			character.creatures <- ret;
	;;
let rec addCreatures character = function
	| [] -> ()
	| t::q -> begin addCreature character (begin let defCre = getDefaultCreature() in setCreatureReference defCre t; defCre end); addCreatures character q end;;

let addExperienceToCreatures character exp =
	let n = vect_length (character.creatures) - 1 in
	for i=0 to n do
		addExperience (character.creatures.(i)) exp;
	done;;

let eraseCreature character param=
	begin
		let n=vect_length (character.creatures) in
		let newVect=make_vect (n-1) (getDefaultCreature ()) in
		for i= 0 to (param-1) do newVect.(i)<-(character.creatures).(i) done;
		for i= param to (n-2) do newVect.(i)<-(character.creatures).(i+1) done;
		character.creatures <- newVect;
	end
;;

let characterStartQuest character quest questIndex=
	character.quests <- (questIndex,(make_vect (getQuestActionsCount quest) false))::(character.quests);
	showPopupMessage ("You started the quest \""^(getQuestTitle quest)^"\".") 4.0;
	;;

let characterUpdateQuests character =
	let rec insideUpdateQuests = function
		| [] -> []
		| (id,vect)::q -> begin let n = vect_length vect - 1 in
			let pt = ref true in
			for i = 0 to n do if vect.(i) = false then pt := false done;
			if !pt then begin (* add the quest in game infos *) 
				gameInfoAddQuest (character.information) id;
				insideUpdateQuests q;
			end else
				(id,vect)::insideUpdateQuests q; 
			end
	in
	character.quests <- (insideUpdateQuests character.quests);;

let characterQuestReward character quest questID =
	let rec removeQuest id = function
		| [] -> []
		| (a,b)::q -> if a=id then removeQuest id q else (a,b)::(removeQuest id q)
	in
	character.quests <- removeQuest questID (character.quests);
	gameInfoAddQuest (character.information) questID;
	(* reward the character *)
	let expEarned = getQuestExperienceEarned quest in
	let objEarned = getQuestObjectsEarned quest in
	let creaEarned = getQuestCreaturesEarned quest in
	
	addExperienceToCreatures character (float_of_int expEarned);
	addItemsInInventory character objEarned;
	addCreatures character creaEarned;

	showPopupMessage ("You Finished the quest "^(getQuestTitle quest)^" and received \n"^(string_of_int expEarned)^"XP, "^(string_of_int (list_length objEarned))^" objects and "^(string_of_int (list_length creaEarned))^" creatures.") 8.0;
	;;
			
(* check if a quest is sorted and add the action if it's consistent *)
let checkSortedAndAddAction questsDatabase questID questVect editID =
	if getQuestSorted (getQuest questsDatabase questID) then begin
		let canEdit = ref true in
		for i=0 to editID-1 do
			if questVect.(i) = false then canEdit := false;
		done;
		if !canEdit then
			questVect.(editID) <- true;
	end	else
		questVect.(editID) <- true;;

let characterTalkToNPC character questsDatabase npc =
	let rec insideUpdateQuests = function
		| [] -> []
		| (id,vect)::t ->  
			let ret = questTalkToNPC (getQuest questsDatabase id) npc in
			if ret = -1 then begin
				(id,vect)::(insideUpdateQuests t);
			end else begin
				checkSortedAndAddAction questsDatabase id vect ret;
				(id, vect)::(insideUpdateQuests t);
			end
	in
	character.quests <- (insideUpdateQuests character.quests);;

let characterKillCreature character questsDatabase creature =
	let rec insideUpdateQuests = function
		| [] -> []
		| (id,vect)::t ->  
			let ret = questKillCreature (getQuest questsDatabase id) creature in
			if ret = -1 then begin
				(id,vect)::(insideUpdateQuests t);
			end else begin
				checkSortedAndAddAction questsDatabase id vect ret;
				(id, vect)::(insideUpdateQuests t);
			end
	in
	character.quests <- (insideUpdateQuests character.quests);;

let characterCaptureCreature character questsDatabase creature =
	let rec insideUpdateQuests = function
		| [] -> []
		| (id,vect)::t ->  
			let ret = questCaptureCreature (getQuest questsDatabase id) creature in
			if ret = -1 then begin
				(id,vect)::(insideUpdateQuests t);
			end else begin
				checkSortedAndAddAction questsDatabase id vect ret;
				(id, vect)::(insideUpdateQuests t);
			end
	in
	character.quests <- (insideUpdateQuests character.quests);;

let characterVisitMap character questsDatabase mapIndex =
	let rec insideUpdateQuests = function
		| [] -> []
		| (id,vect)::t ->  
			let ret = questVisitMap (getQuest questsDatabase id) mapIndex in
			if ret = -1 then begin
				(id,vect)::(insideUpdateQuests t);
			end else begin
				checkSortedAndAddAction questsDatabase id vect ret;
				(id, vect)::(insideUpdateQuests t);
			end
	in
	character.quests <- (insideUpdateQuests character.quests);;

let characterFindItem character questsDatabase itemID =
	let rec insideUpdateQuests = function
		| [] -> []
		| (id,vect)::t ->  
			let ret = questFindItem (getQuest questsDatabase id) itemID in
			if ret = -1 then begin
				(id,vect)::(insideUpdateQuests t);
			end else begin
				checkSortedAndAddAction questsDatabase id vect ret;
				(id, vect)::(insideUpdateQuests t);
			end
	in
	character.quests <- (insideUpdateQuests character.quests);;

let characterBroughtObjects character questsDatabase objId quantity npc = 
	let rec insideUpdateQuests alreadyUpdated = function
		| [] -> []
		| (id,vect)::t ->  
			let ret = questBringObjects (getQuest questsDatabase id) (objId,quantity,npc) in
			if ret = -1 or alreadyUpdated then begin
				(id,vect)::(insideUpdateQuests alreadyUpdated t);
			end else begin
				checkSortedAndAddAction questsDatabase id vect ret;
				(id,vect)::(insideUpdateQuests true t);
			end
	in
		character.quests <- (insideUpdateQuests false character.quests);
	;;


exception CloseDialog;;
exception MustExit;;
exception Accept of int;;


let hasEnoughInInventory v objectId amount =
	let n = vect_length v - 1 in
	try
		for i=0 to n do
			let (id,nb) = v.(i) in
			if id = objectId && nb >= amount then raise (Accept(0));
		done;
		false;
	with
		| Accept(_) -> true;;

let characterProcessBringObjects character questsDatabase objectsDatabase npc = 
	let rec addIDToObjectsToBring id = function
		| [] -> []
		| (a,b,c)::q -> (a,b,c,id)::(addIDToObjectsToBring id q)
	in
	let rec findQuests = function
		| [] -> []
		| (id, vect)::t -> begin
			let objects = (getQuestObjectsToBringToNPC (getQuest questsDatabase id) npc) in
			if list_length objects > 0 then	begin				
				(addIDToObjectsToBring id objects)@(findQuests t)
			end else 
				findQuests t
		end
	in	
	let rec askPlayerToComplete = function
		| [] -> ()
		| (objId, amount, actionID, questID)::q -> begin (* ask player to choose *)
			if not (getCharacterQuestActions character questID).(actionID) then begin
				if hasEnoughInInventory (character.inventory) objId amount then begin (* check that the player has what's needed *) 

					setDialogText ("Accomplishing a quest :\\nDo you want to give "^(string_of_int amount)^" "^(getObjectName (getObjectByIndex objectsDatabase objId))^" to this person ?");
					clearDialogAnswers ();
					addDialogAnswer "Yes";
					addDialogAnswer "No";
					enableDialog();
					try
						let pos = ref 1 in
						while true do
							let a = ref 0 in
							while !a <> -1 do (* get all the events stack *)	
								a := getEvent();
								if !a = -666 or !a = 1 then (* closed window, escape char *)
									raise MustExit
								else if !a = 789 or !a = 104 then (*  *)
									raise (Accept(!pos))
								else if !a = 100 then (* Up key *)
									pos := 1
								else if !a = 101 then (* Down key *)
									pos := 0;
							done;
							setSelectorPos(!pos);
							drawWindow();
						done
					with
						| (Accept(pos)) -> 
							if pos = 1 then begin 
								removeItemsFromInventory character objId amount ;
								characterBroughtObjects character questsDatabase objId amount npc;
							end else 
								();
					disableDialog ();
				end;
			end;
			
			askPlayerToComplete q;
		end	
	in
	askPlayerToComplete (findQuests character.quests)
	;;

	

let printQuests character = 
	print_string "Will print quests :"; print_newline ();
	if character.quests = [] then begin
		print_string "No quests. Will crash now"; print_newline (); end;
	let (a,b) = match character.quests with
		 (a,b)::_ -> (a,b) 
		| _ -> failwith "Error"
	in
	print_int a;
	print_string " ";
	for i=0 to vect_length b-1 do
		print_string (if b.(i) then "true " else "false ");		
	done;
	print_newline ();
	;;








