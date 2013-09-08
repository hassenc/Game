


type TexturesDatabase = TexturesDatabase of string vect;;


let loadTexturesDatabase filename =
	let stream = open_in filename in
	let nb = int_of_string (input_line stream) in
	let v = make_vect nb "" in
	for i=0 to nb-1 do
		let line = input_line stream in
		v.(i) <- line;
	done;
	TexturesDatabase(v);;

let getTextureByIndex (TexturesDatabase(v)) i =
	v.(i);;

