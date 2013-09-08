#open "graphicsInterface";;
#open "texturesDatabase";;
#open "fileParsing";;

exception FullMatrix;;

(*Map type definition*)
type Map={mutable name:string;mutable def :Tile vect vect; mutable level : int; mutable wymProba: float; mutable creatures: int list};;


let getDefaultMap () = {name=""; def=[| [| |] |]; level=0 ; creatures=[]; wymProba = 0.};;

(*Auxilary function that gets the tiles and puts them in a 12*18 matrix*)
let ReadTiles str mat=

	let i= ref 0 and j= ref 0 and p= ref 0 and s= ref str in 
		try
		while true do
			begin
			let tile=sub_string !s (!p) 12 in mat.(!i).(!j)<-tile;
			if !j<17 then j:=!j+1 else if !i<11 then begin i:=!i+1;j:= 0 end else raise FullMatrix;
			p:=!p+13;	
			end
		done
		with FullMatrix->();;

(*Main function that gets the tiles and puts them in a 12*18 string vect vect matrix*)
let GetMapDef str=
let mapMatrix=make_matrix 12  18 "000000000000" in ReadTiles str mapMatrix;mapMatrix;;





(*Transforms the Tile from a string to a type tile*)
let GetTile s textures=
let tile={positionX=0;positionY=0;texture="";tile_type=0;action=0;action_parameter=0;actionDone =false} and
positionX,positionY,texture,tile_type,action,action_parameter=(sub_string s 0 2), (sub_string s 2 2), (sub_string s 4 3), (sub_string s 7 1), (sub_string s 8 1), (sub_string s 9 3) in  
	tile.positionX<-int_of_string positionX;
	tile.positionY<-int_of_string positionY;
	tile.texture<- getTextureByIndex textures (int_of_string texture);
	tile.tile_type<-int_of_string tile_type;
	tile.action<-int_of_string action;
	tile.action_parameter<-int_of_string action_parameter;
	tile;;





(*function that transforms the matrix of strings in a matrix of tiles*)
let TransformInTile mat1 textures=
let tile={positionX=0;positionY=0;texture="";tile_type=0;action=0;action_parameter=0;actionDone =false} in let mat2=make_matrix 12 18 tile in
	for i=0 to 11 do
		for j=0 to 17 do
		 let tile = GetTile mat1.(i).(j) textures in mat2.(tile.positionY).(tile.positionX)<-tile;
		done;
	done;mat2;;


(*Parsing function*)
let parseProperty str =
	let posStart,posEqual,startQuote,endQuote = index_char str `P`, index_char str `=`, index_char str `"`, rindex_char str `"` in
	sub_string str (posStart+2) (posEqual-posStart-2),
	sub_string str (startQuote+1) (endQuote-startQuote-1)
	;;

let readCreatures s =
	let n = string_length s in
	let temp = ref "" in
	let result = ref [] in
	for i=0 to n-1 do
		let c = nth_char s i in
		if c <> `;` then
			temp := !temp^(string_of_char c)
		else begin
			if !temp <> "" then begin
				result := ((int_of_string !temp)::(!result));
				temp := "";
			end
		end
	done;
	if !temp <> "" then
		result := (int_of_string !temp)::(!result);
	!result;;


(*Auxilary function that gets the map from a file*)
let ReadMap_part map filename textures=
let f=open_in filename in
	try
	while true do
		let line=input_line f in
		
		if line="" or nth_char line 0 =`#` then ()
		else 
			let (a,b)=parseProperty line in match a with
				|"Name"->map.name<-b
				|"Def"->map.def<-TransformInTile (GetMapDef b) textures
				|"Level"->map.level<-int_of_string b
				|"Creatures"->map.creatures<-(readCreatures b)
				|"WymProba"->map.wymProba<-(float_of_string b)
				|_-> ()
	done
	with End_of_file-> ();;

(*Main function that gets the map from a file and returns a string vect vect*)
let ReadMap filename textures=
let tile={positionX=0;positionY=0;texture="";tile_type=0;action=0;action_parameter=0;actionDone =false} in
let map=getDefaultMap () in ReadMap_part map filename textures;map;;

(* updateMap function
	gives the information required by graphicsInterface.c to draw the map *)
let updateMap map =
	for i=0 to 11 do
		for j=0 to 17 do	
			setMapTile j i (map.def.(i).(j).texture) (map.def.(i).(j).tile_type);
		done;
	done;
	;;

let updateMapActionsDone map mapIndex l =
	let rec process = function
		| [] -> ();
		| (a,b,c)::q -> begin if c = mapIndex then map.def.(b).(a).actionDone <- true; process q end
	in
		process l;;

let loadMapAndGetName i =
	let f=open_in ("media/maps/map"^(if i<10 then "00" else if i <100 then "00" else "")^(string_of_int i)^".om") in
	let name = ref "" in
	try
	while true do
		let line=input_line f in
		if line="" or nth_char line 0 =`#` then ()
		else 
			let (a,b)=parseProperty line in match a with
				|"Name"-> name := b;
				|_-> ()
	done;
	!name;
	with End_of_file-> !name;;

let rec getListElement i = function
	| [] -> failwith "too far"
	| t::q -> if i = 0 then t else getListElement (i-1) q;;

(* addRandomCreatures function. Returns the list of the positions of randomed creatures on the map *)
let addRandomCreatures map = 
	let returns = ref [] in
	let max = list_length (map.creatures) in
	for i=0 to 11 do
		for j=0 to 17 do
			if map.def.(i).(j).tile_type = 0 && map.def.(i).(j).action = 0 then begin
				let rand = random__float 1.0 in
				if rand < map.wymProba then begin
					map.def.(i).(j).action <- 3; (* action of tile is StartFight *)
					returns := (i,j)::(!returns); (* creature has been randomed, we store which are randomed *)
					let myint = (random__int max) in
					map.def.(i).(j).action_parameter <- (getListElement myint (map.creatures)); (* choose the creature to fight *)
				end
			end
		done;
	done;
	!returns
	;; 

let getMapDefinition map = map.def;;
let getMapName map = map.name;;
let getMapLevel map = map.level;;

(*

(*Extracts informations about the tile s:string: # Tile : positionX(2) positionY(2) texture(3) type(1) action(1) action_parameter(3) *)
let GetTileParameter s=let positionX,positionY,texture,tile_type,action,action_parameter=int_of_string (sub_string s 0 2),int_of_string (sub_string s 2 2),int_of_string (sub_string s 4 3),int_of_string (sub_string s 7 1),int_of_string (sub_string s 8 1),int_of_string (sub_string s 9 3) in  positionX,positionY,texture,tile_type,action,action_parameter;;


*)









	


