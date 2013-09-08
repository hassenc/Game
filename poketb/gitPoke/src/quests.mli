
#open "fileParsing";;

type QuestsDatabase;;
type Quest;;

value 	readQuestsDatabase: 			string 			-> QuestsDatabase
and		getQuest:						QuestsDatabase 	-> int 				-> Quest
and		getQuestTitle:					Quest 			-> string
and		getQuestSorted:					Quest 			-> bool
and		getQuestMinLevel:				Quest 			-> int
and		getQuestActionsCount: 			Quest 			-> int
and		getQuestMinimumWymLevel:		Quest 			-> int
and		getQuestRequiredQuests:			Quest 			-> int list
and		getQuestExperienceEarned: 		Quest 			-> int
and		getQuestObjectsEarned: 			Quest 			-> int list
and		getQuestCreaturesEarned: 		Quest 			-> int list
and 	getQuestJournalString:			Quest			-> bool vect		-> bool	-> string
and		getQuestTrophyPointsEarned:		Quest			-> int 
and		getQuestObjectsToBring:			Quest			-> (int*int*int) list
and		getQuestObjectsToBringToNPC:	Quest			-> int				-> (int*int*int) list

(* questTalkToNPC: 
	returns the index of the action 'FindNPC' to set to 'done' if there's one (which matches the seen npc). returns -1 in other cases
	example : aquest ctions are [KillCreature; FindNPC(3); FindNPC(2)]
	questTalkToNPC quest 3 -> returns 1
	questTalkToNPC quest 1 -> returns -1
	questTalkToNPC quest 2 -> returns 2
	*)
and 	questTalkToNPC:				Quest			-> int				-> int
and 	questKillCreature:			Quest			-> int				-> int
and 	questVisitMap:				Quest			-> int				-> int
and 	questFindItem:				Quest			-> int				-> int
and 	questCaptureCreature:		Quest			-> int				-> int
and 	questBringObjects:			Quest			-> int*int*int		-> int
;; 

(*
and		getQuestDialog: 
*)


















