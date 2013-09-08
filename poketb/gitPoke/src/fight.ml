#open "main";;
#open "referenceCreature";;
#open "creature";;
#open "fightInterface";;
#open "fightFunctions";;
#open "graphicsInterface";;
#open "fightDialog";;
#open "character";;
#open "log";;


(* ***************fight**************************)
let refVect= referenceVector ();;



let fight gameData enemyRefIndex enemyLvl=
	let otherCreature = getDefaultCreature ()
	in

	setCreatureReference otherCreature enemyRefIndex;
	setCreatureExperience otherCreature (float_of_int ((enemyLvl*enemyLvl*enemyLvl)+1));
	setCreatureLife otherCreature (LifeMax otherCreature);
	setCreatureMana otherCreature (ManaMax otherCreature);


	clearLeftFightWindow();
	setRightCreature otherCreature;
	updateBarsTextures();
	updateBarsStrings();
	updateCreaturesStrings();
	drawFightInterface();

	enableDialog();
	processFight 10 gameData otherCreature 0;


	try

	while gameData.isInFight=true do
		if (stillAlive gameData) then
			begin
			enableDialog();
			processFight 19  gameData otherCreature 0; (* choix sans option Back *)
			let 	myCreature=(getCharacterCreatures gameData.character).(0) in
				begin
					setLeftCreature myCreature;
					updateBarsTextures();
					updateBarsStrings();
					updateCreaturesStrings();
					drawFightInterface();
				
					setCreatureParticipation myCreature true;
					while ((getCreatureLife myCreature)>0) && ((getCreatureLife otherCreature)>0) && (gameData.isInFight=true) do
						processFight 11 gameData otherCreature 0; (*choisir attaque et attaque*)
						let myCreature=(getCharacterCreatures gameData.character).(0) in
						processFight (fst (gameData.nextFightDialog))  gameData otherCreature (snd (gameData.nextFightDialog));
						gameData.nextFightDialog<-(18,0);
						setLeftCreature myCreature;
						setRightCreature otherCreature;
						updateBarsTextures();
						updateBarsStrings();
						updateCreaturesStrings();
						drawFightInterface();
					
						if ((getCreatureLife otherCreature)=0) then raise I_Win 
						else	begin
							if (getCreatureParticipation myCreature=true) &&  (gameData.isInFight=true)
							(* si c'est la première fois qu'elle apparait,la creature a la priorité*)
							then 
								begin
								hitMe gameData myCreature otherCreature enemyLvl;
								processFight (fst (gameData.nextFightDialog))  gameData otherCreature (snd (gameData.nextFightDialog));
								gameData.nextFightDialog<-(18,0);
								setRightCreature otherCreature;
								setLeftCreature myCreature;
								updateBarsTextures();
								updateBarsStrings();
								drawFightInterface()
								end
							else setCreatureParticipation myCreature true
							end ;
					
					done
				end
			end
		else raise Game_Over (*actualiser le vect?*)
	done;

	false;

	with 	|I_Win-> begin 	enableDialog();
					processFight 16  gameData otherCreature 0;
					log_killCreature (gameData.character) (gameData.questsDatabase) (getCreatureReference otherCreature);
					win gameData enemyLvl;clearLeftFightWindow(); true end
		| Game_Over-> (*win gameData enemyLvl*) begin enableDialog();
				processFight 17  gameData otherCreature 0 ;gameData.isInFight<-false;clearLeftFightWindow(); false end
		| CapturedCreature -> begin clearLeftFightWindow(); true end
	;;


