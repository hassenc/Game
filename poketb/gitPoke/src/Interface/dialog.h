/*******************************************************************
dialog.h file.
Contains a lot of functions which are used to set-up the strings
that are displayed to the user to dialog, trough the DialogPanel
structure.
*******************************************************************/

#include <SFML/Graphics.h>
#include <SFML/Window.h>
#include "list.h"
#include <stdio.h>

/* DialogPanel struct
	stores text and answers to be displayed */
struct DialogPanel
{
	sfString* text;
	struct StringList* answers;
	sfSprite* background;
	sfSprite* selector;
};
typedef struct DialogPanel DialogPanel;

void DialogPanel_setup(DialogPanel* panel)
{
	if (!panel)
		return;
	
	panel->background = sfSprite_Create();
	sfImage* img = sfImage_CreateFromFile("media/ui/dialogBackground.png");
	if (!img)
		printf("The image \"media/ui/background.png\" couldn't be loaded.");
	sfSprite_SetImage(panel->background, img);
	sfSprite_SetPosition(panel->background, (1080-sfImage_GetWidth(img))/2, 720-sfImage_GetHeight(img));
	panel->text = NULL;
	panel->answers = NULL;

	panel->selector = sfSprite_Create();
img = sfImage_CreateFromFile("media/ui/dialogCursor.png");
	sfSprite_SetImage(panel->selector, img);
	sfSprite_SetScale(panel->selector, 0.6, 0.6);
}

void DialogPanel_draw(DialogPanel* panel, sfRenderWindow* renderer)
{
	// draw background if possible
	if (panel->background)
		sfRenderWindow_DrawSprite(renderer, panel->background);
	// set strings positions
	if (panel->text)
		sfString_SetPosition( panel->text, sfSprite_GetX(panel->background)+130, sfSprite_GetY(panel->background) +35);
	// draw strings
	if (panel->text)
		sfRenderWindow_DrawString( renderer, panel->text);

	// set answers positions:
	struct StringList* current = panel->answers;
	int i = 0;
	while (current != NULL)
	{
		sfString_SetPosition( current->entry, sfSprite_GetX(panel->background)+130, 655-(i)*20);
		sfRenderWindow_DrawString(renderer, current->entry);
		current = current->next;
		i++;
	}
	
	if (panel->selector)
		sfRenderWindow_DrawSprite(renderer, panel->selector);
}

/* setText function
	sets the text of the dialog */
void DialogPanel_setText(DialogPanel* panel, char* text)
{
	if (!panel)
		return;
	
	int i = 0;
	int justReadSlash = 0;
	while (*(text+i) != '\0')
	{
		i++;
	}
	int stringLength = i;
	sfString* a = sfString_Create();
	sfString_SetText(a, text);
	sfString_SetColor(a, sfBlack);
	sfString_SetSize(a, 18);

	// try to find where to add \n characters to display text properly 
	sfFloatRect rect = sfString_GetRect(a);
	float width = rect.Right - rect.Left;
	while ( i > 0)
	{
		// changes all spaces by new line characters
		if (*(text+i) == ' ') *(text+i) = '\n';
		i--;
	}
	sfString_SetText(a, text);
	rect = sfString_GetRect(a);
	width = rect.Right - rect.Left;
	i = 0;
	while ( i < stringLength)
	{
			if (*(text+i) == '\n')  // replace newline characters by spaces
			{
				*(text+i) = ' ';
				sfString_SetText(a, text);
				rect = sfString_GetRect(a);
				width = rect.Right - rect.Left;
			}
			if (width > 800) // if the text is too long, reverse the change
			{
				int j;
				j = 0;
				while ( j < i-1)
				{
					if (*(text+j) == '\\' && *(text+j+1) == 'n')
					{
						*(text+j+1) = '\n';
						*(text+j) = ' ';
						sfString_SetText(a, text);
						rect = sfString_GetRect(a);
						width = rect.Right - rect.Left;
					}
					j++;
				}
				if (width > 800) // if it's still too long
				{
					*(text+i) = '\n';
					sfString_SetText(a, text);
					rect = sfString_GetRect(a);
					width = rect.Right - rect.Left;
				}
			}
		i++;
	}
	// add now the text newline characters
	i = 0;
	while ( i < stringLength-1)
	{
		if (*(text+i) == '\\' && *(text+i+1) == 'n')
		{
			*(text+i+1) = '\n';
			*(text+i) = ' ';
		}
		i++;
	}
	sfString_SetText(a, text);

	if (panel->text)
		sfString_Destroy(panel->text);
	panel->text = a;
}


/* addAnswer function
	adds an answer to a given dialog */
void DialogPanel_addAnswer(DialogPanel* panel, char* answer)
{
	if (!panel)
		return;
	
	struct StringList* a = malloc(sizeof(struct StringList));
	a->entry = sfString_Create();
	sfString_SetText(a->entry, answer);
	sfString_SetColor(a->entry, sfColor_FromRGBA(83,27,2,255));
	sfString_SetSize(a->entry,18);
		
	a->next = panel->answers;
	
	panel->answers = a;

}

void DialogPanel_clearAnswers(DialogPanel* panel)
{
	free(panel->answers);
	panel->answers = NULL;
}

void DialogPanel_setSelectorPos(DialogPanel* panel, int number)
{
	sfSprite_SetPosition( panel->selector, sfSprite_GetX(panel->background)+100, 655-20*number);
}

