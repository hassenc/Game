#open "graphicsInterface";;
#open "fileParsing";;
#open "encrypter";;
#open "dialogFunctions";;
#open "dialog";;
#open "gameInformation";;
#open "character";;
#open "creature";;
#open "referenceCreature";;
#open "maps";;
#open "texturesDatabase";;
#open "object";;
#open "fightInterface";;
#open "fightDialog";;
#open "fightDialogFunctions";;
#open "fightFunctions";;
#open "fight";;
#open "NPC";;
#open "quests";;
#open "log";;
#open "generalFunctions";;
#open "unix";;
#open "inventory";;
#open "music";;

(* in
let bz = checkMediaIntegrity () in
let cz = writeSaveIntegrity () in
let dz = checkSaveIntegrity () in
if  bz=1 && dz=1 then begin print_string "It's ok"; print_newline (); end else begin print_string "It's NOT ok"; print_newline (); end;;
*)


let A = 0;;

random__init (time ());;


startMusic();;

(* manage the movement of the character *)
let manageMovement gameData speed =
	let move dir = begin
		let distance = moveCharacter dir speed in
		let pos = getCharacterPosition gameData.character in
		let newpos = {x=pos.x;y=pos.y} in 
		let def = getMapDefinition gameData.currentMap in
		if dir=0 then
			newpos.y <- (pos.y -. distance)
		else if dir=1 then
			newpos.y <- (pos.y +. distance)
		else if dir=2 then
			newpos.x <- (pos.x -. distance)
		else if dir=3 then
			newpos.x <- (pos.x +. distance)
		;
		(* avoid silly crashes because we're out of the map *)
		if newpos.x +. 15.0 < 1.0 then newpos.x <- 1.0 -. 15.0;
		if newpos.x +. 57.9 -. 20.0 > 1079.0 then newpos.x <- 1079.0 -. 57.9 +. 20.0;
		if newpos.y +. 20.0 < 1.0 then newpos.y <- 1.0 -. 20.0;
		if newpos.y +. 57.9 -. 10.0 > 719.0 then newpos.y <- 719.0 -. 57.9 +. 10.; 	

		(* gestion des collisions *)
		let minY, minX, maxY, maxX = newpos.y +. 57.9 -.10., newpos.x+.15., newpos.y+.20., newpos.x +. 57.9 -.20. in
		let tileIndexY2 = (int_of_float minY)/60 in
		let tileIndexY1 = (int_of_float maxY)/60 in
		let tileIndexX1 = (int_of_float minX)/60 in
		let tileIndexX2 = (int_of_float maxX)/60 in
		(* check when he goes top *)
		if dir=0 then
			if def.(tileIndexY1).(tileIndexX1).tile_type == 1 or def.(tileIndexY1).(tileIndexX2).tile_type == 1 then begin
				newpos.y <- float_of_int (tileIndexY1 * 60 + 60 - 20);
			end;
		(* check when he goes bottom *)
		if dir=1 then
			if def.(tileIndexY2).(tileIndexX1).tile_type == 1 or def.(tileIndexY2).(tileIndexX2).tile_type == 1 then begin
				newpos.y <- float_of_int (tileIndexY2 * 60 - 58+10);
			end;
		(* check when he goes left *)
		if dir=2 then
			if def.(tileIndexY1).(tileIndexX1).tile_type == 1 or def.(tileIndexY2).(tileIndexX1).tile_type == 1 then begin
				newpos.x <- float_of_int (tileIndexX1 * 60 + 60 - 15);
			end;
		(* check when he goes right *)
		if dir=3 then
			if def.(tileIndexY1).(tileIndexX2).tile_type == 1 or def.(tileIndexY2).(tileIndexX2).tile_type == 1 then begin
				newpos.x <- float_of_int (tileIndexX2 * 60 - 58 + 20);
			end;
		(* end of collisions *)

		let wasTalking = (gameData.npcToTalk <> (-1,-1)) in
		(* managing NPCs *)
		if def.(tileIndexY1).(tileIndexX1).action = -789 then 
			gameData.npcToTalk <- (tileIndexX1, tileIndexY1)
		else if def.(tileIndexY1).(tileIndexX2).action = -789 then 
			gameData.npcToTalk <- (tileIndexX2, tileIndexY1)
		else if def.(tileIndexY2).(tileIndexX1).action = -789 then 
			gameData.npcToTalk <- (tileIndexX1, tileIndexY2)
		else if def.(tileIndexY2).(tileIndexX2).action = -789 then 
			gameData.npcToTalk <- (tileIndexX2, tileIndexY2)
		else
			gameData.npcToTalk <- (-1,-1);

		if gameData.npcToTalk <> (-1,-1) && wasTalking = false then begin
			let npcIndex = (npcIndexFromPos (gameData.npcDatabase) (gameData.npcToTalk)) in
			let dialog = getNPCDialog (gameData.npcDatabase) npcIndex in
			if dialog >= 0 then
				showPopupMessage "Press space to talk with this character." 1.0
			else
				gameData.npcToTalk <- (-1, -1);
		end;
		(* end of managing NPCs *)

		setCharacterPos newpos.x newpos.y;
		setCharacterPosition gameData.character newpos;
		end
	in (* know which key is down to choose where the character goes *)
	let u,d,l,r = isKeyDown("Up_")=1,isKeyDown("Dow")=1,isKeyDown("Lef")=1,isKeyDown("Rig")=1 in
	if gameData.isMoving then begin
		match gameData.currentDirection with
			| 0 -> if u then move 0 else gameData.isMoving <- false
			| 1 -> if d then move 1 else gameData.isMoving <- false
			| 2 -> if l then move 2 else gameData.isMoving <- false
			| 3 -> if r then move 3 else gameData.isMoving <- false
			| _ -> failwith "unmatched case in manageMovement function (main.ml)";
	end (* char is not moving and a key is pressed : choose a new direction *)
	else begin 
		if u then begin
			gameData.isMoving <- true; gameData.currentDirection <- 0
		end else if d then begin
			gameData.isMoving <- true; gameData.currentDirection <- 1
		end else if l then begin
			gameData.isMoving <- true; gameData.currentDirection <- 2
		end else if r then begin
			gameData.isMoving <- true; gameData.currentDirection <- 3
		end else begin (* no movement key pressed *)	
			characterIdle(gameData.currentDirection)	
		end
	end;
;;

(* check the current tile type (where the user is) and triggers its actions *)
let manageCurrentTile gameData =
	let def = ref (getMapDefinition gameData.currentMap) in
	let currentTileX = ((int_of_float ((getCharacterPosition gameData.character).x) + 29)/60) in
	let currentTileY = ((int_of_float ((getCharacterPosition gameData.character).y) + 29)/60) in
	let tileType = !def.(currentTileY).(currentTileX).action in
	let parameter = !def.(currentTileY).(currentTileX).action_parameter in 
	if gameData.hasJustChangedMap = false && tileType = 1 then begin (* change map action, and we are on the map since some time (hasJustChangedMap) *)
		let mapString = "media/maps/map"^(if parameter/100=0 then "0" else "")^(if parameter/10=0 then "0" else "")^(string_of_int parameter)^".om" in
		gameData.currentMap <- ReadMap (checkFile mapString) (gameData.texturesDatabase);
		updateMap (gameData.currentMap);
		def := getMapDefinition gameData.currentMap;
		(* now find where the character should pop on the new map *)
		let x,y = (ref 0),(ref 0) in
		for i=0 to 11 do for j=0 to 17 do
			(*print_int (!def.(i).(j).action); print_string "\t"; print_int (!def.(i).(j).action_parameter); print_string "\t"; print_int (gameData.currentMapIndex);  print_newline ();*)
			if !def.(i).(j).action = 1 && !def.(i).(j).action_parameter = gameData.currentMapIndex then begin
				x:=j; y:=i; 
			end
		done done;
		setCharacterPosition gameData.character { x=(float_of_int !x) *. 60.0; y=(float_of_int !y) *. 60.0};
		setCharacterPos ((getCharacterPosition gameData.character).x) ((getCharacterPosition gameData.character).y);
		gameData.currentMapIndex <- parameter;
		gameData.hasJustChangedMap <- true;
		gameData.randomedCreatures <- addRandomCreatures (gameData.currentMap);
		flushPopups();
		showPopupMessage ("You're in \""^(getMapName (gameData.currentMap))^"\"") 3.0;
		addGameInfoVisitedMap (getCharacterInformation (gameData.character)) parameter;
		log_changeMap (gameData.character) (gameData.questsDatabase) (gameData.currentMapIndex);
		updateMapActionsDone (gameData.currentMap) (gameData.currentMapIndex) (getCharacterActionDoneTiles gameData.character);
		removeNPCs();
		showNPCs (gameData.npcDatabase) (gameData.currentMap) (gameData.currentMapIndex);
	end
	else if gameData.hasJustChangedMap && tileType <> 1 then begin (* we just changed map and are not on a "changeMap" tile *)
		gameData.hasJustChangedMap <- false;
	end
	(* if action is start dialog *)
	else if tileType = 4 && gameData.hasJustShowDialog <> parameter then begin
		enableDialog ();
		gameData.hasJustShowDialog <- parameter;
		processDialog  parameter gameData 0;
	end;
	
	if (tileType = 4 && gameData.hasJustShowDialog <> parameter) || tileType<>4 then begin
		gameData.hasJustShowDialog <- -1;
	end;

	(* GiveObjects processing *)
	if (tileType == 2) then begin
		(* if we didn't took the item before *)
		if (!def.(currentTileY).(currentTileX).actionDone = false) then begin
			(* add the item in inventory *)
			let obj = getObjectByIndex gameData.objectsDatabase parameter in
			let quantity = getObjectAmount obj in
			showPopupMessage ("You have found "^(getObjectNameByID (gameData.objectsDatabase) parameter )^" ("^(string_of_int quantity)^").\n It's been placed in your inventory.") 2.0;
			log_findItemOnTile gameData.character gameData.questsDatabase currentTileX currentTileY (gameData.currentMapIndex) parameter quantity;
			if parameter >= 10 && parameter < 20 then log_earnGold gameData.character (quantity);
			(* remove the map tile object info *)
			!def.(currentTileY).(currentTileX).actionDone <- true;
		end;
	end;
	
	(* StartFight processing *)
	if (tileType == 3) then begin
		(* if we didn't took the item before *)
		let (triggered ,i,j) = gameData.hasJustTriggeredTile in 
		if (!def.(currentTileY).(currentTileX).actionDone = false) && not(i=currentTileX && j=currentTileY && triggered = true) then begin
			gameData.isInFight <- true;
			gameData.fightWymIndex <- !def.(currentTileY).(currentTileX).action_parameter;
			let mapLevel = getMapLevel (gameData.currentMap) in
			let a,b = (random__float 1.0), (random__float 1.0) in
			let normalDistributionRandom = 3. *. (sqrt (-2. *. (log a)) ) *. (cos (2. *. 3.1415 *. b))  in 
			gameData.fightLevel <- max 1 ((int_of_float normalDistributionRandom) + mapLevel);
			if gameData.currentMapIndex = 990 then gameData.fightLevel <- 1;
			gameData.hasJustTriggeredTile <- (true,currentTileX,currentTileY);
		end
	end;
	let (triggered ,i,j) = gameData.hasJustTriggeredTile in 
	if i<>currentTileX or j<>currentTileY then 
		gameData.hasJustTriggeredTile <- (false,currentTileX,currentTileY);
;;	



let setJournalTexts gameData =
	let formerQuests = rev (getGameInfoDoneQuests (getCharacterInformation gameData.character)) in
	let currentQuests = rev (getCharacterQuests gameData.character) in
	let questIndex = gameData.currentShowedQuest in
	let rec getOne i quests = match (i,quests) with
		| _,[] -> -1
		| 0,t::q -> t
		| _,t::q -> getOne (i-1) q
	in
	let q1,q2 = getOne (questIndex) (formerQuests@currentQuests), getOne (questIndex+1) (formerQuests@currentQuests) in
	if q1 <> -1 then
		setLeftJournalText (getQuestJournalString (getQuest gameData.questsDatabase q1) (getCharacterQuestActions gameData.character q1) (getGameInfoHasDoneQuest (getCharacterInformation gameData.character) q1))
	else 
		setLeftJournalText "";
	if q2 <> -1 then
		setRightJournalText (getQuestJournalString (getQuest gameData.questsDatabase q2) (getCharacterQuestActions gameData.character q2) (getGameInfoHasDoneQuest (getCharacterInformation gameData.character) q2))
	else 
		setRightJournalText "";
;;



(* definition de deux creatures*)
let c1 ()=let c= (getDefaultCreature ()) in
	begin
	setCreatureReference c  0;
	setCreatureExperience c  8.;
	setCreatureLife c 32;
	setCreatureMana c 32;
	end;c;;

let saveGameData gameData =
	saveCharacter "saves/main/character.osf" gameData.character;
	let stream = open_out "saves/main/gameData.osf" in
	output_binary_int stream gameData.currentMapIndex;
	close_out stream;

	(* uncomment this to forbid cheating in save files. Be careful, it may cause the game to crash when saving *)
	(*writeFileIntegrity("saves/main/character.osf");*)
	(*writeFileIntegrity("saves/main/gameData.osf");*)
;;

let loadGameData gameData = 

	let stream = open_in ((*checkFile *)"saves/main/gameData.osf") in
	gameData.currentMapIndex <- input_binary_int stream;
	close_in stream;
	
	gameData.character <- loadCharacter ((*checkFile*) "saves/main/character.osf") ;

;;

(* start the main loop *)
let mainMenu = ref true;;
let startNewGame = ref false;;
let playing = ref false;;
let isWindowOpened = ref true;;
let gamePlayed = ref false;;


let gameData = { character=getDefaultCharacter (); currentMap=getDefaultMap (); texturesDatabase=loadTexturesDatabase "media/maps/textures/textures.otd"; isMoving=false; currentDirection=0; currentMapIndex=3; hasJustChangedMap=false; hasJustShowDialog= -1; objectsDatabase=LoadObjects (checkFile "media/objects/objects.ood"); isInFight=false; questsDatabase= readQuestsDatabase (checkFile "media/story/quests.oqd"); npcDatabase=readNPCDatabase (checkFile "media/story/npcs.ond"); npcToTalk=(-1,-1); isSelectingAnything = false; selecting = "";nextFightDialog=(18,0); showingJournal=false; currentShowedQuest=0; hasJustTriggeredTile=(false,-1,-1); randomedCreatures = []; fightLevel=0; fightWymIndex=0};;

exception MainMenu;;
exception StartMain;;

let rec main () = 
	try
	if !mainMenu then begin
		let mainMenuSelectorPos = ref 0 in
		while(true) do
			let a = ref 0 in
			(* get all the events stack *)	
			while (!a <> -1) do
				a := getEvent();
				if !a = -666 then (* closed window *)
					raise MustExit;
				if !a = 1 && !gamePlayed = true then begin(* back to game *)
					startNewGame := false;
					mainMenu := false;
					playing := true;
					raise StartMain;
				end;
				if !a = 104 then begin
					if !mainMenuSelectorPos = 0 then begin (* new game *)
						startNewGame := true;
						mainMenu := false;
						playing := true;
						raise StartMain;
					end else if !mainMenuSelectorPos = 1 then begin  (* save game *)
						if !playing = true then begin
							saveGameData gameData;
							startNewGame := false;
							mainMenu := false;
							playing := true;
							raise StartMain;
						end
					end else if !mainMenuSelectorPos = 2 then begin (* load game *)
						startNewGame := false;
						mainMenu := false;
						playing := true;
						(* load the new conf *)
						loadGameData gameData;
						setCharacterPos (getCharacterPosition (gameData.character)).x (getCharacterPosition (gameData.character)).y;
						gameData.currentMap <- (ReadMap (checkFile ("media/maps/map"^(
							if gameData.currentMapIndex >= 10 then 
								if gameData.currentMapIndex >= 100 then 
									string_of_int gameData.currentMapIndex 
								else 
									"0"^(string_of_int gameData.currentMapIndex) 
							else 
								"00"^(string_of_int gameData.currentMapIndex)
						)^".om")) gameData.texturesDatabase);
						
						gameData.randomedCreatures <- addRandomCreatures (gameData.currentMap);
						updateMap (gameData.currentMap);
						updateMapActionsDone (gameData.currentMap) (gameData.currentMapIndex) (getCharacterActionDoneTiles gameData.character);
						removeNPCs ();
						showNPCs (gameData.npcDatabase) (gameData.currentMap) (gameData.currentMapIndex);

						raise StartMain;
					end else if !mainMenuSelectorPos = 3 then (* quit game *)
						raise MustExit;
				end else
				if !a >= 100 && !a < 104 then begin
					match !a with
						| 100 -> mainMenuSelectorPos := !mainMenuSelectorPos - 1
						| 101 -> mainMenuSelectorPos := !mainMenuSelectorPos + 1
						| _ -> ()
				end
			done;
			if (!mainMenuSelectorPos >= 4) then mainMenuSelectorPos := 3;
			if (!mainMenuSelectorPos < 0) then mainMenuSelectorPos := 0;
			setMainMenuSelectorPosition(!mainMenuSelectorPos);
			rotateMainMenuSelector();
			drawMainMenuWindow();

		done;
	(*with
		| MustExit -> begin closeWindow(); mainMenu := false; main () end*)
	end else
	if !playing then begin (* play *)
		gamePlayed := true;
		if !startNewGame then begin
		(* reinitialises gameData *)
		gameData.character<-getDefaultCharacter (); 
		gameData.currentMap<-getDefaultMap ();
		gameData.texturesDatabase<-loadTexturesDatabase "media/maps/textures/textures.otd"; 
		gameData.isMoving<-false; 
		gameData.currentDirection<- 0; 
		gameData.hasJustChangedMap<-false; 
		gameData.hasJustShowDialog<- -1; 
		gameData.objectsDatabase<-LoadObjects (checkFile "media/objects/objects.ood"); 
		gameData.isInFight<-false; 
		gameData.questsDatabase<- readQuestsDatabase (checkFile "media/story/quests.oqd"); 
		gameData.npcDatabase<-readNPCDatabase (checkFile "media/story/npcs.ond"); 
		gameData.npcToTalk<-(-1,-1); 
		gameData.isSelectingAnything <- false; 
		gameData.selecting <- "";
		gameData.nextFightDialog<-(18,0); 
		gameData.showingJournal<-false; 
		gameData.currentShowedQuest<-0;

		setCharacterPos 450.0 300.0;
		gameData.currentMap <- (ReadMap (checkFile "media/maps/map000.om") gameData.texturesDatabase);
		gameData.currentMapIndex <- 0;
		gameData.hasJustChangedMap <- true;
		gameData.randomedCreatures <- addRandomCreatures (gameData.currentMap);
		updateMap (gameData.currentMap);
		gameData.isMoving <- false;
		gameData.currentDirection <- 0;
		gameData.hasJustShowDialog <- -1;
		removeNPCs ();
		showNPCs (gameData.npcDatabase) (gameData.currentMap) (gameData.currentMapIndex);
	
		addCreature (gameData.character) (c1 ());
	
		addItemInInventory  (gameData.character) 10 1;
		addItemInInventory  (gameData.character) 5 2;
		addItemInInventory  (gameData.character) 0 1;
		addItemInInventory  (gameData.character) 2 1;
		
		(* setup some infos about the character beginning *)
		addGameInfoVisitedMap (getCharacterInformation (gameData.character)) 3;
		setCharacterName gameData.character "Nimur";
		setCharacterPosition gameData.character { x=450.0; y=300.0 };
		end else (* don't start a new game*) ();

	
		gameData.currentDirection <- 1;(* face camera *)
		setCharacterPoints (getGameInfoTrophyPoints (getCharacterInformation gameData.character));
		flushPopups ();
		(*let life = ref 235698 in
		let test = ref 99 in*)
		while(true) do

			let a = ref 0 in
			(* get all the events stack *)	
			while (!a <> -1) 
			do
				a := getEvent();
				if !a = -666 then (* closed window *)
					raise MustExit;
				if !a = 1 then begin (* escape char *)
					if gameData.isInFight = true then 
						gameData.isInFight <- false 
					else if gameData.isSelectingAnything = true then begin
						gameData.isSelectingAnything <- false; 
						disableAnythingSelection (); 
						gameData.selecting <- ""; 
					end	else if gameData.showingJournal = true then begin
						gameData.showingJournal <- false; 
						disableJournal (); 
					end else			
						raise MainMenu;
				end else
				(* if we're moving journal page *)
				if !a >= 100 && !a < 104 && gameData.showingJournal then begin
					let _ = match !a with
						| 102 -> gameData.currentShowedQuest <- gameData.currentShowedQuest - 2
						| 103 -> gameData.currentShowedQuest <- gameData.currentShowedQuest + 2
						| _ -> ()
					in
					let maxSize = list_length (getCharacterQuests gameData.character) + (list_length (getGameInfoDoneQuests (getCharacterInformation gameData.character))) in
					if gameData.currentShowedQuest >= maxSize then
						gameData.currentShowedQuest <- maxSize -1 - ((maxSize -1) mod 2)
					else if gameData.currentShowedQuest < 0 then 
						gameData.currentShowedQuest <- 0;
					setJournalTexts gameData;
				end else
				(* if we're selecting something, move the selector *)
				if !a >= 100 && !a < 104 && gameData.isSelectingAnything then begin
					match !a with
						| 100 -> moveAnythingSelectorUp ()
						| 101 -> moveAnythingSelectorDown ()
						| 102 -> moveAnythingSelectorLeft ()
						| 103 -> moveAnythingSelectorRight ()
						| _ -> ()
				end else
				(* press enter while selecting and item *)
				if !a = 104 && gameData.isSelectingAnything && gameData.selecting = "inventory" then begin 
					let idSelected = getAnythingSelection () in
					disableAnythingSelection ();
					gameData.isSelectingAnything <- false;
					gameData.selecting <- "";
					useInventoryItem idSelected gameData;
						
				end else
				(* press delete while selecting and item *)
				if !a = 211 && gameData.isSelectingAnything && gameData.selecting = "inventory" then begin 
					let idSelected = getAnythingSelection () in
					disableAnythingSelection ();
					gameData.isSelectingAnything <- false;
					gameData.selecting <- "";
					deleteInventoryItem idSelected gameData;
						
				end else
				if !a = 208 then begin
					if gameData.isSelectingAnything = false && gameData.selecting = "" then begin
						showInventory gameData;
						gameData.selecting <- "inventory";
						gameData.isSelectingAnything <- true;					
					end
					else if gameData.selecting = "inventory" then begin
						gameData.isSelectingAnything <- false; 
						gameData.selecting <- "";
						disableAnythingSelection (); 
					end
				end else
				if !a = 210 then begin
					if gameData.isSelectingAnything = false && gameData.selecting = "" then begin
						selectCreature gameData;
						gameData.selecting <- "creature";
						gameData.isSelectingAnything <- true;					
					end
					else if gameData.selecting = "creature" then begin
						gameData.isSelectingAnything <- false; 
						gameData.selecting <- "";
						disableAnythingSelection (); 
					end;
				end else
				if !a = 789 (* space : dialog *) then begin
					if gameData.npcToTalk <> (-1,-1) then begin
						let npcIndex = (npcIndexFromPos (gameData.npcDatabase) (gameData.npcToTalk)) in
						log_talkToNPC (gameData.character) (gameData.questsDatabase) npcIndex;
						characterProcessBringObjects (gameData.character) (gameData.questsDatabase) (gameData.objectsDatabase) npcIndex;
						let dialog = getNPCDialog (gameData.npcDatabase) npcIndex in
						enableDialog();
						processDialog dialog gameData 0;
					end
				end else
				(* press J : show journal *)
				if !a = 209 then begin
					if gameData.showingJournal then begin
						gameData.showingJournal <- false;
						setJournalTexts gameData;
						disableJournal ();
					end
					else if gameData.showingJournal=false then begin
						gameData.showingJournal <- true;
						let a = list_length (getGameInfoDoneQuests (getCharacterInformation gameData.character)) in gameData.currentShowedQuest <- (a-(a mod 2));
						setJournalTexts gameData;
						enableJournal ();
					end
				end
			done;
			if gameData.isInFight then begin	
				let fightResult = fight gameData (gameData.fightWymIndex) (gameData.fightLevel) in
				if fightResult = true then begin
					let currentTileX = ((int_of_float ((getCharacterPosition gameData.character).x) + 29)/60) in
					let currentTileY = ((int_of_float ((getCharacterPosition gameData.character).y) + 29)/60) in
					(getMapDefinition gameData.currentMap).(currentTileY).(currentTileX).actionDone <- true;
					if isItemInList (currentTileY, currentTileX) (gameData.randomedCreatures) = false then
						log_killUnitOnTile (gameData.character) currentTileX currentTileY (gameData.currentMapIndex);
				end;
				end
			else if gameData.isSelectingAnything then begin	
				drawWindow(); 
				end
			else if gameData.showingJournal then begin	
				drawWindow(); 
				end
			else begin 
				manageMovement gameData 300.0;
				manageCurrentTile gameData;
				drawWindow();  
			end;
				(*printQuests gameData.character;*)
		done;
	end
with
	| MustExit -> begin if !isWindowOpened then begin closeWindow (); isWindowOpened := false end else ();
					raise MustExit; (* if we're inside an other main, we have to exit it *) end
	| StartMain -> begin main (); end
	| MainMenu -> begin mainMenu := true; main (); end
	| FAKE_FILE -> begin closeWindow(); isWindowOpened := false; raise MustExit; end
;;

try
	createWindow ();
	initFightInterface();
	main();
with
	| MustExit -> ();;


