
(* DataType type
	describes all the data types that can be dynamically asked *)
type DataFightType = AvaiableActions | AvaiableItems | AvaiableCreatures | AllCreatures;;
(* Answer type
	Either an answer is static (never changes depending on time/user), Either it depends and it's dynamic.
	The index (for both) represents the Index of the next dialog. Put 0 (means End "") to stop dialog with no message. *)
type FightAnswer = StaticAnswer of string*int | DynamicAnswer of DataFightType*int;;
(* Dialog Type
	Dialog that is shown to the user and possible answers (for Message only).
	An answer read there as Dynamic will be generated on live.
	StartQuest/SellItem... requires only a yes/no answer, all the time. 
	End(mesage) is a message ending a dialog *)
type FightDialog = Message of (string * FightAnswer list) | Hit of int | UseItem of int | ChangeCreature of int |Run of int|DeleteCreature of int| End of string;;


value 	changeProperty2 : 		FightDialog*(string*string) 	-> FightDialog
and		readDialogFromFile2 : 	in_channel 		-> FightDialog
and 	readDialogs2 :			string			-> FightDialog vect
;;



