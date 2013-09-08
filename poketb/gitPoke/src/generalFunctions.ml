

let rec isItemInList a = function
	| [] -> false
	| t::q -> if a = t then true else isItemInList a q;;
