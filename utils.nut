SCRIPT_OWNER <- "7ychu5";
SCRIPT_TIME <- "2023年7月10日13点53分";
SCRIPT_MAP <- "GLOBAL";
SCRIPT_VERISON <- "0.1";

speedmod <- null;
    if(Entities.FindByName(null, "speedmod") == null)
        {
            speedmod <- Entities.CreateByClassname("player_speedmod");
            speedmod.__KeyValueFromString("targetname", "speedmod");
            speedmod.__KeyValueFromInt("spawnflags", 0);
        }
    else speedmod <- Entities.FindByName(null, "speedmod");

maker <- null;
    if(Entities.FindByName(null, "maker") == null)
        {
            maker <- Entities.CreateByClassname("env_entity_maker");
            maker.__KeyValueFromString("targetname", "maker");
            maker.__KeyValueFromString("EntityTemplate", "");
            maker.__KeyValueFromInt("spawnflags", 0);
        }
    else maker <- Entities.FindByName(null, "maker");

stripper <- null;
    if(Entities.FindByName(null, "stripper") == null)
        {
            stripper <- Entities.CreateByClassname("player_weaponstrip");
            stripper.__KeyValueFromString("targetname", "stripper");
            stripper.__KeyValueFromInt("spawnflags", 0);
        }
    else stripper <- Entities.FindByName(null, "stripper");

equiper <- null;
    if(Entities.FindByName(null, "equiper") == null)
        {
            equiper <- Entities.CreateByClassname("game_player_equip");
            equiper.__KeyValueFromInt("spawnflags", 5);
            equiper.__KeyValueFromString("targetname", "equiper");
        }
    else equiper <- Entities.FindByName(null, "equiper");

hurter <- null;
    if(Entities.FindByName(null, "hurter") == null)
        {
            hurter <- Entities.CreateByClassname("point_hurt");
            hurter.__KeyValueFromString("targetname", "hurter");
        }
    else hurter <- Entities.FindByName(null, "hurter");

fader <- null;
    if(Entities.FindByName(null, "fader") == null)
        {
            fader <- Entities.CreateByClassname("env_fade");
            fader.__KeyValueFromString("targetname", "fader");
        }
    else fader <- Entities.FindByName(null, "fader");

::DEBUG <- function (info) {
    printl("////////////DEBUG////////////");
    printl(info);
    printl("/////////////////////////////");
}



::GetDistance <- function(vector1, vector2)
{
    local z1 = vector1.z;
    local z2 = vector2.z;
    return sqrt((vector1.x-vector2.x)*(vector1.x-vector2.x) +
                (vector1.y-vector2.y)*(vector1.y-vector2.y) +
                (z1-z2)*(z1-z2));
}

::isCrouch <- function(ply){
    local height = ply.EyePosition().z - ply.GetOrigin().z;
    if(height < 64) return true;
    else return false;
}

::isGrounded <- function(ply){return zSquareCheck(ply,-15)}
::zSquareCheck <- function(ply,dist)
{
	local offsets =
	[
		Vector(0,0,0),
		Vector(0,16,0),
		Vector(0,-16,0),

		Vector(-16,0,0),
		Vector(-16,16,0),
		Vector(-16,-16,0),

		Vector(16,0,0),
		Vector(16,16,0),
		Vector(16,-16,0),
	]

	foreach(o in offsets)
		if(TraceLinePlayersIncluded(ply.GetOrigin()+o, ply.GetOrigin()+o + Vector(0,0,dist), ply) < 1)
			return true
	return false
}

function GetDistanceXY(vector1, vector2)
{
    return sqrt((vector1.x-vector2.x)*(vector1.x-vector2.x) +
                (vector1.y-vector2.y)*(vector1.y-vector2.y));
}

function GetTargetPitch(v1, v2){
    local m_targetVector = v1;
    local m_sentryOrigin = v2;
    local m_dir = m_targetVector - m_sentryOrigin;

    local UCSX = sqrt(pow(m_dir.x,2)+pow(m_dir.y,2));
    local pitch = asin(m_dir.z / sqrt( pow(UCSX,2) + pow(m_dir.z,2) )) * 180 / PI * -1;
    local yaw = asin(m_dir.y / sqrt( pow(m_dir.x,2) + pow(m_dir.y,2) )) * 180 / PI;

    if(m_dir.x < 0)
        yaw = 180 - yaw;

    return pitch;
}

function GetTargetYaw(v1, v2){
    local m_targetVector = v1;
    local m_sentryOrigin = v2;
    local m_dir = m_targetVector - m_sentryOrigin;

    local UCSX = sqrt(pow(m_dir.x,2)+pow(m_dir.y,2));
    local pitch = asin(m_dir.z / sqrt( pow(UCSX,2) + pow(m_dir.z,2) )) * 180 / PI * -1;
    local yaw = asin(m_dir.y / sqrt( pow(m_dir.x,2) + pow(m_dir.y,2) )) * 180 / PI;

    if(m_dir.x < 0)
        yaw = 180 - yaw;

    return yaw;
}

function luff_GetTargetYaw(start,target)
{
	local yaw = 0.00;
	local v = Vector(start.x-target.x,start.y-target.y,start.z-target.z);
	local vl = sqrt(v.x*v.x+v.y*v.y);
	yaw = 180*acos(v.x/vl)/3.14159;
	if(v.y<0)
		yaw=-yaw;
	return yaw;
}

function GVO(vec,_x,_y,_z) {
    return Vector(vec.x+_x,vec.y+_y,vec.z+_z);
}


::CreateText <- function() {
    local text = Entities.CreateByClassname("game_text");
    text.__KeyValueFromString("effect", "0");
    text.__KeyValueFromString("fadein", "0");
    text.__KeyValueFromString("fadeout", "0");
    text.__KeyValueFromString("holdtime", "1");
    text.__KeyValueFromString("x", "-1");
    text.__KeyValueFromString("y", "-1");
    text.__KeyValueFromString("color", "0 255 255");
    text.__KeyValueFromString("channel", "0");
    text.__KeyValueFromString("spawnflags", "1");
    return text;
}

::CreateHudhint <- function() {
    local hudhint = Entities.CreateByClassname("Env_hudhint");
    //hudhint.__KeyValueFromString("spawnflags", "0");
    return hudhint;
}

function CreateHint() {
    local hint = Entities.CreateByClassname("Env_instructor_hint");
    hint.__KeyValueFromString("hint_static", "0");
    hint.__KeyValueFromString("hint_color", "113 145 64");
    hint.__KeyValueFromString("hint_nooffscreen", "0");
    hint.__KeyValueFromString("hint_icon_onscreen", "icon_tip");
    hint.__KeyValueFromString("hint_timeout", "5");
    hint.__KeyValueFromString("hint_forcecaption", "1");
    return hint;
}