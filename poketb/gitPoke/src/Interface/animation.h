#ifndef ANIMATION_H_INCLUDED
#define ANIMATION_H_INCLUDED

#include <stdio.h>
#include <stdlib.h>

struct AnimationStep
{
	float startTime;
	float length;
	int positionX;
	int positionY;
	char* image;
	struct AnimationStep* next;
};
typedef struct AnimationStep AnimationStep;


Animation* loadAnimation(char* filename)
{
	FILE *fp = NULL;
	fp=fopen(filename, "r");
	if (! fp)
		return;

	char line [4096];
    float time =0.0, length=0.0;
    int posX=0;
    int posY=0;
    char* text = malloc(256*sizeof(char));

	while (!feof(fp)) 
	{
		fgets ( line, sizeof line, fp);
		
    	if (sscanf(line, "%f;%f;%d;%d;%s", &time,&length,&posX,&posY,text) == 4) // reading 4 thins
		{
			// add a line to the animation
    		printf("You asked to draw %s on pos %d during %f starting at %f.", text, pos, time, length);
		}
		
    }

	fclose(fp);
}


#endif
