#open "character";;
#open "maps";;
#open "object";;
#open "quests";;
#open "NPC";;
#open "main";;

(* character questsDatabase npc *)
value 	log_getExperience: 			Character -> float 			-> unit
and 	log_dealDamage: 			Character -> int 			-> unit
and 	log_earnGold:				Character -> int 			-> unit
and		log_talkToNPC: 				Character -> QuestsDatabase -> int -> unit
and 	log_killCreature: 			Character -> QuestsDatabase -> int -> unit
and 	log_captureCreature: 		Character -> QuestsDatabase -> int -> unit
and 	log_findItemOnTile:			Character -> QuestsDatabase -> int -> int -> int -> int -> int -> unit
and 	log_killUnitOnTile:			Character -> int 			-> int -> int -> unit
and 	log_rewardFinishedQuest: 	GameData  -> Quest 			-> int -> unit
and		log_changeMap:				Character -> QuestsDatabase -> int -> unit
	
;;
