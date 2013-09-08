#open "character";;
#open "creature";;
#open "referenceCreature";;
#open "fightDialogFunctions";;
#open "gameInformation";;
#open "main";;
#open "object";;

let refVect=referenceVector ();;


let getAvaiableActionsList answers  gameData indexOffset =
	let creature=(getCharacterCreatures gameData.character).(0) in (*indexOffset normalement envoyé avec 10000*) 
	let v = getReferenceCreatureActions (refVect.( getCreatureReference ( creature ) ))  and l= ref answers in
	let n=vect_length v in
	for i= 0 to (n-1) do
 	if 
	(Lvl  creature ) >= (getFightActionShowingLevel v.(i)) && (Lvl creature) <= (getFightActionHidingLevel v.(i)) && (getCreatureLife creature > getFightActionLifeCost v.(i)) && (getCreatureMana creature >= getFightActionManaCost v.(i))

	then l:=!l@[StaticAnswer(getFightActionName v.(i),i+indexOffset)] done;!l;;




let getAvaiableCreaturesList answers gameData indexOffset =(*indexOffset normalement envoyé avec 30000*) 
let v = getCharacterCreatures (gameData.character)  and l= ref answers in
let n=vect_length v in
	for i= 0 to (n-1) do
if v.(i) <> (getDefaultCreature ()) && (getCreatureLife v.(i) > 0) then l:=!l@[StaticAnswer( (getReferenceCreatureName (refVect.( getCreatureReference v.(i))))^" (Lvl: "^string_of_int (Lvl v.(i))^"    Xp:"^string_of_int (int_of_float (getCreatureExperience v.(i)))^"/"^string_of_int (NextLevelExperience v.(i))^")"^" Life: "^string_of_int (getCreatureLife v.(i)), i+indexOffset)] done;!l;;


let getAllCreaturesList answers gameData indexOffset =(*indexOffset normalement envoyé avec 50000*) 
let v = getCharacterCreatures (gameData.character)  and l= ref answers in
let n=vect_length v in
	for i= 0 to (n-2) do
if v.(i) <> (getDefaultCreature ()) then l:=!l@[StaticAnswer( (getReferenceCreatureName (refVect.( getCreatureReference v.(i))))^" (Lvl: "^string_of_int (Lvl v.(i))^"    Xp:"^string_of_int (int_of_float (getCreatureExperience v.(i)))^"/"^string_of_int (NextLevelExperience v.(i))^")"^" Life: "^string_of_int (getCreatureLife v.(i)), i+indexOffset)] done;
if v.(n-1) <> (getDefaultCreature ()) then l:=!l@[StaticAnswer( "Abandon "^(getReferenceCreatureName (refVect.( getCreatureReference v.(n-1))))^" (Lvl: "^string_of_int (Lvl v.(n-1))^"    Xp:"^string_of_int (int_of_float (getCreatureExperience v.(n-1)))^"/"^string_of_int (NextLevelExperience v.(n-1))^")"^" Life: "^string_of_int (getCreatureLife v.(n-1)), (n-1)+indexOffset)] ;!l;;



let getAvaiableItemsList answers gameData indexOffset =(*indexOffset normalement envoyé avec 20000*) 
let objDatabase=gameData.objectsDatabase and v=getCharacterInventory (gameData.character) and l= ref answers in
let n=vect_length v in
	for i=0 to (n-1) do
		let (reference,quantity)=v.(i) in 
		let obj=getObjectByIndex objDatabase (reference) and name=getObjectNameByID objDatabase (reference) and givenAmount=getObjectGivenAmountByID objDatabase (reference) in
		match obj with
			| LifePotion(_) -> l:=!l@[StaticAnswer( name^" : "^(string_of_int givenAmount)^"   (quantity: x"^(string_of_int quantity)^")",i+indexOffset)] 
			| ManaPotion(_) -> l:=!l@[StaticAnswer( name^" : "^(string_of_int givenAmount)^"   (quantity: x"^(string_of_int quantity)^")",i+indexOffset)]
			| CreatureGetter(_) -> l:=!l@[StaticAnswer( name^"   (quantity: x"^(string_of_int quantity)^")",i+indexOffset)]
			| _ -> () 
	done;!l;;











(* ******************************************Dynamic Text*******************************************************************)

let getSelectedAction param gameData=
let action=(getReferenceCreatureActions (refVect.(getCreatureReference (getCharacterCreatures gameData.character).(0)))).(param) in
getFightActionName action;;


let getSelectedEnemy creature=
(getReferenceCreatureName (refVect.( getCreatureReference creature)));;

let getSelectedCreature gameData=
let v = getCharacterCreatures (gameData.character) in
(getReferenceCreatureName (refVect.( getCreatureReference v.(0))));;

let getSelectedItem param gameData=
let objDatabase=gameData.objectsDatabase and v=getCharacterInventory (gameData.character) in
let (reference,quantity)=v.(param) in 
getObjectNameByID objDatabase (reference);;
(* *****************************************************************************************************************************)















(* addCorrespondingAnswers function
	returns the answers given as a parameter plus actions that are related to the dynamic action which name
	is the second parameter. *)

let addCorrespondingAnswers2 answers gameData indexOffset = function
	| AvaiableCreatures ->getAvaiableCreaturesList answers gameData (indexOffset)
	| AvaiableActions ->getAvaiableActionsList answers gameData (indexOffset)
	| AvaiableItems	->getAvaiableItemsList answers gameData (indexOffset)
	| AllCreatures	->getAllCreaturesList answers gameData (indexOffset)
;;
