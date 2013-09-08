#open "graphicsInterface";;
#open "fightInterface";;
#open "dialogFunctions";;
#open "dialog";;
#open "character";;
#open "creature";;
#open "referenceCreature";;
#open "main";;
#open "object";;
#open "log";;
#open "random";;
#open "eventsFunctions";;(*contains myLevel *)

let refVect= referenceVector ();;
exception I_Win;;
exception Not_Enough_Mana_Life;;
exception Game_Over;;
exception Run_Away;;
exception CapturedCreature;;

(* *******************************************When winning************************************************)



let obtainedXp gameData enemyLvl=
let creaVect=getCharacterCreatures (gameData.character)  and (moy,nb)=(myLevel gameData) in

	if (enemyLvl-(moy))<0 then 4.*.(exp((float_of_int(enemyLvl-(moy))-.1.)**3./.300.)/.float_of_int(nb))
	else 4.*.((1.+.100.*.(exp((float_of_int enemyLvl)/.(float_of_int moy)*.float_of_int(enemyLvl-(moy))/.2000.)-.1.))/.float_of_int(nb))
;;



(*Experience sharing*)
let shareXp gameData enemyLvl=
	let creaVect=getCharacterCreatures (gameData.character) and nb= ref 0 and moy =ref 0 and xp =(obtainedXp gameData enemyLvl) in
	begin
		for i= 0 to ((vect_length creaVect) -1) do 
			if getCreatureParticipation (creaVect.(i)) then addExperience (creaVect.(i)) xp 
		done;

	end;;





(*prize*)
let choosePrize gameData enemyLvl=11;; (* index of 5 gold *)
let givePrize gameData enemyLvl= let a=choosePrize gameData enemyLvl in	addItemInInventory (gameData.character) a (getObjectGivenAmountByID (gameData.objectsDatabase) a);
if getObjectName (getObjectByIndex (gameData.objectsDatabase) a) = "Gold" then log_earnGold (gameData.character) (getObjectGivenAmountByID (gameData.objectsDatabase) a);;





(*I win*)
let win gameData enemyLvl=
	let creaVect=getCharacterCreatures (gameData.character) in
	begin
	gameData.isInFight<-false;
	let a=choosePrize gameData enemyLvl in
	showPopupMessage ("Involved Wyms won "^(string_of_float(obtainedXp gameData enemyLvl))^ "xp.\nAnd you won "^string_of_int(getObjectGivenAmountByID (gameData.objectsDatabase) a)^" "^(getObjectNameByID (gameData.objectsDatabase) a )^"(s).") 5.0;
	shareXp gameData enemyLvl;
	givePrize gameData enemyLvl;
	log_getExperience (gameData.character) (obtainedXp gameData enemyLvl);
		for i= 0 to ((vect_length creaVect) -1) do 
			if getCreatureParticipation (creaVect.(i)) then setCreatureParticipation (creaVect.(i)) false 
		done;
	end;;
	let gameOver ()=();;







(* ************************************Fight Dialog Functions***********************************************)

(*graphic life and mana change functions*)






(*FightAction taking effect*)
(*In the parameter you will notice a boolean: if it's true its our player's turn, else its the other creature turn*)
let accessAction character creature1 creature2 action boolean=
begin	
	let l1=Lvl creature1 in let p1=(exp((float_of_int(Lvl creature1)-.1.)/.4.5)) in
	try
		begin
		(*Removing life cost*)
		if getCreatureLife creature1 > getFightActionLifeCost action then	
		let finalLife=((getCreatureLife creature1) - (getFightActionLifeCost action)) in
		if boolean then setLeftLifeMax (LifeMax creature1) else setRightLifeMax (LifeMax creature1);
		while (getCreatureLife creature1)> (finalLife) do begin
						addLife creature1 (-1);
						if boolean then setLeftLife (getCreatureLife creature1) else setRightLife (getCreatureLife creature1);
						updateBarsTextures();
						updateBarsStrings();
						updateCreaturesStrings();
						drawFightInterface();
						end
		done
		
		else raise Not_Enough_Mana_Life;


		(*Removing mana cost*)
		if getCreatureMana creature1 >= getFightActionManaCost action then
		let finalMana=((getCreatureMana creature1) - (getFightActionManaCost action)) in
		if boolean then setLeftManaMax (ManaMax creature1) else setRightManaMax (ManaMax creature1);
		while (getCreatureMana creature1)> (finalMana) do begin
						addMana creature1 (-1);
						if boolean then setLeftMana (getCreatureMana creature1) else setRightMana (getCreatureMana creature1);
						updateBarsTextures();
						updateBarsStrings();
						updateCreaturesStrings();
						drawFightInterface();
						end
			done
		else raise Not_Enough_Mana_Life;



		(*Adding life gain*)
		if ((getCreatureLife creature1) + (getFightActionLifeGain action))<(LifeMax creature1) then
		begin
			let finalLife=((getCreatureLife creature1) + (getFightActionLifeGain action)) in
			if boolean then setLeftLifeMax (LifeMax creature1) else setRightLifeMax (LifeMax creature1);
			while (getCreatureLife creature1)< (finalLife) do begin
						addLife creature1 (1);
						if boolean then setLeftLife (getCreatureLife creature1) else setRightLife (getCreatureLife creature1);
						updateBarsTextures();
						updateBarsStrings();
						updateCreaturesStrings();
						drawFightInterface();
						end
			done
		end
		else
		begin
			let finalLife=(LifeMax creature1) in
			if boolean then setLeftLifeMax (LifeMax creature1) else setRightLifeMax (LifeMax creature1);
			while (getCreatureLife creature1)< (finalLife) do 
						addLife creature1 (1);
						if boolean then setLeftLife (getCreatureLife creature1) else setRightLife (getCreatureLife creature1);
						updateBarsTextures();
						updateBarsStrings();
						updateCreaturesStrings();
						drawFightInterface();
						
		
			done
		end;

		(*Adding mana gain*)
		if ((getCreatureMana creature1) + (getFightActionManaGain action))<(ManaMax creature1) then
		begin
			let finalMana=((getCreatureMana creature1) + (getFightActionManaGain action)) in
			if boolean then setLeftManaMax (ManaMax creature1) else setRightManaMax (ManaMax creature1);
			while (getCreatureMana creature1)< (finalMana) do begin
						addMana creature1 (1);
						if boolean then setLeftMana (getCreatureMana creature1) else setRightMana (getCreatureMana creature1);
						updateBarsTextures();
						updateBarsStrings();
						updateCreaturesStrings();
						drawFightInterface();
						end
			done
		end
		else
		begin
			let finalMana=(ManaMax creature1) in
			if boolean then setLeftManaMax (ManaMax creature1) else setRightManaMax (ManaMax creature1);
			while (getCreatureMana creature1)< (finalMana) do begin
						addMana creature1 (1);
						if boolean then setLeftMana (getCreatureMana creature1) else setRightMana (getCreatureMana creature1);
						updateBarsTextures();
						updateBarsStrings();
						updateCreaturesStrings();
						drawFightInterface();
						end
			done
		end;

		(*Removing life damage*)
		if getCreatureLife creature2 > (int_of_float(float_of_int(getFightActionLifeDamage action)*.p1)) then
		begin
			let finalLife=((getCreatureLife creature2) - (int_of_float(float_of_int(getFightActionLifeDamage action)*.p1))) in
			if boolean then log_dealDamage character (int_of_float(float_of_int (getFightActionLifeDamage action)*.p1));
			(*if boolean then setRightLifeMax (LifeMax creature2) else setLeftLifeMax (LifeMax creature2);*)
			while (getCreatureLife creature2)> (finalLife) do 
						addLife creature2 (-1);
						if boolean then setRightLife (getCreatureLife creature2) else setLeftLife (getCreatureLife creature2);
						updateBarsTextures();
						updateBarsStrings();
						updateCreaturesStrings();
						drawFightInterface();
						
			done
		end
		else 
		begin
			if boolean then log_dealDamage character (getCreatureLife creature2);
			let finalLife=0 in
			if boolean then setRightLifeMax (LifeMax creature2) else setLeftLifeMax (LifeMax creature2);
			while (getCreatureLife creature2)> (finalLife) do begin
						addLife creature2 (-1);
						if boolean then setRightLife (getCreatureLife creature2) else setLeftLife (getCreatureLife creature2);
						updateBarsTextures();
						updateBarsStrings();
						updateCreaturesStrings();
						drawFightInterface();
						end
			done
		end;


		(*Removing mana damage*)
		if getCreatureMana creature2 >= (int_of_float(float_of_int(getFightActionManaDamage action)*.p1)) then 
		begin
			let finalMana=((getCreatureMana creature2) - (int_of_float(float_of_int(getFightActionManaDamage action)*.p1))) in
			if boolean then setRightManaMax (ManaMax creature2) else setLeftManaMax (ManaMax creature2);
			while (getCreatureMana creature2)> (finalMana) do 
						addMana creature2 (-1);
						if boolean then setRightMana (getCreatureMana creature2) else setLeftMana (getCreatureMana creature2);
						updateBarsTextures();
						updateBarsStrings();
						updateCreaturesStrings();
						drawFightInterface();
						
			done
		end
		 else
		begin
			let finalMana=0 in
			if boolean then setRightManaMax (ManaMax creature2) else setLeftManaMax (ManaMax creature2);
			while (getCreatureMana creature2)> (finalMana) do
						addMana creature2 (-1);
						if boolean then setRightMana (getCreatureMana creature2) else setLeftMana (getCreatureMana creature2);
						updateBarsTextures();
						updateBarsStrings();
						updateCreaturesStrings();
						drawFightInterface();
						
			done
 		end;
		end
	with |Not_Enough_Mana_Life->raise Not_Enough_Mana_Life
end;;









(*hit*)
let hit param gameData creature2 =
	let creature1=(getCharacterCreatures gameData.character).(0)
	and action=(getReferenceCreatureActions (refVect.(getCreatureReference (getCharacterCreatures gameData.character).(0)))).(param)
	in	accessAction (gameData.character) creature1 creature2 action true;
	gameData.nextFightDialog<-(25,(param));;

(*Tests if it's possible to get the creature*)
let possibleGetting gameData creature2=
	if (float_of_int (getCreatureLife creature2)/. float_of_int (LifeMax creature2))<= 0.2 then true else false;;




(*useItem*)
let useItem param gameData creature2 = 
	let objDatabase=gameData.objectsDatabase and inventory=getCharacterInventory (gameData.character)  and creature1=((getCharacterCreatures gameData.character).(0)) in

	let (reference,quantity)=inventory.(param) in 
			let obj=getObjectByIndex objDatabase (reference) and name=getObjectNameByID objDatabase (reference) and givenAmount=getObjectGivenAmountByID objDatabase (reference) in

	match obj with
			| ManaPotion(_) -> if ((getCreatureMana creature1) +  (givenAmount))<(ManaMax creature1) then
							begin
						   	let finalMana=((getCreatureMana creature1) + givenAmount) in
							setLeftManaMax (ManaMax creature1); 
							while (getCreatureMana ((getCharacterCreatures gameData.character).(0)))< (finalMana) do 
							addMana ((getCharacterCreatures gameData.character).(0)) (1);
							setLeftMana (getCreatureMana ((getCharacterCreatures gameData.character).(0))) ;
							updateBarsTextures();
							updateBarsStrings();
							updateCreaturesStrings();
							drawFightInterface();
							done
							end
						else
							begin
							let finalMana=(ManaMax creature1) in
							setLeftManaMax (ManaMax creature1); 
							while (getCreatureMana ((getCharacterCreatures gameData.character).(0)))< (finalMana) do 
							addMana ((getCharacterCreatures gameData.character).(0)) (1);
							setLeftMana (getCreatureMana ((getCharacterCreatures gameData.character).(0))) ;
							updateBarsTextures();
							updateBarsStrings();
							updateCreaturesStrings();
							drawFightInterface();
							done
							end
						(*;gameData.nextFightDialog<-(27,param)*)(*problem when deleting the last item in inventory*); removeItemFromInventory (gameData.character) param;setCreatureParticipation creature1 false

			| LifePotion(_) -> if ((getCreatureLife creature1) +  (givenAmount))<(LifeMax creature1) then
							begin
						  	let finalLife=((getCreatureLife creature1) + (givenAmount)) in
							setLeftLifeMax (LifeMax creature1);
							while (getCreatureLife creature1)< (finalLife) do
							addLife (creature1) (1);
							setLeftLife (getCreatureLife creature1);
							updateBarsTextures();
							updateBarsStrings();
							updateCreaturesStrings();
							drawFightInterface();
							done
							end
						else
							begin
						 	let finalLife=(LifeMax creature1) in
							setLeftLifeMax (LifeMax creature1);
							while (getCreatureLife creature1)< (finalLife) do
							addLife (creature1) (1);
							setLeftLife (getCreatureLife creature1);
							updateBarsTextures();
							updateBarsStrings();
							updateCreaturesStrings();
							drawFightInterface();
							done
							end(*;gameData.nextFightDialog<-(27,param)*); removeItemFromInventory (gameData.character) param;setCreatureParticipation creature1 false
			| CreatureGetter(_) ->	if (possibleGetting gameData creature2) 
							then 
								begin 
								addCreature (gameData.character) creature2 ;
								gameData.isInFight<-false;
								(* remplacement éventuel de creatures, si nombre>10*)
								let n=vect_length (getCharacterCreatures gameData.character) in 
									if n=10 then gameData.nextFightDialog<-(21,0) 	 
									else gameData.nextFightDialog<-(23,0) ;
								removeItemFromInventory (gameData.character) param;
								win gameData (Lvl creature2);
								log_captureCreature (gameData.character) (gameData.questsDatabase) (getCreatureReference creature2);
								raise CapturedCreature;
								end
							else begin gameData.nextFightDialog<-(22,0);removeItemFromInventory (gameData.character) param end
						
			|_ -> ();;






(*changing creature*)
let changeCreature index gameData = 
	let tmp= ref (getCharacterCreatures gameData.character).(0) in
	(getCharacterCreatures gameData.character).(0)<-(getCharacterCreatures gameData.character).(index);
	(getCharacterCreatures gameData.character).(index)<-(!tmp);
	gameData.nextFightDialog<-(27,0);;


(*runnig*)
let run param gameData creature2 =let moy,nb=(myLevel gameData) in


if (*moy > (Lvl creature2) *)(random__int 2)=0
						then
							begin gameData.isInFight<-false;
							gameData.nextFightDialog<-(24,0)
							end
						else gameData.nextFightDialog<-(20,0);;


(*Deleting a Creature*)
let deleteCreature param gameData=eraseCreature (gameData.character) param;;



(* *****************************************************************************************************************)


(*i begin*)
let ibegin character enemyLvl= (Lvl (getCharacterCreatures character).(0)  )>= enemyLvl;;

let stillAlive gameData=let creatures=getCharacterCreatures (gameData.character) and b=ref false in
for i=0 to ((vect_length creatures) -1)   do
b:=!b or ((getCreatureLife (creatures.(i))) >0)
done;
if !b=true then true else false;; 


(*
let lvlUp
let prize
*)

(*artificial intelligence *)
let chooseAttack myCreature otherCreature=
0;;


(*HitMe function*)
let hitMe gameData myCreature otherCreature enemyLvl=
	let action=(getReferenceCreatureActions refVect.((getCreatureReference otherCreature))).(chooseAttack myCreature otherCreature) in accessAction (gameData.character) otherCreature myCreature action false;gameData.nextFightDialog<-(26,(chooseAttack myCreature otherCreature));;



(* ******************************************* Set creature************************************************)
let setLeftCreature creature=
setLeftManaMax (ManaMax creature);
setLeftLifeMax (LifeMax creature);
setLeftLife (getCreatureLife creature);
setLeftMana (getCreatureMana creature);
setLeftCreatureLevel (Lvl creature);
setLeftCreatureName (getReferenceCreatureName (refVect.(getCreatureReference creature)));
setLeftCreatureTexture (getReferenceCreatureTexturePath (refVect.(getCreatureReference creature)))
;;

let setRightCreature creature=
setRightManaMax (ManaMax creature);
setRightLifeMax (LifeMax creature);
setRightLife (getCreatureLife creature);
setRightMana (getCreatureMana creature);
setRightCreatureLevel (Lvl creature);
setRightCreatureName (getReferenceCreatureName refVect.(getCreatureReference creature));
setRightCreatureTexture (getReferenceCreatureTexturePath (refVect.(getCreatureReference creature)))
;;

