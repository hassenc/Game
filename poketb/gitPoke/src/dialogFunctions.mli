
(* DataType type
	describes all the data types that can be dynamically asked *)
type DataType = DiscoveredMaps | OwnedObjects | OwnedCreatures;;
(* Answer type
	Either an answer is static (never changes depending on time/user), Either it depends and it's dynamic.
	The index (for both) represents the Index of the next dialog. Put 0 (means End "") to stop dialog with no message. *)
type Answer = StaticAnswer of string*int | DynamicAnswer of DataType*int;;
(* Dialog Type
	Dialog that is shown to the user and possible answers (for Message only).
	An answer read there as Dynamic will be generated on live.
	StartQuest/SellItem... requires only a yes/no answer, all the time. 
	End(mesage) is a message ending a dialog *)
type Dialog = Message of (string * Answer list) | StartQuest of int | SellItem of int | ChangeMap of int |HealCreatures of int| End of string;;


value 	changeProperty : 		Dialog*(string*string) 	-> Dialog
and		readDialogFromFile : 	in_channel 		-> (Dialog*int)
and 	readDialogs :			string			-> Dialog vect
;;



