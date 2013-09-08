
#open "main";;
#open "graphicsInterface";;
#open "fightInterface";;
#open "fightDialogFunctions";;
#open "fightInformationGatherer";;
#open "fightFunctions";;
#open "character";;
#open "referenceCreature";;
#open "creature";;

let dialogs = readDialogs2 ("media/story/fight.txt");;



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

let rec processFightDynamicText s param gameData creature =
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
					| "SelectedCreature" 	-> getSelectedCreature gameData
					| "SelectedAction"	-> "'"^(getSelectedAction param gameData)^"'"
					| "SelectedEnemy"	-> getSelectedEnemy  creature
					| "SelectedItem"	-> getSelectedItem param gameData
					| _ -> begin "$"^(!currentVariable)^"$" end
				)^(processFightDynamicText (sub_string !newS (!posEnd+1) (string_length !newS - !posEnd - 1)) param gameData creature)  ) end;
		end
		else if !readVariable then
			currentVariable := (!currentVariable^(string_of_char (nth_char !newS !i)));
		
		i := !i + 1;
		
	done;
	!newS
	;;

let selectCreature gameData = 
	clearAnythings ();

	(* add all the character's creatures *)
	let creatures = getCharacterCreatures (gameData.character) in
	let n = vect_length creatures - 1 in
	let references = referenceVector () in
	for i = 0 to n do
		(*Il faut afficher toutes les creatures pour qu' il n'yait pas de problemes entre index dans l'inventaire et index dans le vecteur creatures*)
		let reference = references.(getCreatureReference (creatures.(i))) in
		let texture = getReferenceCreatureTexturePath reference and str=ref "" and
			fightActions v=
			let s=ref "" and n=vect_length v in 
			for j= 0 to (n-1) do 	if 
	(Lvl  creatures.(i) ) >= (getFightActionShowingLevel v.(j)) && (Lvl creatures.(i)) <= (getFightActionHidingLevel v.(j)) && (getCreatureLife creatures.(i) > getFightActionLifeCost v.(j)) && (getCreatureMana creatures.(i) >= getFightActionManaCost v.(j))

							then	 
							s:=!s^"\n"^getFightActionName (v.(j)) 
			done;!s; 
		in
		
		
		begin
		if i=0 then str:="This Wym is already selected" else () ;
		if (getCreatureLife creatures.(i))=0 then str:=(!str)^("\nThis Wym is no more avaiable") else () ;
		addAnything texture ("Name: "^(getReferenceCreatureName reference)^"\nLvl: "^string_of_int (Lvl creatures.(i))^"\nXp:"^string_of_int (int_of_float (getCreatureExperience creatures.(i)))^"/"^(string_of_int (NextLevelExperience creatures.(i)))^"\nLife: "^(string_of_int (getCreatureLife (creatures.(i))))^" / "^(string_of_int (LifeMax creatures.(i)))^"\nMana: "^(string_of_int (getCreatureMana (creatures.(i))))^" / "^(string_of_int (ManaMax creatures.(i)))^"\nActions:"^"\n"^fightActions (getReferenceCreatureActions reference)^"\n\n"^(!str))
		end
	done;
	
	gameData.isSelectingAnything <- true;
	gameData.selecting <- "creature";
	enableAnythingSelection();
	
;;


let rec processFight dialogIndex gameData creature2 param =
	clearDialogAnswers ();
	let dialogEventLoop answers = begin
		drawFightInterface();
		try
			let nbAnswers = list_length answers in
			let selectorPos = ref (nbAnswers-1) in
			while(true) do
			(* get all the events stack *)	
				let a = ref 0 in
				while (!a <> -1) 
				do
					a := getEvent();
					if !a = -666 then raise MustExit;
					if !a = 1 then showPopupMessage "You have to finish the fight." 2.0
					else if !a >= 100 && !a < 104 && gameData.isSelectingAnything && gameData.selecting = "creature" then begin (* if we're selecting some creature, process it and not the other dialog *)
						match !a with
							| 100 -> moveAnythingSelectorUp ()
							| 101 -> moveAnythingSelectorDown ()
							| 102 -> moveAnythingSelectorLeft ()
							| 103 -> moveAnythingSelectorRight ()
							| _ -> ()
					end else if !a = 104 && gameData.isSelectingAnything && gameData.selecting = "creature" then begin 
						let idSelected = getAnythingSelection () in
						let selectedCreature=(getCharacterCreatures (gameData.character)).(idSelected) in
						(*we can only select alife creatures*)
						if (getCreatureLife selectedCreature)>0 then
						begin
						disableAnythingSelection ();
						gameData.isSelectingAnything <- false;
						gameData.selecting <- "";
(*						changeCreature idSelected gameData;*)
						raise (StartNextDialog(3, idSelected));
						end
					end else if !a = 100 then selectorPos := (!selectorPos+1)
					else if !a = 101 then selectorPos := (!selectorPos-1)
					else if !a = 104 then begin
						if nbAnswers > 0 then
							let nextDialogIndex = getListElement answers (nbAnswers-1- !selectorPos) in
							if nextDialogIndex/10000 = 0 then
								raise (StartNextDialog(nextDialogIndex, 0))
							else if nextDialogIndex/10000 = 1 then (* hit *)
								raise (StartNextDialog(1, nextDialogIndex mod 10000))
							else if nextDialogIndex/10000 = 2 then (* use item *)
								raise (StartNextDialog(2, nextDialogIndex mod 10000))
							else if nextDialogIndex/10000 = 3 then (* change creature *) begin
								selectCreature gameData;
								(*raise (StartNextDialog(3, nextDialogIndex mod 10000))*) end
							else if nextDialogIndex/10000 = 4 then (* run *)
								raise (StartNextDialog(4, nextDialogIndex mod 10000))
							else if nextDialogIndex/10000 = 5 then (* delete creature *)
								raise (StartNextDialog(5, nextDialogIndex mod 10000))
						else
							raise StopDialog();
					end;
				done;
				(* event stack is empty and processed now *)
				if (!selectorPos >= nbAnswers) then selectorPos := (nbAnswers-1);
				if (!selectorPos < 0) then selectorPos := 0;
				if (!selectorPos >= nbAnswers) then selectorPos := 0;
				if (!selectorPos < 0) then selectorPos := (nbAnswers-1);


				setSelectorPos(!selectorPos);
				drawFightInterface()
			done;
		with
			| StopDialog -> disableDialog() 
			| StartNextDialog(i, param) -> processFight i gameData creature2 param
 end in


	let dialog = dialogs.(dialogIndex) in 
	match dialog with
		| Message(text, answerList) -> begin 
			let rec addAllAnswers = function
				| [] -> []
				| StaticAnswer(s,nextDialog)::t -> begin
					addDialogAnswer(s); 
					nextDialog::(addAllAnswers t);
				end
				| DynamicAnswer(dataType,param)::t -> begin (*for example for Avaiableactions param=10000*)
					let rec process = function
						| [] -> addAllAnswers t
						| StaticAnswer(t2,s2)::q -> begin addDialogAnswer(t2); s2::(process q) end
						| _ -> failwith "StaticAnswer expected in processDialog \--> addAllAnswers \--> process function"
					in
					process (addCorrespondingAnswers2 [] gameData param dataType)
				end
			in
			setDialogText( processFightDynamicText text param gameData creature2);
			let answersIndexes = addAllAnswers (rev answerList) in begin (*exemple:Avaiableactions have 10001,10002... as indexes*)
			dialogEventLoop answersIndexes; end;
			end
		| End("") -> disableDialog ()
		| End(text) -> begin
			setDialogText( processFightDynamicText text param gameData creature2);
			addDialogAnswer("Ok.");
			dialogEventLoop [0];
				end
		| Hit(i) ->  begin hit param gameData creature2 end
		| UseItem(i) -> begin useItem param gameData creature2 end
		| ChangeCreature(i) -> begin changeCreature param gameData end
		| Run(i) ->begin run param gameData creature2; disableDialog(); end
		| DeleteCreature (i) -> deleteCreature param gameData
;;	











