
type FightAction = {mutable fightName: string ;
			  mutable lifeDamage :int ;
			  mutable manaDamage :int ;
			  mutable lifeCost :int ;	
			  mutable manaCost: int;
			  mutable lifeGain :int ;
			  mutable manaGain :int ;
			  mutable showingLevel: int;
			  mutable hidingLevel: int} ;;


type ReferenceCreature = {
	mutable	life : int;
	mutable mana : int;
	mutable name : string;
	mutable texturePath : string;
	mutable actions : FightAction vect;
};;

let getReferenceCreatureName referenceCreature = referenceCreature.name;;
let getReferenceCreatureLife referenceCreature = referenceCreature.life;;
let getReferenceCreatureMana referenceCreature = referenceCreature.mana;;
let getReferenceCreatureTexturePath referenceCreature = referenceCreature.texturePath;;
let getReferenceCreatureActions referenceCreature = referenceCreature.actions;;




let	getFightActionName fightAction=fightAction.fightName;;
let	getFightActionLifeDamage fightAction=fightAction.lifeDamage;;
let	getFightActionManaDamage fightAction=fightAction.manaDamage;;
let	getFightActionLifeCost fightAction=fightAction.lifeCost;;
let	getFightActionManaCost fightAction=fightAction.manaCost;;
let	getFightActionLifeGain fightAction=fightAction.lifeGain;;
let	getFightActionManaGain fightAction=fightAction.manaGain;;
let	getFightActionShowingLevel fightAction=fightAction.showingLevel;;
let	getFightActionHidingLevel fightAction=fightAction.hidingLevel;;




let getReferenceCreature i =
	{
	life=0;
	mana=0;
	name="";
	texturePath="";
	actions=[||];
};;

let defaultFightAction={fightName= "defalutAttack" ; lifeDamage = 0;manaDamage = 0;lifeCost=0 ;manaCost=0 ;lifeGain=0;manaGain=0 ; showingLevel= 0; hidingLevel=0};;

let defaultReferenceCreature ()={life = 0;mana = 0 ;name = "0";texturePath = "";actions =make_vect 10 defaultFightAction};;






(*Get the FightAction type*)
let ParseFightAction str=
	let pos= index_char str `_` in
	sub_string str 0 (pos),
	sub_string str (pos+1) 3,
	sub_string str (pos+4) 3,
	sub_string str (pos+7) 3,
	sub_string str (pos+10) 3,
	sub_string str (pos+13) 3,
	sub_string str (pos+16) 3,
	sub_string str (pos+19) 2,
	sub_string str (pos+21) 2
	;;



(*Parsing function*)
let parseProperty str =
	let posStart,posEqual,startQuote,endQuote = index_char str `P`, index_char str `=`, index_char str `"`, rindex_char str `"` in
	sub_string str (posStart+2) (posEqual-posStart-2),
	sub_string str (startQuote+1) (endQuote-startQuote-1)
	;;


(*returns a list of actions from a string (attck,a2,a3,)  *)
let rec GetActions_list =function str->
	let n=string_length str in
	match n with
	|0->[]
	|_->let p=index_char str `,` in 
			let (a,b,c,d,e,f,g,h,i)=ParseFightAction (sub_string str 0 p) in
			{fightName= a ; lifeDamage = (int_of_string b);manaDamage = (int_of_string c);lifeCost=(int_of_string d) ;manaCost=(int_of_string e) ;lifeGain=(int_of_string f) ;manaGain=(int_of_string g) ; showingLevel= (int_of_string h); hidingLevel= (int_of_string i)}::GetActions_list (sub_string str (p+1) (n- p -1));;




(*return a vect of actions*)
(*Here we limit the FightActions to 10 actions*)

let GetActions str=
let l=ref (GetActions_list str) and t=make_vect 10(*OOO*) defaultFightAction in
for i=0 to 9 do
match !l with
|[]-> ()
|a::b->begin t.(i) <-a ; l:= b end ;
done;
t;;





(*Auxilary function that gets the ref from a file*)
let ReadCreature_part tab filename=

	let f=open_in filename and  i=ref (-1) and refCreature= ref (defaultReferenceCreature ()) in
		try
		while true do
			let line=input_line f in
		
			if line="" or nth_char line 0 =`#` then ()
			else if line="<creature>" then  i:=!i+1
			else if line="</creature>" then begin tab.(!i)<-(!refCreature); refCreature:={life = 0;mana = 0 ;name = "0";texturePath = "";actions =[||]} end
			else		let (a,b)=parseProperty line in 
							match a with
							|"Name"->(!refCreature).name<-b
							|"Life"->(!refCreature).life<-int_of_string b
							|"Mana"->(!refCreature).mana<-int_of_string b
							|"Texture"->(!refCreature).texturePath<- b
							|"Actions"->(!refCreature).actions<-GetActions b
							|_-> ();

		
		done
		with End_of_file-> ();;

(*Main function that gets the ref from a file and returns a ReferenceCreature vect vect*)

let readCreature filename =
	let refCreature=defaultReferenceCreature () in let tab=make_vect (*80 references*)80 refCreature in ReadCreature_part tab filename;tab;;

