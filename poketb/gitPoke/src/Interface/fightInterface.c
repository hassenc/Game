#include <SFML/Audio.h>
#include <SFML/Graphics.h>
#include <SFML/Window.h>
#include <SFML/System.h>

#include <mlvalues.h>
#include <alloc.h>
#include <memory.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "texturesManager.h"
#include "graphicsInterface.c"

struct FightInterface
{
	sfSprite* background;
	sfSprite* headerBackground;
	sfSprite* leftLifeBarContainer;
	sfSprite* leftManaBarContainer;
	sfSprite* rightLifeBarContainer;
	sfSprite* rightManaBarContainer;
	sfSprite* leftManaBar;
	sfSprite* rightManaBar;
	sfSprite* leftLifeBar;
	sfSprite* rightLifeBar;

	sfSprite* leftCreature;
	sfSprite* rightCreature;

	sfString* rightCreatureName;
	sfString* leftCreatureName;
	sfString* rightCreatureLevel;
	sfString* leftCreatureLevel;

	sfString* rightManaBarText;
	sfString* leftManaBarText;
	sfString* rightLifeBarText;
	sfString* leftLifeBarText;
	
	int leftLife;
	int rightLife;
	int leftMana;
	int rightMana;
	int leftLifeMax;
	int rightLifeMax;
	int leftManaMax;
	int rightManaMax;

	int leftLevel;
	int rightLevel;
	char* leftName;
	char* rightName;
};

struct FightInterface fi;

char* getString(int val)
{
	char* text = malloc(15*sizeof(char));
	if (val > 1000000)
		sprintf(text, "%i %i %i", val/1000000, (val % 1000000)/1000, val % 1000);
	else if (val > 1000)
		sprintf(text, "%i %i",  val/1000, val % 1000);
	else
		sprintf(text, "%i", val);
	return text;
}
char* getStringDivision(int a, int b)
{
	char* ret = malloc(30*sizeof(char));
	sprintf(ret, "%s%s%s", getString(a), " / ", getString(b));
	return ret;
}

value updateBarsStrings()
{
	char text[30];
	char* entry;

	entry = getStringDivision(fi.leftLife, fi.leftLifeMax);
	strcpy(text, entry);
	free(entry);
    sfString_SetText(fi.leftLifeBarText, text);
	sfFloatRect leftLifeBarTextPos = sfString_GetRect(fi.leftLifeBarText);
	sfString_SetCenter(fi.leftLifeBarText, (leftLifeBarTextPos.Right - leftLifeBarTextPos.Left)/2, 0); 

	entry = getStringDivision(fi.leftMana, fi.leftManaMax);
	strcpy(text, entry);
	free(entry);
    sfString_SetText(fi.leftManaBarText, text);
	sfFloatRect leftManaBarTextPos = sfString_GetRect(fi.leftManaBarText);
	sfString_SetCenter(fi.leftManaBarText, (leftManaBarTextPos.Right - leftManaBarTextPos.Left)/2, 0); 

	entry = getStringDivision(fi.rightLife, fi.rightLifeMax);
	strcpy(text, entry);
	free(entry);
    sfString_SetText(fi.rightLifeBarText, text);
	sfFloatRect rightLifeBarTextPos = sfString_GetRect(fi.rightLifeBarText);
	sfString_SetCenter(fi.rightLifeBarText, (rightLifeBarTextPos.Right - rightLifeBarTextPos.Left)/2, 0); 

	entry = getStringDivision(fi.rightMana, fi.rightManaMax);
	strcpy(text, entry);
	free(entry);
    sfString_SetText(fi.rightManaBarText, text);
	sfFloatRect rightManaBarTextPos = sfString_GetRect(fi.rightManaBarText);
	sfString_SetCenter(fi.rightManaBarText, (rightManaBarTextPos.Right - rightManaBarTextPos.Left)/2, 0); 
	
	return Val_unit;
}

value updateBarsTextures()
{
	sfSprite_SetScaleX(fi.leftLifeBar, (float)(fi.leftLife) / (float)(fi.leftLifeMax));
	sfSprite_SetScaleX(fi.leftManaBar, (float)(fi.leftMana) / (float)(fi.leftManaMax));
	sfSprite_SetScaleX(fi.rightLifeBar, (float)(fi.rightLife) / (float)(fi.rightLifeMax));
	sfSprite_SetScaleX(fi.rightManaBar, (float)(fi.rightMana) / (float)(fi.rightManaMax));
}




value updateCreaturesStrings()
{
	char text[30];
	sprintf(text, "Lvl:%i", fi.leftLevel);
	sfString_SetText(fi.leftCreatureLevel, text);
	
	sprintf(text, "Lvl:%i", fi.rightLevel);
	sfString_SetText(fi.rightCreatureLevel, text);
	
	sfString_SetText(fi.leftCreatureName, fi.leftName);
	sfString_SetText(fi.rightCreatureName, fi.rightName);
}

value initFightInterface()
{
	fi.background = sfSprite_Create();
	sfSprite_SetImage(fi.background, TexturesManager_getTexture(game.texturesManager, "media/ui/fightBackground1.png"));
	sfSprite_SetPosition(fi.background, 0,0);

	fi.headerBackground = sfSprite_Create();
	sfSprite_SetImage(fi.headerBackground, TexturesManager_getTexture(game.texturesManager, "media/ui/headerBackground.png"));
	sfSprite_SetPosition(fi.headerBackground, 0,0);

	fi.leftLifeBarContainer = sfSprite_Create();
	sfSprite_SetImage(fi.leftLifeBarContainer, TexturesManager_getTexture(game.texturesManager, "media/ui/barsContainer.png"));
	sfSprite_SetPosition(fi.leftLifeBarContainer, 90,108);

	fi.leftManaBarContainer = sfSprite_Create();
	sfSprite_SetImage(fi.leftManaBarContainer, TexturesManager_getTexture(game.texturesManager, "media/ui/barsContainer.png"));
	sfSprite_SetPosition(fi.leftManaBarContainer, 90,140);

	fi.rightLifeBarContainer = sfSprite_Create();
	sfSprite_SetImage(fi.rightLifeBarContainer, TexturesManager_getTexture(game.texturesManager, "media/ui/barsContainer.png"));
	sfSprite_SetPosition(fi.rightLifeBarContainer, 764,108);

	fi.rightManaBarContainer = sfSprite_Create();
	sfSprite_SetImage(fi.rightManaBarContainer, TexturesManager_getTexture(game.texturesManager, "media/ui/barsContainer.png"));
	sfSprite_SetPosition(fi.rightManaBarContainer, 764,140);

	fi.leftLifeBar = sfSprite_Create();
	sfSprite_SetImage(fi.leftLifeBar, TexturesManager_getTexture(game.texturesManager, "media/ui/lifeBar.png"));
	sfSprite_SetPosition(fi.leftLifeBar, 95,112);

	fi.leftManaBar = sfSprite_Create();
	sfSprite_SetImage(fi.leftManaBar, TexturesManager_getTexture(game.texturesManager, "media/ui/manaBar.png"));
	sfSprite_SetPosition(fi.leftManaBar, 95,144);

	fi.rightLifeBar = sfSprite_Create();
	sfSprite_SetImage(fi.rightLifeBar, TexturesManager_getTexture(game.texturesManager, "media/ui/lifeBar.png"));
	sfSprite_SetPosition(fi.rightLifeBar, 769,112);

	fi.rightManaBar = sfSprite_Create();
	sfSprite_SetImage(fi.rightManaBar, TexturesManager_getTexture(game.texturesManager, "media/ui/manaBar.png"));
	sfSprite_SetPosition(fi.rightManaBar, 769,144);

	fi.leftCreature = sfSprite_Create();
	sfSprite_FlipX(fi.leftCreature, 1);
	/*sfSprite_SetImage(fi.leftCreature, TexturesManager_getTexture(game.texturesManager, "media/creatures/.png"));*/
	sfSprite_SetPosition(fi.leftCreature, 60,250);
	

	fi.rightCreature = sfSprite_Create();
	/*sfSprite_SetImage(fi.rightCreature, TexturesManager_getTexture(game.texturesManager, "media/creatures/Galouf.png"));*/
	sfSprite_SetPosition(fi.rightCreature, 740,250);

	setSelectorPos(game.dialogPanel, 0);


	// initialize creature labels :
	fi.leftName = "";
	fi.leftCreatureName = sfString_Create();
    sfString_SetText(fi.leftCreatureName, "Payssa");
    sfString_SetFont(fi.leftCreatureName, game.font);
	sfString_SetSize(fi.leftCreatureName, 20);
	sfString_SetColor(fi.leftCreatureName, sfBlack);
	sfString_SetPosition(fi.leftCreatureName, 95, 65);

	fi.leftLevel = 0;
	fi.leftCreatureLevel = sfString_Create();
    sfString_SetText(fi.leftCreatureLevel, "Lvl:66");
    sfString_SetFont(fi.leftCreatureLevel, game.font);
	sfString_SetSize(fi.leftCreatureLevel, 20);
	sfString_SetColor(fi.leftCreatureLevel, sfBlack);
	sfString_SetPosition(fi.leftCreatureLevel, 265, 65);

	fi.rightName = "Galouf";
	fi.rightCreatureName = sfString_Create();
    sfString_SetText(fi.rightCreatureName, "Galouf");
    sfString_SetFont(fi.rightCreatureName, game.font);
	sfString_SetSize(fi.rightCreatureName, 20);
	sfString_SetColor(fi.rightCreatureName, sfBlack);
	sfString_SetPosition(fi.rightCreatureName, 766, 65);

	fi.rightLevel = 2;
	fi.rightCreatureLevel = sfString_Create();
    sfString_SetText(fi.rightCreatureLevel, "Lvl:2");
    sfString_SetFont(fi.rightCreatureLevel, game.font);
	sfString_SetSize(fi.rightCreatureLevel, 20);
	sfString_SetColor(fi.rightCreatureLevel, sfBlack);
	sfString_SetPosition(fi.rightCreatureLevel, 936, 65);

	// life/mana labels

    fi.leftLife = 0;
	fi.leftLifeMax = 0;
	fi.leftMana = 0;
	fi.leftManaMax = 0;
    fi.rightLife = 30;
	fi.rightLifeMax = 30;
	fi.rightMana = 10;
	fi.rightManaMax = 10;

	fi.leftLifeBarText = sfString_Create();
    sfString_SetFont(fi.leftLifeBarText, game.font);
	sfString_SetSize(fi.leftLifeBarText, 12);
	sfString_SetColor(fi.leftLifeBarText, sfBlack);
	sfFloatRect leftLifeBarTextPos = sfString_GetRect(fi.leftLifeBarText);
	sfString_SetCenter(fi.leftLifeBarText, (leftLifeBarTextPos.Right - leftLifeBarTextPos.Left)/2, 0); 
	sfString_SetPosition(fi.leftLifeBarText, 205, 112);

	fi.leftManaBarText = sfString_Create();
    sfString_SetFont(fi.leftManaBarText, game.font);
	sfString_SetSize(fi.leftManaBarText, 12);
	sfString_SetColor(fi.leftManaBarText, sfBlack);
	sfFloatRect leftManaBarTextPos = sfString_GetRect(fi.leftManaBarText);
	sfString_SetCenter(fi.leftManaBarText, (leftManaBarTextPos.Right - leftManaBarTextPos.Left)/2, 0);
	sfString_SetPosition(fi.leftManaBarText, 205, 144);

	fi.rightLifeBarText = sfString_Create();
    sfString_SetFont(fi.rightLifeBarText, game.font);
	sfString_SetSize(fi.rightLifeBarText, 12);
	sfString_SetColor(fi.rightLifeBarText, sfBlack);
	sfFloatRect rightLifeBarTextPos = sfString_GetRect(fi.rightLifeBarText);
	sfString_SetCenter(fi.rightLifeBarText, (rightLifeBarTextPos.Right - rightLifeBarTextPos.Left)/2, 0); 
	sfString_SetPosition(fi.rightLifeBarText, 879, 112);

	fi.rightManaBarText = sfString_Create();
    sfString_SetFont(fi.rightManaBarText, game.font);
	sfString_SetSize(fi.rightManaBarText, 12);
	sfString_SetColor(fi.rightManaBarText, sfBlack);
	sfFloatRect rightManaBarTextPos = sfString_GetRect(fi.rightManaBarText);
	sfString_SetCenter(fi.rightManaBarText, (rightManaBarTextPos.Right - rightManaBarTextPos.Left)/2, 0); 
	sfString_SetPosition(fi.rightManaBarText, 879, 144);

	updateBarsStrings();

	return Val_unit;
}

value drawFightInterface()
{
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

	sfRenderWindow_Clear(game.renderWindow, sfWhite);


	if (fi.background)
		sfRenderWindow_DrawSprite(game.renderWindow, fi.background);
	if (fi.headerBackground)
		sfRenderWindow_DrawSprite(game.renderWindow, fi.headerBackground);
	if (fi.leftLifeBarContainer)
		sfRenderWindow_DrawSprite(game.renderWindow, fi.leftLifeBarContainer);
	if (fi.leftManaBarContainer)
		sfRenderWindow_DrawSprite(game.renderWindow, fi.leftManaBarContainer);
	if (fi.rightLifeBarContainer)
		sfRenderWindow_DrawSprite(game.renderWindow, fi.rightLifeBarContainer);
	if (fi.rightManaBarContainer)
		sfRenderWindow_DrawSprite(game.renderWindow, fi.rightManaBarContainer);
	if (fi.leftManaBar && fi.leftMana > 0)
		sfRenderWindow_DrawSprite(game.renderWindow, fi.leftManaBar);
	if (fi.rightManaBar && fi.rightMana > 0)
		sfRenderWindow_DrawSprite(game.renderWindow, fi.rightManaBar);
	if (fi.leftLifeBar && fi.leftLife > 0)
		sfRenderWindow_DrawSprite(game.renderWindow, fi.leftLifeBar);
	if (fi.rightLifeBar && fi.rightLife > 0)
		sfRenderWindow_DrawSprite(game.renderWindow, fi.rightLifeBar);
	if (fi.leftCreature)
		sfRenderWindow_DrawSprite(game.renderWindow, fi.leftCreature);
	if (fi.rightCreature)
		sfRenderWindow_DrawSprite(game.renderWindow, fi.rightCreature);

	if (fi.rightCreatureName)
		sfRenderWindow_DrawString(game.renderWindow, fi.rightCreatureName);
	if (fi.leftCreatureName)
		sfRenderWindow_DrawString(game.renderWindow, fi.leftCreatureName);
	if (fi.rightCreatureLevel)
		sfRenderWindow_DrawString(game.renderWindow, fi.rightCreatureLevel);
	if (fi.leftCreatureLevel)
		sfRenderWindow_DrawString(game.renderWindow, fi.leftCreatureLevel);

	if (fi.leftLifeBarText)
		sfRenderWindow_DrawString(game.renderWindow, fi.leftLifeBarText);
	if (fi.leftManaBarText)
		sfRenderWindow_DrawString(game.renderWindow, fi.leftManaBarText);
	if (fi.rightLifeBarText)
		sfRenderWindow_DrawString(game.renderWindow, fi.rightLifeBarText);
	if (fi.rightManaBarText)
		sfRenderWindow_DrawString(game.renderWindow, fi.rightManaBarText);
	
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
	
	
	sfRenderWindow_Display(game.renderWindow);
	return Val_unit;
	
}


value setLeftLife(val)
{
	fi.leftLife = Int_val(val);
	return Val_unit;
}

value setLeftLifeMax(val)
{
	fi.leftLifeMax = Int_val(val);
	return Val_unit;
}

value setLeftMana(val)
{
	fi.leftMana = Int_val(val);
	return Val_unit;
}

value setLeftManaMax(val)
{
	fi.leftManaMax = Int_val(val);
	return Val_unit;
}

value setRightLife(val)
{
	fi.rightLife = Int_val(val);
	return Val_unit;
}

value setRightLifeMax(val)
{
	fi.rightLifeMax = Int_val(val);
	return Val_unit;
}

value setRightMana(val)
{
	fi.rightMana = Int_val(val);
	return Val_unit;
}

value setRightManaMax(val)
{
	fi.rightManaMax = Int_val(val);
	return Val_unit;
}

value setLeftCreatureTexture(str)
{
	char* texture = (char*)(String_val(str));
	sfSprite_SetImage(fi.leftCreature, TexturesManager_getTexture(game.texturesManager, texture));
	//sfSprite_FlipX(fi.leftCreature);
	return Val_unit;
}

value setRightCreatureTexture(str)
{
	char* texture = (char*)(String_val(str));
	sfSprite_SetImage(fi.rightCreature, TexturesManager_getTexture(game.texturesManager, texture));
	return Val_unit;
}

value setLeftCreatureName(str)
{
	fi.leftName = (char*)(String_val(str));
	return Val_unit;
}

value setRightCreatureName(str)
{
	fi.rightName = (char*)(String_val(str));
	return Val_unit;
}

value setLeftCreatureLevel(lvl)
{
	fi.leftLevel = Int_val(lvl);
	return Val_unit;
}

value setRightCreatureLevel(lvl)
{
	fi.rightLevel = Int_val(lvl);
	return Val_unit;
}

value clearLeftFightWindow()
{
	sfSprite_SetImage(fi.leftCreature, TexturesManager_getTexture(game.texturesManager, "media/creatures/Empty.png"));
	setLeftCreatureLevel(0);
	setLeftCreatureName("");
	setLeftMana(0);
	setLeftManaMax(0);
	setLeftLife(0);
	setLeftLifeMax(0);
}






