PLAYERS<-[];
eventinfo<-[];
eventlist<-[];
eventproxy<-[];
//handle  = null;//-----> player handle 	(is null OR .IsValid()==false when disconnected)
class PlayerInfo
{
    name = null;
	userid = null;
	steamid = null;
    handle = null;
	constructor(p_name,p_userid,p_steamid)
	{
        name = p_name;
		userid = p_userid;
		steamid = p_steamid;
	}
}

/*events_ids_translate[EVENT_PLAYER_CONNECT] <- ["player_connect",["name","index","userid","networkid","address"]];
events_ids_translate[EVENT_PLAYER_INFO] <- ["player_info",["name","index","userid","networkid","bot"]];
events_ids_translate[EVENT_PLAYER_DISCONNECT] <- ["player_disconnect",["userid","reason","name","networkid"]];*/

function Precache()
{
    eventinfo = Entities.FindByName(null, "eventlistener_playerinfo");
	eventlist = Entities.FindByName(null, "eventlistener_playerconnect");
    eventproxy = Entities.FindByClassname(null, "info_game_event_proxy");
}

function PlayerConnect()
{
    local name = eventlist.GetScriptScope().event_data.name;
	local userid = eventlist.GetScriptScope().event_data.userid;
	local steamid = eventlist.GetScriptScope().event_data.networkid;
    if(steamid != null || steamid != "BOT")
    {
		local p = PlayerInfo(name,userid,steamid);
        PLAYERS.push(p);
    }
}

function ClearConnects()
{
    if(PLAYERS.len() > 0)
    {
        PLAYERS.clear();
    }
}

function EventInfo()
{
	local userid = eventinfo.GetScriptScope().event_data.userid;
	if(PLAYERS.len() > 0)
	{
		for(local i=0; i < PLAYERS.len(); i++)
		{
			if(PLAYERS[i].userid == userid)
			{
				PLAYERS[i].handle = TEMP_HANDLE;
				return;
			}
		}
	}
}

function Reg_Player()
{
	act <- activator;
	EntFireByHandle(eventproxy,"GenerateGameEvent","",0.00,act,null);
}

function GetPlayerClassByUserID(userid) {
    foreach(p in PLAYERS){
        if(p.userid==userid)return p;
    }
    return null;
}
function GetPlayerClassBySteamID(steamid) {
    foreach(p in PLAYERS){
        if(p.steamid==steamid)return p;
    }
    return null;
}
function GetPlayerClassByHandle(player) {
    foreach(p in PLAYERS)
    {
        if(p.handle==player)return p;
    }
    return null;
}
