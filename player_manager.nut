SCRIPT_OWNER <- "7ychu5";
SCRIPT_TIME <- "2023年8月20日10:18:27";
SCRIPT_MAP <- "GLOBAL";
SCRIPT_VERISON <- "0.1";

IncludeScript("7ychu5/utils.nut");
IncludeScript("vs_library.nut");
//////////user_variable///////////

self.PrecacheScriptSound("survival/jump_ability_long_01.wav");

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

function PrintTable() {
    local scope = activator.GetScriptScope();
    ::DEBUG("//////////////////////////////");
    foreach (i,k in scope) {
        printl(i + "=" + k);
    }
    ::DEBUG("//////////////////////////////");
}

VS.ListenToGameEvent( "player_spawn", function( event )
{
    local player = VS.GetPlayerByUserid(event.userid);
    local scope = player.GetScriptScope();
    if(player.GetName() == ""){ //初始化，把保留变量都放在这下面
        scope.xp_attack <- 1.00;
        scope.xp_speed <- 1.00;
        scope.xp_tech <- 1.00;
        scope.hp <- 200;

        local name = scope.name+"#"+scope.userid;
        scope.targetname <- name;
        EntFireByHandle(player, "AddOutput", "targetname "+name, 0.0, null, null);


        //EntFireByHandle(player, "SetHealth", "-1", 0.02, null, null);
    }
    scope.ui <- ::create_ui(player);
    scope.hudhint <- ::CreateHudhint();scope.hudhint.__KeyValueFromString("targetname", "hudhint_"+scope.targetname);
    scope.job <- 0;
    scope.kev <- 100;
    scope.kev_type <- 0;

    scope.ability_jetpack <- false;
    scope.ability_jetpack_use <- true;
    scope.ability_climb <- false;
    scope.ablilty_climb_use <- true;
    scope.ablilty_magic_ice <- false;
    scope.ablilty_magic_ice_use <- true;

    scope.key_w <- false;
    scope.key_a <- false;
    scope.key_s <- false;
    scope.key_d <- false;
    scope.key_m1 <- false;
    scope.key_m2 <- false;
    scope.key_space <- false;
    scope.grounded <- true;
    scope.crouch <- false;

    player.SetMaxHealth(scope.hp);
    player.SetHealth(scope.hp);

    ::update_player_status(player);

    EntFire("speedmod", "ModifySpeed", scope.xp_speed.tostring(), 0.0, player);

}, "" );

::update_player_status <- function(player) {
    EntFireByHandle(::logic_script, "RunScriptcode", "update_player_status(activator);", 0.1, player, null);

    local scope = player.GetScriptScope();
    scope.grounded <- ::isGrounded(player);
    scope.crouch <- ::isCrouch(player);

    if(scope.ability_jetpack) ::detect_ability_jetpack(player);
    if(scope.ability_climb) ::detect_ability_climb(player);
}

::detect_ability_jetpack <- function(player){
    local scope = player.GetScriptScope();
    if(!scope.crouch || !scope.key_space || !scope.ability_jetpack_use) return;
    scope.ability_jetpack_use <- false;
    player.SetVelocity(player.GetVelocity()*2);
    player.EmitSound("survival/jump_ability_long_01.wav");
}

::detect_ability_climb <- function(player){
    local scope = player.GetScriptScope();
    local origin_bottom = player.GetOrigin() + Vector(0, 0, 4);
    local origin_middle = player.GetOrigin() + Vector(0, 0, 54);
    local origin_eye = player.EyePosition();
    local origin_top = player.GetOrigin() + Vector(0, 0, 72);

    local vector_eye = player.GetForwardVector();

    // printl(vector_eye);
}


::show_player_information <- function(player) {
    local text = ::CreateText();
    text.__KeyValueFromString("x", "0");
    text.__KeyValueFromString("y", "0.38");
    text.__KeyValueFromString("color", "255 0 0");
    text.__KeyValueFromString("channel", "5");
    text.__KeyValueFromString("holdtime", "5");
    text.__KeyValueFromString("spawnflags", "0");
    local scope = player.GetScriptScope();
    local info =
        "玩家：" + scope.targetname + "\n" +
        "职业：" + ::translate_job(scope.job) + "\n" +
        "生命：" + player.GetHealth() + " / " + scope.hp + "\n" +
        "护甲：" + scope.kev + "(" + ::translate_kev_type(scope.kev_type) + ") " + "\n" +
        "力量：" + scope.xp_attack*100 + "%\n" +
        "敏捷：" + scope.xp_speed*100 + "%\n" +
        "智慧：" + scope.xp_tech*100 + "%\n" +
        "状态：" + ::translate_item_status(scope.ui) + "\n";

    EntFireByHandle(text, "SetText", info, 0.0, player, null);
    EntFireByHandle(text, "Display", "", 0.02, player, null);
    //EntFireByHandle(::logic_script, "RunScriptcode", "show_player_information(activator);", 0.1, player, null);
    EntFireByHandle(text, "kill", "", 0.09, player, null);
}

::translate_kev_type <- function(params) {
    switch (params) {
        case 0:return "\x04布甲\x04";
        case 1:return "\x09锁子甲\x04";
        case 2:return "\x02钢板\x04";
        case 3:return "\x08合金\x04";
        case 4:return "\x08工兵\x04";
    }
}

::translate_job <- function(params) {
    switch (params) {
        case 0:return "\x04動員兵";
        case 1:return "\x09突擊兵";
        case 2:return "\x02支援兵";
        case 3:return "\x08偵察兵";
        case 4:return "\x08工兵";
    }
}

::translate_item_status <- function(params) {
    if(params == null) return "OFFLINE";
    return "ONLINE";
}

::player_set_hp <- function(player, params) {
    if(!player.IsValid()){::DEBUG("ERROR PLAYER PARAMS");return;}
    player.GetScriptScope().hp <- params.tointeger();
    ::DEBUG(player + "health :" + params);
}

VS.ListenToGameEvent( "player_hurt", function( event )
{
    local player = VS.GetPlayerByUserid(event.userid);
    player.GetScriptScope().kev <- event.armor;
    //player.SetHealth(player.GetScriptScope().hp+event.dmg_health);

}, "listen_player_hurt" );

::create_ui <- function (player) {
    if(Entities.FindByName(null, "game_ui#"+player.GetScriptScope().userid.tostring()) != null) return;
    local game_ui = Entities.CreateByClassname("game_ui");
    game_ui.__KeyValueFromString("targetname", "game_ui#"+player.GetScriptScope().userid.tostring());
    game_ui.__KeyValueFromString("FieldOfView", "-1");
    game_ui.__KeyValueFromString("spawnflags", "256");

    //printl(game_ui.ValidateScriptScope());
    if(!game_ui.ValidateScriptScope()) return;
    local temp_scope = game_ui.GetScriptScope();
    game_ui.ConnectOutput("PlayerOn", "PlayerOn");
	game_ui.ConnectOutput("PlayerOff", "PlayerOff");
    game_ui.ConnectOutput("PressedMoveLeft", "PressedMoveLeft");
    game_ui.ConnectOutput("UnpressedMoveLeft", "UnpressedMoveLeft");
    game_ui.ConnectOutput("PressedMoveRight", "PressedMoveRight");
    game_ui.ConnectOutput("UnpressedMoveRight", "UnpressedMoveRight");
    game_ui.ConnectOutput("PressedForward", "PressedForward");
    game_ui.ConnectOutput("UnpressedForward", "UnpressedForward");
    game_ui.ConnectOutput("PressedBack", "PressedBack");
    game_ui.ConnectOutput("UnpressedBack", "UnpressedBack");
	game_ui.ConnectOutput("PressedAttack", "PressedAttack");
    game_ui.ConnectOutput("UnpressedAttack", "UnpressedAttack");
    game_ui.ConnectOutput("PressedAttack2", "PressedAttack2");
    game_ui.ConnectOutput("UnpressedAttack2", "UnpressedAttack2");
    temp_scope["player"] <- player;
    temp_scope["PlayerOn"] <- function (){activator.GetScriptScope().key_space <- false;printl(activator+"，启动！")}
    temp_scope["PlayerOff"] <- function (){activator.GetScriptScope().key_space <- true;EntFireByHandle(self, "Activate", "", 0.5, player, player);}
    temp_scope["PressedMoveLeft"] <- function (){activator.GetScriptScope().key_a <- true;}
    temp_scope["UnpressedMoveLeft"] <- function (){activator.GetScriptScope().key_a <- false;}
    temp_scope["PressedMoveRight"] <- function (){activator.GetScriptScope().key_d <- true;}
    temp_scope["UnpressedMoveRight"] <- function (){activator.GetScriptScope().key_d <- false;}
    temp_scope["PressedForward"] <- function (){activator.GetScriptScope().key_w <- true;}
    temp_scope["UnpressedForward"] <- function (){activator.GetScriptScope().key_w <- false;}
    temp_scope["PressedBack"] <- function (){activator.GetScriptScope().key_s <- true;}
    temp_scope["UnpressedBack"] <- function (){activator.GetScriptScope().key_s <- false;}
    temp_scope["PressedAttack"] <- function (){activator.GetScriptScope().key_m1 <- true;}
    temp_scope["UnpressedAttack"] <- function (){activator.GetScriptScope().key_m1 <- false;}
    temp_scope["PressedAttack2"] <- function (){activator.GetScriptScope().key_m2 <- true;}
    temp_scope["UnpressedAttack2"] <- function (){activator.GetScriptScope().key_m2 <- false;}


    EntFireByHandle(game_ui, "Activate", "", 0.0, player, player);
    return game_ui;
}

VS.ListenToGameEvent( "player_footstep", function( event )
{
    local player = VS.GetPlayerByUserid(event.userid);
    local scope = player.GetScriptScope();
    if(scope.ability_jetpack) if(!scope.crouch) scope.ability_jetpack_use = true;

}, "listen_player_footstep" );

VS.ListenToGameEvent( "inspect_weapon", function( event )
{
    local player = VS.GetPlayerByUserid(event.userid);
    local scope = player.GetScriptScope();
    ::show_player_information(player);

}, "listen_inspect_weapon" );
