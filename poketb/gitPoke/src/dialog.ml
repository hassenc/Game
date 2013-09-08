
#open "main";;
#open "graphicsInterface";;
#open "dialogFunctions";;
#open "informationGatherer";;
#open "eventsFunctions";;
#open "character";;
#open "quests";;
#open "dialog";;
#open "NPC";;
#open "object";;
#open "log";;
#open "encrypter";;
#open "fileParsing";;
#open "gameInformation";;



let dialogs = readDialogs(checkFile "media/story/dialogs.odd");;



exception MustExit;;
exception StartNextDialog of int*int;;
exception StopDialog;;

let rec getListElement l = function
	| 0 -> begin 
		match l with
			| [] -> failwith("getListElement cannot find requested item.")
			| t::q -> t
		end
	| nb -> begin
		 match l with
			| [] -> failwith("getListElement goes too far.")
			| t::q -> getListElement q (nb-1)
		end;
	;;

let processDynamicText s gameData =
	let i = ref 0 in
	let newS = ref s in
	let readVariable = ref false in
	let currentVariable = ref "" in
	let posStart, posEnd = ref 0, ref 0 in
	while !i < string_length !newS do
		if nth_char !newS !i = `$` && !readVariable = false then begin posStart := !i; readVariable := true; end
		else if nth_char !newS !i = `$` && !readVariable = true then begin
			posEnd := !i;
			readVariable := false;
			(* process the variable *)
			newS := begin
				 ((sub_string !newS 0 !posStart )^
				(match !currentVariable with
					| "VisitedMaps" -> getVisitedMapString gameData
					| _ -> begin "$"^(!currentVariable)^"$" end
				)^(sub_string !newS (!posEnd+1) (string_length !newS - !posEnd - 1))) end;
		end
		else if !readVariable then
			currentVariable := (!currentVariable^(string_of_char (nth_char !newS !i)));
		
		i := !i + 1;
		
	done;
	!newS
	;;

let selectItemToBuy gameData = 
	clearAnythings ();
	let objects =  (gameData.objectsDatabase) in
	let n = 6 in
	for i = 0 to n do
		let obj = getObjectByIndex objects i and name=getObjectNameByID gameData.objectsDatabase i and 			givenAmount=getObjectGivenAmountByID gameData.objectsDatabase i  and
				 myGold ()=let s=ref"" in
			let p=searchItemIndex gameData.character 7 in
			if p=(-1) then s:="0"
			else if p<>(-1) then begin
				let (a,b)=(getCharacterInventory gameData.character).(p) in s:=(string_of_int b) end;!s;

		
		 in
		match obj with
		| ManaPotion(_) ->addAnything 
			(getObjectTexture obj)
			("You have "^myGold ()^" Gold"^"\n"^"Object: "^(getObjectName obj)^" \n"^" gives you "^string_of_int givenAmount^" mana points"^"\n"^" Price: "^(string_of_int (getObjectPrice obj))^"\n");
		| LifePotion(_) ->addAnything 
			(getObjectTexture obj)
			("You have "^myGold ()^" Gold"^"\n"^"Object: "^(getObjectName obj)^"\n"^" gives you "^string_of_int givenAmount^" life points"^"\n"^" Price: "^(string_of_int (getObjectPrice obj))^"\n");
		| ExperiencePotion(_) ->addAnything 
			(getObjectTexture obj)
			("You have "^myGold ()^" Gold"^"\n"^"Object: "^(getObjectName obj)^"\n"^" gives you "^string_of_int givenAmount^" xp"^"\n"^" Price: "^(string_of_int (getObjectPrice obj))^"\n");
		| CallBackScroll(_) ->addAnything 
			(getObjectTexture obj)
			("You have "^myGold ()^" Gold"^"\n"^"Object: "^(getObjectName obj)^"\n"^" sends you home"^"\n"^" Price: "^(string_of_int (getObjectPrice obj))^"\n");
		| CreatureGetter(_)->addAnything 
			(getObjectTexture obj)
			("You have "^myGold ()^" Gold"^"\n"^"Object: "^(getObjectName obj)^"\n"^" To catch new Wyms"^"\n"^" Price: "^(string_of_int (getObjectPrice obj))^"\n");
		| _->addAnything 
			(getObjectTexture obj)
			("Object: ");
	done;
	enableAnythingSelection();
	gameData.isSelectingAnything <- true;
	gameData.selecting <- "inventory";

	
;;

let rec processDialog dialogIndex gameData param =
	clearDialogAnswers ();
	let dialogEventLoop answers = begin
		drawWindow();	
		try
			let nbAnswers = list_length answers in
			let selectorPos = ref (nbAnswers-1) in
			while(true) do
			(* get all the events stack *)	
				let a = ref 0 in
				while (!a <> -1) 
				do
					a := getEvent();
					if !a = 1 then raise MustExit
					else if !a >= 100 && !a < 104 && gameData.isSelectingAnything && gameData.selecting = "inventory" then begin (* if we're selecting some object, process it and not the other dialog *)
						match !a with
							| 100 -> moveAnythingSelectorUp ()
							| 101 -> moveAnythingSelectorDown ()
							| 102 -> moveAnythingSelectorLeft ()
							| 103 -> moveAnythingSelectorRight ()
							| _ -> ()
					end else if !a = 104 && gameData.isSelectingAnything && gameData.selecting = "inventory" then begin 
						let idSelected = getAnythingSelection () in
						disableAnythingSelection ();
						gameData.isSelectingAnything <- false;
						gameData.selecting <- "";
						raise (StartNextDialog(2, idSelected));
						end
					else if !a = 100 then selectorPos := (!selectorPos+1)
					else if !a = 101 then selectorPos := (!selectorPos-1)
					else if !a = 104 || !a = 789 (* space or enter *) then 
						if nbAnswers > 0 then
							let nextDialogIndex = getListElement answers (nbAnswers-1- !selectorPos) in
							if nextDialogIndex/10000 = 0 then
								raise (StartNextDialog(nextDialogIndex, 0))
							else if nextDialogIndex/10000 = 1 then (* process quests dialogs *)
								raise (StartNextDialog(1, nextDialogIndex mod 10000))
							else if nextDialogIndex/10000 = 2 then (* sell item *)
								selectItemToBuy gameData
							else if nextDialogIndex/10000 = 3 then (* change map *)
								raise (StartNextDialog(3, nextDialogIndex mod 10000))
							else if nextDialogIndex/10000 = 4 then (* heal creatures *)
								raise (StartNextDialog(4, nextDialogIndex mod 10000))
						else
							raise StopDialog();
				done;
				(* event stack is empty and processed now *)
				if isKeyDown("Esc") = 1 then raise MustExit;
				if (!selectorPos >= nbAnswers) then selectorPos := 0;
				if (!selectorPos < 0) then selectorPos := (nbAnswers-1);
				setSelectorPos(!selectorPos);
				drawWindow();
			done;
		with
			| StopDialog -> disableDialog() 
			| StartNextDialog(1, param) -> begin (* processing quest dialog *) 
				let state = getCharacterQuestState (gameData.character) param in
					match state with
						| "tbs" -> begin let indexOfNPC = npcIndexFromPos (gameData.npcDatabase) (gameData.npcToTalk) in
										let dialog = getNPCQuestStartDialog (gameData.npcDatabase) indexOfNPC param in 
										if (dialog <> -1) then begin
											characterStartQuest (gameData.character) (getQuest (gameData.questsDatabase) param) param;
											processDialog dialog gameData param;
										end
											else disableDialog ();
									 end
						| "tbd" -> begin let indexOfNPC = npcIndexFromPos (gameData.npcDatabase) (gameData.npcToTalk) in
										let dialog = getNPCQuestTBDDialog (gameData.npcDatabase) indexOfNPC param in 
										if (dialog <> -1) then begin
											processDialog dialog gameData param; 
										end
											else disableDialog ();
									end
						| "finished" -> begin let indexOfNPC = npcIndexFromPos (gameData.npcDatabase) (gameData.npcToTalk) in
											let dialog = getNPCQuestEndDialog (gameData.npcDatabase) indexOfNPC param in 
											(* get the reward, and clear the quest of current quests *)
											if (dialog <> -1) then begin
												log_rewardFinishedQuest gameData (getQuest (gameData.questsDatabase) param) param;
												processDialog dialog gameData param; 
											end
												else disableDialog ();
										end
						| "done" ->	begin let indexOfNPC = npcIndexFromPos (gameData.npcDatabase) (gameData.npcToTalk) in
										let dialog = getNPCQuestDoneDialog (gameData.npcDatabase) indexOfNPC param in 
										if (dialog <> -1) then begin
											processDialog dialog gameData param; 
										end
											else disableDialog ();
									end
						| _ -> ()
				end
			| StartNextDialog(i, param) -> processDialog i gameData param
			| MustExit -> disableDialog()
 	end in

	let dialog = dialogs.(dialogIndex) in 
	match dialog with
		| Message(text, answerList) -> begin 
			let rec addAllAnswers = function
				| [] -> []
				| StaticAnswer(s,nextDialog)::t -> begin
					if nextDialog/10000 <> 1 then begin 
						addDialogAnswer(s); 
						nextDialog::(addAllAnswers t); 
					end else begin (* answer starting a quest *)
						let questIndex = nextDialog mod 10000 in
						let indexOfNPC = npcIndexFromPos (gameData.npcDatabase) (gameData.npcToTalk) in
						if getCharacterQuestState (gameData.character) questIndex <> "tbs" then begin
							addDialogAnswer(s);
							nextDialog::(addAllAnswers t);
						end
						else if indexOfNPC >= 0 then begin
							let rec hasDoneRequiredQuests questsDone requiredQuests = 
								let rec hasBeenDone quest = function
									| [] -> false
									| t::q -> if t = quest then true else hasBeenDone quest q
								in
								match requiredQuests with
									| [] -> true
									| t::q -> if hasBeenDone t questsDone then hasDoneRequiredQuests questsDone q else false
							in
							if 	npcCanGiveQuest (gameData.npcDatabase) indexOfNPC questIndex && 
								getCharacterMaxCreatureLvl gameData.character >= getQuestMinimumWymLevel (getQuest gameData.questsDatabase questIndex) &&
								hasDoneRequiredQuests (getGameInfoDoneQuests (getCharacterInformation gameData.character)) (getQuestRequiredQuests (getQuest gameData.questsDatabase questIndex)) then begin
								addDialogAnswer(s);
								nextDialog::(addAllAnswers t);
							end else
								addAllAnswers t;
						end else begin 
							addAllAnswers t; 
						end
					end
				end
				| DynamicAnswer(dataType,param)::t -> begin
					let rec process = function
						| [] -> addAllAnswers t (* we have nothing more in dynamic answers, add the other answers to the answer list *)
						| StaticAnswer(t2,s2)::q -> begin addDialogAnswer(t2); s2::(process q) end (* add answers 1 by 1 *)
						| _ -> failwith "StaticAnswer expected in processDialog \--> addAllAnswers \--> process function"
					in
					process (addCorrespondingAnswers [] gameData param dataType)
				end
			in
			setDialogText( processDynamicText text gameData);
			let answersIndexes = addAllAnswers (rev answerList) in begin
			dialogEventLoop answersIndexes; end;
			end
		| End("") -> disableDialog ()
		| End(text) -> begin
			setDialogText( processDynamicText text gameData);
			addDialogAnswer("Goodbye.");
			dialogEventLoop [0];
				end
		| StartQuest(i) -> begin startQuest(param); disableDialog(); end
		| SellItem(i) -> begin sellItem gameData param; disableDialog(); end
		| ChangeMap(i) -> begin changeMap param gameData; disableDialog(); end
		| HealCreatures(i) -> begin  healCreatures gameData ; disableDialog(); end
;;	


(* processQuestDialog
	if the user has not started the quest, calls the start dialog
	if he started if but hasn't finished it yet, calls the mid dialog
	if he finished, call the end dialog and give him what he deserves.
	if he already did it, show the alreadyDone message *)
let processQuestDialog gameData questIndex =
	let character = gameData.character in
	let quest = getQuest (gameData.questsDatabase) questIndex in
	
	let canStartQuest = if getCharacterMaxCreatureLvl character > getQuestMinLevel quest then true else false in
	if canStartQuest then processDialog 900 gameData 0 else begin
		processDialog 0 gameData 0
	end
;;









