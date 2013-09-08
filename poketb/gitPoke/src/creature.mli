#open "referenceCreature";;

type Creature;;

value	referenceVector:		unit		-> ReferenceCreature vect
and	getDefaultCreature:			unit 		-> Creature	
and 	getCreatureLife: 		Creature 	-> int
and 	getCreatureMana: 		Creature 	-> int
and 	getCreatureExperience: 	Creature 	-> float
and 	getCreatureReference: 	Creature 	-> int
and	getCreatureParticipation: 	Creature 	-> bool
and 	setCreatureLife: 		Creature 	-> int 		-> unit
and 	setCreatureMana: 		Creature 	-> int 		-> unit
and 	setCreatureExperience: 	Creature 	-> float	-> unit
and 	setCreatureReference: 	Creature 	-> int 		-> unit
and	setCreatureParticipation: 	Creature 	-> bool 	-> unit
and 	Lvl:					Creature 	-> int
and	LifeMax:					Creature 	-> int
and	ManaMax:					Creature 	-> int
and	NextLevelExperience:		Creature 	-> int
and	addLife:					Creature 	-> int 		-> unit
and	addMana:					Creature 	-> int 		-> unit
and	addExperience:				Creature 	-> float	-> unit
;;


