SCRIPT_OWNER <- "7ychu5";
SCRIPT_TIME <- "2023年8月20日10:18:27";
SCRIPT_MAP <- "GLOBAL";
SCRIPT_VERISON <- "0.1";

IncludeScript("7ychu5/utils.nut");
IncludeScript("vs_library.nut");
//////////user_variable///////////

//ToDo：要写的是状态累计，需要更复杂的判断。但是搁置吧，不适应于当前环境

//////////sys_variable////////////

::logic_script <- Entities.FindByName(null, "logic_script");

::weapon_primary_list <- [
	"weapon_ak47"
	"weapon_aug"
	"weapon_awp"
	"weapon_bizon"
	"weapon_famas"
	"weapon_g3sg1"
	"weapon_galilar"
	"weapon_m249"
	"weapon_m4a1"
	"weapon_m4a1_silencer"
	"weapon_mac10"
	"weapon_mag7"
	"weapon_mp5sd"
	"weapon_mp7"
	"weapon_mp9"
	"weapon_negev"
	"weapon_nova"
	"weapon_p90"
	"weapon_sawedoff"
	"weapon_scar20"
	"weapon_sg556"
	"weapon_ssg08"
	"weapon_ump45"
	"weapon_xm1014"
]

::weapon_secondary_list <- [
	"weapon_cz75a"
	"weapon_deagle"
	"weapon_elite"
	"weapon_fiveseven"
	"weapon_glock"
	"weapon_hkp2000"
	"weapon_p250"
	"weapon_revolver"
	"weapon_tec9"
	"weapon_usp_silencer"
]

::weapon_throwable_list <- [
	"weapon_hegrenade"
    "weapon_firebomb"
    "weapon_incgrenade"
    "weapon_flashbang"
    "weapon_frag_grenade"
    "weapon_molotov"
    "weapon_decoy"
    "weapon_diversion"
    "weapon_smokegrenade"
]
//////////////////////////////////

VS.ListenToGameEvent( "player_spawn", function( event )
{
    local player = VS.GetPlayerByUserid(event.userid);
    local scope = player.GetScriptScope();
    scope.job <- 0;
    scope.listen_key <- false;
    scope.damage_head <- 0;
    scope.damage_arm <- 0;
    scope.damage_chest <- 0;
    scope.damage_stomach <- 0;
    scope.damage_leg <- 0;

    if(player.GetName() == ""){
        scope.xp <- 0;
        scope.hp <- 1000;

        local name = scope.name+"#"+RandomInt(1000, 9999);
        while(Entities.FindByName(null, name) != null){
            name = scope.name+"#" + RandomInt(1000, 9999).tostring();
        }
        scope.targetname <- name;
        EntFireByHandle(player, "AddOutput", "targetname "+name, 0.0, null, null);

        //EntFireByHandle(player, "SetHealth", "-1", 0.02, null, null);
    }

    player.SetMaxHealth(scope.hp);
    player.SetHealth(scope.hp);

    ::show_player_information(player);

}, "" );

::show_player_information <- function(player) {
    local text = ::CreateText();
    text.__KeyValueFromString("x", "0");
    text.__KeyValueFromString("y", "0.38");
    text.__KeyValueFromString("color", "255 0 0");
    text.__KeyValueFromString("channel", "5");
    text.__KeyValueFromString("spawnflags", "0");
    local info =
        "头部状态："+::translate_status(::body_damage_head_status(player))+"\n"+
        "手臂状态："+::translate_status(::body_damage_arm_status(player))+"\n"+
        "胸部状态："+::translate_status(::body_damage_chest_status(player))+"\n"+
        "腹部状态："+::translate_status(::body_damage_stomach_status(player))+"\n"+
        "腿部状态："+::translate_status(::body_damage_leg_status(player));
    EntFireByHandle(text, "SetText", info, 0.0, player, null);
    EntFireByHandle(text, "Display", "", 0.02, player, null);
    EntFireByHandle(::logic_script, "RunScriptcode", "show_player_information(activator);", 1.0, player, null);
    EntFireByHandle(text, "kill", "", 0.99, player, null);
    ::update_player_status(player);
}

::translate_status <- function(params) {
    switch (params) {
        case 0:return "\x04健康";
        case 1:return "\x09良好";
        case 2:return "\x02残疾";
        case 3:return "\x08毁坏";
    }
}

::update_player_status <- function(player){
    ::body_damage_head_cause(player);
    ::body_damage_leg_cause(player)
}

function PrintTable() {
    local scope = activator.GetScriptScope();
    foreach (i,k in scope) {
        //printl(i + "=" + k);
    }
    body_damage_arm_set(activator, 1)
    //body_damage_head_cause(activator)
}

::body_damage_head_set <- function(player, params) {player.GetScriptScope().damage_head <- params.tointeger();}
::body_damage_arm_set <- function(player, params) {player.GetScriptScope().damage_arm <- params.tointeger();}
::body_damage_chest_set <- function(player, params) {player.GetScriptScope().damage_chest <- params.tointeger();}
::body_damage_stomach_set <- function(player, params) {player.GetScriptScope().damage_stomach <- params.tointeger();}
::body_damage_leg_set <- function(player, params) {player.GetScriptScope().damage_leg <- params.tointeger();}

::body_damage_head_status <- function(player) {return player.GetScriptScope().damage_head;}
::body_damage_arm_status <- function(player) {return player.GetScriptScope().damage_arm;}
::body_damage_chest_status <- function(player) {return player.GetScriptScope().damage_chest;}
::body_damage_stomach_status <- function(player) {return player.GetScriptScope().damage_stomach;}
::body_damage_leg_status <- function(player) {return player.GetScriptScope().damage_leg;}

VS.ListenToGameEvent( "player_hurt", function( event )
{
    if(event.armor >= 80) return;
    else if(event.armor >= 50){
        if(RandomInt(1, 100) >= 75) ::body_damage(event.userid,event.hitgroup);
    }
    else{
        if(RandomInt(1, 100) >= 40) ::body_damage(event.userid,event.hitgroup);
    }
}, "listen_player_hurt" );

::body_damage <- function(id,params) {
    local player = VS.GetPlayerByUserid(id)
    switch (params) {
        case 1: if(::body_damage_head_status(player)>=3) return; ::body_damage_head_set(player, ::body_damage_head_status(player)+1);break;
        case 2: if(::body_damage_chest_status(player)>=3) return; ::body_damage_chest_set(player, ::body_damage_chest_status(player)+1);break;
        case 3: if(::body_damage_stomach_status(player)>=3) return; ::body_damage_stomach_set(player, ::body_damage_stomach_status(player)+1);break;
        case 4: if(::body_damage_arm_status(player)>=3) return; ::body_damage_arm_set(player, ::body_damage_arm_status(player)+1);break;
        case 5: if(::body_damage_arm_status(player)>=3) return; ::body_damage_arm_set(player, ::body_damage_arm_status(player)+1);break;
        case 6: if(::body_damage_leg_status(player)>=3) return; ::body_damage_leg_set(player, ::body_damage_leg_status(player)+1);break;
        case 7: if(::body_damage_leg_status(player)>=3) return; ::body_damage_leg_set(player, ::body_damage_leg_status(player)+1);break;
        default:break;
    }
}

::body_damage_head_cause <- function(player) {
    local params = ::body_damage_head_status(player);
    local angles = player.GetAngles();
    switch (params) {
        case 0:
            //player.SetAngles(angles.x, angles.y, 0);
            SendToConsole("r_screenoverlay /")
            break;
        case 1:
            //player.SetAngles(angles.x, angles.y, 0);
            SendToConsole("r_screenoverlay /")
            break;
        case 2:
            player.SetAngles(angles.x, angles.y, RandomFloat(-15, 15));
            SendToConsole("r_screenoverlay /")
            break;
        case 3:
            player.SetAngles(angles.x, angles.y, RandomFloat(-30, 30));
            SendToConsole("r_screenoverlay /")
            break;
    }
}

::body_damage_leg_cause <- function(player) {
    local params = ::body_damage_arm_status(player);

    switch (params) {
        case 0:
            EntFire("speedmod", "AddOutput", "spawnflags 0", 0.0, null);
            EntFire("speedmod", "ModifySpeed", "1.0", 0.01, player);
            break;
        case 1:
            EntFire("speedmod", "AddOutput", "spawnflags 0", 0.0, null);
            EntFire("speedmod", "ModifySpeed", "0.9", 0.01, player);
            break;
        case 2:
            EntFire("speedmod", "AddOutput", "spawnflags 8", 0.0, null);
            EntFire("speedmod", "ModifySpeed", "0.7", 0.01, player);
            break;
        case 3:
            EntFire("speedmod", "AddOutput", "spawnflags 4", 0.0, null);
            EntFire("speedmod", "ModifySpeed", "0.5", 0.01, player);
            break;
    }
}
VS.ListenToGameEvent( "item_equip", function( event )
{
	local player = VS.GetPlayerByUserid(event.userid);
    local weapon = "weapon_" + event.item;
	local params = ::body_damage_arm_status(player);

    switch (params) {
        case 0:

            break;
        case 1:
            foreach (k in ::weapon_throwable_list) {
                if(weapon == k) {
                    EntFire("speedmod", "AddOutput", "spawnflags 1", 0.0, null);
                    EntFire("speedmod", "ModifySpeed", 0.99, 0.02, player);
                }
            }
            break;
        case 2:
            foreach (k in ::weapon_secondary_list) {
                if(weapon == k) {
                    EntFire("speedmod", "AddOutput", "spawnflags 1", 0.0, null);
                    EntFire("speedmod", "ModifySpeed", 0.99, 0.02, player);
                }
            }
            break;
        case 3:
            foreach (k in ::weapon_primary_list) {
                if(weapon == k) {
                    EntFire("speedmod", "AddOutput", "spawnflags 1", 0.0, null);
                    EntFire("speedmod", "ModifySpeed", 0.99, 0.02, player);
                }
            }
            break;
    }
}, "listen_item_equip" );