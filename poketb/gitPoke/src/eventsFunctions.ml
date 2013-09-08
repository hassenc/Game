#open "character";;
#open "main";;
#open "creature";;
#open "graphicsInterface";;
#open "object";;

(* ***myLevel function returns an average of the creatures level and their number :also used in fights*** *)
let myLevel gameData=
let creaVect=getCharacterCreatures (gameData.character) and nb= ref 0 and moy =ref 0 in
	for i= 0 to ((vect_length creaVect) -1) do 
		if getCreatureParticipation creaVect.(i) then begin moy:=!moy+(Lvl creaVect.(i));nb:=!nb+1 end
	done;
	if !nb > 0 then begin
		moy:=!moy/(!nb);
		(!moy,!nb);
	end else begin 
		print_string "The player is trying to heal his creatures despite he has none of them."; print_newline (); 
		(0,0)
	end;;
(* ******* *)


let startQuest index = 
	();;

let sellItem gameData index = 
	let obj = getObjectByIndex gameData.objectsDatabase index and name=getObjectNameByID gameData.objectsDatabase index in 
	let 	price=getObjectPrice obj in
	let p=searchItemIndex gameData.character 10 in
	if p=(-1) then showPopupMessage "You don't have enough money." 1.0
	else if p<>(-1) then 
		begin
		let (a,b)=(getCharacterInventory gameData.character).(p) in 
			if b<price then showPopupMessage "You don't have enough money." 1.0 
			else if b>=price then
			begin
			addItemInInventory (gameData.character) index 1;
			showPopupMessage ("You 've have bought a "^name) 1.0;
			for i=1 to price do
			removeItemFromInventory gameData.character p
			done	
			end;
		end
;;

let changeMap index gameData = 
	()
	;;
let healCreatures gameData =let (a,b)=myLevel gameData in let price=a in
	let v=getCharacterCreatures gameData.character in
	let p=searchItemIndex gameData.character 10 in
	if p=(-1) then showPopupMessage "You don't have enough money." 1.0
	else if p<>(-1) then 
		begin
		let (a,b)=(getCharacterInventory gameData.character).(p) in 
			if b<price then showPopupMessage "You don't have enough money." 1.0 
			else if b>=price then
			begin
				let n=vect_length v in
				for i=0 to (n-1) do 
				addLife v.(i) (LifeMax(v.(i)));
				addMana v.(i) (ManaMax(v.(i)))
				done;
				showPopupMessage "Your Wyms are 100% ready" 1.0 ;
				for i=1 to (price) do
				removeItemFromInventory (gameData.character) p
				done	
			end;	
		end	;	
;;

