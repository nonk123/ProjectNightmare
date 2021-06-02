/// @description string_parse(string)
/// @param string
function string_parse(_string)
{
	//  Returns an array containing all substring elements within a given string which are separated by "|".
	//
	//  eg. string_parse("cat|dog|house|bee")
	//      returns a ds_list { "cat", "dog", "house", "bee" }
	//
    //      str         elements, string
	//
    /// GMLscripts.com/license
	var str = _string, array = [], temp;
    while (string_length(str) != 0)
	{
		temp = string_pos("|", str);
        if (temp)
		{
			if (temp != 1) array[@ array_length(array)] = string_copy(str, 1, temp - 1);
			str = string_copy(str, temp + 1, string_length(str));
        }
		else
		{
			array[@ array_length(array)] = str;
            str = "";
        }
    }
    return (array)
}