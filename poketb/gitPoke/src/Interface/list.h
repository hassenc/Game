#include <SFML/Graphics.h>


struct StringList
{
	sfString* entry;
	struct StringList* next;
} ;

int StringList_getSize(struct StringList* list)
{
	struct StringList* current = list;
	int i = 0;
	while (current != NULL)
	{
		current = list->next;
		i++;
 	}
	return i;
}

