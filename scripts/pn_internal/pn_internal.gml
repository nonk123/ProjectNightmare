function pn_is_internal_object() { return (object_index == objControl || object_index == rousrDissonance) }

function pn_transition_set_timer()
{
	switch (transition)
	{
		case (eTransition.circle):
		case (eTransition.circle2): timer[0] = 60; break
		case (eTransition.fade): timer[0] = 120; break
	}
}