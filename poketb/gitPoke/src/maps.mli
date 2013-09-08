#open "graphicsInterface";;
#open "texturesDatabase";;

(*Tile Type*)
type Tile={mutable positionX:int; mutable positionY:int; mutable texture:string; mutable tile_type:int; mutable action:int; mutable action_parameter:int;mutable actionDone :bool};;
type Map;;

value	getDefaultMap:		unit				-> Map 	
and 	ReadTiles: 			string 				-> string vect vect 	-> unit
and 	GetMapDef: 			string 				-> string vect vect 
and 	GetTile: 			string 				-> TexturesDatabase		-> Tile
and 	TransformInTile: 	string vect vect 	-> TexturesDatabase 	-> Tile vect vect
and 	parseProperty: 		string 				-> string*string
and 	ReadMap_part: 		Map 				-> string 				-> TexturesDatabase 	-> unit
and 	ReadMap: 			string 				-> TexturesDatabase 	-> Map
and 	updateMap: 			Map 				-> unit
and 	updateMapActionsDone: Map				-> int					-> (int*int*int) list 	-> unit
and		addRandomCreatures: Map					-> (int*int) list

and getMapDefinition: 	Map -> Tile vect vect
and getMapName:			Map -> string
and getMapLevel:		Map -> int
and loadMapAndGetName:	int -> string

;;











	


