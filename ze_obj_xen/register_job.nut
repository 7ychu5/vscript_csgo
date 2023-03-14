SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "ze_obj_xen";
SCRIPT_TIME <- "2023年1月10日12:27:48";

IncludeScript("vs_library");
IncludeScript("glow");

MAPPER_NetID <- [
    "STEAM_1:0:92422507",//7ychu5
];

self.PrecacheScriptSound("exghit/kill.wav");
MAPPER_skin <- "models/player/custom_player/legacy/ctm_heavy.mdl";self.PrecacheModel(MAPPER_skin);
self.PrecacheModel("models/weapons/zombieden/w_flashbang_missile.mdl");

::PLAYERS<-[];
class ::PlayerInfo
{
	name = null;
	userid = null;
	networkid = null;
    handle = null;
	constructor(p_name,p_userid,p_networkid)
	{
        name = p_name;
		userid = p_userid;
		networkid = p_networkid;
	}

	hurt = 0;
	function hurt_add(hurt) {this.hurt += hurt;}
	function check_hurt() {return this.hurt;}
	job = 0;//0=无职业 1=工兵 2=突击兵 3=支援兵
	function check_job(){return this.job;}
	function clear_job(){this.job = 0;}
	function set_job1(){this.job = 1;}
	function set_job2(){this.job = 2;}
	function set_job3(){this.job = 3;}
}

env_instructor_hint <- Entities.CreateByClassname("env_instructor_hint");
env_instructor_hint.__KeyValueFromString("hint_target", "btn_job_supply");
env_instructor_hint.__KeyValueFromString("hint_static", "0");
env_instructor_hint.__KeyValueFromString("hint_caption", "获取补给升级装备！");
env_instructor_hint.__KeyValueFromString("hint_color", "255 255 0");
env_instructor_hint.__KeyValueFromString("hint_nooffscreen", "0");
env_instructor_hint.__KeyValueFromString("hint_icon_onscreen", "icon_tip");

first_time <- true;
function map_start() {
	//::PLAYERS.clear();
	if(first_time == true)
	{
		foreach(p in VS.GetAllPlayers())
		{
			local userid = p.GetScriptScope().userid;
			local name = p.GetScriptScope().name;
			local networkid = p.GetScriptScope().networkid;

			local pp = ::PlayerInfo(name,userid,networkid);
			::PLAYERS.push(pp);
			mapper_info(userid);
			if(p.GetTeam()==2)
			{
				p.SetHealth(3000);
			}
		}
		first_time = false;
	}
	else check_players_array();
}

function check_players_array() {
	local Temp_Player_Arr = [];
	for(local i = 0; i < ::PLAYERS.len(); i++)
	{
		if(VS.GetPlayerByUserid(::PLAYERS[i].userid) != null && VS.GetPlayerByUserid(PLAYERS[i].userid).IsValid())
		{
			Temp_Player_Arr.push(::PLAYERS[i]);
		}
	}
	::PLAYERS.clear();
	for(local a = 0; a < Temp_Player_Arr.len(); a++)
	{
		::PLAYERS.push(Temp_Player_Arr[a]);
	}
}

function mapper_info(userid) {
	local handle = VS.GetPlayerByUserid(userid);
	local scope = handle.GetScriptScope();
	local name = scope.name;
	local networkid = scope.networkid;
	for(local a = 0; a < MAPPER_NetID.len(); a++)
	{
		if(networkid.tostring() == MAPPER_NetID[a].tostring())
		{
			Chat(TextColor.Uncommon+"[MAP] "+ TextColor.Location + " 您好！我是 "+TextColor.Immortal + name + TextColor.Location +"！希望您游玩愉快！\n ");
			handle.SetModel(MAPPER_skin);
			hint_job();
		}
		break;
	}
	//ScriptPrintMessageCenterAll("<html><img src=\"https://steamuserimages-a.akamaihd.net/ugc/2001321225474498283/2FB6FA65DC8ED3A6224DF943A18F64326C88D1E2/\"/></html>\n");
}

function hint_job() {
	EntFireByHandle(env_instructor_hint, "ShowHint", " ", 0.0, null, null);
	local ent;
    while((ent = Entities.FindByClassname(ent, "prop_dynamic") ) != null)
    {
		//weapons/zombieden/v_spitfire.mdl
        if(ent.GetModelName().find("weapons/zombieden/v_spitfire.mdl", 0) != null)
        {
            Glow.Set( ent, Vector(255, 255, 255), 0, 2048 );
        }
    }
}

function player_set_job2() {
	//local handle = VS.GetPlayerByUserid(activator.GetScriptScope().userid);
	foreach(p in ::PLAYERS)
	{
		if(p.userid == activator.GetScriptScope().userid)
		{
			p.set_job2();
			local text = CreateText();
			EntFireByHandle(text, "SetText", "您好，支援兵！", 0.0, activator, null);
			EntFireByHandle(text, "Display", "", 0.01, activator, null);
			EntFireByHandle(text, "kill", "", 0.02, activator, null);
		}
	}
}

::CreateText <- function()
{
	local text = Entities.CreateByClassname("game_text");
	text.__KeyValueFromString("message","game_text");
	text.__KeyValueFromString("color","255 255 255");
	text.__KeyValueFromString("color2","255 255 255");
	text.__KeyValueFromString("effect","2");
	text.__KeyValueFromString("x","-1");
	text.__KeyValueFromString("y","0.7");
	text.__KeyValueFromString("channel","5");
	text.__KeyValueFromString("spawnflags","1");
	text.__KeyValueFromString("holdtime","0.1");
	text.__KeyValueFromString("fadein","0.01");
	text.__KeyValueFromString("fadeout","0.01");
	text.__KeyValueFromString("fxtime","0");
	return text;
}


VS.ListenToGameEvent( "player_connect", function( event )
{
	local userid = event.userid;
    local name = event.name;
	local networkid = event.networkid;
    local p = ::PlayerInfo(name,userid,networkid);
	::PLAYERS.push(p);
},"");

VS.ListenToGameEvent( "bullet_impact", function( event )
{
	local player = VS.GetPlayerByUserid( event.userid );
	foreach(p in ::PLAYERS)
	{
		if(p.userid == player.GetScriptScope().userid)
		{
			if(p.job==2)
			{
				local position = Vector( event.x, event.y, event.z );
				//DispatchParticleEffect("weapon_shell_casing_minigun_fallback", position, Vector(0,0,0));
				DebugDrawLine( player.EyePosition(), position, 255, 0, 0, false, 2.0 );
				DebugDrawBox( position, Vector(-2,-2,-2), Vector(2,2,2), 255, 0, 255, 127, 2.0 );
			}
		}
	}
}, "DrawImpact" );

VS.ListenToGameEvent( "weapon_fire", function( event )
{
	printl(event.weapon);
	if(event.weapon == "weapon_usp_silencer")
	{
		local maker = Entities.CreateByClassname("env_entity_maker");
		maker.__KeyValueFromString("EntityTemplate","kill_particle_template");
		local player = ToExtendedPlayer( VS.GetPlayerByUserid(event.userid) );
		local eyePos = player.EyePosition();
		local viewForward = player.EyeForward();
		local pos = eyePos+(viewForward*500);

		maker.SpawnEntityAtLocation(pos, Vector(0, 0, 0));
		local particle = Entities.FindByNameNearest("kill_particle", pos, 1);
		EntFireByHandle(particle, "start", "", 0.01, null, null);
		EntFireByHandle(particle, "kill", "", 0.02, null, null);
		EntFireByHandle(maker, "kill", "", 0.01, null, null);
		printl("1");
	}

}, "" );

VS.ListenToGameEvent( "player_death", function( event )
{
	local player = ToExtendedPlayer( VS.GetPlayerByUserid(event.userid) );
	local maker = Entities.CreateByClassname("env_entity_maker");
	maker.__KeyValueFromString("EntityTemplate","kill_particle_template");
	maker.SpawnEntityAtLocation(Vector(player.GetOrigin().x, player.GetOrigin().y, player.GetOrigin().z+80), Vector(0, 0, 0));
	local particle = Entities.FindByNameNearest("kill_particle", Vector(player.GetOrigin().x, player.GetOrigin().y, player.GetOrigin().z+80), 1);
	EntFireByHandle(particle, "start", "", 0.01, null, null);
	EntFireByHandle(particle, "kill", "", 0.2, null, null);
	EntFireByHandle(maker, "kill", "", 0.01, null, null);
	DispatchParticleEffect("firework_crate_explosion_01", player.GetOrigin(), Vector(0,0,0));
}, "" );

VS.ListenToGameEvent( "player_hurt", function( event )
{
	local player = ToExtendedPlayer( VS.GetPlayerByUserid(event.attacker) );
	foreach(p in ::PLAYERS)
	{
		if(p.userid == player.GetScriptScope().userid)
		{
			p.hurt_add(event.dmg_health);
			if(p.check_hurt()>=500)
			{
				local eyePos = player.EyePosition();
				local viewForward = player.EyeForward();
				local weapon = event.weapon;
				local ent;
				while((ent = Entities.FindByClassname(ent, "*") ) != null)
				{
					if(ent.GetClassname() == "prop_dynamic")
					{

						if(ent.GetModelName().find("negev", 0) != null)
						{
							local maker = Entities.CreateByClassname("env_entity_maker");
							maker.__KeyValueFromString("EntityTemplate","kill_particle_template");
							local pos = eyePos+(viewForward*50);

							maker.SpawnEntityAtLocation(pos, Vector(0, 0, 0));
							local particle = Entities.FindByNameNearest("kill_particle", pos, 1);
							particle.EmitSound("exghit/kill.wav");
							EntFireByHandle(particle, "start", "", 0.01, null, null);
							EntFireByHandle(particle, "kill", "", 0.02, null, null);
							EntFireByHandle(maker, "kill", "", 0.01, null, null);
						}
					}
				}
				local text = ::CreateText();
				EntFireByHandle(text, "SetText", "500 Dmg", 0.0, null, null);
				EntFireByHandle(text, "Display", "", 0.01, player, null);
				EntFireByHandle(text, "kill", "", 0.02, player, null);
				p.hurt-=500;
			}
		}
	}

}, "" );

function add() {
	for (local ent; ent = Entities.FindByClassname(ent, "weapon_*");)
	{
		if(ent.GetMoveParent()==activator)EntFireByHandle(ent,"SetAmmoAmount","200",0.00,null,null);
	}
}


// Default: \x01
// Dark Red: \x02
// Purple: \x03
// Green: \x04
// Light Green: \x05
// Lime Green: \x06
// Red: \x07
// Grey: \x08
// Orange: \x09
// Brownish Orange: \x10
// Gray: \x08
// Very faded blue: \x0A
// Faded blue: \x0B
// Dark blue: \x0C