
#include <stdio.h>
#include <pthread.h>
#include </homes/rnicolle/Téléchargements/SFML-1.6/CSFML/include/SFML/Audio.h>

#include <mlvalues.h>
#include <alloc.h>
#include <memory.h>

void music()
{
    sfMusic* Music1 = NULL;
    if (!(Music1 = sfMusic_CreateFromFile("media/music/pepin.ogg")))
    {
        printf("Error while loading music\n");
        return;
    }
    sfMusic_SetLoop(Music1, 1);
    sfMusic_Play(Music1);
    return;
}

value startMusic(value unit)
{
    music();
    return Val_unit;
}

