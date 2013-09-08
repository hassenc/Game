
#open "fileParsing";;

(* description des types :
	int values reprensents references in databases.
*)
type ActionType = 
	  None 
	| Kill of int 			
	| FindMap of int 
	| FindObject of int  
	| BringObject of (int*int*int)  (* object, quantity, npc *)
	| FindNPC of int
	| Capture of int
	;;

(* quest type 
	 *)
type Quest = {
	mutable actions: (ActionType*string) vect; (* Actions, string shown in journal before you did the quest *)
	mutable title: string;
	mutable sorted: bool;
	mutable npc: int;
	mutable minWymLevel: int;
	mutable experienceEarned: int;
	mutable objectsEarned: int list;
	mutable creaturesEarned: int list;
	mutable trophyPointsEarned: int;
	mutable requiredQuests:	int list;
	};;

type QuestsDatabase = QuestsDatabase of Quest vect;;

let getDefaultQuest () = {actions=[||]; sorted=true; npc= -1; experienceEarned=0; objectsEarned = []; title=""; minWymLevel=0; creaturesEarned=[]; trophyPointsEarned = 0; requiredQuests = []};;

let parseProperty2 str =
		let posStart,posEqual,startQuote,endQuote,midLimit = index_char str `P`, index_char str `=`, index_char str `"`, rindex_char str `"`, rindex_char str `;` in
		if midLimit >= 0 then
			sub_string str (posStart+2) (posEqual-posStart-2),
		 	sub_string str (startQuote+1) (midLimit-startQuote-1),
		 	sub_string str (midLimit+1) (endQuote-midLimit-1)
		else
			sub_string str (posStart+2) (posEqual-posStart-2),
			sub_string str (startQuote+1) (endQuote-startQuote-1),""
	;;

let readActions stream =
	let line = ref (input_line stream) in
	let v = ref [||] in
	let i = ref (0) in
	let continue = ref true in
	while !continue do
		if !line = "" then begin end else begin
		if nth_char !line 0 = `#` then begin end 
		else begin
			let prop, propVal, propText = parseProperty2 !line in
			let _ = match prop with
				| "ActionsNB" 		-> v := make_vect (int_of_string propVal) (None, "")
				| "Kill" 			-> !v.(!i) <- Kill(int_of_string propVal), propText
				| "FindMap"			-> !v.(!i) <- FindMap(int_of_string propVal), propText
				| "FindObject"		-> !v.(!i) <- FindObject(int_of_string propVal), propText
				| "BringObject"		-> !v.(!i) <- BringObject(let a = intListOfFormatedString 4 propVal in (hd a, hd (tl a), hd (tl (tl a)))), propText
				| "FindNPC"			-> !v.(!i) <- FindNPC(int_of_string propVal), propText
				| "Capture"			-> !v.(!i) <- Capture(int_of_string propVal), propText
				| "TAG"	-> if propVal = "</Actions>" then continue := false
				| _ -> begin print_string "failwith"; print_newline (); failwith "This type has never existed for quests actions." end
			in
			if (prop <> "ActionsNB") then
				i := !i+1;	
		end; end;
		if (!continue) then
			line := input_line stream;
	done;
	!v;;

let readQuest stream =
	let line = ref (input_line stream) in
	let quest = getDefaultQuest () in
	while !line <> "</Quest>" do
		if !line = "" then begin end else begin
		if nth_char !line 0 = `#` then begin end 
		else begin
			let prop, propVal = parseProperty !line in
			match prop with
				| "TAG" 			-> if propVal = "<Actions>" then quest.actions <- (readActions stream) else ()
				| "Title" 			-> quest.title <- propVal
				| "Sorted"			-> quest.sorted <- (propVal="1")
				| "NPC"				-> quest.npc <- (int_of_string propVal)
				| "ExpEarned"		-> quest.experienceEarned <- (int_of_string propVal)
				| "MinWymLevel"		-> quest.minWymLevel <- (int_of_string propVal)
				| "ObjectsEarned"	-> quest.objectsEarned <- (intListOfFormatedString 3 propVal)
				| "CreaturesEarned"	-> quest.creaturesEarned <- (intListOfFormatedString 3 propVal)
				| "TrophyPoints"	-> quest.trophyPointsEarned <- (int_of_string propVal)
				| "RequiredQuests"	-> quest.requiredQuests <- (intListOfFormatedString 4 propVal)
				| _					-> failwith "Did you hack the quests files ? little cheater !"
			;
		end; end;
		line := input_line stream;
	done;
	quest;;

let readQuestsDatabase filename =
	let stream = open_in filename in
	let ret = make_vect (int_of_string (input_line stream)) (getDefaultQuest ()) in
	let line = ref (input_line stream) in	
	try
		for i=0 to vect_length ret - 1 do
			if !line = "<Quest>" then
				ret.(i) <- readQuest stream
			else ();
			line := input_line stream;
		done;
		close_in stream;
		QuestsDatabase(ret);
	with
		End_of_file -> begin close_in stream; QuestsDatabase(ret); end;;

let getQuest (QuestsDatabase(v)) i = v.(i);;
let getQuestTitle q= q.title;;
let getQuestSorted q = q.sorted;;
let getQuestMinLevel q= q.minWymLevel;;
let getQuestActionsCount q = vect_length (q.actions);;
let getQuestMinimumWymLevel q = q.minWymLevel;;
let getQuestRequiredQuests q = q.requiredQuests;;
let getQuestExperienceEarned q = q.experienceEarned;;
let getQuestObjectsEarned q = q.objectsEarned;;
let getQuestCreaturesEarned q = q.creaturesEarned;;
let getQuestActionStrings q = 
	let rec getStrings v = function
		| -1 -> []
		| i -> let a,_ = v.(i) in a::(getStrings v (i-1))
	in
		getStrings (q.actions) (vect_length q.actions)
;;
let getQuestTrophyPointsEarned q = q.trophyPointsEarned;;

let getQuestObjectsToBring q =
	let n = vect_length (q.actions) - 1 in
	let ret = ref [] in
	for i = 0 to n do
		match q.actions.(i) with
			| BringObject(item, quantity, npc),_ -> ret := (item, quantity, npc)::(!ret)
			| _ -> ();
	done;
	!ret
	;;
let getQuestObjectsToBringToNPC q npcID =
	let n = vect_length (q.actions) - 1 in
	let ret = ref [] in
	for i = 0 to n do
		match q.actions.(i) with
			| BringObject(item, quantity, npc),_ when npc = npcID -> ret := (item, quantity, i)::(!ret)
			| _ -> ();
	done;
	!ret
	;;

let getQuestJournalString q doneVect hasBeenDone =
	if q.sorted then begin (* the quest is sorting actions *)
		let rec addAllSteps v = function
			| i when i = (vect_length v - 1) -> 
					let _,s = v.(vect_length v - 1) in if hasBeenDone then ("[Done] "^s) else if doneVect.(vect_length v - 1) then ("[Done] "^s) else s
			| i  -> let _,s = v.(i) in begin 
					if hasBeenDone then 
						("[Done] "^s^"\\n"^(addAllSteps v (i+1))) 
					else
					let newPart = if doneVect.(i) = true then ("[Done] "^s) else s in
					if doneVect.(i) = false then newPart else newPart^"\\n"^(addAllSteps v (i+1))
				end
		in
			(addAllSteps (q.actions) 0)^(if hasBeenDone then "\\n\\n\\n\t\t REWARDED" else "")
	end else begin
		let rec addString v = function
			| 0 -> let _,s = v.(0) in (if hasBeenDone then("[Done] "^s) else if doneVect.(0) then ("[Done] "^s) else s)
			| i  -> let _,s = v.(i) in ((if hasBeenDone then("[Done] "^s) else if doneVect.(i) then ("[Done] "^s) else s)^"\\n\\n"^(addString v (i-1)))
		in
			(addString (q.actions) (vect_length q.actions - 1))^(if hasBeenDone then "\\n\\n\\n\t\t REWARDED" else "")
	end
;;



let questTalkToNPC q npc =
	let n = vect_length (q.actions) - 1 in
	let ret = ref (-1) in
	for i = 0 to n do
		match q.actions.(i) with
			| FindNPC(found),_ when found = npc -> ret := i
			| _ -> ();
	done;
	!ret
	;;

let questKillCreature q creature =
	let n = vect_length (q.actions) - 1 in
	let ret = ref (-1) in
	for i = 0 to n do
		match q.actions.(i) with
			| Kill(found),_ when found = creature -> ret := i
			| _ -> ();
	done;
	!ret
	;;

let questVisitMap q mapIndex =
	let n = vect_length (q.actions) - 1 in
	let ret = ref (-1) in
	for i = 0 to n do
		match q.actions.(i) with
			| FindMap(found),_ when found = mapIndex -> ret := i
			| _ -> ();
	done;
	!ret
	;;

let questFindItem q itemFound =
	let n = vect_length (q.actions) - 1 in
	let ret = ref (-1) in
	for i = 0 to n do
		match q.actions.(i) with
			| FindObject(found),_ when found = itemFound -> ret := i
			| _ -> ();
	done;
	!ret
	;;

let questCaptureCreature q capturedWym =
	let n = vect_length (q.actions) - 1 in
	let ret = ref (-1) in
	for i = 0 to n do
		match q.actions.(i) with
			| Capture(found),_ when found = capturedWym -> ret := i
			| _ -> ();
	done;
	!ret
	;;

let questBringObjects q param = 
	let n = vect_length (q.actions) - 1 in
	let ret = ref (-1) in
	for i = 0 to n do
		match q.actions.(i) with
			| BringObject(parameter),_ when param=parameter -> ret := i
			| _ -> ();
	done;
	!ret
	;;













