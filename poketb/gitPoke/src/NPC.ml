#open "fileParsing";;
#open "graphicsInterface";;
#open "maps";;

type NPC = {
	mutable name: string;
	mutable quests: (bool*int*int*int*int*int) list; (* (canGiveQuest, index of quest, dialogStart, dialogTBD, dialogEnd, dialogDone) list *)
	mutable dialog: int; (* dialog when you talk to him *)
	mutable texture: string;
	mutable presentMap: int;
	mutable position: int*int; (* tileX, tileY *)
	};;

type NPCDatabase = NPCDatabase of NPC vect;;

let getDefaultNPC () = { name=""; quests=[]; dialog= -1; texture=""; presentMap= -1; position=(-1,-1); };;


let showNPCs (NPCDatabase(v)) currentMap currentMapIndex=
	let n = vect_length v - 1 in
	for i=0 to n do
		let a,b = v.(i).position in
		if (v.(i).presentMap = currentMapIndex) then begin (* the NPC is on the current Map *)
			addNPC a b v.(i).texture;									(* draw him *)
			(getMapDefinition currentMap).(b).(a).tile_type <- 1; 		(* don't let user walk on him ;) *)
			(getMapDefinition currentMap).(b).(a).action <- -789; 		(* i love random values to complicate the code *)
		end
	done;
	;;


let getNPCDialog (NPCDatabase(v)) npc = 
	v.(npc).dialog;;

let getNPCQuests (NPCDatabase(v)) npc =
	v.(npc).quests;;

let npcIndexFromPos (NPCDatabase(v)) (a,b) =
	let n = vect_length v - 1 in
	let ret = ref (-1) in
	for i=0 to n do
		if (a,b) = v.(i).position then
			ret := i;
	done;
	!ret;;

let npcCanGiveQuest (NPCDatabase(v)) npc quest =
	let rec containsQuest = function 
		| [] -> false
		| (true,t,_,_,_,_)::q -> if t = quest then true else containsQuest q
		| _::q -> containsQuest q
	in
		containsQuest (v.(npc).quests);;

(* reads 0;232;120;130;12 as (0,232,120,130,12) *)
let readQuest str =
	let sol = make_vect 5 (-1) in
	let n = string_length str - 1 in
	let pt = ref 0 in
	let acc = ref "" in
	for i = 1 to n do
		if nth_char str i = `;` && !pt < 5 then begin
			sol.(!pt) <- int_of_string !acc;
			acc := "";
			pt := !pt + 1;
		end else begin
			acc := (!acc^(string_of_char (nth_char str i)));
		end
	done;
	if !pt < 5 then (* no ; at the end *)
		sol.(!pt) <- int_of_string !acc; 
	((if nth_char str 0 = `1` then true else false),sol.(0), sol.(1), sol.(2), sol.(3), sol.(4));;


let loadNPC stream =
	let line = ref (input_line stream) in
	let npc = getDefaultNPC() in
	while !line <> "</NPC>" do
		if !line = "" then begin end else begin
		if nth_char !line 0 = `#` then begin end else begin
		let (prop, propValue) = parseProperty (!line) in
		match prop with
			| "Name" 	-> npc.name 			<- propValue
			| "Quest"	-> npc.quests 			<- (if propValue <> "" then (readQuest propValue)::npc.quests else npc.quests)
			| "Dialog"	-> npc.dialog 			<- (int_of_string propValue)
			| "Texture"	-> npc.texture			<- propValue
			| "Map"		-> npc.presentMap 		<- (int_of_string propValue)
			| "Position"-> npc.position 		<- let l = (intListOfFormatedString 2 propValue) in (hd l, hd (tl l))
			| _ 		-> failwith "Error in the NPC_loadNPC function. A property has not been found."
		;
		end end;
		line := (input_line stream);
	done;
	npc;;



let readNPCDatabase filename=
	let stream = open_in filename in
	let nb = (int_of_string (input_line stream)) in
	let ret = make_vect nb (getDefaultNPC()) in
	for i=0 to nb-1 do
		let line = input_line stream in
		if line = "" then begin end else begin
		if nth_char line 0 = `#` then begin end else begin
			if line = "<NPC>" then 
				ret.(i) <- loadNPC stream;
		end
		end
	done;
	close_in stream;
	NPCDatabase(ret);;


let getNPCQuest (NPCDatabase(v)) npc quest =
	let rec getIt = function
		| [] -> (false,-1,-1,-1,-1,-1)
		| (a,b,c,d,e,f)::q -> if b = quest then (a,b,c,d,e,f) else getIt q
	in
		getIt (v.(npc).quests);;

let getNPCQuestStartDialog db npc quest =
	let (_,_,s,_,_,_) = getNPCQuest db npc quest in
	s;;

let getNPCQuestTBDDialog db npc quest =
	let (_,_,_,e,_,_) = getNPCQuest db npc quest in
	e;;

let getNPCQuestEndDialog db npc quest =
	let (_,_,_,_,w,_) = getNPCQuest db npc quest in
	w;;

let getNPCQuestDoneDialog db npc quest =
	let (_,_,_,_,_,d) = getNPCQuest db npc quest in
	d;;










