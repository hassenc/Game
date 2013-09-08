(* drawFightInterface function :
	draws the fight interface *)
value drawFightInterface : unit -> unit = 1 "drawFightInterface";;
(* initFightInterface function
	setups all the images and text for a fight to be displayed. Call it only once preferentially *)
value initFightInterface : unit -> unit = 1 "initFightInterface";;
(* updateBarsStrings functon
	updates the strings that are shown on bars, according to life/mana values *)
value updateBarsStrings : unit -> unit = 1 "updateBarsStrings";;
(* updateBarsTextures functon
	rescales the life/mana bars to show the values/valuesMax *)
value updateBarsTextures : unit -> unit = 1 "updateBarsTextures";;
(* updateCreaturesStrings function
	updates the creature's name and level strings *)
value updateCreaturesStrings: unit -> unit = 1 "updateCreaturesStrings";;
(* setLeftLife function
	sets the life of the left creature *)
value setLeftLife:	int -> unit = 1 "setLeftLife";;
(* setLeftLifeMax function
	sets the maximum life of the left creature *)
value setLeftLifeMax:	int -> unit = 1 "setLeftLifeMax";;
(* setLeftMana function
	sets the mana of the left creature *)
value setLeftMana:	int -> unit = 1 "setLeftMana";;
(* setLeftManaMax function
	sets the maximum mana of the left creature *)
value setLeftManaMax:	int -> unit = 1 "setLeftManaMax";;
(* setRightLife function
	sets the life of the right creature *)
value setRightLife:	int -> unit = 1 "setRightLife";;
(* setRightLifeMax function
	sets the maximum life of the right creature *)
value setRightLifeMax:	int -> unit = 1 "setRightLifeMax";;
(* setRightMana function
	sets the mana of the right creature *)
value setRightMana:	int -> unit = 1 "setRightMana";;
(* setRightManaMax function
	sets the maximum mana of the right creature *)
value setRightManaMax:	int -> unit = 1 "setRightManaMax";;
(* setLeftCreatureTexture str
	set str as the left creature texture *)
value setLeftCreatureTexture: string -> unit = 1 "setLeftCreatureTexture";;
(* setRightCreatureTexture str
	set str as the right creature texture *)
value setRightCreatureTexture: string -> unit = 1 "setRightCreatureTexture";;
(* setLeftCreatureName str
	set str as the name of the left creature *)
value setLeftCreatureName: string -> unit = 1 "setLeftCreatureName";;
(* setLeftCreatureLevel str
	set str as the name of the left creature *)
value setLeftCreatureLevel: int -> unit = 1 "setLeftCreatureLevel";;
(* setRightCreatureName str
	set str as the name of the right creature *)
value setRightCreatureName: string -> unit = 1 "setRightCreatureName";;
(* setRightCreatureLevel str
	set str as the name of the right creature *)
value setRightCreatureLevel: int -> unit = 1 "setRightCreatureLevel";;

value clearLeftFightWindow:	unit->unit = 1 "clearLeftFightWindow";;

