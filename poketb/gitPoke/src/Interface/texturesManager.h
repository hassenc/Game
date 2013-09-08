#ifndef TEXTURES_MANAGER
#define TEXTURES_MANAGER

#include <SFML/Graphics.h>
#include "string.h"

#define MAX_TEXTURES 1024

struct Texture
{
	sfImage* texture;
	char* filename;
};
typedef struct Texture Texture;

struct TexturesManager
{
	Texture* textures[MAX_TEXTURES];
	int textureCount;
};
typedef struct TexturesManager TexturesManager;

void TexturesManager_init(TexturesManager* manager)
{
	manager->textureCount = 0;
}

sfImage* TexturesManager_getTexture(TexturesManager* manager, char* file)
{
	int i;
	for (i=0; i < manager->textureCount; i++)
	{
		if (strcmp(manager->textures[i]->filename,file) == 0)
			return manager->textures[i]->texture;
	}

	// texture not found : load one	
	if (manager->textureCount < MAX_TEXTURES)
	{
		sfImage* img = sfImage_CreateFromFile(file);
		sfImage_SetSmooth(img, 0);
		Texture* tex = malloc(sizeof(Texture));
		tex->texture = img;
		tex->filename = malloc(100*sizeof(char));
		strcpy(tex->filename,file);
		manager->textures[manager->textureCount] = tex;
		manager->textureCount ++;
		return manager->textures[manager->textureCount-1]->texture;
	}
	return manager->textures[0]->texture;
}

#endif
