
#open "encrypter";;
(* here are some functions to help parsing the text *)

(* parseProptery function
	parses a givent text of the pattern "  P_PropName= \"Content\"  " and returns (PropName,Content) *)
let parseProperty str =
	let posStart,posEqual,startQuote,endQuote = index_char str `P`, index_char str `=`, index_char str `"`, rindex_char str `"` in
	sub_string str (posStart+2) (posEqual-posStart-2),
	sub_string str (startQuote+1) (endQuote-startQuote-1)
	;;

(* intListOfFormatedString function
	parses a text that is a big number into a list of numbers represented by parts of size length in the str data 
	for example, intListOfFormatedString 4 012345678901 answers [0123, 4567, 8901]*)
let intListOfFormatedString length str =
	let rec process = function
		| "" -> []
		| s -> (int_of_string (sub_string s 0 length))::(process (sub_string s length (string_length s - length)))
	in process str;;


(* getString9 function
	getString9 data(int) size(<9)
	adds enough 0 to data(int) to create a string of size size *)  
let getString9 data size =
	let a = "000000000" in
	let tmp = string_of_int data in
	(sub_string a 0 (size-(string_length tmp)))^tmp;;

(* formatedStringOfIntList
	transforms a string that contains sub_strings which are all of the same size into a list of strings which size is length. *)
let rec formatedStringOfIntList length = function
	| [] -> ""
	| h::t -> (getString9 h length)^(formatedStringOfIntList length t) ;;


exception FAKE_FILE;;

(* checkFile function :
	checks the file integrity, raises an exception if it's not correct, and returns its name elseway *)
let checkFile filename = 
	let result = checkFileIntegrity filename in 
	if (result != 1) then
		raise FAKE_FILE;
	filename
	;;

