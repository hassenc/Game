
(* the numeber index/10000 represents the next action : 0 = dialog, 1 = Hit etc... *)

#open "io";;
#open "fileParsing";;
#open "informationGatherer";;

(*	changeProperty function
	changes a Dialog property, the arguments are :
	Dialog,(propertyToChange,valueToEnter) *)
let changeProperty2 = function
	| Message(str,answ), (propName,propValue) -> begin
		match propName with
			| "Text" -> Message(propValue, answ)
			| "StatAns" -> (* to have the index of the next dialog, use the 4 numbers at the beginning of the msg to parse it *)
				let s1,s2 = (sub_string propValue 0 5), (sub_string propValue 5 (string_length propValue - 5)) in begin
				Message(str, StaticAnswer(s2,int_of_string s1)::answ) end
			| "DynAns" -> Message(str, DynamicAnswer((match sub_string propValue 5 (string_length propValue - 5) with
				| "AvaiableActions" 	-> AvaiableActions
				| "AvaiableItems" 	-> AvaiableItems
				| "AvaiableCreatures" 	-> AvaiableCreatures 
				| "AllCreatures"		-> AllCreatures
				| _ -> failwith "uknown dynamic answer type" ), int_of_string (sub_string propValue 0 5))::answ)
			| _ -> begin 
				print_string ("Une propriété \""^propName^"\" présente dans le fichier de dialogues n'a pas été reconnue.");
				Message(str,answ)
				end
		end
	| Hit(i), (propName,propValue) -> begin
		match propName with
			| "Index" -> Hit(int_of_string propValue)  
			| _ -> failwith ("Une propriété \""^propName^"\" présente dans le fichier de dialogues n'a pas été reconnue.");
		end
	| UseItem(i), (propName,propValue) -> begin
		match propName with
			| "Index" -> UseItem(int_of_string propValue)
			| _ -> (failwith ("Une propriété \""^propName^"\" présente dans le fichier de dialogues n'a pas été reconnue."));
		end
	| ChangeCreature(i), (propName,propValue) -> begin
		match propName with
			| "Index" -> ChangeCreature(int_of_string propValue)
			| _ -> (failwith ("Une propriété \""^propName^"\" présente dans le fichier de dialogues n'a pas été reconnue."));
		end
	| Run(i), (propName,propValue) -> begin
		match propName with
			| "Index" -> Run(int_of_string propValue)
			| _ -> (failwith ("Une propriété \""^propName^"\" présente dans le fichier de dialogues n'a pas été reconnue."));
		end
	| DeleteCreature(i), (propName,propValue) -> begin
		match propName with
			| "Index" ->DeleteCreature(int_of_string propValue)
			| _ -> (failwith ("Une propriété \""^propName^"\" présente dans le fichier de dialogues n'a pas été reconnue."));
		end
	| End(_), (propName,propValue) -> begin
		match propName with
			| "Text" -> End(propValue)
			| _ -> failwith ("Une propriété \""^propName^"\" présente dans le fichier de dialogues n'a pas été reconnue.");
		end
	;;


(* ReturnDialog exception
	exception used to return a dialog each time it's fully read *)
exception ReturnDialog of FightDialog;;

(* readDialogFromFile function
	takes a stream as an argument, and outs ONE dialog of it with full properties. *)
let readDialogFromFile2 stream =
	try
		let started = ref false in
		let d = ref (End("")) in
		while(true) do
			let line = input_line stream in 
			if nth_char line 0 <> `#` then begin
				if line = "<Dialog>" then
					started := true
				else if line = "</Dialog>" then begin
					started := false;
					raise (ReturnDialog(!d)); 
					end
				else if !started = true then begin
					let propName,propValue = parseProperty line in 
					d := match propName with 
						| "Type" -> begin 
							match propValue with 
								| "Message" -> Message("",[])
								| "Hit" -> Hit(-1)
								| "UseItem" -> UseItem(-1)
								| "ChangeCreature" -> ChangeCreature(-1)
								| "Run" -> Run(-1)
								| "DeleteCreature" -> DeleteCreature(-1)
								| "End" -> End("")
								| _ -> End("") 
							end
						| _ -> changeProperty2 ((!d),(propName,propValue));
					end;
			end;
 		done;
		End(""); (* to force the type only *)
	with 		
		| ReturnDialog(d) -> d
		| End_of_file -> raise End_of_file;	
;;

(* readDialogs function
	reads the file where all dialogs should be put. stores it in a `Dialog vect` and returns it *)
let readDialogs2 filename =
	let rec readOne stream tbl cnt  = 
		try		
			let a = (readDialogFromFile2 stream) in
			tbl.(cnt) <- a;
			readOne stream tbl (cnt+1);
		with
			End_of_file -> begin close_in stream; tbl end
	in
		let stream = open_in filename in
		let size = input_line stream in
		readOne (open_in filename) (make_vect (int_of_string size) (End(""))) 0;;




