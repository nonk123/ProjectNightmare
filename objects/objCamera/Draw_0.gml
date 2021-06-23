/// @description Render Game

//Level
var roomData = global.levelData[? global.levelRoom];
if !(is_undefined(roomData))
{
	var roomModel = roomData[eRoomData.model];
	if !(is_undefined(roomModel))
	{
		var i = 0;
		repeat (array_length(roomModel) * 0.5)
		{
			vertex_submit(roomModel[i], pr_trianglelist, pn_material_get_texture(roomModel[i + 1]));
			i += 2;
		}
	}
}

//Actors farthest to nearest (fixes alpha blending issues)
with (objActor) if (fVisible) ds_priority_add(other.renderPriority, self, point_distance_3d(other.x, other.y, other.z, x, y, z));

repeat (ds_priority_size(renderPriority))
{
	ds_priority_find_max(renderPriority).draw();
	ds_priority_delete_max(renderPriority);
}