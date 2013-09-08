value createWindow : unit -> unit = 1 "createWindow";;
value drawMainMenuWindow : unit -> unit = 1 "drawMainMenuWindow";;
value setMainMenuSelectorPosition : int -> unit = 1 "setMainMenuSelectorPosition";;
value rotateMainMenuSelector : unit -> unit = 1 "rotateMainMenuSelector";;
value drawWindow : unit -> unit = 1 "drawWindow";;
value closeWindow : unit -> unit = 1 "closeWindow";;
value getEvent : unit -> int = 1 "getEvent";;
value isKeyDown : string -> int = 1 "isKeyDown";;
value enableDialog : unit -> unit = 1 "enableDialog";;
value disableDialog : unit -> unit = 1 "disableDialog";;
value setDialogText : string -> unit = 1 "setDialogText";;
value addDialogAnswer : string -> unit = 1 "addDialogAnswer";;
value wannaWrite : unit -> int = 1 "wannaWrite";;
value clearDialogAnswers : unit -> unit = 1 "clearDialogAnswers";;
value setSelectorPos : int -> unit = 1 "setSelectorPos";;
value setMapTile : int -> int -> string -> int -> unit = 4 "setMapTile";;
value drawWindowGL : unit -> unit = 1 "drawWindowGL";;
value setCharacterPoints: int -> unit = 1 "setCharacterPoints";;
value moveCharacter : int -> float -> float = 2 "moveCharacter";;
value characterIdle : int -> unit = 1 "characterIdle";;
value setCharacterPos : float -> float -> unit = 2 "setCharacterPos";;
value addNPC: int -> int -> string -> unit = 3 "addNPC";; (* tileX, tileY, texture *)
value showPopupMessage: string -> float -> unit = 2 "showPopupMessage";; (* text, length (seconds) *)
value flushPopups: unit -> unit = 1 "flushPopups";;
value removeNPCs: unit -> unit = 1 "removeNPCs";; (* remove all the npcs on the map. Call this each time you change map *)


(* WINDOW FOR SELECTING SOMETHING *)

(* enableAnythingSelection:	
	starts the selection mode: draws the window on top of the others *)
value enableAnythingSelection: unit -> unit = 1 "enableAnythingSelection";;
(* disableAnythingSelection:	
	read its name again, or the upper function description, with more attention *)
value disableAnythingSelection: unit -> unit = 1 "disableAnythingSelection";;
(* clearAnythings :
	clears former entries. *)
value clearAnythings: unit -> unit = 1 "clearAnythings";;
(* add Anything to the anythingSelector panel
	that means that the thing you add can be anything. It just requires a texture and a text. No automated newlines. Use \n to create new lines.
	you can add up to 9 items
	How to use => addAnything "myImage.png" "Type: Image/png\nDescription: This image show my ***\nSize: 64bk" *)
value addAnything: string -> string -> unit = 2 "addAnything";;
(* moveAnythingSelector*
	moves the selector in the given direction. makes circles (go top when bottom etc...)
	user won't be able to select things he didn't added *)
value moveAnythingSelectorUp 	: unit -> unit = 1 "moveAnythingSelectorUp";;
value moveAnythingSelectorDown 	: unit -> unit = 1 "moveAnythingSelectorDown";;
value moveAnythingSelectorLeft 	: unit -> unit = 1 "moveAnythingSelectorLeft";;
value moveAnythingSelectorRight : unit -> unit = 1 "moveAnythingSelectorRight";;
(* getAnythingSelection 
	returns then current item index *)
value getAnythingSelection: unit -> int = 1 "getAnythingSelection";;


(*** JOURNAL FUNCTIONS **)

value setLeftJournalText: string -> unit = 1 "setLeftJournalText";;
value setRightJournalText: string -> unit = 1 "setRightJournalText";;
value enableJournal: unit -> unit  = 1 "enableJournal";;
value disableJournal: unit -> unit  = 1 "disableJournal";;










