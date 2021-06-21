/// @description Destroy Event Handler

for (var key = ds_map_find_first(global.events), isLevelEvent = false; !is_undefined(key); key = ds_map_find_next(global.events, key)) if (eventList = global.events[? key])
{
    isLevelEvent = true;
    break
}
if !(isLevelEvent) ds_list_destroy(eventList);
ds_list_destroy(currentActions);
show_debug_message("Event handler " + string(id) + " ended");