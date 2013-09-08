#open "maps";;

type NPCDatabase;;

value showNPCs: NPCDatabase -> Map -> int -> unit
and readNPCDatabase: string -> NPCDatabase
and getNPCDialog: NPCDatabase -> int -> int
and getNPCQuests: NPCDatabase -> int -> (bool*int*int*int*int*int) list
and getNPCQuest: NPCDatabase -> int -> int -> (bool*int*int*int*int*int)
and getNPCQuestStartDialog: NPCDatabase -> int -> int -> int
and getNPCQuestTBDDialog: NPCDatabase -> int -> int -> int
and getNPCQuestEndDialog: NPCDatabase -> int -> int -> int
and getNPCQuestDoneDialog: NPCDatabase -> int -> int -> int
and npcIndexFromPos: NPCDatabase -> int*int -> int
and npcCanGiveQuest: NPCDatabase -> int -> int -> bool;;












