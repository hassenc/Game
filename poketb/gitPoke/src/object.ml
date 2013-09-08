
(*An exemple of object file:


<object>
type=ManaPotion
name=
manaGiven=4
price=
texture=
</object>

<object>
type=LifePotion
name=
lifeGiven=
price=
texture=
</object>

<object>
type=
name=
creatures=1,2,3,  
buyPrice=
buildPrice=
resultingCreature=
</object>

<object>
type=CallBackScroll
</object>

*)

let parseProperty str =
	let posStart,posEqual,startQuote,endQuote = index_char str `P`, index_char str `=`, index_char str `"`, rindex_char str `"` in
	sub_string str (posStart+2) (posEqual-posStart-2),
	sub_string str (startQuote+1) (endQuote-startQuote-1)
	;;

(*Parsing function that gets what is on the two sides of the char `=` *)
let CutString =function s ->
	let p= index_char s `=`  and n=string_length s in
(sub_string s 0 (p),sub_string s (p+1) (n- (p) -1));;




(*Parsing function that transforms the list (1,2,3,) of creatures in an integer list*)
(*!Do not miss the last coma in (1,2,3,)! *)
let rec CutCreatures =function s->
	let n=string_length s in
	match n with
	|0->[]
	|_->let p=index_char s `,` in (int_of_string (sub_string s 0 p))::CutCreatures (sub_string s (p+1) (n- p -1));;


	


(*Object types definition*)
type LifePotionType = {mutable lifeGiven:int;mutable lifeName:string;mutable lifePrice:int ; mutable lifeTexture:string};;
type ManaPotionType = {mutable manaGiven:int;mutable manaName:string;mutable manaPrice:int; mutable manaTexture:string};;
type ExperiencePotionType = {mutable experienceGiven:int;mutable experienceName:string;mutable experiencePrice:int; mutable experienceTexture:string};;
type FusionStoneType ={mutable name:string;mutable buildPrice:int;mutable buyPrice:int;mutable creatures:int list;mutable resultingCreature :int; mutable fusionTexture:string};;
type GoldType ={mutable amount:int;mutable goldTexture:string};;
type CallBackScrollType ={mutable scrollPrice:int;mutable scrollTexture:string};;
type CreatureGetterType={mutable getterPrice:int;mutable getterTexture:string};;
type AnyObjectType={mutable objectName:string;mutable objectTexture:string};;


type ObjectDatabase = ObjectDatabase of Object vect;;

(*An auxilary function for reading the file and filling a vector of objects*)
let LoadObjectsFromFile t f=
let i=ref (-1) and f=open_in f in 
try
while true do

	let line=input_line f in
		if line="<object>" then i:=!i+1
		else if line="" or nth_char line 0 =`#` then ()
		else let (a,b)=parseProperty line in
			if a="type" then
 			begin
			match b with
			|"LifePotion" ->let obj=  		{lifeGiven=0;lifeName="";lifePrice=0;lifeTexture=""}  and s=ref (input_line f) in
					begin
					while !s <> "</object>" do
						begin
						let (a,b)=parseProperty !s in
						s:=(input_line f);
						match a with
							|"name"->obj.lifeName <- b
							|"price"->obj.lifePrice <- int_of_string b
							|"lifeGiven"->obj.lifeGiven <- int_of_string b
							|"texture"->obj.lifeTexture <- b
							|_ ->();
						end;
					done;
					t.(!i)<-LifePotion obj;
					end;
			
			|"ExperiencePotion" ->let obj=  		{experienceGiven=0;experienceName="";experiencePrice=0;experienceTexture=""}  and s=ref (input_line f) in
					begin
					while !s <> "</object>" do
						begin
						let (a,b)=parseProperty !s in
						s:=(input_line f);
						match a with
							|"name"->obj.experienceName <- b
							|"price"->obj.experiencePrice <- int_of_string b
							|"experienceGiven"->obj.experienceGiven <- int_of_string b
							|"texture"->obj.experienceTexture <- b
							|_ ->();
						end;
					done;
					t.(!i)<-ExperiencePotion obj;
					end;

			|"ManaPotion" ->let obj= {manaGiven=0;manaName="";manaPrice=0;manaTexture=""}  and s=ref (input_line f) in
					begin
					while !s <> "</object>" do
						begin
						let (a,b)=parseProperty !s in
						s:=(input_line f);
						match a with
							|"name"->obj.manaName <- b
							|"price"->obj.manaPrice <- int_of_string b
							|"manaGiven"->obj.manaGiven <- int_of_string b
							|"texture"->obj.manaTexture <- b
							|_ ->();
						end;
					done;
					t.(!i)<-ManaPotion obj;
					end;
			|"CallBackScroll" -> let obj= {scrollPrice=0;scrollTexture=""}  and s=ref (input_line f) in begin
					while !s <> "</object>" do
						begin
						let (a,b)=parseProperty !s in
						s:=(input_line f);
						match a with
							|"price"->obj.scrollPrice <- int_of_string b
							|"texture"->obj.scrollTexture <- b
							|_ ->();
						end;
					done;
					t.(!i)<-CallBackScroll obj;
					end;  

			|"FusionStone" ->let obj={name="";buildPrice=0;buyPrice=0;creatures=[0];resultingCreature=0;fusionTexture=""}  and s=ref (input_line f) in
					begin
					while !s <> "</object>" do
						begin
						let (a,b)=parseProperty !s in
						s:=(input_line f);
						match a with
							|"name"->obj.name <- b
							|"buildPrice"->obj.buildPrice <- int_of_string b
							|"buyPrice"->obj.buyPrice <- int_of_string b
							|"creatures"->obj.creatures <- CutCreatures b
							|"resultingCreature"->obj.resultingCreature <- int_of_string b
							|"texture"->obj.fusionTexture <- b
							|_ ->();
						end;
					done;
					t.(!i)<-FusionStone obj;
					end;  
			|"CreatureGetter" -> let obj= {getterPrice=0;getterTexture=""}  and s=ref (input_line f) in begin
					while !s <> "</object>" do
						begin
						let (a,b)=parseProperty !s in
						s:=(input_line f);
						match a with
							|"price"->obj.getterPrice <- int_of_string b
							|"texture"->obj.getterTexture <- b
							|_ ->();
						end;
					done;
					t.(!i)<-CreatureGetter obj;
					end;  



			|"Gold" -> let obj= {amount=0;goldTexture=""}  and s=ref (input_line f) in
					begin
					while !s <> "</object>" do
						begin
						let (a,b)=parseProperty !s in
						s:=(input_line f);
						match a with
							|"amount"->obj.amount <- int_of_string b
							|"texture"->obj.goldTexture <- b
							|_ ->();
						end;
					done;
					t.(!i)<-Gold obj;
					end; 
			|"AnyObject" ->let obj=  		{objectName="";objectTexture=""}  and s=ref (input_line f) in
					begin
					while !s <> "</object>" do
						begin
						let (a,b)=parseProperty !s in
						s:=(input_line f);
						match a with
							|"name"->obj.objectName <- b
							|"texture"->obj.objectTexture <- b
							|_ ->();
						end;
					done;
					t.(!i)<-AnyObject obj;
					end; 
			|_ -> () ;	
			end
			else ();

done;
with End_of_file-> ();;


(*The main function for reading the file and returning a vector of objects*)
let LoadObjects f=
let objectTab=make_vect 40 Empty in
LoadObjectsFromFile objectTab f;
ObjectDatabase(objectTab);;


let getObjectByIndex (ObjectDatabase(database)) i = database.(i);;
let getObjectAmount = function
	| Gold({amount=i; _}) -> i (* we're talking about gold *)
	| _ -> 1;; (* anything else *)


let getObjectName = function 
		| Gold(_) -> "Gold"
		| LifePotion({lifeName=a;_}) -> a
		| ManaPotion({manaName=a;_}) -> a
		| CallBackScroll(_) -> "Town scroll"
		| FusionStone({name=a;_}) -> a
		| CreatureGetter(_) -> "Wym capture ball"
		| ExperiencePotion({experienceName=a;_}) -> a
		| AnyObject({objectName=a;_})-> a
		| Empty -> "Nothing";;

let getObjectNameByID (ObjectDatabase(database)) i = 
	getObjectName database.(i);;

let getObjectGivenAmountByID (ObjectDatabase(database)) i =
	match database.(i) with
		| Gold({amount=a;_}) -> a
		| LifePotion({lifeGiven=a;_}) -> a
		| ManaPotion({manaGiven=a;_}) -> a
		| CallBackScroll(_) -> (-1)
		| FusionStone({name=a;_}) -> (-1)
		| CreatureGetter(_) -> (-1)
		| ExperiencePotion({experienceGiven=a}) -> a
		| AnyObject(_)-> (-1)
		| Empty -> (-1);;

let getObjectTexture = function
		| Gold({goldTexture=a;_}) -> a
		| LifePotion({lifeTexture=a;_}) -> a
		| ManaPotion({manaTexture=a;_}) -> a
		| CallBackScroll({scrollTexture=a;_}) -> a
		| FusionStone({fusionTexture=a;_}) -> a
		| CreatureGetter({getterTexture=a;_}) -> a
		| ExperiencePotion({experienceTexture=a}) -> a
		| AnyObject({objectTexture=a;_})-> a
		| Empty -> "";;
	
let getObjectPrice = function
		| LifePotion({lifePrice=a;_}) -> a
		| ManaPotion({manaPrice=a;_}) -> a
		| CallBackScroll({scrollPrice=a;_}) -> a
		| CreatureGetter({getterPrice=a;_}) -> a
		| ExperiencePotion({experiencePrice=a}) -> a
		| FusionStone({buyPrice=a}) -> a
		| Empty -> 999
		|_ ->999
;;
let isObjectGold = function
	| Gold({_}) -> true
	| _ -> false;;

let isObjectGoldByID (ObjectDatabase(db)) i = isObjectGold (db.(i));;


let getFusionBuildPrice=function  FusionStone({buildPrice=a}) -> a|_-> (-1);;

let getFusionCreatures=function  FusionStone({creatures=a}) -> a|_-> [];;


let getFusionResultingCreature=function  FusionStone({resultingCreature=a}) -> a |_-> (-1);;




