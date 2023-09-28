IncludeScript("vs_library.nut");

::bell_normal <- "training/bell_normal.wav"
::bell_impact <- "training/bell_impact.wav"

self.PrecacheScriptSound(::bell_normal);
self.PrecacheScriptSound(::bell_impact);

initialization_command <- [
    "mp_humanteam CT",
    "jointeam 3",
    "bot_join_team T",
    "mp_respawn_immunitytime 0",
    "sv_airaccelerate 300",
    "sv_gravity 800",
	"sv_accelerate 5.5",
	"sv_friction 5.2",
	"mp_autoteambalance 0",
	"mp_limitteams 0",
    "mp_roundtime 60",
    "mp_warmup_end",
    "mp_respawn_on_death_ct 1",
    "mp_respawn_on_death_t 0",
    "bot_dont_shoot 0",
    "bot_zombie 0",
    "bot_stop 0",
    "bot_freeze 0",
    "bot_ignore_enemies 0",
    "bot_ignore_players 0",
    "bot_mimic 0",
    "mp_ignore_round_win_conditions 0",
    "mp_freezetime 1"
]

::weapon_list <- [
	"weapon_ak47"
	// "weapon_aug"
	// "weapon_awp"
	"weapon_bizon"
	"weapon_cz75a"
	"weapon_deagle"
	"weapon_elite"
	"weapon_famas"
	"weapon_fiveseven"
	"weapon_g3sg1"
	"weapon_galilar"
	"weapon_glock"
	"weapon_hkp2000"
	// "weapon_m249"
	"weapon_m4a1"
	"weapon_m4a1_silencer"
	"weapon_mac10"
	// "weapon_mag7"
	"weapon_mp5sd"
	"weapon_mp7"
	"weapon_mp9"
	// "weapon_negev"
	// "weapon_nova"
	"weapon_p250"
	"weapon_p90"
	"weapon_revolver"
	// "weapon_sawedoff"
	// "weapon_scar20"
	// "weapon_sg556"
	// "weapon_ssg08"
	"weapon_tec9"
	"weapon_ump45"
	"weapon_usp_silencer"
	// "weapon_xm1014"
]

::knife_list <- [
	"weapon_knife"
	"weapon_knife_butterfly"
	"weapon_knife_falchion"
	"weapon_knife_flip"
	"weapon_knife_gut"
	"weapon_knife_gypsy_jackknife"
	"weapon_knife_karambit"
	"weapon_knife_m9_bayonet"
	"weapon_knife_push"
	"weapon_knife_stiletto"
	"weapon_knife_survival_bowie"
	"weapon_knife_t"
	"weapon_knife_tactical"
	"weapon_knife_ursus"
	"weapon_knife_widowmaker"
	"weapon_knifegg"
]

::aim_oneway_origin <- [
    Vector(4148, 3751, 720),//三楼
    Vector(3577, 3767, 516),//包点深处铁箱上
    Vector(3829, 3553, 448),//包点右柱后
    Vector(3661, 3553, 448),//包点左柱后
    Vector(3461, 3312, 466),//白房门口
    Vector(3434, 3032, 592),//白房上
    Vector(3563, 3055, 432),//白房铁箱后
    Vector(4038, 3296, 720),//三楼右
    Vector(3362, 3217, 720),//三楼左
    Vector(3981, 2781, 432),//A门右
    Vector(3392, 2816, 432),//A门左
]

::shuffle_temp_array <-
[
    -1,-1,-1,-1,-1,//五个数，保证不重样。
]

::PLAYER <- Entities.FindByClassname(null, "player");
EntFireByHandle(PLAYER, "AddOutput", "targetname user", 0.0, null, null);

SendToConsole("con_logfile \"\";");

::MODE_TYPE <- 1; // 0 = numm ; 1 = warmup ; 2 = track ; 3 = aim ; 4 = spary ; 5 = flick ; 6 = perceive; 7 = aim_ball ； 8 = zombie ; 9 = warmup_2
::CURR_MODE_TYPE <- 0;
::CURR_ARMOR <- 0; // 0 no armor, 1 kevlar, 2 vest helm
::IS_BOT_STOP <- false;

::PLAYER_PRIMARY <- "weapon_ak47";
::PLAYER_SECONDARY <- "weapon_glock";
::SET_INFINITE_AMMO <- false;

function initialize() {
    // for(local j=0;j<=initialization_command.len()-1;j++)
    // {
    //     SendToConsoleServer(initialization_command[j]);
    // }
    // EntFire("panel_startup", "setdisplaytext",
    // "跟枪                          KPM计算                  弹道修正                  甩狙                          听声辨位                    AimBall                          "
    // , 0.0, null);
}

::ToggleAmmo <- function(){
	if (::SET_INFINITE_AMMO != true){
		::SET_INFINITE_AMMO <- true;
		ScriptPrintMessageChatAll(" Infinite Ammo:\x04 ENABLED");
		SendToConsole("sv_infinite_ammo 1");
	}
	else if (::SET_INFINITE_AMMO != false){
		::SET_INFINITE_AMMO <- false;
		ScriptPrintMessageChatAll(" Infinite Ammo:\x02 DISABLED");
		SendToConsole("sv_infinite_ammo 2");
	}
}

::GiveWeapon<-function(weapon){
    weapon = weapon.slice(4);
	local weapon_equip = Entities.CreateByClassname("game_player_equip");
	weapon_equip.__KeyValueFromInt(weapon, 1);
	weapon_equip.__KeyValueFromInt("spawnflags", 5);
	EntFireByHandle(weapon_equip, "Use", "", 0.0, activator, caller);
	weapon_equip.Destroy();
    EntFire("logic_script", "RunScriptcode", "SupplyAmmo(activator)", 0.01, activator);
}

SupplyAmmo <- function (user) {
    for (local ent; ent = Entities.FindByClassname(ent, "weapon_*");) {
        if(ent.GetClassname() != "weapon_axe" &&
        ent.GetClassname() != "weapon_knife" &&
        ent.GetClassname() != "weapon_breachcharge" &&
        ent.GetClassname() != "weapon_c4" &&
        ent.GetClassname() != "weapon_decoy" &&
        ent.GetClassname() != "weapon_diversion" &&
        ent.GetClassname() != "weapon_flashbang" &&
        ent.GetClassname() != "weapon_healthshot" &&
        ent.GetClassname() != "weapon_hegrenade" &&
        ent.GetClassname() != "weapon_incgrenade" &&
        ent.GetClassname() != "weapon_hammer" &&
        ent.GetClassname() != "weapon_knifegg" &&
        ent.GetClassname() != "weapon_molotov" &&
        ent.GetClassname() != "weapon_smokegrenade" &&
        ent.GetClassname() != "weapon_snowball" &&
        ent.GetClassname() != "weapon_spanner" &&
        ent.GetClassname() != "weapon_tagrenade" &&
        ent.GetClassname() != "weapon_taser" &&
        ent.GetClassname() != "weapon_bumpmine"){
            if(ent.GetMoveParent()==user)
            {
                EntFireByHandle(ent,"SetReserveAmmoAmount","300",0.02,null,null);
            }
        }
    }
}

VS.ListenToGameEvent( "player_hurt", function( event )
{
    SendToConsole("r_cleardecals");
}, "listen_local_hurt" );

VS.ListenToGameEvent( "player_death", function( event )
{
    EntFire("cs_ragdoll", "kill", "", 0.01, null);
    if(event.attacker == event.userid || event.attacker == null) VS.GetPlayerByUserid(event.userid).EmitSound(::bell_impact);
    else VS.GetPlayerByUserid(event.userid).EmitSound(::bell_normal);
	if(VS.GetPlayerByUserid(event.userid).GetTeam() != 3) return;
	for (local ent; ent = Entities.FindByClassname(ent, "game_ui"); )
	{
		EntFireByHandle(ent, "Deactivate", "", 0.0, VS.GetPlayerByUserid(event.userid), null);
		EntFireByHandle(ent, "kill", "", 0.01, null, null);
	}
}, "listen_local_death" );

VS.ListenToGameEvent( "player_spawn", function( event )
{
    local player = VS.GetPlayerByUserid(event.userid);
	if(event.teamnum == 3)
	{
        // ::MODE_TYPE <- 1;
		// local weapon_equip = Entities.CreateByClassname("game_player_equip");
		// weapon_equip.__KeyValueFromInt("spawnflags", 5);
		// weapon_equip.__KeyValueFromInt("weapon_tablet", 1);
		// EntFireByHandle(weapon_equip, "Use", "", 0, player, null);
		// weapon_equip.Destroy();
	}

	if(event.teamnum == 2)
	{
		::ChangeModel(player);
        EntFireByHandle(player, "AddOutput", "targetname bot", 0.0, null, null);
		::GiveKevlar(VS.GetPlayerByUserid(event.userid))
		::GiveRandWeapon(VS.GetPlayerByUserid(event.userid));
		//if(::MODE_TYPE == 2 || ::MODE_TYPE == 4) EntFireByHandle(player, "SetHealth", "9999", 0.0, null, null);
	}
	if(::IS_BOT_STOP)
	{
		::StopBot();
	}
	if(::MODE_TYPE == 3) ::GiveKevlar(player);
    if(::MODE_TYPE == 9){
        local random_num = RandomInt(0, ::aim_oneway_origin.len()-1-5);

        local origin = ::aim_oneway_origin[random_num];

        player.SetAngles(0,270,0);
        player.SetOrigin(origin);

        local temp = ::aim_oneway_origin[random_num];
        ::aim_oneway_origin.remove(random_num);
        ::aim_oneway_origin.push(temp);
    }
}, "" );

::GiveRandWeapon <- function (ent) {
	local weapon_equip = Entities.CreateByClassname("game_player_equip");
	weapon_equip.__KeyValueFromInt("spawnflags", 5);
    local weapon = "";
    if(::MODE_TYPE == 8)weapon = "weapon_knife";
    else weapon = weapon_list[RandomInt(0, weapon_list.len()-1)];
	weapon_equip.__KeyValueFromInt(weapon, 1);
	EntFireByHandle(weapon_equip, "Use", "", 0, ent, null);
	weapon_equip.Destroy();
}

function warmup_oneway_state_change(){
    if(::MODE_TYPE == 9)
    {
        EntFire("warmup_oneway_brush_status", "Color", "255 0 0", 0.0, null);
        ::MODE_TYPE <- 0;
        ::SpawnBot();
    }
    else
    {
        EntFire("warmup_oneway_brush_status", "Color", "0 255 0", 0.0, null);
        ::MODE_TYPE <- 9;
        ::SpawnBot();
    }
}

//////////////////////////////////
//////////////BOT/////////////////
//////////////////////////////////

::SET_DIST_NEAR_ENABLED <- true;
::SET_DIST_MID_ENABLED <- true;
::SET_DIST_FAR_ENABLED <- true;

::SpawnBot<-function() {
    for (local ent; ent = Entities.FindByClassname(ent, "info_player_terrorist"); )
    {
        EntFireByHandle(ent, "SetDisabled", "", 0.00, null, null);
    }
    ::UpdateBotAI();
    switch (::MODE_TYPE) {
        case 0:
            ::BOTStoSpec();
            break;
        case 1:
            ::BOTStoSpec();
            EntFire("logic_script", "RunScriptcode", "BOTStoT(10)", 0.01, null);
            ::UpdateSpawn();
            break;
        case 2:
            ::BOTStoSpec();
            EntFire("bot_spawn_track_1", "SetEnabled", "", 0.01, null);
            EntFire("logic_script", "RunScriptcode", "BOTStoT(1)", 0.01, null);
            EntFire("bot", "SetHealth", "-1", 0.02, null);
            break;
        case 3:
            ::BOTStoSpec();
            EntFire("logic_script", "RunScriptcode", "BOTStoT(10)", 0.01, null);
            EntFire("bot", "SetHealth", "-1", 0.02, null);
            ::UpdateSpawn();
            break;
        case 4:
            ::BOTStoSpec();
            EntFire("bot_spawn_spary", "SetEnabled", "", 0.01, null);
            EntFire("logic_script", "RunScriptcode", "BOTStoT(1)", 0.01, null);
            EntFire("bot", "AddOutput", "origin 32 0 -50", 0.02, null);
            EntFire("bot", "RunScriptcode", "self.SetHealth(999999)", 0.02, null);
            break;
        case 5:
            ::BOTStoSpec();
            EntFire("logic_script", "RunScriptcode", "BOTStoT(1)", 0.01, null);
            //EntFire("bot", "AddOutput", "origin 2304 304 1040", 0.02, null);
            break;
        case 6:
            ::BOTStoSpec();
            EntFire("logic_script", "RunScriptcode", "BOTStoT(1)", 0.01, null);
            break;
        case 7:
            ::BOTStoSpec();
            break;
        case 8:
            ::BOTStoSpec();
            EntFire("logic_script", "RunScriptcode", "BOTStoT(5)", 0.01, null);
            ::UpdateSpawn();
            EntFire("bot_spawn_near", "SetDisabled", "", 0, null);
            break;
        case 9:
            ::BOTStoSpec();
            EntFire("logic_script", "RunScriptcode", "BOTStoT(5)", 0.01, null);
            break;
    }
}
::UpdateSpawn<-function() {
	if (SET_DIST_NEAR_ENABLED){
        EntFire("killnear", "Disable", "", 0, null);
        EntFire("bot_spawn_near", "SetEnabled", "", 0, null);
    }
	if (!SET_DIST_NEAR_ENABLED){
        EntFire("killnear", "Enable", "", 0, null);
        EntFire("bot_spawn_near", "SetDisabled", "", 0, null);
    }
	if (SET_DIST_MID_ENABLED){
        EntFire("killmid", "Disable", "", 0, null);
        EntFire("bot_spawn_middle", "SetEnabled", "", 0, null);
    }
	if (!SET_DIST_MID_ENABLED){
        EntFire("killmid", "Enable", "", 0, null);
        EntFire("bot_spawn_middle", "SetDisabled", "", 0, null);
    }
	if (SET_DIST_FAR_ENABLED){
        EntFire("killfar", "Disable", "", 0, null);
        EntFire("bot_spawn_far", "SetEnabled", "", 0, null);
    }
	if (!SET_DIST_FAR_ENABLED){
        EntFire("killfar", "Enable", "", 0, null);
        EntFire("bot_spawn_far", "SetDisabled", "", 0, null);
    }

    EntFire("btn_bot_spawn_near", "unlock", "", 0.0, null);
    EntFire("btn_bot_spawn_middle", "unlock", "", 0.0, null);
    EntFire("btn_bot_spawn_far", "unlock", "", 0.0, null);
    if(!SET_DIST_NEAR_ENABLED && SET_DIST_MID_ENABLED && !SET_DIST_FAR_ENABLED) EntFire("btn_bot_spawn_middle", "lock", "", 0.01, null);
    if(!SET_DIST_NEAR_ENABLED && !SET_DIST_MID_ENABLED && SET_DIST_FAR_ENABLED) EntFire("btn_bot_spawn_far", "lock", "", 0.01, null);
    if(SET_DIST_NEAR_ENABLED && !SET_DIST_MID_ENABLED && !SET_DIST_FAR_ENABLED) EntFire("btn_bot_spawn_near", "lock", "", 0.01, null);
}

function ToggleKevlar(){
	::CURR_ARMOR++;
    if(::CURR_ARMOR >= 4) ::CURR_ARMOR = 0;
    switch (::CURR_ARMOR){
        case 0:
            ScriptPrintMessageChatAll(" Bot护甲:\x04 无护甲");break;
        case 1:
            ScriptPrintMessageChatAll(" Bot护甲:\x04 仅身体");break;
        case 2:
            ScriptPrintMessageChatAll(" Bot护甲:\x04 头盔+身体");break;
        case 3:
            ScriptPrintMessageChatAll(" Bot护甲:\x04 重型护甲");break;
    }

    for (local ent; ent = Entities.FindByClassname(ent, "player"); )
    {
        if(ent.GetTeam() == 2) ::GiveKevlar(ent);
    }
    for (local ent; ent = Entities.FindByClassname(ent, "cs_bot"); )
    {
        if(ent.GetTeam() == 2) ::GiveKevlar(ent);
    }
}

::GiveKevlar<-function(ent) {
    switch (::CURR_ARMOR) {
        case 0:
            EntFire("strip", "StripWeaponsAndSuit", "", 0.0, ent);
            break;
        case 1:
            local weapon_equip = Entities.CreateByClassname("game_player_equip");
            weapon_equip.__KeyValueFromInt("item_kevlar", 1);
            weapon_equip.__KeyValueFromInt("spawnflags", 5);

            EntFireByHandle(weapon_equip, "Use", "", 0, ent, null);
            weapon_equip.Destroy();
            break;
        case 2:
            local weapon_equip = Entities.CreateByClassname("game_player_equip");
            weapon_equip.__KeyValueFromInt("item_assaultsuit", 1);
            weapon_equip.__KeyValueFromInt("spawnflags", 5);
            EntFireByHandle(weapon_equip, "Use", "", 0, ent, null);
            weapon_equip.Destroy();
            break;
        case 3:
            local weapon_equip = Entities.CreateByClassname("game_player_equip");
            weapon_equip.__KeyValueFromInt("item_heavyassaultsuit", 1);
            weapon_equip.__KeyValueFromInt("spawnflags", 5);
            EntFireByHandle(weapon_equip, "Use", "", 0, ent, null);
            weapon_equip.Destroy();
            break;
        default:
            break;
    }
}

::LookAtPlayer <- function(){
	if (activator == null) return
	local delta = ::PLAYER.EyePosition()-activator.EyePosition();
	delta.Norm();
	activator.SetForwardVector(delta);
}

::StopBot<-function() {
    if(IS_BOT_STOP){
        for (local ent; ent = Entities.FindByClassname(ent, "cs_bot"); )
        {
            if(ent.GetTeam()==2) EntFire("speedmod", "ModifySpeed", "0", 0.0, ent);
        }
        for (local ent; ent = Entities.FindByClassname(ent, "player"); )
        {
            if(ent.GetTeam()==2) EntFire("speedmod", "ModifySpeed", "0", 0.0, ent);
        }
    }
    else{
        for (local ent; ent = Entities.FindByClassname(ent, "cs_bot"); )
        {
            if(ent.GetTeam()==2) EntFire("speedmod", "ModifySpeed", "1.0", 0.0, ent);
        }
        for (local ent; ent = Entities.FindByClassname(ent, "player"); )
        {
            if(ent.GetTeam()==2) EntFire("speedmod", "ModifySpeed", "1.0", 0.0, ent);
        }
    }
}

::UpdateBotAI<-function(){
    EntFire("bot", "SetHealth", "-1", 0.0, null);
	switch (::MODE_TYPE){
		case 1:{
            SendToConsole("mp_bot_ai_bt scripts/ai/bots.kv3");
            SendToConsoleServer("mp_bot_ai_bt scripts/ai/bots.kv3");
			break;
		}
        case 2:{
            SendToConsole("mp_bot_ai_bt \"\"");
            SendToConsoleServer("mp_bot_ai_bt \"\"");
            ::IS_BOT_STOP <- false;
			break;
		}
        case 3:{
            SendToConsole("mp_bot_ai_bt scripts/ai/bots.kv3");
            SendToConsoleServer("mp_bot_ai_bt scripts/ai/bots.kv3");
            ::IS_BOT_STOP <- true;
			break;
		}
        case 4:{
            SendToConsole("mp_bot_ai_bt \"\"");
            SendToConsoleServer("mp_bot_ai_bt \"\"");
            ::IS_BOT_STOP <- true;
			break;
		}
        case 5:{
            SendToConsole("mp_bot_ai_bt scripts/ai/bots.kv3");
            SendToConsoleServer("mp_bot_ai_bt scripts/ai/bots.kv3");
            ::IS_BOT_STOP <- true;
			break;
		}
        case 6:{
            SendToConsole("mp_bot_ai_bt scripts/ai/bots.kv3");
            SendToConsoleServer("mp_bot_ai_bt scripts/ai/bots.kv3");
            ::IS_BOT_STOP <- true;
			break;
		}
        case 7:{
            SendToConsole("mp_bot_ai_bt scripts/ai/bots.kv3");
            SendToConsoleServer("mp_bot_ai_bt scripts/ai/bots.kv3");
            ::IS_BOT_STOP <- true;
			break;
		}
        case 8:{
            SendToConsole("mp_bot_ai_bt \"\"");
            SendToConsoleServer("mp_bot_ai_bt \"\"");
            ::IS_BOT_STOP <- false;
			break;
		}
        case 9:{
            SendToConsole("mp_bot_ai_bt \"\"");
            SendToConsoleServer("mp_bot_ai_bt \"\"");
            ::IS_BOT_STOP <- false;
			break;
		}
    }
}

::BOTStoSpec<-function(){
	EntFire("bot", "RunScriptCode", "self.SetTeam(1)", 0.0, null);
	for (local bot; bot = Entities.Next(bot);){
    	if (bot.GetClassname() == "player" || bot.GetClassname() == "cs_bot"){
			if(bot.GetTeam() != 3){
				bot.SetTeam(1)
			}
		}
	}
}

::BOTStoT<-function(amount){
	local bot = null;
	local AMT_WANTED = amount;
	local AMT_SWITCHED = 0;
	while (bot = Entities.FindByClassname(bot, "player")){
		if (bot.GetTeam() == 1 && AMT_WANTED > AMT_SWITCHED){
			bot.SetTeam(2);
			++AMT_SWITCHED;
		}
	}
    while (bot = Entities.FindByClassname(bot, "cs_bot")){
		if (bot.GetTeam() == 1 && AMT_WANTED > AMT_SWITCHED){
			bot.SetTeam(2);
			++AMT_SWITCHED;
		}
	}
}

::ChangeModel<-function(ent) {
    if(!ent.IsValid() || ent.GetHealth() <= 0) return;
	switch(RandomInt(0, 5)){
		case 1:ent.SetModel("models/player/custom_player/legacy/ctm_sas.mdl");break
		case 2:ent.SetModel("models/player/custom_player/legacy/ctm_idf_variantb.mdl");break
		case 3:ent.SetModel("models/player/custom_player/legacy/ctm_gsg9.mdl");break
		case 4:ent.SetModel("models/player/custom_player/legacy/ctm_gign.mdl");break
        case 5:ent.SetModel("models/player/custom_player/legacy/ctm_diver_variantc.mdl");break
        default:break;
	}
}