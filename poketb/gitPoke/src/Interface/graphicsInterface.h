#ifndef GRAPHICS_INTERFACE
#define GRAPHICS_INTERFACE

#include <SFML/Audio.h>
#include <SFML/Graphics.h>
#include <SFML/Window.h>
#include <SFML/System.h>

#include <mlvalues.h>
#include <alloc.h>
#include <memory.h>
#include <stdio.h>
#include <stdlib.h>

#include "dialog.h"
#include "texturesManager.h"
#include "journal.h"

struct MapTile
{
	sfSprite* sprite;
	int type;
};
typedef struct MapTile MapTile;

struct Anything
{
	char* texture;
	char* description;
};
typedef struct Anything Anything;

struct AnythingSelection
{
	int running;
	sfSprite* bg;
	sfSprite* selector;
	sfString* selectionRelatedText;
	int anythingCount;
	int xSelector, ySelector;
	Anything* anythings[9];
	sfSprite* sprites[9];
};
typedef struct AnythingSelection AnythingSelection;

struct PopupQueue
{
	char* message;
	float time;
	struct PopupQueue* next; 
};
typedef struct PopupQueue PopupQueue;

/* GameGraphics structure : 
	contains all data about the graphical part of this app */
struct GameGraphics
{
	sfRenderWindow* renderWindow;
	MapTile* map[18*12];
	sfSprite* user;
	float userWalkCount;
	sfSprite* trophy;
	sfSprite* trophyBackground;	
	sfFont* font;
	sfString* text;
	int dialogMode;
	DialogPanel* dialogPanel;
	int wannaWrite;
	TexturesManager* texturesManager;
	int npcCount;
	sfSprite** npc;
	sfString* popupMessage;
	sfClock* popupClock;
	sfSprite* popupBackground;
	float popupTime;
	int popupMessageCount;
	PopupQueue* popupQueue;
	int showJournal;
	Journal* journal;

	sfSprite* mainMenu;
	sfSprite* mainMenuSelector;
};
typedef struct GameGraphics GameGraphics;

GameGraphics game;
AnythingSelection anythingSelection;
sfClock* clock;

void updatePopup();
void drawAnythingSelection();
void updateAnythingSelection();
void initAnythingSelection();
void updateSelectionRelatedText();
void updateSelectorPos();

#endif
