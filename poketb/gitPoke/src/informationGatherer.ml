#open "character";;
#open "creature";;
#open "object";;
#open "referenceCreature";;
#open "dialogFunctions";;
#open "gameInformation";;
#open "maps";;
#open "main";;
#open "NPC";;

let getOwnedCreaturesList answers gameData indexOffset =
	let v = getCharacterCreatures (gameData.character) in
	let n = vect_length v in
	let rec process = function
		| -1 -> answers
		| i -> StaticAnswer( (getReferenceCreatureName (getReferenceCreature( getCreatureReference v.(i))))^" (Experience: "^string_of_int (int_of_float (getCreatureExperience v.(i)))^")", i+indexOffset)::(process (i-1))
	in
	process (n-1);;

let getOwnedObjectsList answers gameData indexOffset =
	let v = getCharacterInventory (gameData.character) in
	let n = vect_length v in
	let rec process = function
		| -1 -> answers
		| i -> let (id,amnt) = v.(i) in StaticAnswer( (getObjectNameByID gameData.objectsDatabase id)^" (Nb: "^(string_of_int amnt)^")", indexOffset)::(process (i-1))
	in
	process (n-1);;

let getVisitedMapList answers gameData indexOffset = 
	let l = getGameInfoVisitedMaps (getCharacterInformation gameData.character) in
	let addMapIndexes = if indexOffset/10000 = 3 then true else false in
	let rec process = function
		| [] -> answers
		| t::q -> StaticAnswer( loadMapAndGetName t, if addMapIndexes then t+indexOffset else indexOffset)::(process q)
	in
	process l;;

let getVisitedMapString gameData = 
	let l = getGameInfoVisitedMaps (getCharacterInformation gameData.character) in
	let rec process = function
		| [] -> ""
		| t::[] -> (loadMapAndGetName t)^"\""
		| t::q -> (loadMapAndGetName t)^"\", \""^(process q)
	in
	"\""^process l;;


(* addCorrespondingAnswers function
	returns the answers given as a parameter plus actions that are related to the dynamic action which name
	is the second parameter. 
	
*)
let addCorrespondingAnswers answers gameData indexOffset = function
	| DiscoveredMaps -> getVisitedMapList answers gameData (indexOffset)
	| OwnedCreatures -> getOwnedCreaturesList answers gameData (indexOffset)
	| OwnedObjects -> getOwnedObjectsList answers gameData (indexOffset)
	;;

