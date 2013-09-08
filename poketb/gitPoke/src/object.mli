type LifePotionType;;
type ManaPotionType;;
type ExperiencePotionType;;
type FusionStoneType;;
type GoldType;;
type CallBackScrollType;;
type CreatureGetterType;;
type AnyObjectType;;

(*type Object;;*)
type Object = Gold of GoldType  | LifePotion of LifePotionType  | ManaPotion of ManaPotionType | CallBackScroll of CallBackScrollType| FusionStone of FusionStoneType | CreatureGetter of CreatureGetterType|ExperiencePotion of ExperiencePotionType| AnyObject of AnyObjectType|Empty;;

type ObjectDatabase;;

value 	LoadObjects: 		string 			-> ObjectDatabase
and		getObjectByIndex:	ObjectDatabase 	-> int 				-> Object
and		getObjectAmount: 	Object			-> int 
and 	getObjectName:		Object 			-> string
and		getObjectNameByID: 	ObjectDatabase 	-> int				-> string 
and		getObjectGivenAmountByID:	ObjectDatabase 	-> int				-> int
and 	getObjectTexture:	Object 			-> string
and 	getObjectPrice: 	Object			-> int 
and 	isObjectGold:		Object			-> bool
and		isObjectGoldByID:	ObjectDatabase	-> int	-> bool
and	getFusionBuildPrice:Object			-> int 
and	getFusionCreatures :Object			-> int list
and	getFusionResultingCreature :Object			-> int
;;



