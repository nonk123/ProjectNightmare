/// @description Animation Control
switch (state)
{
    case (0):
        //Set our timer to begin
        timer[0] = 30;
        state = 1;
    break
	
    case (1):
        //Tick down the timer before the logo appears.
        if (timer_tick(0))
        {
            audio_play_sound(global.sounds[? "sndCoinIntro"][0], 1, false);
            state = 2;
        }
    break
	
    case (2):
        //Grow the logo
        if (image_xscale)
        {
            wobble = 1;
            state = 3;
        }
        else image_xscale += 0.05;
    break
	
    case (3):
        //Dewobble the logo
        if (wobble > 0) wobble -= 0.05;
        else
        {
            wobble = 0;
            timer[0] = 30;
            state = 4;
        }
    break
	
    case (4):
        if (timer_tick(0))
        {
            audio_play_sound(global.sounds[? "sndMarioIntro"][0], 1, false);
            timer[0] = 30;
            state = 5;
        }
    break
	
    case (5):
        timer_tick(0);
        if !(timer[0])
            if (image_alpha)
            {
                timer[0] = 80;
                state = 6;
            }
            else image_alpha += 0.05;
    break
	
    case (6):
        timer_tick(0);
        if !(timer[0])
            if (image_alpha > 0) image_alpha -= 0.05;
            else
                if (image_xscale > 0) image_xscale -= 0.05;
                else
                {
                    image_xscale = 0;
                    timer[0] = 40;
                    state = 7;
                }
    break
	
    case (7): if (timer_tick(0)) pn_level_goto(eLevel.logo); break
}