#open "graphicsInterface";;
#open "referenceCreature";;
#open "encrypter";;
#open "fileParsing";;

(*let az = writeMediaIntegrity ();;*)
let referenceVector ()=readCreature (checkFile "media/creatures/references/refCreatures.txt");;

let refVect=referenceVector ();;


type Creature = { 
	mutable life : int;
	mutable mana : int;
	mutable experience : float;
	mutable reference : int;
	mutable participation :bool
};;

let getDefaultCreature () = 
	{ life=0; mana=0; experience=0.; reference=0;participation=false };;

let getCreatureLife creature = creature.life;;
let getCreatureMana creature = creature.mana;;
let getCreatureExperience creature = creature.experience;;
let getCreatureReference creature = creature.reference;;
let getCreatureParticipation creature = creature.participation;;

let Lvl creature= int_of_float ((creature.experience)**(1./.3.));;
let LifeMax creature = int_of_float((exp((float_of_int(Lvl creature)-.1.)/.4.))*.float_of_int(getReferenceCreatureLife(refVect.(creature.reference))));;
let ManaMax creature = int_of_float((exp((float_of_int(Lvl creature)-.1.)/.4.))*.float_of_int(getReferenceCreatureMana(refVect.(creature.reference))));;
let NextLevelExperience creature = int_of_float ((float_of_int ((Lvl creature) + 1))**(3.));;

let setCreatureLife creature life = 
	creature.life <- life;
	if creature.life > LifeMax creature then
		creature.life <- LifeMax creature
	else if creature.life < 0 then
		creature.life <- 0;;
let setCreatureMana creature mana = 
	creature.mana <- mana;
	if creature.mana > ManaMax creature then
		creature.mana <- ManaMax creature
	else if creature.mana < 0 then
		creature.mana <- 0;;

let setCreatureExperience creature experience = creature.experience <- experience;;
let setCreatureReference creature reference = creature.reference <- reference;;
let setCreatureParticipation creature participation= creature.participation<- participation;;



(* removeLife function :
	removes some hp to the given creature *)
(*
let removeLife creature life =
	creature.life <- (creature.life - life);;
*)
let addLife creature life = 
	let tmp = (creature.life + life) in
	let lifeMax = LifeMax creature in
	if (tmp >= lifeMax ) then
		creature.life <- lifeMax
	else
		creature.life <- tmp
;;


let addMana creature mana = 
	let tmp = (creature.mana + mana) in
	let manaMax = ManaMax creature in
	if (tmp >= manaMax ) then
		creature.mana <- manaMax
	else
		creature.mana <- tmp
;;

let addExperience creature xp = 
	let lastLevel=ref (Lvl creature) 
	and tmp = (creature.experience +. xp) 
	and lastLifePercent=ref ((float_of_int creature.life)/.(float_of_int (LifeMax creature))) 
	and lastManaPercent=ref ((float_of_int creature.mana)/.(float_of_int (ManaMax creature)))  in
		begin
		let nextLevel=int_of_float (tmp**(1./.3.)) in
		creature.experience <- tmp;
			if (!lastLevel) <> nextLevel then 
				begin
				(*showPopupMessage ((getReferenceCreatureName refVect.(creature.reference))^"is now level: "^string_of_int nextLevel) 1.0*) ();
				creature.life<-int_of_float((float_of_int (LifeMax creature))*.(!lastLifePercent));
				creature.mana<-int_of_float((float_of_int (ManaMax creature))*.(!lastManaPercent));
				end
		
		
		end		
;;



