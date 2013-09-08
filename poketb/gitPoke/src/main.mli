#open "character";;
#open "maps";;
#open "texturesDatabase";;
#open "object";;
#open "quests";;
#open "NPC";;

type GameData = { 
	(* general data *)
	mutable character:			Character;
	mutable currentMap:			Map;
	mutable currentMapIndex:	int;
	mutable texturesDatabase:	TexturesDatabase;
	mutable objectsDatabase:	ObjectDatabase;
	mutable questsDatabase:		QuestsDatabase;
	mutable npcDatabase:		NPCDatabase;
	(* movement related *)
	mutable isMoving: 			bool; 
	mutable currentDirection:	int;
	mutable hasJustChangedMap:	bool;
	(* tile management *)
	mutable hasJustShowDialog: 	int;
	mutable hasJustTriggeredTile: (bool*int*int);
	mutable randomedCreatures: 	(int*int) list;
	(* fight related *)
	mutable isInFight:			bool;
	mutable fightLevel:			int;
	mutable fightWymIndex:		int;
	mutable nextFightDialog:	int*int;
	(* NPC related *)
	mutable npcToTalk:			int*int; (* the position of the npc *)
	mutable isSelectingAnything:bool;
	mutable selecting:			string;
	(* quests related *)
	mutable showingJournal:		bool;
	mutable currentShowedQuest:	int;
	
};;



value 	manageMovement: 		GameData 		-> float	-> unit
and 	manageCurrentTile:		GameData		-> unit
;;


