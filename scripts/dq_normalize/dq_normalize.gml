// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function dq_normalize(Q)
{
	var l, d;
	l = sqrt(sqr(Q[0]) + sqr(Q[1]) + sqr(Q[2]) + sqr(Q[3]));
	if l < 0.00001
	{
	l = 1;
	Q[0] = 1;
	Q[1] = 0;
	Q[2] = 0;
	Q[3] = 0;
	}
	l = 1 / l;
	Q[0] *= l
	Q[1] *= l
	Q[2] *= l
	Q[3] *= l

	d = Q[0] * Q[4] + Q[1] * Q[5] + Q[2] * Q[6] + Q[3] * Q[7];
	Q[4] = (Q[4] - Q[0] * d) * l;
	Q[5] = (Q[5] - Q[1] * d) * l;
	Q[6] = (Q[6] - Q[2] * d) * l;
	Q[7] = (Q[7] - Q[3] * d) * l;

	return Q;
}