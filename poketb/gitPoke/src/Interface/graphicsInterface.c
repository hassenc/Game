#include "graphicsInterface.h"

#include <math.h>

#define X_TILE_OFFSET 22.5
#define X_TILE_SIZE 2.5
#define Y_TILE_OFFSET 12.5

#define TILE_SIZE 60



/* getIndexFromPos function
	converts a position into index */
int getIndexFromPos(int x, int y)
{
	return x+18*y;
}

/* getPosFromIndex function
	returns a (x,y) position from a given index. : index=x+18*y */
int* getPosFromIndex(int index)
{
	int* a = malloc(2*sizeof(int));
	*a = index%18;
	*(a+1)  = index/18;
	return a;
}


/***********************************************************************************
							 INITIALIZING FUNCTIONS
***********************************************************************************/

/* CreateWindow function 
	This function initialises */ 
value createWindow(value unit)
{
	sfWindowSettings Settings = {24, 8, 0};
    sfVideoMode Mode = {1080, 720, 32};
    game.renderWindow = NULL;
    game.renderWindow = sfRenderWindow_Create(Mode, "Ozixya", sfClose, Settings);
	sfRenderWindow_PreserveOpenGLStates(game.renderWindow, 1);
  	game.text = NULL;
	game.font = NULL; 
	game.trophy = NULL;
	game.popupMessage = NULL;
	game.popupClock = NULL;
	game.popupBackground = NULL;
	game.popupTime = 0;
	game.dialogMode = 0;
	game.wannaWrite = 0;
	game.userWalkCount = 0.f;
	game.dialogPanel = malloc(sizeof(DialogPanel));
	DialogPanel_setup(game.dialogPanel);
	game.texturesManager = malloc(sizeof(TexturesManager));
	TexturesManager_init(game.texturesManager);
	clock = sfClock_Create();
	game.npcCount = 0;
	game.popupQueue = NULL;

	game.user = sfSprite_Create();
	sfSprite_SetImage(game.user, TexturesManager_getTexture(game.texturesManager, "media/characters/face_idle.png"));
	sfSprite_SetPosition(game.user, 0,0);
	sfSprite_Resize(game.user, 50,50);

	game.mainMenu = sfSprite_Create();
	sfSprite_SetImage(game.mainMenu, TexturesManager_getTexture(game.texturesManager, "media/ui/mainMenu.png"));
	sfSprite_SetPosition(game.mainMenu, 0,0);
	sfSprite_SetScale(game.mainMenu, 0,0);
	game.mainMenuSelector = sfSprite_Create();
	sfSprite_SetImage(game.mainMenuSelector, TexturesManager_getTexture(game.texturesManager, "media/ui/mainMenuSelector.png"));
	sfSprite_SetCenter(game.mainMenuSelector, 39, 37);
	sfSprite_SetPosition(game.mainMenuSelector, 390,272);
	sfSprite_SetScale(game.mainMenuSelector, 0.6,0.6);
	game.trophyBackground = sfSprite_Create();
	sfSprite_SetImage(game.trophyBackground, TexturesManager_getTexture(game.texturesManager, "media/ui/trophyBackground.png"));
	sfSprite_SetPosition(game.trophyBackground, 0,0);
	game.trophy = sfSprite_Create();
	sfSprite_SetImage(game.trophy, TexturesManager_getTexture(game.texturesManager, "media/ui/trophies/wood.png"));
	sfSprite_SetPosition(game.trophy, 4,5);
	sfSprite_Resize(game.trophy, 25,25);

	int i = 0; 
	for (i = 0; i < 18*12; i++)
	{
		game.map[i] = NULL;
	}

	game.font =  (sfFont*)(sfFont_CreateFromFile("media/fonts/serif.ttf", 20, NULL));
	if (!game.font)
	{
   	 	printf("The font has not been loaded.\n");// Erreurr...
	}
	// Code initializing a text
	else {	
		game.text = sfString_Create();
    	sfString_SetText(game.text, "Points: 0");
    	sfString_SetFont(game.text, game.font);
	    sfString_SetSize(game.text, 20); 
		sfString_SetColor(game.text, sfBlack);
    	sfString_SetPosition(game.text, 40, 3);
	} 

	// init the selection for any type of thing
	initAnythingSelection();

	// inits the journal
	game.showJournal = 0;
	game.journal = malloc(sizeof(Journal*));
	initJournal(game.journal, game.font, game.texturesManager);

	/* load all the characters faces */
	TexturesManager_getTexture(game.texturesManager, "media/characters/face_idle.png");
	TexturesManager_getTexture(game.texturesManager, "media/characters/back_idle.png");
	TexturesManager_getTexture(game.texturesManager, "media/characters/left_idle.png");
	TexturesManager_getTexture(game.texturesManager, "media/characters/right_idle.png");
	TexturesManager_getTexture(game.texturesManager, "media/characters/face_walk_1.png");
	TexturesManager_getTexture(game.texturesManager, "media/characters/face_walk_2.png");
	TexturesManager_getTexture(game.texturesManager, "media/characters/back_walk_1.png");
	TexturesManager_getTexture(game.texturesManager, "media/characters/back_walk_2.png");
	TexturesManager_getTexture(game.texturesManager, "media/characters/left_walk_0.png");
	TexturesManager_getTexture(game.texturesManager, "media/characters/left_walk_1.png");
	TexturesManager_getTexture(game.texturesManager, "media/characters/left_walk_2.png");
	TexturesManager_getTexture(game.texturesManager, "media/characters/right_walk_0.png");
	TexturesManager_getTexture(game.texturesManager, "media/characters/right_walk_1.png");
	TexturesManager_getTexture(game.texturesManager, "media/characters/right_walk_2.png");
	

	return Val_unit;
}
/*******************************************************************************************
								MAIN MENU FUNCTIONS
********************************************************************************************/

/* drawMainMenuWindow function
	draws the main menu. */
value drawMainMenuWindow(value unit)
{
	sfRenderWindow_Clear(game.renderWindow, sfBlack);
			
	sfRenderWindow_DrawSprite(game.renderWindow, game.mainMenu);
	sfRenderWindow_DrawSprite(game.renderWindow, game.mainMenuSelector);
	
	sfRenderWindow_Display(game.renderWindow);
	return Val_unit;
}

value setMainMenuSelectorPosition(pos)
{
	int i = Int_val(pos);
	sfSprite_SetPosition(game.mainMenuSelector, 390,240+110*i);
}

value rotateMainMenuSelector()
{
	sfSprite_SetRotation(game.mainMenuSelector, sfSprite_GetRotation(game.mainMenuSelector)+0.2f);
}



/*******************************************************************************************
							END OF MAIN MENU FUNCTIONS
********************************************************************************************/


/***********************************************************************************
								DRAWING FUNCTIONS
***********************************************************************************/

/* drawWindow function
	draws the renderWindow. */
value drawWindow(value unit)
{
	/* process events that need high rate of refresh */

	if (game.popupClock)
		if (sfClock_GetTime(game.popupClock) > game.popupTime)
		{
			sfClock_Destroy(game.popupClock);
			game.popupClock = NULL;
			game.popupTime = 0.0f;
			sfString_Destroy(game.popupMessage);
			game.popupMessage = NULL;
			sfSprite_Destroy(game.popupBackground);
			game.popupBackground = NULL;
			game.popupMessageCount--;
			if (game.popupMessageCount > 0)
				updatePopup();
		}



	sfRenderWindow_Clear(game.renderWindow, sfBlack);
	int i=0;

	int pos = (int)((sfSprite_GetY(game.user)+ 47.9)/60.f);
	
	//printf("%i\n", pos);
	for (i=0; i<12*18; i++)
		if (game.map[i] != NULL)
			sfRenderWindow_DrawSprite(game.renderWindow, game.map[i]->sprite);

	if (game.user)
		sfRenderWindow_DrawSprite(game.renderWindow, game.user);

	for (i=(pos+1)*18; i<12*18; i++)
		if (game.map[i] != NULL)
			sfRenderWindow_DrawSprite(game.renderWindow, game.map[i]->sprite);

	// draw NPCs :
	for (i=0; i < game.npcCount ; i++)
		if (*(game.npc + i*sizeof(sfSprite*)))
			sfRenderWindow_DrawSprite(game.renderWindow, *(game.npc + i*sizeof(sfSprite*)));
	
	// now everything that is not in game (dialogs, pop-ups)

	if (game.dialogMode == 1)
		DialogPanel_draw(game.dialogPanel, game.renderWindow);
	if (anythingSelection.running == 1)
		drawAnythingSelection();
	
	if (game.trophyBackground)
		sfRenderWindow_DrawSprite(game.renderWindow, game.trophyBackground);
	if (game.trophy)
		sfRenderWindow_DrawSprite(game.renderWindow, game.trophy);
	if (game.text)
		sfRenderWindow_DrawString(game.renderWindow, game.text);

	if (game.popupBackground != NULL)
		sfRenderWindow_DrawSprite(game.renderWindow, game.popupBackground);
	if (game.popupMessage != NULL)
		sfRenderWindow_DrawString(game.renderWindow, game.popupMessage);

	if (game.showJournal)
		drawJournal(game.journal, game.renderWindow);

	
	sfRenderWindow_Display(game.renderWindow);
	return Val_unit;
}

/* closeWindow function
	closes and destroys the renderWindow and its content */
value closeWindow(value unit)
{
	if (game.renderWindow) {
		sfRenderWindow_Close(game.renderWindow);
		sfRenderWindow_Destroy(game.renderWindow);
		game.renderWindow = NULL;
	}
	return Val_unit;
}

/***********************************************************************************
							  MAP-RELATED FUNCTIONS
***********************************************************************************/

/* setMapTile function
	sets the texture image on the tile with the horizontal pos x and the vertical y. the type is not used for now */
value setMapTile( x, y, texture, type)
{
	int i = Int_val(x);
	int j = Int_val(y);
	char* tex = (char*) String_val(texture);
	int t = Int_val(type);
	
	free(game.map[getIndexFromPos(i,j)]);
	game.map[getIndexFromPos(i,j)] = malloc(sizeof(struct MapTile));
	game.map[getIndexFromPos(i,j)]->type = t;
	sfImage* img = TexturesManager_getTexture(game.texturesManager, tex);
	sfSprite* spr = sfSprite_Create();
	sfSprite_SetImage(spr, img);
	sfSprite_SetPosition(spr, (i)*TILE_SIZE, (j-1)*TILE_SIZE);
	sfSprite_Resize(spr, TILE_SIZE, TILE_SIZE*2);
	game.map[getIndexFromPos(i,j)]->sprite = spr;
}


/***********************************************************************************
							  CHARACTER-RELATED FUNCTIONS
***********************************************************************************/

value setCharacterPoints(points)
{
	int pts = Int_val(points);
	/*
	float time = sfRenderWindow_GetFrameTime(game.renderWindow);
	int aInt = (int)(1.f/time);
	char* str = malloc(15*sizeof(char));*/
	char* str = malloc(15*sizeof(char));
	sprintf(str, "Points: %i", pts);
	sfString_SetText( game.text, str);
	// update the trophy :
	int trophy = (int)(sqrt(pts/20));
	//int trophy = (int)(pts/2); //for tests. work
	char* trophyPath = malloc(100*sizeof(char));
	if(trophy==0)
		sprintf(trophyPath, "media/ui/trophies/wood.png");
	else if (trophy==1)
		sprintf(trophyPath, "media/ui/trophies/stone.png");
	else if (trophy==2)
		sprintf(trophyPath, "media/ui/trophies/iron.png");
	else if (trophy==3)
		sprintf(trophyPath, "media/ui/trophies/copper.png");
	else if (trophy==4)
		sprintf(trophyPath, "media/ui/trophies/bronze.png");
	else if (trophy==5)
		sprintf(trophyPath, "media/ui/trophies/silver.png");
	else if (trophy==6)
		sprintf(trophyPath, "media/ui/trophies/gold.png");
	else if (trophy==7)
		sprintf(trophyPath, "media/ui/trophies/platinum.png");
	else if (trophy==8)
		sprintf(trophyPath, "media/ui/trophies/sapphire.png");
	else if (trophy==9)
		sprintf(trophyPath, "media/ui/trophies/emerald.png");
	else if (trophy==10)
		sprintf(trophyPath, "media/ui/trophies/ruby.png");
	else if (trophy>=11)
		sprintf(trophyPath, "media/ui/trophies/diamond.png");
	sfSprite_SetImage(game.trophy, TexturesManager_getTexture(game.texturesManager, trophyPath));
	sfSprite_Resize(game.trophy, 25, 25);

	return Val_unit;
}

/* moveCharacter function
	moves the user in a specified direction (4 dir) with its speed */
value moveCharacter(direction, speed)
{
	float timer = sfRenderWindow_GetFrameTime(game.renderWindow);
	int dir = Int_val(direction);
	double speed_val = Double_val(speed)*timer*70;
	game.userWalkCount += 0.07*timer*Double_val(speed);
	if (game.userWalkCount>6.f)
		game.userWalkCount = 0.f;

	int walkState = (int)(game.userWalkCount);
	float x = sfSprite_GetX(game.user);
	float y = sfSprite_GetY(game.user);
	if (dir==0) /* is going top */
	{
		char* str = malloc(sizeof(char)*100);
		sprintf(str, "media/characters/back_walk_%i.png", 1+walkState%2);
		sfSprite_SetImage(game.user, TexturesManager_getTexture(game.texturesManager, (char*)(str)));
		sfSprite_SetPosition(game.user, x, y-(speed_val)/100.f);
	}	
	if (dir==1) /* is going bot */
	{
		char* str = malloc(sizeof(char)*100);
		sprintf(str, "media/characters/face_walk_%i.png", 1+walkState%2);
		sfSprite_SetImage(game.user, TexturesManager_getTexture(game.texturesManager, str));
		sfSprite_SetPosition(game.user, x, y+speed_val/100.f);
	}	
	if (dir==2) /* is going left */
	{
		char* str = malloc(sizeof(char)*100);
		sprintf(str, "media/characters/left_walk_%i.png", walkState%3);
		sfSprite_SetImage(game.user, TexturesManager_getTexture(game.texturesManager, str));
		sfSprite_SetPosition(game.user, x-speed_val/100.f, y);
	}
	if (dir==3) /* is going right */
	{
		char* str = malloc(sizeof(char)*100);
		sprintf(str, "media/characters/right_walk_%i.png", walkState%3);
		sfSprite_SetImage(game.user, TexturesManager_getTexture(game.texturesManager, str));
		sfSprite_SetPosition(game.user, x+speed_val/100.f, y);
	}	
	
	return copy_double(speed_val/100.f);

}

value setCharacterPos(x,y)
{
	sfSprite_SetPosition(game.user, Double_val(x), Double_val(y));
	return Val_unit;
}

value characterIdle(direction)
{
	int dir = Int_val(direction);

	char* str = malloc(sizeof(char)*100);
	if (dir==0) 
		sprintf(str, "media/characters/back_idle.png");
	if (dir==1) 
		sprintf(str, "media/characters/face_idle.png");
	if (dir==2)
		sprintf(str, "media/characters/left_idle.png");
	if (dir==3) 
		sprintf(str, "media/characters/right_idle.png");

	sfSprite_SetImage(game.user, TexturesManager_getTexture(game.texturesManager, (char*)(str)));
}



/***********************************************************************************
							  EVENTS-RELATED FUNCTIONS
***********************************************************************************/


/* getEvent function
	returns the event that is at the top of the queue, as a number
	use only for system inputs, not for keys, because there might be a delay.
	return values:
		- -1 = signal to tell caml there's no event
		- 0 = nothing that needs a treatment
		- 1 = closeWindow
		-
 */
value getEvent(value unit)
{
	int returnValue = 0;
	sfBool result = sfTrue;
	sfEvent evt;
	result = sfRenderWindow_GetEvent(game.renderWindow, &evt);
	if (evt.Type == sfEvtClosed){	
		returnValue = -666;
	}
	if (result == sfFalse) 
		return Val_int(-1);

	if (evt.Type == sfEvtKeyPressed)
	{
		if (evt.Key.Code == sfKeyUp)
			return Val_int(100);
		if (evt.Key.Code == sfKeyDown)
			return Val_int(101);
		if (evt.Key.Code == sfKeyLeft)
			return Val_int(102);
		if (evt.Key.Code == sfKeyRight)
			return Val_int(103);
		if (evt.Key.Code == sfKeyReturn)
			return Val_int(104);
		if (evt.Key.Code == sfKeyEscape)
			return Val_int(1);
		if (evt.Key.Code == sfKeySpace)
			return Val_int(789);
		if (evt.Key.Code == sfKeyI)
			return Val_int(208);
		if (evt.Key.Code == sfKeyJ)
			return Val_int(209);
		if (evt.Key.Code == sfKeyA)
			return Val_int(200);
		if (evt.Key.Code == sfKeyB)
			return Val_int(201);
		if (evt.Key.Code == sfKeyC)
			return Val_int(202);
		if (evt.Key.Code == sfKeyD)
			return Val_int(203);
		if (evt.Key.Code == sfKeyE)
			return Val_int(204);
		if (evt.Key.Code == sfKeyF)
			return Val_int(205);
		if (evt.Key.Code == sfKeyG)
			return Val_int(206);
		if (evt.Key.Code == sfKeyH)
			return Val_int(207);
		if (evt.Key.Code == sfKeyW)
			return Val_int(210);
		if (evt.Key.Code == sfKeyDelete)
			return Val_int(211);

	}
	 return Val_int(returnValue);
}


int compareStrings(char* a, char* text)
{
	return (*a == *text);
		
}

/* isKeyDown function
	takes a 'key' parameters, that contains a char.
	returns 1 if the letter corresponding to 'key' is pressed, 0 elseway. */
value isKeyDown(key)
{
	sfKeyCode keyCode;
	
	char* a = String_val(key);
	
	if (compareStrings(a, "a__"))
		keyCode = sfKeyA;
	else if (compareStrings(a, "b__"))
		keyCode = sfKeyB;
	else if (compareStrings(a, "c__"))
		keyCode = sfKeyC;
	else if (compareStrings(a, "d__"))
		keyCode = sfKeyD;
	else if (compareStrings(a, "e__"))
		keyCode = sfKeyE;
	else if (compareStrings(a, "f__"))
		keyCode = sfKeyF;
	else if (compareStrings(a, "g__"))
		keyCode = sfKeyG;
	else if (compareStrings(a, "h__"))
		keyCode = sfKeyH;
	else if (compareStrings(a, "i__"))
		keyCode = sfKeyI;
	else if (compareStrings(a, "j__"))
		keyCode = sfKeyJ;
	else if (compareStrings(a, "k__"))
		keyCode = sfKeyK;
	else if (compareStrings(a, "l__"))
		keyCode = sfKeyL;
	else if (compareStrings(a, "m__"))
		keyCode = sfKeyM;
	else if (compareStrings(a, "n__"))
		keyCode = sfKeyN;
	else if (compareStrings(a, "o__"))
		keyCode = sfKeyO;
	else if (compareStrings(a, "p__"))
		keyCode = sfKeyP;
	else if (compareStrings(a, "q__"))
		keyCode = sfKeyQ;
	else if (compareStrings(a, "r__"))
		keyCode = sfKeyR;
	else if (compareStrings(a, "s__"))
		keyCode = sfKeyS;
	else if (compareStrings(a, "t__"))
		keyCode = sfKeyT;
	else if (compareStrings(a, "u__"))
		keyCode = sfKeyU;
	else if (compareStrings(a, "v__"))
		keyCode = sfKeyV;
	else if (compareStrings(a, "w__"))
		keyCode = sfKeyW;
	else if (compareStrings(a, "x__"))
		keyCode = sfKeyX;
	else if (compareStrings(a, "y__"))
		keyCode = sfKeyY;
	else if (compareStrings(a, "z__"))
		keyCode = sfKeyZ;
	else if (compareStrings(a, "0__"))
		keyCode = sfKeyNum0;
	else if (compareStrings(a, "1__"))
		keyCode = sfKeyNum1;
	else if (compareStrings(a, "2__"))
		keyCode = sfKeyNum2;
	else if (compareStrings(a, "3__"))
		keyCode = sfKeyNum3;
	else if (compareStrings(a, "4__"))
		keyCode = sfKeyNum4;
	else if (compareStrings(a, "5__"))
		keyCode = sfKeyNum5;
	else if (compareStrings(a, "6__"))
		keyCode = sfKeyNum6;
	else if (compareStrings(a, "7__"))
		keyCode = sfKeyNum7;
	else if (compareStrings(a, "8__"))
		keyCode = sfKeyNum8;
	else if (compareStrings(a, "9__"))
		keyCode = sfKeyNum9;
	else if (compareStrings(a, "Esc"))
		keyCode = sfKeyEscape;
	else if (compareStrings(a, "Dow"))
		keyCode = sfKeyDown;
	else if (compareStrings(a, "Up_"))
		keyCode = sfKeyUp;
	else if (compareStrings(a, "Rig"))
		keyCode = sfKeyRight;
	else if (compareStrings(a, "Lef"))
		keyCode = sfKeyLeft;
	else if (compareStrings(a, "Ret"))
		keyCode = sfKeyReturn;
	else if (compareStrings(a, "Bac"))
		keyCode = sfKeyBack;
	else if (compareStrings(a, "Spa"))
		keyCode = sfKeySpace;




	sfInput* input = sfRenderWindow_GetInput(game.renderWindow);
	if (sfInput_IsKeyDown(input, keyCode))	
		return Val_int(1);
	else
		return Val_int(0);
}



/***********************************************************************************
							FUNCTIONS FOR DIALOGS
***********************************************************************************/

/* enableDialog function
	enables the dialog panel, so text can be printed with a background */
value enableDialog(value unit)
{
	game.dialogMode = 1;
	/* show the dialog panel */
}

/* disableDialog function
	hides the dialog panel and reset text and all concerned values */
value disableDialog(value unit)
{
	game.dialogMode = 0;
	/* hide the dialog panel and reset its values */
}

/* setDialogText function
	sets up the text of the dialog */
value setDialogText(text)
{
	char* dialogText = malloc(sizeof(char)*4096);
	strcpy(dialogText, String_val(text));
	DialogPanel_setText(game.dialogPanel, dialogText);
	free(dialogText);
}

/* addDialogAnswer function
	adds an answer to the dialog panel */
value addDialogAnswer(answ)
{
	char* answer = String_val(answ);
	DialogPanel_addAnswer(game.dialogPanel, answer);
}

value wannaWrite(value unit)
{
	if (game.wannaWrite!=0)
	{
		game.wannaWrite = 0;
		return 1; 
	}
	return 0;
}

value clearDialogAnswers(value unit)
{
	DialogPanel_clearAnswers( game.dialogPanel);
	return Val_unit;
}

value setSelectorPos(pos)
{
	DialogPanel_setSelectorPos(game.dialogPanel, Int_val(pos));
	return Val_unit;
}

/***********************************************************************************
							FUNCTIONS FOR NPCS
***********************************************************************************/
value addNPC(tileX, tileY, texture)
{
	game.npcCount++;
	game.npc = (sfSprite**) realloc (game.npc, game.npcCount * sizeof(sfSprite*));
	*(game.npc + (game.npcCount-1)*sizeof(sfSprite*)) = sfSprite_Create();
	sfSprite_SetImage(*(game.npc + (game.npcCount-1)*sizeof(sfSprite*)), TexturesManager_getTexture(game.texturesManager, String_val(texture)));
	sfSprite_SetPosition(*(game.npc + (game.npcCount-1)*sizeof(sfSprite*)), Int_val(tileX)*60,Int_val(tileY)*60);
	sfSprite_Resize(*(game.npc + (game.npcCount-1)*sizeof(sfSprite*)), 50,50);
	return Val_unit;
}
value removeNPCs()
{
	int i = 0;
	for(i=0; i < game.npcCount; i++)
	{
		sfSprite_Destroy(*(game.npc + (game.npcCount-1)*sizeof(sfSprite*)));
		*(game.npc + (game.npcCount-1)*sizeof(sfSprite*)) = NULL;
	}
	game.npc = malloc(0);
	game.npcCount = 0;
	return Val_unit;
}

/***********************************************************************************
							FUNCTIONS FOR POPUPS
***********************************************************************************/
void updatePopup()
{
	if (game.popupMessageCount > 0) {
		game.popupMessage = sfString_Create();
		game.popupBackground = sfSprite_Create();
		game.popupClock = sfClock_Create();
		game.popupTime = game.popupQueue->time;
		sfSprite_SetImage(game.popupBackground, TexturesManager_getTexture(game.texturesManager, "media/ui/popupBackground.png"));
		sfSprite_SetPosition(game.popupBackground, 240, 0);
		sfString_SetText(game.popupMessage, game.popupQueue->message);
		sfString_SetFont(game.popupMessage, game.font);
		sfString_SetSize(game.popupMessage, 18);
		sfString_SetColor(game.popupMessage, sfBlack);
		sfFloatRect rect = sfString_GetRect(game.popupMessage);
		sfString_SetCenter(game.popupMessage, (rect.Right - rect.Left)/2, (rect.Bottom - rect.Top)/2); 
		sfString_SetPosition(game.popupMessage, 540, 20);
		game.popupQueue = game.popupQueue->next;
	}
	
}
value flushPopups()
{
	
	PopupQueue* popup = game.popupQueue;
	while(popup != NULL) {
		PopupQueue* current = popup;
		popup = popup->next;
		free(current);
	}
	game.popupQueue = NULL;

	sfClock_Destroy(game.popupClock);
	game.popupClock = NULL;
	game.popupTime = 0.0f;
	sfString_Destroy(game.popupMessage);
	game.popupMessage = NULL;
	sfSprite_Destroy(game.popupBackground);
	game.popupBackground = NULL;
	game.popupMessageCount = 0;
		
	return Val_unit;
}
value showPopupMessage(str, time)
{
	if (game.popupMessageCount == 0) {
		game.popupMessage = sfString_Create();
		game.popupBackground = sfSprite_Create();
		game.popupClock = sfClock_Create();
		game.popupTime = Double_val(time);
		sfSprite_SetImage(game.popupBackground, TexturesManager_getTexture(game.texturesManager, "media/ui/popupBackground.png"));
		sfSprite_SetPosition(game.popupBackground, 240, 0);
		sfString_SetText(game.popupMessage, String_val(str));
		sfString_SetFont(game.popupMessage, game.font);
		sfString_SetSize(game.popupMessage, 18);
		sfString_SetColor(game.popupMessage, sfBlack);
		sfFloatRect rect = sfString_GetRect(game.popupMessage);
		sfString_SetCenter(game.popupMessage, (rect.Right - rect.Left)/2, (rect.Bottom - rect.Top)/2); 
		sfString_SetPosition(game.popupMessage, 540, 20);
		game.popupMessageCount ++;
	}
	else { // just add a popup message to the queue
		// create the popup
		PopupQueue* nextPopup = malloc(sizeof(PopupQueue));
		nextPopup->message = malloc(sizeof(char)*256);
		strcpy(nextPopup->message, String_val(str));
		nextPopup->time = Double_val(time);
		nextPopup->next = NULL;
		// add it
		PopupQueue* current = game.popupQueue;
		if (current == NULL) 
			game.popupQueue = nextPopup;
		else {
			while(current->next != NULL) {
				current = current->next;
			}
			current->next = nextPopup;
		}
		game.popupMessageCount ++;
	}
}

/***********************************************************************************
						FUNCTIONS FOR SELECTION PANEL
***********************************************************************************/
value clearAnythings( )
{
	int i = 0;
	for (i=0; i < 9; i++) { 
		free(anythingSelection.anythings[i]);
		free(anythingSelection.sprites[i]);
		anythingSelection.anythings[i] = NULL;
		anythingSelection.sprites[i] = NULL;
	}
	anythingSelection.anythingCount = 0;
	anythingSelection.xSelector = 0;
	anythingSelection.ySelector = 0;
	return Val_unit;
}
value addAnything(value texture, value description)
{
	if (anythingSelection.anythingCount >= 9)
		return;
	Anything* anything = malloc(sizeof(Anything));

	char* text = (char*) String_val(texture);
	anything->texture = malloc(256*sizeof(char));
	strcpy(anything->texture, text);

	char* text2 = (char*) String_val(description);
	anything->description = malloc(2048*sizeof(char));
	strcpy(anything->description, text2);

	anythingSelection.anythings[anythingSelection.anythingCount] = anything;
	anythingSelection.anythingCount ++;

	return Val_unit;
}

void updateSelectionRelatedText()
{
	int number = anythingSelection.xSelector+3*anythingSelection.ySelector;
	if (number < anythingSelection.anythingCount)
	{
		Anything* anything = anythingSelection.anythings[number];
		sfString_SetText(anythingSelection.selectionRelatedText, anything->description);
	}
	else
		sfString_SetText(anythingSelection.selectionRelatedText, "Please select something.\0");
}

void updateSelectorPos()
{
	sfSprite_SetPosition(anythingSelection.selector, 71+anythingSelection.xSelector*207, 52+anythingSelection.ySelector*205);
	updateSelectionRelatedText();
}

value enableAnythingSelection()
{
	updateAnythingSelection();
	updateSelectorPos();
	updateSelectionRelatedText();
	anythingSelection.running = 1;
}
value disableAnythingSelection()
{
	anythingSelection.running = 0;
}

void initAnythingSelection()
{
	anythingSelection.running = 0;
	anythingSelection.anythingCount = 0;
	int i = 0;
	for (i=0; i < 9; i++) { 
		anythingSelection.anythings[i] = NULL;
		anythingSelection.sprites[i] = NULL;
	}
	anythingSelection.xSelector = 0;
	anythingSelection.ySelector = 0;

	anythingSelection.bg = sfSprite_Create();
	sfSprite_SetImage( anythingSelection.bg, TexturesManager_getTexture(game.texturesManager, "media/ui/anythingSelectionBackground.png"));
	anythingSelection.selector = sfSprite_Create();
	sfSprite_SetImage( anythingSelection.selector, TexturesManager_getTexture(game.texturesManager, "media/ui/anythingSelector.png"));
	sfSprite_SetPosition(anythingSelection.selector, 71, 52);

	anythingSelection.selectionRelatedText = sfString_Create();
	sfString_SetFont(anythingSelection.selectionRelatedText, game.font);
	sfString_SetSize(anythingSelection.selectionRelatedText, 18);
	sfString_SetColor(anythingSelection.selectionRelatedText, sfBlack);
	sfString_SetPosition(anythingSelection.selectionRelatedText, 713, 124);
}

void updateAnythingSelection()
{
	int i = 0;
	for (i=0; i < anythingSelection.anythingCount; i++)
	{
		anythingSelection.sprites[i] = sfSprite_Create();
		Anything* anything = anythingSelection.anythings[i];
		char* text = malloc(sizeof(char));
		*text = '\0';
		if (strcmp(anything->texture, text) != 0)
			sfSprite_SetImage( anythingSelection.sprites[i], TexturesManager_getTexture(game.texturesManager, anything->texture));
		sfSprite_SetPosition( anythingSelection.sprites[i], 72+(i%3)*207, 53+(i/3)*205);
		sfSprite_Resize( anythingSelection.sprites[i], 203, 203);
	}
}

void drawAnythingSelection() 
{
	sfRenderWindow_DrawSprite(game.renderWindow, anythingSelection.bg);
	int i = 0;
	for (i=0; i < anythingSelection.anythingCount; i++)
	{ 
		sfRenderWindow_DrawSprite(game.renderWindow, anythingSelection.sprites[i]);
	}
	sfRenderWindow_DrawSprite(game.renderWindow, anythingSelection.selector);
	sfRenderWindow_DrawString(game.renderWindow, anythingSelection.selectionRelatedText);
}

value moveAnythingSelectorUp()
{
	do {
		anythingSelection.ySelector --;
		if (anythingSelection.ySelector < 0) anythingSelection.ySelector = 2;
	} while (anythingSelection.ySelector*3 + anythingSelection.xSelector >= anythingSelection.anythingCount);
	updateSelectorPos();
	return Val_unit;
}
value moveAnythingSelectorDown()
{
	do {
		anythingSelection.ySelector ++;
		if (anythingSelection.ySelector > 2) anythingSelection.ySelector = 0;
	} while (anythingSelection.ySelector*3 + anythingSelection.xSelector >= anythingSelection.anythingCount);
	updateSelectorPos();
	return Val_unit;
}
value moveAnythingSelectorLeft()
{
	do {
		anythingSelection.xSelector --;
		if (anythingSelection.xSelector < 0) anythingSelection.xSelector = 2;
	} while (anythingSelection.ySelector*3 + anythingSelection.xSelector >= anythingSelection.anythingCount);
	updateSelectorPos();
	return Val_unit;
}
value moveAnythingSelectorRight()
{
	do {
		anythingSelection.xSelector ++;
		if (anythingSelection.xSelector > 2) anythingSelection.xSelector = 0;
	} while (anythingSelection.ySelector*3 + anythingSelection.xSelector >= anythingSelection.anythingCount);
	updateSelectorPos();
	return Val_unit;
}

value getAnythingSelection()
{
	return Val_int(anythingSelection.xSelector + anythingSelection.ySelector*3);
}

/***********************************************************************************
							FUNCTIONS FOR JOURNAL
***********************************************************************************/
value setLeftJournalText(s)
{
	char* text = (char*) String_val(s);
	setLeftText(game.journal, text);
}
value setRightJournalText(s)
{
	char* text = (char*) String_val(s);
	setRightText(game.journal, text);
}
value enableJournal()
{
	game.showJournal = 1;
}
value disableJournal()
{
	game.showJournal = 0;
}









