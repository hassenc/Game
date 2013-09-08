
type FightAction;;

type ReferenceCreature;;

value	getReferenceCreature:				int					-> ReferenceCreature
and 	defaultReferenceCreature:			unit->	ReferenceCreature 
and 	getReferenceCreatureName: 			ReferenceCreature 	-> string
and 	getReferenceCreatureLife: 			ReferenceCreature 	-> int
and 	getReferenceCreatureMana: 			ReferenceCreature 	-> int
and 	getReferenceCreatureTexturePath: 	ReferenceCreature 	-> string
and 	getReferenceCreatureActions: 		ReferenceCreature 	-> FightAction vect
and	getFightActionName: FightAction -> string
and	getFightActionLifeDamage: FightAction -> int
and	getFightActionManaDamage: FightAction -> int
and	getFightActionLifeCost:FightAction -> int
and	getFightActionManaCost:FightAction -> int
and	getFightActionLifeGain:FightAction -> int
and	getFightActionManaGain:FightAction -> int
and	getFightActionShowingLevel:FightAction -> int
and	getFightActionHidingLevel:FightAction -> int



and	ParseFightAction :		string -> string * string * string * string * string * string * string * string * string
and	GetActions_list : string -> FightAction list
and	GetActions : string -> FightAction vect
and	ReadCreature_part : ReferenceCreature vect -> string -> unit 
and	readCreature : string -> ReferenceCreature vect 


;;


