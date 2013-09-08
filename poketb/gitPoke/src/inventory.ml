#open "main";;
#open "referenceCreature";;
#open "character";;
#open "object";;
#open "creature";;
#open "graphicsInterface";;
#open "fileParsing";;
#open "encrypter";;
#open "fightInterface";;
#open "fightDialog";;
#open "fightDialogFunctions";;
#open "maps";;
#open "gameInformation";;
#open "log";;
#open "NPC";;



let showInventory gameData =
	clearAnythings ();
	let v = getCharacterInventory (gameData.character) and references = referenceVector () in
	let  rec getFusionCreaturesNames l=match l with
					|[] -> ""
					|a::q-> (getReferenceCreatureName (references.(a)))^"\n"^(getFusionCreaturesNames q) 
	in 
	let n = vect_length v - 1 in
	for i = 0 to n do
		let id, amnt = v.(i) in
		let obj = getObjectByIndex gameData.objectsDatabase id and name=getObjectNameByID gameData.objectsDatabase id and 			givenAmount=getObjectGivenAmountByID gameData.objectsDatabase id in
		match obj with
		| ManaPotion(_) ->addAnything 
			(getObjectTexture obj)
			("Object: "^(getObjectName obj)^" ("^(string_of_int amnt)^") \n"^" gives you "^string_of_int givenAmount^" mana points"^"\n"^"\n"^"\n"^"\n"^"\n"^"Press 'Delete' to delete this "^"\n"^"item from your inventory");
		| LifePotion(_) ->addAnything 
			(getObjectTexture obj)
			("Object: "^(getObjectName obj)^" ("^(string_of_int amnt)^") \n"^" gives you "^string_of_int givenAmount^" life points"^"\n"^"\n"^"\n"^"\n"^"\n"^"Press 'Delete' to delete this "^"\n"^"item from your inventory");
		| ExperiencePotion(_) ->addAnything 
			(getObjectTexture obj)
			("Object: "^(getObjectName obj)^" ("^(string_of_int amnt)^") \n"^" gives you "^string_of_int givenAmount^" xp"^"\n"^"\n"^"\n"^"\n"^"\n"^"Press 'Delete' to delete this "^"\n"^"item from your inventory");
		| CallBackScroll(_) ->addAnything 
			(getObjectTexture obj)
			("Object: "^(getObjectName obj)^" ("^(string_of_int amnt)^") \n"^" sends you home"^"\n"^"\n"^"\n"^"\n"^"\n"^"Press 'Delete' to delete this "^"\n"^"item from your inventory");
		| FusionStone(_) ->addAnything 
			(getObjectTexture obj)
			("Object: "^(getObjectName obj)^"\n"^" Transforms the following Wyms :"^"\n"^getFusionCreaturesNames (getFusionCreatures obj)^"\n"^"into a "^getReferenceCreatureName references.(getFusionResultingCreature obj)^"\n"^"Fusion cost: "^string_of_int (getFusionBuildPrice obj)^"\n"^"\n"^"WARNING:USE IT ONLY IF YOU "^"\n"^"HAVE ALL THE REQUIRED WYMS"^"\n"^"\n"^"\n"^"\n"^"Press 'Delete' to delete this "^"\n"^"item from your inventory");
		| _->addAnything 
			(getObjectTexture obj)
			("Object: "^(getObjectName obj)^" ("^(string_of_int amnt)^")\n"^"\n"^"\n"^"\n"^"Press 'Delete' to delete this "^"\n"^"item from your inventory");
		
	done;
	
	gameData.isSelectingAnything <- true;
	gameData.selecting <- "inventory";
	enableAnythingSelection()
;;




(* **********Selecting creatures to use objects************)
let selectCreature gameData = 
	clearAnythings ();

	(* add all the character's creatures *)
	let creatures = getCharacterCreatures (gameData.character) in
	let n = vect_length creatures - 1 in
	let references = referenceVector () in
	for i = 0 to n do
		(*We have to show all creatures*)
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
	enableAnythingSelection()
	
;;

(* **********Using objects************)
exception FusionAborted;;
exception CreatureFound;;
exception CreatureNotFound;;
exception Found of int;;

let rec existe elt l=match l with
		|[]->false
		|a::q->(a=elt) || (existe elt q);;
let rec supr elt l=match l with
		|[]->[]
		|a::q->if a= elt then q else a::(supr elt q);;

let testFusion l gameData=
	let t=getCharacterCreatures (gameData.character) and b=ref false in
		let rec test l d=match l with
			|[]->true
			|a::q as l->try 
					for i=d to (vect_length t)-1 do
					let elt=getCreatureReference t.(i) in 
						if existe elt l then raise (Found i) done;!b
					with |Found i-> test (supr (getCreatureReference t.(i)) l) (i+1)				
	in test l 0;;
let moneyTestFusion obj gameData=let test=ref false in
	let 	price=getFusionBuildPrice obj in
	let p=searchItemIndex gameData.character 10 in
	if p=(-1) then begin showPopupMessage "You don't have money." 1.0 end
	else if p<>(-1) then 
		begin
		let (a,b)=(getCharacterInventory gameData.character).(p) in 
			if b<price then begin showPopupMessage "You don't have enough money." 1.0 end 
			else if b>=price then 
			begin
			showPopupMessage ("You spent  "^string_of_int price^" for fusionning") 1.0;
			for i=1 to price do
			removeItemFromInventory gameData.character p
			done;	
			test:=true
			end;
		end;!test;;


let useInventoryItem param gameData= 

	let objDatabase=gameData.objectsDatabase and inventory=getCharacterInventory (gameData.character)   in

	let (reference,quantity)=inventory.(param) in 
		let obj=getObjectByIndex objDatabase (reference) and name=getObjectNameByID objDatabase (reference) and 			givenAmount=getObjectGivenAmountByID objDatabase (reference) in

	match obj with
		| ManaPotion(_) -> selectCreature gameData;let b=ref true in
					while (!b=true) do
		let a = ref 0  in
		(* get all the events stack *)	
		while (!a <> -1) 
		do
			a := getEvent();
			if !a = -666 then (* closed window *)
				raise MustExit;
			if !a = 1 then begin (* escape char *)
				if gameData.isSelectingAnything = true then begin
					gameData.isSelectingAnything <- false; disableAnythingSelection (); end		
				else			
					raise MustExit;
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
			if !a = 104 && gameData.isSelectingAnything && gameData.selecting = "creature" then begin 
						let idSelected = getAnythingSelection () in
						let creature=(getCharacterCreatures (gameData.character)).(idSelected) in
						
						
						disableAnythingSelection ();
						gameData.isSelectingAnything <- false;
						gameData.selecting <- "";
						addMana creature (givenAmount);
						removeItemFromInventory (gameData.character) param;
						showPopupMessage ("You used a "^name)  1.0;
						end
					done;
			if gameData.isSelectingAnything then begin	
			drawWindow(); 
			end
			else begin 
			(*manageMovement gameData 400.0;
			manageCurrentTile gameData;*)
			drawWindow();  b:=false end;
		
			done;
		| LifePotion(_) -> selectCreature gameData;let b=ref true in
					while (!b=true) do
		let a = ref 0  in
		(* get all the events stack *)	
		while (!a <> -1) 
		do
			a := getEvent();
			if !a = -666 then (* closed window *)
				raise MustExit;
			if !a = 1 then begin (* escape char *)
				if gameData.isSelectingAnything = true then begin
					gameData.isSelectingAnything <- false; disableAnythingSelection (); end		
				else			
					raise MustExit;
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
			if !a = 104 && gameData.isSelectingAnything && gameData.selecting = "creature" then begin 
						let idSelected = getAnythingSelection () in
						let creature=(getCharacterCreatures (gameData.character)).(idSelected) in
						
						
						disableAnythingSelection ();
						gameData.isSelectingAnything <- false;
						gameData.selecting <- "";
						addLife creature (givenAmount);
						removeItemFromInventory (gameData.character) param;
						showPopupMessage ("You used a "^name)  1.0;
						end
					done;
			if gameData.isSelectingAnything then begin	
			drawWindow(); 
			end
			else begin 
			(*manageMovement gameData 400.0;
			manageCurrentTile gameData;*)
			drawWindow();  b:=false end;
		
			done;
		| ExperiencePotion(_) -> selectCreature gameData;let b=ref true in
					while (!b=true) do
		let a = ref 0  in
		(* get all the events stack *)	
		while (!a <> -1) 
		do
			a := getEvent();
			if !a = -666 then (* closed window *)
				raise MustExit;
			if !a = 1 then begin (* escape char *)
				if gameData.isSelectingAnything = true then begin
					gameData.isSelectingAnything <- false; disableAnythingSelection (); end		
				else			
					raise MustExit;
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
			if !a = 104 && gameData.isSelectingAnything && gameData.selecting = "creature" then begin 
						let idSelected = getAnythingSelection () in
						let creature=(getCharacterCreatures (gameData.character)).(idSelected) in
						
						
						disableAnythingSelection ();
						gameData.isSelectingAnything <- false;
						gameData.selecting <- "";
						addExperience creature (float_of_int givenAmount);
						removeItemFromInventory (gameData.character) param;
						showPopupMessage ("You used an "^name)  1.0;
						end
					done;
			if gameData.isSelectingAnything then begin	
			drawWindow(); 
			end
			else begin 
			(*manageMovement gameData 400.0;
			manageCurrentTile gameData;*)
			drawWindow();  b:=false end;
		
			done;
		| CallBackScroll(_) -> gameData.currentMap <- ReadMap (checkFile "media/maps/map010.om") (gameData.texturesDatabase);
		updateMap (gameData.currentMap);
		(* now find where the character should pop on the new map *)
		let x,y = (ref 7),(ref 9) in
		setCharacterPosition gameData.character { x=(float_of_int !x) *. 60.0; y=(float_of_int !y) *. 60.0};
		setCharacterPos ((getCharacterPosition gameData.character).x) ((getCharacterPosition gameData.character).y);
		gameData.currentMapIndex <- 10;
		gameData.hasJustChangedMap <- true;
		addGameInfoVisitedMap (getCharacterInformation (gameData.character)) 10;
		log_changeMap (gameData.character) (gameData.questsDatabase) (gameData.currentMapIndex);
		showPopupMessage ("You're in \""^(getMapName (gameData.currentMap))^"\"") 3.0;
		updateMapActionsDone (gameData.currentMap) (gameData.currentMapIndex) (getCharacterActionDoneTiles gameData.character);
		removeNPCs();
		showNPCs (gameData.npcDatabase) (gameData.currentMap) (gameData.currentMapIndex);
		removeItemFromInventory (gameData.character) param
		| FusionStone(_) -> let l=getFusionCreatures obj and r=getFusionResultingCreature obj and references=referenceVector()  and moyXp=ref 0. and d=ref [] (*liste des index des creatures a spprimer*)in 
			

			let rec fusionCreatures l =match l with
			|[]->	let c1 ()=let c= (getDefaultCreature ()) in
					begin
						setCreatureExperience c  ((!moyXp)/.2.);
						setCreatureReference c  (getFusionResultingCreature obj);
						setCreatureLife c  (LifeMax c);
						setCreatureMana c  (ManaMax c);
					end;c;
				in
				
				addCreature (gameData.character) (c1 ());
				removeItemFromInventory (gameData.character) param;
				showPopupMessage ("Fusion Complete")  1.0
			|x::q->begin
				let t=getCharacterCreatures (gameData.character) in 
					try 
					
					for i=0 to (vect_length t) -1 do
				 		if getCreatureReference t.(i)=x then 
								begin moyXp:=!moyXp+.(getCreatureExperience t.(i));d:=i::(!d);
								raise CreatureFound 
								end
					done; raise CreatureNotFound;
					
					
	


		with 	|CreatureNotFound-> showPopupMessage ("Fusion Failed:You don't have a "^(getReferenceCreatureName references.(x)))  1.0
			|CreatureFound ->
				begin
				(*try*)
				showPopupMessage ("Select a "^getReferenceCreatureName references.(x))  1.0;
				selectCreature gameData;let b=ref true in
				while (!b=true) do
				let a = ref 0  in
				(* get all the events stack *)
					
				while (!a <> -1) 
				do
					a := getEvent();
					if !a = -666 then begin(* closed window *)
						raise MustExit;
					(*if !a = 1 then begin (* escape char *)		
							raise FusionAborted;*)
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
					if !a = 104 && gameData.isSelectingAnything && gameData.selecting = "creature" then begin 
								let idSelected = getAnythingSelection () in
								let creature=(getCharacterCreatures (gameData.character)).(idSelected) in
								if (getCreatureReference creature)=x then	
									begin					
									disableAnythingSelection ();
									gameData.isSelectingAnything <- false;
									gameData.selecting <- "";
									eraseCreature (gameData.character) (idSelected);
									showPopupMessage ("You chose a "^getReferenceCreatureName references.(x))  1.0;
									
									end
								else showPopupMessage ("This is not a "^(getReferenceCreatureName references.(x))) 1.0	
								end
							done;
					if gameData.isSelectingAnything then begin	
					drawWindow(); 
					end
					else begin 
					(*manageMovement gameData 400.0;
					manageCurrentTile gameData;*)
					drawWindow();  b:=false end;
					done;
					fusionCreatures q;
					(*with |FusionAborted ->showPopupMessage ("Fusion Aborted") 1.0;*)
					end
					

			
			end;(*end du 2eme match *)

			in
		

		if (moneyTestFusion obj gameData) then  begin if (testFusion l gameData) then
		fusionCreatures l else showPopupMessage ("You don't have the required wyms") 1.0 end;
		|_ -> ();;

let deleteInventoryItem idSelected gameData=	
						removeItemFromInventory (gameData.character) idSelected;
						showPopupMessage ("You deleted an item")  1.0;
			;;
