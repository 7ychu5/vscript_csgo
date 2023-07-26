function CreateText() {
    local text = Entities.CreateByClassname("game_text");
	text.__KeyValueFromString("message","game_text");
	text.__KeyValueFromString("color","255 255 255");
	text.__KeyValueFromString("color2","255 255 255");
	text.__KeyValueFromString("effect","2");
	text.__KeyValueFromString("x","0");
	text.__KeyValueFromString("y","0.41");
	text.__KeyValueFromString("channel","5");
	text.__KeyValueFromString("spawnflags","0");
	text.__KeyValueFromString("holdtime","5");
	text.__KeyValueFromString("fadein","0");
	text.__KeyValueFromString("fadeout","0");
	text.__KeyValueFromString("fxtime","0");
	return text;
}
function GetDistance(vector1, vector2)
{
	local z1 = vector1.z;
	local z2 = vector2.z;
	return sqrt((vector1.x-vector2.x)*(vector1.x-vector2.x) +
				(vector1.y-vector2.y)*(vector1.y-vector2.y) +
				(z1-z2)*(z1-z2));
}

function GetDistanceXY(vector1, vector2)
{
	return sqrt((vector1.x-vector2.x)*(vector1.x-vector2.x) +
				(vector1.y-vector2.y)*(vector1.y-vector2.y));
}
