/*
	Some math scripts that are used by the ColMesh system.
*/

#macro cmDot dot_product_3d
#macro cmSqr colmesh_vector_square
#macro cmMag colmesh_vector_magnitude

/// @func colmesh_vector_square(x, y, z)
function colmesh_vector_square(x, y, z)
{
	//Returns the square of the magnitude of the given vector
	return dot_product_3d(x, y, z, x, y, z);
}
/// @func colmesh_vector_magnitude(x, y, z)
function colmesh_vector_magnitude(x, y, z)
{
	//Returns the magnitude of the given vector
	return sqrt(dot_product_3d(x, y, z, x, y, z));
}

/// @func colmesh_matrix_invert_fast(M, targetM*)
function colmesh_matrix_invert_fast(M, targetM) 
{
	//Returns the inverse of a 4x4 matrix. Assumes indices 3, 7 and 11 are 0, and index 15 is 1
	//With this assumption a lot of factors cancel out
	var m0 = M[0], m1 = M[1], m2 = M[2], m4 = M[4], m5 = M[5], m6 = M[6], m8 = M[8], m9 = M[9], m10 = M[10], m12 = M[12], m13 = M[13], m14 = M[14];
	var I = (is_undefined(targetM) ? array_create(16) : targetM);
	I[@ 0]  = m5 * m10 - m9 * m6;
	I[@ 1]  = m9 * m2  - m1 * m10;
	I[@ 2]  = m1 * m6  - m5 * m2;
	I[@ 3]  = 0;
	I[@ 4]  = m8 * m6  - m4 * m10;
	I[@ 5]  = m0 * m10 - m8 * m2;
	I[@ 6]  = m4 * m2  - m0 * m6;
	I[@ 7]  = 0;
	I[@ 8]  = m4 * m9  - m8 * m5;
	I[@ 9]  = m8 * m1  - m0 * m9;
	I[@ 10] = m0 * m5  - m4 * m1;
	I[@ 11] = 0;
	I[@ 12] = - dot_product_3d(m12, m13, m14, I[0], I[4], I[8]);
	I[@ 13] = - dot_product_3d(m12, m13, m14, I[1], I[5], I[9]);
	I[@ 14] = - dot_product_3d(m12, m13, m14, I[2], I[6], I[10]);
	I[@ 15] = m0 * m5 * m10 - m0 * m6 * m9 - m4 * m1 * m10 + m4 * m2 * m9 + m8 * m1 * m6 - m8 * m2 * m5;
	var _det = dot_product_3d(m0, m1, m2, I[0], I[4], I[8]);
	if (_det == 0)
	{
		show_debug_message("Error in function colmesh_matrix_invert_fast: The determinant is zero.");
		return I;
	}
	_det = 1 / _det;
	for(var i = 0; i < 16; i++)
	{
		I[@ i] *= _det;
	}
	return I;
}

/// @func colmesh_matrix_invert(M, targetM*)
function colmesh_matrix_invert(M, targetM)
{
	//Proper matrix inversion
	var m0 = M[0], m1 = M[1], m2 = M[2], m3 = M[3], m4 = M[4], m5 = M[5], m6 = M[6], m7 = M[7], m8 = M[8], m9 = M[9], m10 = M[10], m11 = M[11], m12 = M[12], m13 = M[13], m14 = M[14], m15 = M[15];
	var I = (is_undefined(targetM) ? array_create(16) : targetM);
	I[@ 0]  = m5 * m10 * m15 - m5 * m11 * m14 - m9 * m6 * m15 + m9 * m7 * m14 +m13 * m6 * m11 - m13 * m7 * m10;
	I[@ 1]  = -m1 * m10 * m15 + m1 * m11 * m14 + m9 * m2 * m15 - m9 * m3 * m14 - m13 * m2 * m11 + m13 * m3 * m10;
	I[@ 2]  = m1 * m6 * m15 - m1 * m7 * m14 - m5 * m2 * m15 + m5 * m3 * m14 + m13 * m2 * m7 - m13 * m3 * m6;
	I[@ 3]  = -m1 * m6 * m11 + m1 * m7 * m10 + m5 * m2 * m11 - m5 * m3 * m10 - m9 * m2 * m7 + m9 * m3 * m6;
	I[@ 4]  = -m4 * m10 * m15 + m4 * m11 * m14 + m8 * m6 * m15 - m8 * m7 * m14 - m12 * m6 * m11 + m12 * m7 * m10;
	I[@ 5]  = m0 * m10 * m15 - m0 * m11 * m14 - m8 * m2 * m15 + m8 * m3 * m14 + m12 * m2 * m11 - m12 * m3 * m10;
	I[@ 6]  = -m0 * m6 * m15 + m0 * m7 * m14 + m4 * m2 * m15 - m4 * m3 * m14 - m12 * m2 * m7 + m12 * m3 * m6;
	I[@ 7]  = m0 * m6 * m11 - m0 * m7 * m10 - m4 * m2 * m11 + m4 * m3 * m10 + m8 * m2 * m7 - m8 * m3 * m6;
	I[@ 8]  = m4 * m9 * m15 - m4 * m11 * m13 - m8 * m5 * m15 + m8 * m7 * m13 + m12 * m5 * m11 - m12 * m7 * m9;
	I[@ 9]  = -m0 * m9 * m15 + m0 * m11 * m13 + m8 * m1 * m15 - m8 * m3 * m13 - m12 * m1 * m11 + m12 * m3 * m9;
	I[@ 10] = m0 * m5 * m15 - m0 * m7 * m13 - m4 * m1 * m15 + m4 * m3 * m13 + m12 * m1 * m7 - m12 * m3 * m5;
	I[@ 11] = -m0 * m5 * m11 + m0 * m7 * m9 + m4 * m1 * m11 - m4 * m3 * m9 - m8 * m1 * m7 + m8 * m3 * m5;
	I[@ 12] = m12 * (m6 * m9  - m5 * m10) + m13 * (m4 * m10 - m8 * m6)  + m14 * (m8 * m5 - m4 * m9);
	I[@ 13] = m12 * (m1 * m10 - m2 * m9)  + m13 * (m8 * m2  - m0 * m10) + m14 * (m0 * m9 - m8 * m1);
	I[@ 14] = m12 * (m5 * m2  - m1 * m6)  + m13 * (m0 * m6  - m4 * m2)  + m14 * (m4 * m1 - m0 * m5);
	I[@ 15] = m0 * m5 * m10 - m0 * m6 * m9 - m4 * m1 * m10 + m4 * m2 * m9 + m8 * m1 * m6 - m8 * m2 * m5;
	var _det = m0 * I[0] + m1 * I[4] + m2 * I[8] + m3 * I[12];
	if (_det == 0)
	{
		show_debug_message("Error in function colmesh_matrix_invert: The determinant is zero.");
		return I;
	}
	_det = 1 / _det;
	for(var i = 0; i < 16; i++)
	{
		I[@ i] *= _det;
	}
	return I;
}

function colmesh_matrix_build(x, y, z, xrotation, yrotation, zrotation, xscale, yscale, zscale)
{
	/*
		This is an alternative to the regular matrix_build.
		The regular function will rotate first and then scale, which can result in weird shearing.
		I have no idea why they did it this way.
		This script does it properly so that no shearing is applied even if you both rotate and scale non-uniformly.
	*/
	var M = matrix_build(x, y, z, xrotation, yrotation, zrotation, 1, 1, 1);
	return colmesh_matrix_scale(M, xscale, yscale, zscale);
}

function colmesh_matrix_orthogonalize(M)
{
	/*
		This makes sure the three vectors of the given matrix are all unit length
		and perpendicular to each other, using the up direction as master.
		GameMaker does something similar when creating a lookat matrix. People often use [0, 0, 1]
		as the up direction, but this vector is not used directly for creating the view matrix; rather, 
		it's being used as reference, and the entire view matrix is being orthogonalized to the looking direction.
	*/
	var l = sqrt(dot_product_3d(M[8], M[9], M[10], M[8], M[9], M[10]));
	if (l != 0)
	{
		l = 1 / l;
		M[@ 8]  *= l;
		M[@ 9]  *= l;
		M[@ 10] *= l;
	}
	else
	{
		M[10] = 1;
	}
	
	M[@ 4] = M[9]  * M[2] - M[10] * M[1];
	M[@ 5] = M[10] * M[0] - M[8]  * M[2];
	M[@ 6] = M[8]  * M[1] - M[9]  * M[0];
	var l = sqrt(dot_product_3d(M[4], M[5], M[6], M[4], M[5], M[6]));
	if (l != 0)
	{
		l = 1 / l;
		M[@ 4] *= l;
		M[@ 5] *= l;
		M[@ 6] *= l;
	}
	else
	{
		M[5] = 1;
	}
	
	//The last vector is automatically normalized, since the two other vectors now are perpendicular unit vectors
	M[@ 0] = M[10] * M[5] - M[9]  * M[6];
	M[@ 1] = M[8]  * M[6] - M[10] * M[4];
	M[@ 2] = M[9]  * M[4] - M[8]  * M[5];
	
	return M;
}

function colmesh_matrix_orthogonalize_to(M)
{
	/*
		This makes sure the three vectors of the given matrix are all unit length
		and perpendicular to each other, using the up direction as master.
		GameMaker does something similar when creating a lookat matrix. People often use [0, 0, 1]
		as the up direction, but this vector is not used directly for creating the view matrix; rather, 
		it's being used as reference, and the entire view matrix is being orthogonalized to the looking direction.
	*/
	var l = sqrt(dot_product_3d(M[0], M[1], M[2], M[0], M[1], M[2]));
	if (l != 0)
	{
		l = 1 / l;
		M[@ 0]  *= l;
		M[@ 1]  *= l;
		M[@ 2] *= l;
	}
	else
	{
		M[0] = 1;
	}
	
	M[@ 4] = M[9]  * M[2] - M[10] * M[1];
	M[@ 5] = M[10] * M[0] - M[8]  * M[2];
	M[@ 6] = M[8]  * M[1] - M[9]  * M[0];
	var l = sqrt(dot_product_3d(M[4], M[5], M[6], M[4], M[5], M[6]));
	if (l != 0)
	{
		l = 1 / l;
		M[@ 4] *= l;
		M[@ 5] *= l;
		M[@ 6] *= l;
	}
	else
	{
		M[5] = 1;
	}
	
	//The last vector is automatically normalized, since the two other vectors now are perpendicular unit vectors
	M[@ 8]  = M[1] * M[6] - M[2] * M[5];
	M[@ 9]  = M[2] * M[4] - M[0] * M[6];
	M[@ 10] = M[0] * M[5] - M[1] * M[4];
	
	return M;
}

function colmesh_matrix_scale(M, toScale, siScale, upScale)
{
	/*
		Scaled the given matrix along its own axes
	*/
	M[@ 0] *= toScale;
	M[@ 1] *= toScale;
	M[@ 2] *= toScale;
	M[@ 4] *= siScale;
	M[@ 5] *= siScale;
	M[@ 6] *= siScale;
	M[@ 8] *= upScale;
	M[@ 9] *= upScale;
	M[@ 10]*= upScale;
	return M;
}

/// @func colmesh_matrix_build_from_vector(X, Y, Z, vx, vy, vz, toScale, siScale, upScale, targetM*)
function colmesh_matrix_build_from_vector(X, Y, Z, vx, vy, vz, toScale, siScale, upScale, targetM)
{
	/*
		Creates a matrix based on the vector (vx, vy, vz).
		The vector will be used as basis for the up-vector of the matrix, ie. indices 8, 9, 10.
	*/
	if (is_undefined(targetM))
	{
		var M = [abs(vx) < abs(vy), 1, 1, 0, 0, 0, 0, 0, vx, vy, vz, 0, X, Y, Z, 1];
	}
	else
	{
		var M = targetM;
		M[@ 0]  = abs(vx) < abs(vy);
		M[@ 1]  = 1;
		M[@ 2]  = 1;
		M[@ 3]  = 0;
		M[@ 4]  = 0;
		M[@ 5]  = 0;
		M[@ 6]  = 0;
		M[@ 7]  = 0;
		M[@ 8]  = vx;
		M[@ 9]  = vy;
		M[@ 10] = vz;
		M[@ 11] = 0;
		M[@ 12] = X;
		M[@ 13] = Y;
		M[@ 14] = Z;
		M[@ 15] = 1;
	}
	colmesh_matrix_orthogonalize(M);
	return colmesh_matrix_scale(M, toScale, siScale, upScale);
}

function colmesh_matrix_transform_vertex(M, x, y, z)
{
	/*
		Transforms a vertex using the given matrix
	*/
	static ret = array_create(3);
	ret[@ 0] = M[12] + dot_product_3d(x, y, z, M[0], M[4], M[8]);
	ret[@ 1] = M[13] + dot_product_3d(x, y, z, M[1], M[5], M[9]);
	ret[@ 2] = M[14] + dot_product_3d(x, y, z, M[2], M[6], M[10]);
	return ret;
}

function colmesh_matrix_transform_vector(M, x, y, z)
{
	/*
		Transforms a vector using the given matrix
	*/
	static ret = array_create(3);
	ret[@ 0] = dot_product_3d(x, y, z, M[0], M[4], M[8]);
	ret[@ 1] = dot_product_3d(x, y, z, M[1], M[5], M[9]);
	ret[@ 2] = dot_product_3d(x, y, z, M[2], M[6], M[10]);
	return ret;
}

function colmesh_cast_ray_sphere(sx, sy, sz, r, x1, y1, z1, x2, y2, z2) 
{	
	/*	
		Finds the intersection between a line segment going from [x1, y1, z1] to [x2, y2, z2], and a sphere centered at (sx,sy,sz) with radius r.
		Returns false if the ray hits the sphere but the line segment is too short,
		returns true if the ray misses completely, 
		returns an array of the following format if there was and intersection between the line segment and the sphere:
			[x, y, z]
	*/
	var dx = sx - x1;
	var dy = sy - y1;
	var dz = sz - z1;

	var vx = x2 - x1;
	var vy = y2 - y1;
	var vz = z2 - z1;

	//dp is now the distance from the starting point to the plane perpendicular to the ray direction, times the length of dV
	var v = dot_product_3d(vx, vy, vz, vx, vy, vz);
	var d = dot_product_3d(dx, dy, dz, dx, dy, dz);
	var t = dot_product_3d(vx, vy, vz, dx, dy, dz);

	//u is the remaining distance from this plane to the surface of the sphere, times the length of dV
	var u = t * t + v * (r * r - d);

	//If u is less than 0, there is no intersection
	if (u < 0 || is_nan(u))
	{
		return true;
	}
	
	u = sqrt(max(u, 0));
	if (t < u)
	{
		//Project to the inside of the sphere
		t += u; 
		if (t < 0)
		{
			//The sphere is behind the ray
			return true;
		}
	}
	else
	{
		//Project to the outside of the sphere
		t -= u;
		if (t > v)
		{
			//The sphere is too far away
			return false;
		}
	}

	//Find the point of intersection
	t /= v;
	static ret = array_create(3);
	ret[0] = x1 + vx * t;
	ret[1] = y1 + vy * t;
	ret[2] = z1 + vz * t;
	return ret;
}

function colmesh_cast_ray_plane(px, py, pz, nx, ny, nz, x1, y1, z1, x2, y2, z2) 
{
	/*
		Finds the intersection between a line segment going from [x1, y1, z1] to [x2, y2, z2], and a plane at (px, py, pz) with normal (nx, ny, nz).

		Returns the intersection as an array of the following format:
		[x, y, z, nx, ny, nz, intersection (true or false)]

		Script made by TheSnidr

		www.thesnidr.com
	*/
	var vx = x2 - x1;
	var vy = y2 - y1;
	var vz = z2 - z1;
	var dn = dot_product_3d(vx, vy, vz, nx, ny, nz);
	if (dn == 0)
	{
		return [x2, y2, z2, 0, 0, 0, false];
	}
	var dp = dot_product_3d(x1 - px, y1 - py, z1 - pz, nx, ny, nz);
	var t = - dp / dn; 
	var s = sign(dp);
	
	static ret = array_create(6);
	ret[0] = x1 + t * vx;
	ret[1] = y1 + t * vy;
	ret[2] = z1 + t * vz;
	ret[3] = s * nx;
	ret[4] = s * ny;
	ret[5] = s * nz;
	ret[6]= true;
	return ret;
}