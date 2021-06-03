/// @description Update Game

if (global.levelStart)
{
    global.deltaTime = 1;
    global.levelStart = false;
}
else global.deltaTime = 60 / 1000000 * delta_time;

/*Game logic system:
This synchronizes the game logic with delta time, allowing you
to play at any framerate. Instead of using step events,
all objects use the according User Defined events as their steps.*/

gameLoop += global.deltaTime;
while (gameLoop)
{
    with (all)
    {
        event_user(14); //Begin Step
        event_user(13); //Step
        event_user(15); //End Step
    }
    gameLoop--;
}