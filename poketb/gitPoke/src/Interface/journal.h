#ifndef JOURNAL_H_INCLUDED
#define JOURNAL_H_INCLUDED

#include <SFML/Graphics.h>
#include <stdio.h>
#include "texturesManager.h"

struct Journal
{
	sfSprite* background;
	sfString* leftText;
	sfString* rightText;
};
typedef struct Journal Journal;

void setText(sfString* a, char* text)
{
// try to find where to add \n characters to display text properly 
	sfFloatRect rect = sfString_GetRect(a);
	float width = rect.Right - rect.Left;
	int i = 0;
	while (*(text+i) != '\0')
	{
		if (*(text+i) == ' ') *(text+i) = '\n';
		i++;
	}
	int stringLength = i;

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
			if (width > 380) // if the text is too long, reverse the change
			{
				// before trying to reverse, check if there's no wanted line before :
				int j;
				j = 0;
				while ( j < i)
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
				if (width > 380) // if it's still too long
				{
					*(text+i) = '\n';
					sfString_SetText(a, text);
					rect = sfString_GetRect(a);
					width = rect.Right - rect.Left;
				}
			}
		i++;
	}
	// add \\ n characters
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
}

void setLeftText(Journal* journal, char* text)
{
	setText(journal->leftText, text);
}

void setRightText(Journal* journal, char* text)
{
	setText(journal->rightText, text);
}

void initJournal(Journal* journal, sfFont* font, TexturesManager* texturesManager)
{
	journal->background = sfSprite_Create();
	sfSprite_SetImage(journal->background, TexturesManager_getTexture(texturesManager, "media/ui/journal.png"));
	sfSprite_SetPosition(journal->background, 108,109);
	sfSprite_Resize(journal->background, 864,502);

	journal->leftText = sfString_Create();
    sfString_SetFont(journal->leftText, font);
	sfString_SetSize(journal->leftText, 14);
	sfString_SetColor(journal->leftText, sfBlack);
	sfString_SetPosition(journal->leftText, 140, 180);
	setLeftText(journal, "");

	journal->rightText = sfString_Create();
    sfString_SetFont(journal->rightText, font);
	sfString_SetSize(journal->rightText, 14);
	sfString_SetColor(journal->rightText, sfBlack);
	sfString_SetPosition(journal->rightText, 570, 180);
	setRightText(journal, "");
}



void drawJournal(Journal* journal, sfRenderWindow* rw)
{
	if (journal->background)
		sfRenderWindow_DrawSprite(rw, journal->background);
	if (journal->leftText)
		sfRenderWindow_DrawString(rw, journal->leftText);
	if (journal->rightText)
		sfRenderWindow_DrawString(rw, journal->rightText);
}



#endif

