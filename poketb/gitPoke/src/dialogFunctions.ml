
(* the numeber index/10000 represents the next action : 0 = dialog, 1 = StartQuest etc... *)

#open "io";;
#open "fileParsing";;
#open "informationGatherer";;

(*	changeProperty function
	changes a Dialog property, the arguments are :
	Dialog,(propertyToChange,valueToEnter) *)
let changeProperty = function
	| Message(str,answ), (propName,propValue) -> begin
		match propName with
			| "Text" -> Message(propValue, answ)
			| "StatAns" -> (* to have the index of the next dialog, use the 4 numbers at the beginning of the msg to parse it *)
				let s1,s2 = (sub_string propValue 0 5), (sub_string propValue 5 (string_length propValue - 5)) in begin
				Message(str, StaticAnswer(s2,int_of_string s1)::answ) end
			| "DynAns" -> Message(str, DynamicAnswer((match sub_string propValue 5 (string_length propValue - 5) with
				| "DiscoveredMaps" 	-> DiscoveredMaps
				| "OwnedObjects" 	-> OwnedObjects
				| "OwnedCreatures" 	-> OwnedCreatures 
				| _ -> failwith "uknown dynamic answer type" ), int_of_string (sub_string propValue 0 5))::answ)
			| _ -> begin 
				print_string ("Une propriété \""^propName^"\" présente dans le fichier de dialogues n'a pas été reconnue.");
				Message(str,answ)
				end
		end
	| StartQuest(i), (propName,propValue) -> begin
		match propName with
			| "Index" -> StartQuest(int_of_string propValue)  
			| _ -> failwith ("Une propriété \""^propName^"\" présente dans le fichier de dialogues n'a pas été reconnue.");
		end
	| SellItem(i), (propName,propValue) -> begin
		match propName with
			| "Index" -> SellItem(int_of_string propValue)
			| _ -> (failwith ("Une propriété \""^propName^"\" présente dans le fichier de dialogues n'a pas été reconnue."));
		end
	| ChangeMap(i), (propName,propValue) -> begin
		match propName with
			| "Index" -> ChangeMap(int_of_string propValue)
			| _ -> (failwith ("Une propriété \""^propName^"\" présente dans le fichier de dialogues n'a pas été reconnue."));
		end
	| HealCreatures(i), (propName,propValue) -> begin
		match propName with
			| "Index" -> HealCreatures(int_of_string propValue)
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
exception ReturnDialog of Dialog*int;;

(* readDialogFromFile function
	takes a stream as an argument, and outs ONE dialog of it with full properties. *)
let readDialogFromFile stream =
	try
		let started = ref false in
		let d = ref (End("")) in
		let index = ref (-1) in
		while(true) do
			let line = input_line stream in 
			if nth_char line 0 <> `#` then begin
				if line = "<Dialog>" then
					started := true
				else if line = "</Dialog>" then begin
					started := false;
					raise (ReturnDialog(!d, !index)); 
					end
				else if !started = true then begin
					let propName,propValue = parseProperty line in 
					if propName = "Index" then 
						index := (int_of_string propValue) 
					else begin
						d := match propName with 
						| "Type" -> begin 
							match propValue with 
								| "Message" -> Message("",[])
								| "StartQuest" -> StartQuest(-1)
								| "SellItem" -> SellItem(-1)
								| "ChangeMap" -> SellItem(-1)
								| "HealCreatures" -> HealCreatures(-1)
								| "End" -> End("")
								| _ -> End("") 
							end
						| _ -> changeProperty ((!d),(propName,propValue));
					end;
				end;
			end;
 		done;
		End(""), (-1); (* to force the type only *)
	with 		
		| ReturnDialog(d, i) -> (d,i)
		| End_of_file -> raise End_of_file;	
;;

(* readDialogs function
	reads the file where all dialogs should be put. stores it in a `Dialog vect` and returns it *)
let readDialogs filename =
	let rec readOne stream tbl= 
		try		
			let (dialog,index) = (readDialogFromFile stream) in
			tbl.(index) <- dialog;
			readOne stream tbl;
		with
			End_of_file -> begin close_in stream; tbl end
	in
		let stream = open_in filename in
		let size = input_line stream in
		readOne (open_in filename) (make_vect (int_of_string size) (End("")));;




