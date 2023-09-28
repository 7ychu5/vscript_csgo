IncludeScript("vs_library.nut");

///////////////////////////////////////////////////////////////
//他妈的文盲......spray打成spary了......全部写完了才发现，太愚蠢了。

//我的建议是：全部重做，回到地图原点。
//他妈的我最开始怎么想到搬到他妈的1000多hu之外的？这写的也太死妈了
//希望之后这个逼运算一切顺利

//weapon_accuracy_nospread 0 之后把这个用上再画图

/*TODO：
    射速还有问题
    打印pattern时精确到tick吧，下一次射击时停止显示上一次射击的结果

    压枪数据散乱

    有一个很严重的bug，但是我现在还不知道怎么产生的，貌似是由于timer与非法枪械冲突而产生的（好像解决了）
*/

player_ui <- null;
hTimer <- null;


Recoil_current_pattern <- [];
Recoil_bullet_index <- 0;
Recoil_pattern_length <- 0;
Recoil_bullet_delay <- 0;
Pattern_ROF <- 6400.0 / 1;//WHAT?
temp_index <- 0;
Center_pos <- Vector(0.03125, 0, 0);
Pattern_scale <- -0.53;
display_scale <- 1.5;
display_shift_x <- 0;
display_shift_y <- -100;
display_shift_z <- -200;

bot_hp_start <- 999999;
bot_hp_end <- 0;


Recoil_draw_toggle <- false;
Recoil_screen_shocking_toggle <- false;
Recoil_crosshair_follow_toggle <- false;


///////////////////////////////////////////////////////////////

function spary_mode_on() {
    activator.SetVelocity(Vector(0, 0, 0));
    activator.SetOrigin(Vector(528,0,-60));
    activator.SetAngles(0, 180, 0);
    GetSparyUI();
    ::MODE_TYPE <- 4;
    ::SpawnBot();
    ::SET_INFINITE_AMMO <- true;::ToggleAmmo();
    draw_pattern();
    ScriptPrintMessageCenterAll("<font color='#55efc4'>欢迎来到</font><font color='#ff1010'>扫射</font><font color='#55efc4'>测试！</font>\n<font color='#e67e22'>造成伤害越多得分越高</font>\n<font color='#81ecec'>按下左键即可开始！</font>");
}

function GetSparyUI() {
    player_ui <- Entities.CreateByClassname("game_ui");
    player_ui.__KeyValueFromString("spawnflags", "32");
    player_ui.__KeyValueFromString("FieldOfView", "-1");
    player_ui.ConnectOutput("PlayerOn", "PlayerOn");
	player_ui.ConnectOutput("PlayerOff", "PlayerOff");
	player_ui.ConnectOutput("PressedAttack", "PressedAttack");
    player_ui.ConnectOutput("UnPressedAttack", "UnPressedAttack");
    if(player_ui.ValidateScriptScope())
    {
        local scope = player_ui.GetScriptScope();
        scope["PlayerOn"] <- function ()
        {
            ScriptPrintMessageChatAll("已上线");
        }
        scope["PlayerOff"] <- function ()
        {
            ScriptPrintMessageChatAll("已离线");
            EntFire("logic_script", "RunScriptcode", "spary_mode_stop()", 0, self);
            EntFireByHandle(self, "kill", "", 0.01, null, null);
        }
        scope["PressedAttack"] <- function ()
        {
            EntFire("logic_script", "RunScriptcode", "Recoil_start_shooting();", 0.0, null);
            // Recoil_start_shooting();
        }
        scope["UnPressedAttack"] <- function ()
        {
            EntFire("logic_script", "RunScriptcode", "Recoil_stop_shooting();", 0.02, null);
            // Recoil_stop_shooting();
        }
    }
    EntFireByHandle(player_ui, "Activate", "", 0.0, activator ,null);
}

function spary_mode_stop() {
    ::MODE_TYPE <- 1;::SpawnBot();
    EntFireByHandle(player_ui, "Deactivate", "", 0.0, activator ,null);
    ScriptPrintMessageCenterAll("已默认回到热身模式");
}

function Recoil_start_shooting() {
    Recoil_toggle_display();

    local bot = Entities.FindByName(null, "bot");
    local temp_hp = bot.GetHealth();
    //printl(temp_hp);
    if(temp_hp >= bot_hp_start) bot_hp_start <- temp_hp;

    hTimer <- VS.Timer( 0, Recoil_bullet_delay, function() {
        local aim_pos_x_1 = Pattern_scale * Recoil_current_pattern[temp_index].x;
        local aim_pos_y_1 = Pattern_scale * Recoil_current_pattern[temp_index].y;
        local aim_pos_z_1 = Pattern_scale * Recoil_current_pattern[temp_index].z;
        DebugDrawBox(Vector(aim_pos_x_1, aim_pos_y_1, aim_pos_z_1), Vector(2, 2, 2), Vector(-2, -2, -2), 255, 0, 0, 255, Recoil_bullet_delay);
        if(temp_index < Recoil_current_pattern.len()-1) temp_index++;
    },this);
}

function Recoil_stop_shooting() {
    Recoil_toggle_display();
    local weapon = GetHeldWeaponName(::PLAYER);
    local weapon_equip = Entities.CreateByClassname("game_player_equip");
	weapon_equip.__KeyValueFromInt(weapon, 1);
	weapon_equip.__KeyValueFromInt("spawnflags", 5);
	EntFireByHandle(weapon_equip, "Use", "", 0, ::PLAYER, null);
	weapon_equip.Destroy();
    EntFireByHandle(hTimer, "kill", "", 0.01, null, null);
    local bot = Entities.FindByName(null, "bot");
    bot_hp_end <- bot.GetHealth();
    local value = (bot_hp_start-bot_hp_end)/temp_index.tofloat();
    bot_hp_start <- bot.GetHealth();
    temp_index <- 0;
    EntFire("worldtext_spary_score", "AddOutput", "message "+value, 0.0, null);
}

function Recoil_toggle_display() {
    Recoil_draw_toggle <- !Recoil_draw_toggle;
}

function Recoil_toggle_screen_shocking() {
    Recoil_screen_shocking_toggle <- !Recoil_screen_shocking_toggle;
    if(Recoil_screen_shocking_toggle){
        SendToConsole("weapon_recoil_view_punch_extra 0");
        SendToConsoleServer("weapon_recoil_view_punch_extra 0");
    }
    else{
        SendToConsole("weapon_recoil_view_punch_extra 0.055");
        SendToConsoleServer("weapon_recoil_view_punch_extra 0.055");
    }
}

function Recoil_toggle_crosshair_follow() {
    Recoil_crosshair_follow_toggle <- !Recoil_crosshair_follow_toggle;
    if(Recoil_crosshair_follow_toggle){
        SendToConsole("cl_crosshair_recoil 1");
        SendToConsoleServer("cl_crosshair_recoil 1");
    }
    else{
        SendToConsole("cl_crosshair_recoil 0");
        SendToConsoleServer("cl_crosshair_recoil 0");
    }
}

VS.ListenToGameEvent( "bullet_impact", function( event )
{
    if(::MODE_TYPE == 4){
        local x = event.x;
        local y = event.y;
        local z = event.z;
        local pos = Vector(x, y, z);
        DebugDrawBox(Vector(x, y, z), Vector(1, 1, 1), Vector(-1, -1, -1), 0, 255, 255, 40, 3);
        EntFire("logic_script", "RunScriptcode", "spary_draw_shifting(\""+x+"\",\""+y+"\",\""+z+"\")", 0.0, null);
        // printl("tempPattern.append(Vector(0, "+y+", "+z+"));");
    }
}, "listen_spary_mode_bullet_impact" );

function spary_draw_shifting(hitx,hity,hitz) {  //左边的大型演示图
    local player = ToExtendedPlayer(::PLAYER);
    local eye = player.EyePosition();
    local pos = VS.TraceDir( eye, player.EyeForward(), 512 ).GetPos();

    //瞄准落点 *-0.52
    local aim_pos_x_1 = display_scale * Recoil_current_pattern[temp_index].x + display_shift_x;
    local aim_pos_y_1 = display_scale * Recoil_current_pattern[temp_index].y + display_shift_y;
    local aim_pos_z_1 = display_scale * Recoil_current_pattern[temp_index].z + display_shift_z;

    local temp_index_next = temp_index + 1;
    if(temp_index_next >= Recoil_current_pattern.len()-2) temp_index_next-=1;

    local aim_pos_x_2 = display_scale * Recoil_current_pattern[temp_index_next].x + display_shift_x;
    local aim_pos_y_2 = display_scale * Recoil_current_pattern[temp_index_next].y + display_shift_y;
    local aim_pos_z_2 = display_scale * Recoil_current_pattern[temp_index_next].z + display_shift_z;



    //DebugDrawBox(pos, Vector(2, 2, 2), Vector(-2, -2, -2), 128, 128, 128, 100, 3);//目力方块
    hitx = hitx.tofloat();
    hity = hity.tofloat();
    hitz = hitz.tofloat();
    ScriptPrintMessageChatAll(GetDistance(Vector(hitx,hity,hitz),Center_pos).tostring());
    //DebugDrawBox(Vector(pos.x, pos.y, pos.z), Vector(1.2, 1.2, 1.2), Vector(-1.2, -1.2, -1.2), 0, 255, 255, 40, 3);//目力方块连线
    //DebugDrawBox(Vector(aim_pos_x_1, aim_pos_y_1, aim_pos_z_1), Vector(1.2, 1.2, 1.2), Vector(-1.2, -1.2, -1.2), 0, 255, 0, 40, 3);
    //DebugDrawLine(Vector(aim_pos_x_1, aim_pos_y_1, aim_pos_z_1), Vector(pos.x, pos.y, pos.z), 128, 128, 0, true, 3);
    //DebugDrawLine(Vector(aim_pos_x_1, aim_pos_y_1, aim_pos_z_1), Vector(aim_pos_x_1, aim_pos_y_2, aim_pos_z_2), 0, 128, 128, true, 3)
}

function GetHeldWeaponName(handle = null){
	local vm = null;
	while (vm = Entities.FindByClassname(vm, "predicted_viewmodel")){
		if (vm.GetMoveParent() == handle) return ModelToClassname(vm.GetModelName())
	}
	return null;
}

function ModelToClassname(weapon = null){
	switch (weapon){
		case "models/weapons/v_mach_m249para.mdl":			return "weapon_m249";
		case "models/weapons/v_mach_negev.mdl":				return "weapon_negev";
		// case "models/weapons/v_pist_223.mdl":				return "weapon_usp_silencer";
		case "models/weapons/v_pist_cz_75.mdl":				return "weapon_cz75a";
		// case "models/weapons/v_pist_deagle.mdl":			    return "weapon_deagle";
		// case "models/weapons/v_pist_elite.mdl":				return "weapon_elite";
		// case "models/weapons/v_pist_fiveseven.mdl":			return "weapon_fiveseven";
		// case "models/weapons/v_pist_glock18.mdl":			return "weapon_glock";
		// case "models/weapons/v_pist_hkp2000.mdl":			return "weapon_hkp2000";
		// case "models/weapons/v_pist_p250.mdl":				return "weapon_p250";
		// case "models/weapons/v_pist_revolver.mdl":			return "weapon_revolver";
		// case "models/weapons/v_pist_tec9.mdl":				return "weapon_tec9";
		case "models/weapons/v_rif_ak47.mdl":				return "weapon_ak47";
		case "models/weapons/v_rif_aug.mdl":				return "weapon_aug";
		case "models/weapons/v_rif_famas.mdl":				return "weapon_famas";
		case "models/weapons/v_rif_galilar.mdl":			return "weapon_galilar";
		case "models/weapons/v_rif_m4a1.mdl":				return "weapon_m4a1";
		case "models/weapons/v_rif_m4a1_s.mdl":				return "weapon_m4a1_silencer";
		case "models/weapons/v_rif_sg556.mdl":				return "weapon_sg556";
		//case "models/weapons/v_shot_mag7.mdl":				return "weapon_mag7";
		//case "models/weapons/v_shot_nova.mdl":				return "weapon_nova";
		//case "models/weapons/v_shot_sawedoff.mdl":			return "weapon_sawedoff";
		//case "models/weapons/v_shot_xm1014.mdl":			    return "weapon_xm1014";
		case "models/weapons/v_smg_bizon.mdl":				return "weapon_bizon";
		case "models/weapons/v_smg_mac10.mdl":				return "weapon_mac10";
		case "models/weapons/v_smg_mp5sd.mdl":				return "weapon_mp5sd";
		case "models/weapons/v_smg_mp7.mdl":				return "weapon_mp7";
		case "models/weapons/v_smg_mp9.mdl":				return "weapon_mp9";
		case "models/weapons/v_smg_p90.mdl":				return "weapon_p90";
		case "models/weapons/v_smg_ump45.mdl":				return "weapon_ump45";
		// case "models/weapons/v_snip_awp.mdl":				return "weapon_awp";
		case "models/weapons/v_snip_g3sg1.mdl":				return "weapon_g3sg1";
		case "models/weapons/v_snip_scar20.mdl":			return "weapon_scar20";
		// case "models/weapons/v_snip_ssg08.mdl":				return "weapon_ssg08";
        default: return "weapon_unknown";
	}
}

function draw_pattern() {
    Recoil_set_pattern(GetHeldWeaponName(::PLAYER));

    local scaleFactorX = -1;
    local scaleFactorZ = -1;
    //2304, 288.031, 1105

    for (local index = 0; index < Recoil_pattern_length-1; index++) {
        if(Recoil_draw_toggle)                                      //绘制本来应该的后坐力图样
        {
            local aim_pos_x_1 = Recoil_current_pattern[index].x;local aim_pos_x_2 = Recoil_current_pattern[index+1].x;
            local aim_pos_y_1 = Recoil_current_pattern[index].y;local aim_pos_y_2 = Recoil_current_pattern[index+1].y;
            local aim_pos_z_1 = Recoil_current_pattern[index].z;local aim_pos_z_2 = Recoil_current_pattern[index+1].z;
            DebugDrawLine(Recoil_current_pattern[index], Recoil_current_pattern[index+1], 255, 255, 255, true, Recoil_bullet_delay);
            //DebugDrawLine(Vector(aim_pos_x_1, Recoil_current_pattern[index].y, aim_pos_z_1), Vector(aim_pos_x_2, Recoil_current_pattern[index].y, aim_pos_z_2), 0, 255, 0, true, Recoil_bullet_delay);
        }
        else                                                        //绘制压枪落点图样
        {
            local aim_pos_x_1 = Pattern_scale * Recoil_current_pattern[index].x;
            local aim_pos_y_1 = Pattern_scale * Recoil_current_pattern[index].y;
            local aim_pos_z_1 = Pattern_scale * Recoil_current_pattern[index].z;
            //DebugDrawBox(Recoil_current_pattern[index], Vector(1, 1, 1), Vector(-1, -1, -1), 255, 0, 0, 255, Recoil_bullet_delay);
            DebugDrawBox(Vector(aim_pos_x_1, aim_pos_y_1, aim_pos_z_1), Vector(1, 1, 1), Vector(-1, -1, -1), 0, 255, 0, 255, Recoil_bullet_delay);
        }
    }

    if(::MODE_TYPE == 4) EntFire("logic_script", "RunScriptcode", "draw_pattern();", Recoil_bullet_delay, null);
}

function Recoil_set_pattern(wepName){
    switch(wepName)
    {
        case "weapon_negev":Recoil_current_pattern = Pattern_negev();break;
        case "weapon_m249":Recoil_current_pattern = Pattern_m249();break;
        case "weapon_mp7":Recoil_current_pattern = Pattern_mp7();break;
        case "weapon_mp5sd":Recoil_current_pattern = Pattern_mp5sd();break;
        case "weapon_mac10":Recoil_current_pattern = Pattern_mac10();break;
        case "weapon_mp9":Recoil_current_pattern = Pattern_mp9();break;
        case "weapon_bizon":Recoil_current_pattern = Pattern_ppbizon();break;
        case "weapon_ump45":Recoil_current_pattern = Pattern_ump45();break;
        case "weapon_p90":Recoil_current_pattern = Pattern_p90();break;
        case "weapon_usp_silencer":Recoil_current_pattern = Pattern_usp_s();break;
        case "weapon_cz75":Recoil_current_pattern = Pattern_cz75_auto();break;
        case "weapon_aug":Recoil_current_pattern = Pattern_aug();break;
        case "weapon_ak47":Recoil_current_pattern = Pattern_ak47();break;
        case "weapon_g3sg1":Recoil_current_pattern = Pattern_g3sg1();break;
        case "weapon_famas":Recoil_current_pattern = Pattern_famas();break;
        case "weapon_m4a1_silencer":Recoil_current_pattern = Pattern_m4a1_s();break;
        case "weapon_galilar":Recoil_current_pattern = Pattern_galil_ar();break;
        case "weapon_scar20":Recoil_current_pattern = Pattern_scar_20();break;
        case "weapon_m4a1":Recoil_current_pattern = Pattern_m4a4();break;
        case "weapon_sg556":Recoil_current_pattern = Pattern_sg553();break;
        case "weapon_unknown":Recoil_current_pattern = Pattern_unknown();break;
        default:Recoil_current_pattern = Pattern_unknown();break;
    }
}

::Pattern_ak47<-function(){
    local tempPattern = []
    tempPattern.append(Vector(0, 0.0566825, -0.120029));
    tempPattern.append(Vector(0, 0.991812, 1.87096));
    tempPattern.append(Vector(0, -0.0446669, 11.6925));
    tempPattern.append(Vector(0, 1.2845, 26.4972));
    tempPattern.append(Vector(0, 2.05123, 42.6538));
    tempPattern.append(Vector(0, -4.61907, 57.4199));
    tempPattern.append(Vector(0, -8.19859, 71.5845));
    tempPattern.append(Vector(0, -15.2103, 83.1323));
    tempPattern.append(Vector(0, -6.94336, 90.4402));
    tempPattern.append(Vector(0, 14.3533, 87.8171));
    tempPattern.append(Vector(0, 24.9412, 89.8118));
    tempPattern.append(Vector(0, 18.796, 95.9843));
    tempPattern.append(Vector(0, 26.4432, 97.1863));
    tempPattern.append(Vector(0, 39.1839, 93.7783));
    tempPattern.append(Vector(0, 40.8162, 95.3491));
    tempPattern.append(Vector(0, 21.3004, 96.6034));
    tempPattern.append(Vector(0, 11.6403, 101.028));
    tempPattern.append(Vector(0, 4.12519, 104.782));
    tempPattern.append(Vector(0, -8.9586, 104.168));
    tempPattern.append(Vector(0, -25.7702, 98.9633));
    tempPattern.append(Vector(0, -15.6017, 98.6952));
    tempPattern.append(Vector(0, -18.6058, 100.738));
    tempPattern.append(Vector(0, -14.563, 104.212));
    tempPattern.append(Vector(0, -10.8927, 106.716));
    tempPattern.append(Vector(0, -20.3065, 104.196));
    tempPattern.append(Vector(0, -22.6711, 104.153));
    tempPattern.append(Vector(0, -13.3392, 106.33));
    tempPattern.append(Vector(0, 3.47494, 105.511));
    tempPattern.append(Vector(0, 25.2766, 96.5169));
    tempPattern.append(Vector(0, 33.0723, 95.4499));
    Recoil_pattern_length = tempPattern.len()
    Recoil_bullet_delay = 600/Pattern_ROF;
    return tempPattern
    }
::Pattern_aug<-function(){
    local tempPattern = []
    tempPattern.append(Vector(0, 0.0247242, -0.0242896));
    tempPattern.append(Vector(0, -0.771023, 1.25464));
    tempPattern.append(Vector(0, -1.15643, 5.38518));
    tempPattern.append(Vector(0, 0.118406, 14.2927));
    tempPattern.append(Vector(0, 2.95277, 25.2883));
    tempPattern.append(Vector(0, 0.43409, 37.0723));
    tempPattern.append(Vector(0, -2.99066, 48.3427));
    tempPattern.append(Vector(0, -9.07934, 57.2486));
    tempPattern.append(Vector(0, -11.4744, 63.6398));
    tempPattern.append(Vector(0, -16.6205, 66.8271));
    tempPattern.append(Vector(0, -8.27102, 69.3004));
    tempPattern.append(Vector(0, -6.44634, 73.0709));
    tempPattern.append(Vector(0, -13.2678, 73.878));
    tempPattern.append(Vector(0, -13.0637, 75.2574));
    tempPattern.append(Vector(0, -2.12074, 74.724));
    tempPattern.append(Vector(0, 12.7793, 69.5761));
    tempPattern.append(Vector(0, 25.2364, 66.7404));
    tempPattern.append(Vector(0, 24.8492, 69.1687));
    tempPattern.append(Vector(0, 25.8879, 70.6788));
    tempPattern.append(Vector(0, 29.2299, 70.4258));
    tempPattern.append(Vector(0, 17.9328, 71.5845));
    tempPattern.append(Vector(0, 3.81494, 72.0399));
    tempPattern.append(Vector(0, -1.03451, 74.2337));
    tempPattern.append(Vector(0, 2.51097, 75.2393));
    tempPattern.append(Vector(0, -4.63867, 74.7115));
    tempPattern.append(Vector(0, -17.2497, 70.5967));
    tempPattern.append(Vector(0, -24.5609, 70.0783));
    tempPattern.append(Vector(0, -15.3951, 71.7093));
    tempPattern.append(Vector(0, -8.15224, 73.4699));
    tempPattern.append(Vector(0, -7.16609, 74.7643));
    Recoil_pattern_length = tempPattern.len()
    Recoil_bullet_delay = 600/Pattern_ROF;
    return tempPattern
    }
::Pattern_sg553<-function(){
    local tempPattern = []
    tempPattern.append(Vector(0, 0.200206, 0.193619));
    tempPattern.append(Vector(0, 0.856145, 1.63863));
    tempPattern.append(Vector(0, 6.63237, 8.81617));
    tempPattern.append(Vector(0, 10.3894, 20.1773));
    tempPattern.append(Vector(0, 13.2932, 33.1775));
    tempPattern.append(Vector(0, 16.2595, 46.6664));
    tempPattern.append(Vector(0, 18.2433, 59.1901));
    tempPattern.append(Vector(0, 27.4612, 63.3803));
    tempPattern.append(Vector(0, 19.3933, 70.2822));
    tempPattern.append(Vector(0, 23.6313, 73.0163));
    tempPattern.append(Vector(0, 30.2069, 73.7357));
    tempPattern.append(Vector(0, 31.7214, 75.9422));
    tempPattern.append(Vector(0, 28.4911, 78.7122));
    tempPattern.append(Vector(0, 31.4626, 78.1821));
    tempPattern.append(Vector(0, 29.3139, 80.7825));
    tempPattern.append(Vector(0, 36.5706, 78.9205));
    tempPattern.append(Vector(0, 46.167, 72.2446));
    tempPattern.append(Vector(0, 52.5236, 67.8014));
    tempPattern.append(Vector(0, 53.6243, 67.5915));
    tempPattern.append(Vector(0, 33.0714, 69.9464));
    tempPattern.append(Vector(0, 8.18115, 67.9005));
    tempPattern.append(Vector(0, -9.34472, 65.9625));
    tempPattern.append(Vector(0, -11.8851, 71.316));
    tempPattern.append(Vector(0, -16.0932, 76.5907));
    tempPattern.append(Vector(0, -17.154, 80.5505));
    tempPattern.append(Vector(0, -26.7873, 80.1427));
    tempPattern.append(Vector(0, -38.2922, 74.1121));
    tempPattern.append(Vector(0, -29.9918, 76.352));
    tempPattern.append(Vector(0, -23.3555, 79.8855));
    tempPattern.append(Vector(0, -5.22303, 78.1187));
    Recoil_pattern_length = tempPattern.len()
    Recoil_bullet_delay = 667/Pattern_ROF;
    return tempPattern
    }
::Pattern_cz75_auto<-function(){
    local tempPattern = []
    tempPattern.append(Vector(0, -0.0316038, -0.125275));
    tempPattern.append(Vector(0, 0.782058, 1.12468));
    tempPattern.append(Vector(0, 11.1934, 6.52302));
    tempPattern.append(Vector(0, 7.10644, 19.8022));
    tempPattern.append(Vector(0, -7.11955, 20.6941));
    tempPattern.append(Vector(0, -20.0571, 31.9716));
    tempPattern.append(Vector(0, -4.49546, 45.0499));
    tempPattern.append(Vector(0, 6.72637, 57.5381));
    tempPattern.append(Vector(0, 26.3751, 65.1001));
    tempPattern.append(Vector(0, 14.7882, 73.5175));
    tempPattern.append(Vector(0, 22.6532, 85.2175));
    tempPattern.append(Vector(0, 26.4328, 93.8755));
    Recoil_pattern_length = tempPattern.len();
    Recoil_bullet_delay = 600/Pattern_ROF;
    return tempPattern
    }
::Pattern_famas<-function(){
    local tempPattern = []
    tempPattern.append(Vector(0, -0.265782, 0.0691591));
    tempPattern.append(Vector(0, 1.02509, 1.27335));
    tempPattern.append(Vector(0, 0.683816, 1.8887));
    tempPattern.append(Vector(0, 4.18055, 7.86428));
    tempPattern.append(Vector(0, 5.147, 17.6319));
    tempPattern.append(Vector(0, 4.93625, 28.3262));
    tempPattern.append(Vector(0, -2.00565, 36.4732));
    tempPattern.append(Vector(0, -9.81404, 42.1569));
    tempPattern.append(Vector(0, -7.24483, 49.2087));
    tempPattern.append(Vector(0, 2.93421, 52.5995));
    tempPattern.append(Vector(0, 10.8873, 54.4299));
    tempPattern.append(Vector(0, 17.3693, 56.0185));
    tempPattern.append(Vector(0, 15.2135, 59.5972));
    tempPattern.append(Vector(0, 3.62755, 60.8318));
    tempPattern.append(Vector(0, -1.90539, 62.4384));
    tempPattern.append(Vector(0, -11.3988, 61.9682));
    tempPattern.append(Vector(0, -14.7056, 63.6246));
    tempPattern.append(Vector(0, -22.0075, 62.446));
    tempPattern.append(Vector(0, -23.4705, 64.1917));
    tempPattern.append(Vector(0, -21.4382, 66.4137));
    tempPattern.append(Vector(0, -9.47748, 66.3877));
    tempPattern.append(Vector(0, -7.74088, 67.0707));
    tempPattern.append(Vector(0, -12.8238, 65.6286));
    tempPattern.append(Vector(0, -20.1501, 62.4817));
    tempPattern.append(Vector(0, -27.9565, 58.5217));
    Recoil_pattern_length = tempPattern.len()
    Recoil_bullet_delay = 667/Pattern_ROF;
    return tempPattern
    }
::Pattern_g3sg1<-function(){
    local tempPattern = []
    tempPattern.append(Vector(0, -0.0963217, 0.0254806));
    tempPattern.append(Vector(0, -0.45973, 1.08638));
    tempPattern.append(Vector(0, -0.236497, 1.45252));
    tempPattern.append(Vector(0, 0.227217, 1.50739));
    tempPattern.append(Vector(0, 0.467495, 2.28313));
    tempPattern.append(Vector(0, 0.504165, 5.08443));
    tempPattern.append(Vector(0, 0.328602, 5.68034));
    tempPattern.append(Vector(0, 1.01192, 8.29457));
    tempPattern.append(Vector(0, 2.38902, 9.69323));
    tempPattern.append(Vector(0, 0.374254, 9.20315));
    tempPattern.append(Vector(0, 0.684807, 8.32945));
    tempPattern.append(Vector(0, 0.266863, 8.03708));
    tempPattern.append(Vector(0, -0.942741, 8.85154));
    tempPattern.append(Vector(0, 0.800258, 7.666));
    tempPattern.append(Vector(0, 0.948215, 6.51753));
    tempPattern.append(Vector(0, -0.551915, 8.11317));
    tempPattern.append(Vector(0, 0.94206, 10.0299));
    tempPattern.append(Vector(0, 0.275442, 10.9595));
    tempPattern.append(Vector(0, 1.30559, 12.5213));
    tempPattern.append(Vector(0, 3.33437, 13.3003));
    Recoil_pattern_length = tempPattern.len()
    Recoil_bullet_delay = 0.5;
    return tempPattern
    }
::Pattern_galil_ar<-function(){
    local tempPattern = []
    tempPattern.append(Vector(0, 0.130955, 0.124486));
    tempPattern.append(Vector(0, -1.06755, 1.18042));
    tempPattern.append(Vector(0, -0.695656, 2.25704));
    tempPattern.append(Vector(0, -3.71544, 8.63884));
    tempPattern.append(Vector(0, -9.71395, 16.9164));
    tempPattern.append(Vector(0, -9.41771, 27.57));
    tempPattern.append(Vector(0, -10.5226, 39.0238));
    tempPattern.append(Vector(0, -13.4146, 47.9007));
    tempPattern.append(Vector(0, -19.1648, 53.0951));
    tempPattern.append(Vector(0, -16.919, 59.4376));
    tempPattern.append(Vector(0, -5.91901, 63.1074));
    tempPattern.append(Vector(0, 8.63548, 61.8364));
    tempPattern.append(Vector(0, 23.6944, 56.7588));
    tempPattern.append(Vector(0, 28.2292, 59.5121));
    tempPattern.append(Vector(0, 33.732, 60.1986));
    tempPattern.append(Vector(0, 37.1993, 61.2233));
    tempPattern.append(Vector(0, 37.9114, 62.2526));
    tempPattern.append(Vector(0, 35.188, 65.1558));
    tempPattern.append(Vector(0, 22.3991, 67.8514));
    tempPattern.append(Vector(0, 16.0807, 70.2367));
    tempPattern.append(Vector(0, 3.9297, 69.4601));
    tempPattern.append(Vector(0, -12.086, 64.3137));
    tempPattern.append(Vector(0, -14.3669, 64.5616));
    tempPattern.append(Vector(0, -8.85284, 66.383));
    tempPattern.append(Vector(0, -14.9599, 66.6575));
    tempPattern.append(Vector(0, -20.4141, 67.1638));
    tempPattern.append(Vector(0, -28.5868, 64.9726));
    tempPattern.append(Vector(0, -23.1793, 66.1065));
    tempPattern.append(Vector(0, -8.35331, 64.3825));
    tempPattern.append(Vector(0, 4.51246, 63.8926));
    tempPattern.append(Vector(0, 11.7312, 65.7831));
    tempPattern.append(Vector(0, 8.32163, 68.6643));
    tempPattern.append(Vector(0, 15.3906, 68.0173));
    tempPattern.append(Vector(0, 27.6522, 61.8448));
    tempPattern.append(Vector(0, 34.2183, 60.3999));

    Recoil_pattern_length = tempPattern.len()
    Recoil_bullet_delay = 667/Pattern_ROF;
    return tempPattern
    }
::Pattern_m249<-function(){
    local tempPattern = []
    tempPattern.append(Vector(0, 0.264956, -0.520724));
    tempPattern.append(Vector(0, 1.29905, 1.32053));
    tempPattern.append(Vector(0, 5.47144, 7.81977));
    tempPattern.append(Vector(0, 11.3176, 19.0721));
    tempPattern.append(Vector(0, 21.3514, 30.903));
    tempPattern.append(Vector(0, 30.0005, 43.1608));
    tempPattern.append(Vector(0, 24.1609, 55.6742));
    tempPattern.append(Vector(0, 12.6653, 66.5665));
    tempPattern.append(Vector(0, 1.27262, 75.6581));
    tempPattern.append(Vector(0, -10.7116, 84.6327));
    tempPattern.append(Vector(0, -16.7237, 90.1836));
    tempPattern.append(Vector(0, -21.912, 98.0212));
    tempPattern.append(Vector(0, -11.8215, 102.135));
    tempPattern.append(Vector(0, -12.0513, 105.934));
    tempPattern.append(Vector(0, -15.0875, 108.361));
    tempPattern.append(Vector(0, -18.2613, 111.156));
    tempPattern.append(Vector(0, -23.2593, 113.839));
    tempPattern.append(Vector(0, -23.1812, 115.893));
    tempPattern.append(Vector(0, -21.1805, 115.585));
    tempPattern.append(Vector(0, -12.9586, 113.9));
    tempPattern.append(Vector(0, 2.773, 112.456));
    tempPattern.append(Vector(0, 5.20844, 112.859));
    tempPattern.append(Vector(0, 9.47094, 112.538));
    tempPattern.append(Vector(0, 20.0282, 112.796));
    tempPattern.append(Vector(0, 27.4359, 111.563));
    tempPattern.append(Vector(0, 31.6931, 112.674));
    tempPattern.append(Vector(0, 25.9231, 112.977));
    tempPattern.append(Vector(0, 10.5644, 110.15));
    tempPattern.append(Vector(0, 4.5566, 111.27));
    tempPattern.append(Vector(0, 5.96952, 112.708));
    tempPattern.append(Vector(0, -0.911185, 109.969));
    tempPattern.append(Vector(0, -13.8738, 106.54));
    tempPattern.append(Vector(0, -15.7465, 107.906));
    tempPattern.append(Vector(0, -11.1663, 111.21));
    tempPattern.append(Vector(0, -4.10283, 114.232));
    tempPattern.append(Vector(0, -7.4381, 115.673));
    tempPattern.append(Vector(0, -4.43367, 116.054));
    tempPattern.append(Vector(0, 5.96888, 115.876));
    tempPattern.append(Vector(0, 12.1386, 116.608));
    tempPattern.append(Vector(0, 7.62849, 115.788));
    tempPattern.append(Vector(0, -0.511094, 116.173));
    tempPattern.append(Vector(0, -7.83385, 119.125));
    tempPattern.append(Vector(0, -0.580591, 120.664));
    tempPattern.append(Vector(0, -5.23873, 121.05));
    tempPattern.append(Vector(0, -16.0477, 115.764));
    tempPattern.append(Vector(0, -22.0562, 116.321));
    tempPattern.append(Vector(0, -18.8224, 117.695));
    tempPattern.append(Vector(0, -17.144, 118.6));
    tempPattern.append(Vector(0, -12.2699, 118.857));
    tempPattern.append(Vector(0, -0.198833, 116.163));
    tempPattern.append(Vector(0, 8.53199, 114.611));
    tempPattern.append(Vector(0, 1.98984, 112.739));
    tempPattern.append(Vector(0, -2.19942, 111.67));
    tempPattern.append(Vector(0, -8.34108, 112.164));
    tempPattern.append(Vector(0, -13.925, 114.178));
    tempPattern.append(Vector(0, -7.84566, 113.913));
    tempPattern.append(Vector(0, -7.87092, 113.797));
    tempPattern.append(Vector(0, -17.4449, 112.404));
    tempPattern.append(Vector(0, -28.6365, 109.901));
    tempPattern.append(Vector(0, -28.2809, 111.178));
    tempPattern.append(Vector(0, -20.3915, 113.659));
    tempPattern.append(Vector(0, -24.4154, 112.53));
    tempPattern.append(Vector(0, -28.1607, 113.35));
    tempPattern.append(Vector(0, -27.7281, 115.866));
    tempPattern.append(Vector(0, -24.1151, 118.964));
    tempPattern.append(Vector(0, -7.02411, 105.794));
    tempPattern.append(Vector(0, 5.56254, 95.8757));
    tempPattern.append(Vector(0, 15.6676, 87.8997));
    tempPattern.append(Vector(0, 26.0324, 82.966));
    tempPattern.append(Vector(0, 34.6363, 81.0883));
    tempPattern.append(Vector(0, 27.2907, 83.7215));
    tempPattern.append(Vector(0, 14.3273, 88.3025));
    tempPattern.append(Vector(0, -0.414506, 91.331));
    tempPattern.append(Vector(0, -12.1115, 94.023));
    tempPattern.append(Vector(0, -17.5104, 99.1687));
    tempPattern.append(Vector(0, -20.962, 103.748));
    tempPattern.append(Vector(0, -12.5595, 106.986));
    tempPattern.append(Vector(0, -12.8775, 108.282));
    tempPattern.append(Vector(0, -16.5711, 110.134));
    tempPattern.append(Vector(0, -17.4578, 113.071));
    tempPattern.append(Vector(0, -23.4442, 114.894));
    tempPattern.append(Vector(0, -24.2356, 115.605));
    tempPattern.append(Vector(0, -21.804, 116.133));
    tempPattern.append(Vector(0, -13.4553, 114.589));
    tempPattern.append(Vector(0, 1.71407, 112.858));
    tempPattern.append(Vector(0, 4.5201, 112.604));
    tempPattern.append(Vector(0, 9.9124, 113.578));
    tempPattern.append(Vector(0, 19.1522, 111.749));
    tempPattern.append(Vector(0, 28.2807, 112.192));
    tempPattern.append(Vector(0, 31.7491, 112.925));
    tempPattern.append(Vector(0, 26.2155, 112.802));
    tempPattern.append(Vector(0, 10.0285, 110.719));
    tempPattern.append(Vector(0, 4.57953, 110.97));
    tempPattern.append(Vector(0, 6.80178, 112.49));
    tempPattern.append(Vector(0, -1.09317, 110.299));
    tempPattern.append(Vector(0, -13.9955, 106.574));
    tempPattern.append(Vector(0, -16.4196, 107.737));
    tempPattern.append(Vector(0, -11.7706, 110.904));
    tempPattern.append(Vector(0, -3.87278, 114.133));
    tempPattern.append(Vector(0, -7.07732, 116.042));
    Recoil_pattern_length = tempPattern.len()
    Recoil_bullet_delay = 750/Pattern_ROF;
    return tempPattern
    }
::Pattern_m4a1_s<-function(){
    local tempPattern = []
    tempPattern.append(Vector(0, 0.0640302, -0.0011925));
    tempPattern.append(Vector(0, -0.39219, 1.4672));
    tempPattern.append(Vector(0, -0.335322, 3.04635));
    tempPattern.append(Vector(0, 1.10769, 9.8263));
    tempPattern.append(Vector(0, -0.622016, 18.5812));
    tempPattern.append(Vector(0, 2.297, 28.2453));
    tempPattern.append(Vector(0, 3.65439, 38.1264));
    tempPattern.append(Vector(0, -2.62676, 43.9474));
    tempPattern.append(Vector(0, -6.22886, 49.1136));
    tempPattern.append(Vector(0, -14.9198, 49.7852));
    tempPattern.append(Vector(0, -11.8045, 53.744));
    tempPattern.append(Vector(0, -4.50508, 56.8206));
    tempPattern.append(Vector(0, 6.92641, 55.3031));
    tempPattern.append(Vector(0, 15.8438, 54.1246));
    tempPattern.append(Vector(0, 23.9235, 51.1128));
    tempPattern.append(Vector(0, 23.3407, 53.9032));
    tempPattern.append(Vector(0, 19.4746, 57.5341));
    tempPattern.append(Vector(0, 23.6227, 56.0644));
    tempPattern.append(Vector(0, 28.4127, 53.8674));
    tempPattern.append(Vector(0, 26.5942, 55.2605));
    Recoil_pattern_length = tempPattern.len()
    Recoil_bullet_delay = 667/Pattern_ROF;
    return tempPattern
    }
::Pattern_m4a4<-function(){
    local tempPattern = []
    tempPattern.append(Vector(0, -0.204929, 0.0990235));
    tempPattern.append(Vector(0, -0.294754, 1.51971));
    tempPattern.append(Vector(0, -0.830436, 6.19596));
    tempPattern.append(Vector(0, 1.75247, 15.1392));
    tempPattern.append(Vector(0, -0.727036, 26.8384));
    tempPattern.append(Vector(0, 2.77919, 38.4271));
    tempPattern.append(Vector(0, 5.20269, 50.4048));
    tempPattern.append(Vector(0, -2.63803, 58.8467));
    tempPattern.append(Vector(0, -7.77162, 66.2308));
    tempPattern.append(Vector(0, -19.1882, 67.5606));
    tempPattern.append(Vector(0, -16.2584, 72.0641));
    tempPattern.append(Vector(0, -8.05054, 76.1903));
    tempPattern.append(Vector(0, 6.80352, 75.0396));
    tempPattern.append(Vector(0, 18.8679, 73.8169));
    tempPattern.append(Vector(0, 31.6067, 69.9236));
    tempPattern.append(Vector(0, 32.0866, 72.8959));
    tempPattern.append(Vector(0, 27.8285, 76.2118));
    tempPattern.append(Vector(0, 32.9029, 75.8799));
    tempPattern.append(Vector(0, 39.9273, 73.3317));
    tempPattern.append(Vector(0, 39.0383, 75.3087));
    tempPattern.append(Vector(0, 22.2132, 75.9999));
    tempPattern.append(Vector(0, 17.1266, 78.5903));
    tempPattern.append(Vector(0, 3.47049, 78.5823));
    tempPattern.append(Vector(0, -0.953999, 80.8462));
    tempPattern.append(Vector(0, -6.76998, 82.0547));
    tempPattern.append(Vector(0, -1.58251, 83.2538));
    tempPattern.append(Vector(0, -4.22237, 83.8966));
    tempPattern.append(Vector(0, -5.87561, 85.5079));
    tempPattern.append(Vector(0, -7.75125, 86.0776));
    tempPattern.append(Vector(0, -10.0688, 87.2595));
    Recoil_pattern_length = tempPattern.len()
    Recoil_bullet_delay = 667/Pattern_ROF;
    return tempPattern
    }
::Pattern_mac10<-function(){
    local tempPattern = []
    tempPattern.append(Vector(0, -0.138112, -0.142281));
    tempPattern.append(Vector(0, 1.36632, 0.569262));
    tempPattern.append(Vector(0, 1.71082, 1.70828));
    tempPattern.append(Vector(0, 1.14909, 5.31793));
    tempPattern.append(Vector(0, -0.414587, 12.6948));
    tempPattern.append(Vector(0, -5.65321, 21.7048));
    tempPattern.append(Vector(0, -11.0726, 32.8205));
    tempPattern.append(Vector(0, -15.3658, 42.663));
    tempPattern.append(Vector(0, -13.0535, 51.7345));
    tempPattern.append(Vector(0, -17.3234, 57.5017));
    tempPattern.append(Vector(0, -18.9009, 62.9263));
    tempPattern.append(Vector(0, -21.2983, 67.32));
    tempPattern.append(Vector(0, -19.7451, 70.7348));
    tempPattern.append(Vector(0, -18.8786, 73.7149));
    tempPattern.append(Vector(0, -14.4794, 76.6815));
    tempPattern.append(Vector(0, -3.67141, 75.4876));
    tempPattern.append(Vector(0, 10.3505, 71.5729));
    tempPattern.append(Vector(0, 10.7601, 71.0233));
    tempPattern.append(Vector(0, 16.3183, 70.1319));
    tempPattern.append(Vector(0, 13.8466, 71.2595));
    tempPattern.append(Vector(0, 16.9223, 71.3675));
    tempPattern.append(Vector(0, 23.3953, 69.6988));
    tempPattern.append(Vector(0, 27.7262, 68.9727));
    tempPattern.append(Vector(0, 20.3491, 69.94));
    tempPattern.append(Vector(0, 13.4928, 71.6283));
    tempPattern.append(Vector(0, 6.36328, 73.32));
    tempPattern.append(Vector(0, -6.08412, 71.2885));
    tempPattern.append(Vector(0, -6.30747, 71.415));
    tempPattern.append(Vector(0, 4.09742, 69.8858));
    tempPattern.append(Vector(0, 3.11252, 70.2909));
    Recoil_pattern_length = tempPattern.len()
    Recoil_bullet_delay = 800/Pattern_ROF;
    return tempPattern
    }
::Pattern_mp7<-function(){
    local tempPattern = []
    tempPattern.append(Vector(0, -0.298349, -0.0612312));
    tempPattern.append(Vector(0, -0.204647, 1.23359));
    tempPattern.append(Vector(0, 0.349119, 1.96667));
    tempPattern.append(Vector(0, 1.53216, 4.04729));
    tempPattern.append(Vector(0, 4.44958, 9.67437));
    tempPattern.append(Vector(0, 9.13067, 16.8832));
    tempPattern.append(Vector(0, 8.47962, 24.8364));
    tempPattern.append(Vector(0, 13.1217, 30.9791));
    tempPattern.append(Vector(0, 14.9336, 37.7748));
    tempPattern.append(Vector(0, 19.9747, 39.9907));
    tempPattern.append(Vector(0, 23.7818, 42.838));
    tempPattern.append(Vector(0, 19.8359, 46.7594));
    tempPattern.append(Vector(0, 10.2978, 48.9135));
    tempPattern.append(Vector(0, 0.519179, 48.3729));
    tempPattern.append(Vector(0, -6.42923, 48.132));
    tempPattern.append(Vector(0, -6.80428, 50.4445));
    tempPattern.append(Vector(0, -3.60968, 53.042));
    tempPattern.append(Vector(0, -2.39281, 55.8069));
    tempPattern.append(Vector(0, -0.197331, 57.5008));
    tempPattern.append(Vector(0, -1.99075, 58.3773));
    tempPattern.append(Vector(0, -1.12339, 59.921));
    tempPattern.append(Vector(0, 6.28575, 57.9457));
    tempPattern.append(Vector(0, 16.4603, 52.3968));
    tempPattern.append(Vector(0, 17.9815, 51.4248));
    tempPattern.append(Vector(0, 22.3318, 50.2525));
    tempPattern.append(Vector(0, 22.2642, 51.1783));
    tempPattern.append(Vector(0, 23.1046, 51.1617));
    tempPattern.append(Vector(0, 23.2119, 51.5407));
    tempPattern.append(Vector(0, 24.9242, 51.3308));
    tempPattern.append(Vector(0, 25.6458, 52.7719));
    Recoil_pattern_length = tempPattern.len()
    Recoil_bullet_delay = 750/Pattern_ROF;
    return tempPattern
    }
::Pattern_mp5sd<-function(){
    local tempPattern = []
    tempPattern.append(Vector(0, -0.109721, 0.0888695));
    tempPattern.append(Vector(0, 0.0245035, 1.21689));
    tempPattern.append(Vector(0, 0.292041, 1.82004));
    tempPattern.append(Vector(0, 1.2071, 3.99566));
    tempPattern.append(Vector(0, 4.57202, 9.68057));
    tempPattern.append(Vector(0, 9.11965, 16.8197));
    tempPattern.append(Vector(0, 8.55647, 24.711));
    tempPattern.append(Vector(0, 13.1492, 30.8343));
    tempPattern.append(Vector(0, 14.5732, 37.6213));
    tempPattern.append(Vector(0, 20.1675, 40.033));
    tempPattern.append(Vector(0, 23.4783, 42.5519));
    tempPattern.append(Vector(0, 19.7513, 47.1858));
    tempPattern.append(Vector(0, 10.0776, 48.6132));
    tempPattern.append(Vector(0, 0.589337, 48.7247));
    tempPattern.append(Vector(0, -6.26598, 48.3865));
    tempPattern.append(Vector(0, -6.61265, 50.6864));
    tempPattern.append(Vector(0, -3.73169, 53.1179));
    tempPattern.append(Vector(0, -2.05104, 56.0812));
    tempPattern.append(Vector(0, -0.53223, 57.5465));
    tempPattern.append(Vector(0, -1.84178, 58.2058));
    tempPattern.append(Vector(0, -1.24348, 60.0446));
    tempPattern.append(Vector(0, 6.374, 58.2359));
    tempPattern.append(Vector(0, 16.554, 52.2683));
    tempPattern.append(Vector(0, 18.2625, 51.5184));
    tempPattern.append(Vector(0, 22.413, 50.2455));
    tempPattern.append(Vector(0, 22.0997, 51.1194));
    tempPattern.append(Vector(0, 22.8751, 51.1234));
    tempPattern.append(Vector(0, 22.8635, 51.6621));
    tempPattern.append(Vector(0, 25.0728, 51.4321));
    tempPattern.append(Vector(0, 25.1369, 52.7252));
    Recoil_pattern_length = tempPattern.len()
    Recoil_bullet_delay = 750/Pattern_ROF;
    return tempPattern
    }
::Pattern_mp9<-function(){
    local tempPattern = []
    tempPattern.append(Vector(0, -0.275478, -0.111194));
    tempPattern.append(Vector(0, 0.280279, 1.32148));
    tempPattern.append(Vector(0, 1.05568, 3.06081));
    tempPattern.append(Vector(0, 0.0524503, 9.12355));
    tempPattern.append(Vector(0, 0.611656, 18.8874));
    tempPattern.append(Vector(0, -3.95792, 29.1365));
    tempPattern.append(Vector(0, -3.46847, 40.8769));
    tempPattern.append(Vector(0, 0.237303, 51.03));
    tempPattern.append(Vector(0, -5.10815, 58.3799));
    tempPattern.append(Vector(0, -14.7874, 63));
    tempPattern.append(Vector(0, -26.6082, 63.1752));
    tempPattern.append(Vector(0, -38.0469, 60.8424));
    tempPattern.append(Vector(0, -38.3092, 65.4151));
    tempPattern.append(Vector(0, -38.9503, 70.6092));
    tempPattern.append(Vector(0, -26.6173, 74.3257));
    tempPattern.append(Vector(0, -20.9432, 78.6633));
    tempPattern.append(Vector(0, -11.6638, 82.1929));
    tempPattern.append(Vector(0, -5.14621, 85.4636));
    tempPattern.append(Vector(0, 5.94518, 84.453));
    tempPattern.append(Vector(0, 20.0696, 80.4692));
    tempPattern.append(Vector(0, 17.8572, 80.8898));
    tempPattern.append(Vector(0, 10.2719, 82.3808));
    tempPattern.append(Vector(0, -0.042957, 83.69));
    tempPattern.append(Vector(0, -1.43935, 86.3403));
    tempPattern.append(Vector(0, 7.4483, 84.9017));
    tempPattern.append(Vector(0, 19.4502, 81.8116));
    tempPattern.append(Vector(0, 22.9115, 83.0215));
    tempPattern.append(Vector(0, 27.9602, 83.2721));
    tempPattern.append(Vector(0, 23.4055, 85.1803));
    tempPattern.append(Vector(0, 20.4071, 87.2756));
    Recoil_pattern_length = tempPattern.len()
    Recoil_bullet_delay = 857/Pattern_ROF;
    return tempPattern
    }
::Pattern_p90<-function(){
    local tempPattern = []
    tempPattern.append(Vector(0, -0.053771, -0.0608643));
    tempPattern.append(Vector(0, 0.838508, 1.34677));
    tempPattern.append(Vector(0, 0.27959, 1.79463));
    tempPattern.append(Vector(0, 0.302993, 4.89215));
    tempPattern.append(Vector(0, 1.32963, 11.6256));
    tempPattern.append(Vector(0, 6.83403, 18.8931));
    tempPattern.append(Vector(0, 13.469, 25.4821));
    tempPattern.append(Vector(0, 17.9904, 33.6897));
    tempPattern.append(Vector(0, 13.5744, 40.8727));
    tempPattern.append(Vector(0, 9.48941, 47.7941));
    tempPattern.append(Vector(0, 8.12774, 53.2973));
    tempPattern.append(Vector(0, 6.63047, 59.176));
    tempPattern.append(Vector(0, 7.97613, 63.3336));
    tempPattern.append(Vector(0, 14.4746, 63.2204));
    tempPattern.append(Vector(0, 16.8956, 64.3803));
    tempPattern.append(Vector(0, 20.4624, 66.1474));
    tempPattern.append(Vector(0, 25.8194, 65.8491));
    tempPattern.append(Vector(0, 19.3791, 66.6716));
    tempPattern.append(Vector(0, 11.0385, 67.2187));
    tempPattern.append(Vector(0, 6.46255, 67.7348));
    tempPattern.append(Vector(0, 1.08211, 68.4229));
    tempPattern.append(Vector(0, -5.44095, 68.6333));
    tempPattern.append(Vector(0, -12.9227, 67.4102));
    tempPattern.append(Vector(0, -11.2404, 68.2423));
    tempPattern.append(Vector(0, -13.7022, 68.7613));
    tempPattern.append(Vector(0, -8.16678, 68.5941));
    tempPattern.append(Vector(0, 0.554005, 67.8829));
    tempPattern.append(Vector(0, 10.9555, 64.8923));
    tempPattern.append(Vector(0, 11.326, 65.8557));
    tempPattern.append(Vector(0, 8.59808, 67.3405));
    tempPattern.append(Vector(0, 9.79873, 67.9843));
    tempPattern.append(Vector(0, 12.6665, 69.1254));
    tempPattern.append(Vector(0, 10.0835, 70.5731));
    tempPattern.append(Vector(0, 2.03886, 69.9962));
    tempPattern.append(Vector(0, -1.60978, 70.1739));
    tempPattern.append(Vector(0, -0.00150596, 70.0952));
    tempPattern.append(Vector(0, 1.39445, 71.1753));
    tempPattern.append(Vector(0, 7.73535, 70.2413));
    tempPattern.append(Vector(0, 12.56, 69.5292));
    tempPattern.append(Vector(0, 12.2308, 70.8895));
    tempPattern.append(Vector(0, 6.63936, 70.8936));
    tempPattern.append(Vector(0, -3.84464, 67.6905));
    tempPattern.append(Vector(0, -7.95553, 67.5688));
    tempPattern.append(Vector(0, -13.805, 68.1559));
    tempPattern.append(Vector(0, -21.5008, 67.8385));
    tempPattern.append(Vector(0, -26.5199, 68.2954));
    tempPattern.append(Vector(0, -32.0865, 66.2681));
    tempPattern.append(Vector(0, -29.8392, 67.1199));
    tempPattern.append(Vector(0, -24.8144, 68.2773));
    tempPattern.append(Vector(0, -26.5234, 67.5021));
    Recoil_pattern_length = tempPattern.len()
    Recoil_bullet_delay = 857/Pattern_ROF;
    return tempPattern
    }
::Pattern_ppbizon<-function(){
    local tempPattern = []
    tempPattern.append(Vector(0, -0.447544, 0.0427362));
    tempPattern.append(Vector(0, 0.316626, 1.26241));
    tempPattern.append(Vector(0, 1.40451, 1.90646));
    tempPattern.append(Vector(0, 3.14583, 5.97365));
    tempPattern.append(Vector(0, 7.31691, 13.1915));
    tempPattern.append(Vector(0, 13.5547, 20.405));
    tempPattern.append(Vector(0, 11.8764, 29.8839));
    tempPattern.append(Vector(0, 7.23099, 38.8779));
    tempPattern.append(Vector(0, 7.14478, 47.1866));
    tempPattern.append(Vector(0, -1.80829, 50.7415));
    tempPattern.append(Vector(0, -9.38673, 54.4664));
    tempPattern.append(Vector(0, -11.5259, 59.0527));
    tempPattern.append(Vector(0, -19.4004, 60.1104));
    tempPattern.append(Vector(0, -15.3471, 62.5802));
    tempPattern.append(Vector(0, -3.23824, 61.032));
    tempPattern.append(Vector(0, -2.52936, 62.2589));
    tempPattern.append(Vector(0, -9.0228, 62.7334));
    tempPattern.append(Vector(0, -11.8263, 64.8202));
    tempPattern.append(Vector(0, -10.1986, 66.8027));
    tempPattern.append(Vector(0, -13.5209, 67.7391));
    tempPattern.append(Vector(0, -19.9012, 67.0592));
    tempPattern.append(Vector(0, -27.238, 64.4596));
    tempPattern.append(Vector(0, -30.4729, 63.5282));
    tempPattern.append(Vector(0, -33.4731, 62.3125));
    tempPattern.append(Vector(0, -36.635, 61.2686));
    tempPattern.append(Vector(0, -38.0613, 61.5658));
    tempPattern.append(Vector(0, -36.1977, 62.5146));
    tempPattern.append(Vector(0, -34.1914, 63.6845));
    tempPattern.append(Vector(0, -33.7341, 64.9994));
    tempPattern.append(Vector(0, -23.1564, 66.4767));
    tempPattern.append(Vector(0, -21.1272, 66.7546));
    tempPattern.append(Vector(0, -20.4039, 67.7369));
    tempPattern.append(Vector(0, -24.8894, 66.2776));
    tempPattern.append(Vector(0, -17.5013, 67.381));
    tempPattern.append(Vector(0, -18.3604, 67.0715));
    tempPattern.append(Vector(0, -21.569, 64.9263));
    tempPattern.append(Vector(0, -15.3905, 64.6277));
    tempPattern.append(Vector(0, -16.2213, 65.3817));
    tempPattern.append(Vector(0, -12.7295, 67.113));
    tempPattern.append(Vector(0, -13.2139, 66.708));
    tempPattern.append(Vector(0, -20.5716, 63.1313));
    tempPattern.append(Vector(0, -26.2496, 60.9056));
    tempPattern.append(Vector(0, -33.8384, 58.8671));
    tempPattern.append(Vector(0, -37.1935, 57.4264));
    tempPattern.append(Vector(0, -32.9364, 59.9501));
    tempPattern.append(Vector(0, -33.2724, 61.3704));
    tempPattern.append(Vector(0, -38.2219, 60.4079));
    tempPattern.append(Vector(0, -43.8941, 56.2017));
    tempPattern.append(Vector(0, -33.9595, 58.6706));
    tempPattern.append(Vector(0, -24.9787, 61.6281));
    tempPattern.append(Vector(0, -24.3008, 62.6835));
    tempPattern.append(Vector(0, -27.3735, 62.2476));
    tempPattern.append(Vector(0, -27.5756, 62.1374));
    tempPattern.append(Vector(0, -28.134, 62.763));
    tempPattern.append(Vector(0, -32.4158, 60.8212));
    tempPattern.append(Vector(0, -26.3547, 62.2706));
    tempPattern.append(Vector(0, -19.2559, 63.1172));
    tempPattern.append(Vector(0, -11.2684, 63.9552));
    tempPattern.append(Vector(0, 2.05698, 61.6049));
    tempPattern.append(Vector(0, 5.1962, 62.1213));
    tempPattern.append(Vector(0, 2.97309, 64.4404));
    tempPattern.append(Vector(0, -4.82176, 64.2352));
    tempPattern.append(Vector(0, -0.674022, 64.2422));
    tempPattern.append(Vector(0, 2.32859, 65.7153));
    Recoil_pattern_length = tempPattern.len()
    Recoil_bullet_delay = 750/Pattern_ROF;
    return tempPattern
    }
::Pattern_scar_20<-function(){
    local tempPattern = []
    tempPattern.append(Vector(0, 0.0023759, 0.0378218));
    tempPattern.append(Vector(0, 0.252377, 1.07236));
    tempPattern.append(Vector(0, -0.0743468, 1.5529));
    tempPattern.append(Vector(0, -0.294085, 1.71374));
    tempPattern.append(Vector(0, 0.171005, 4.58495));
    tempPattern.append(Vector(0, 2.11869, 8.58635));
    tempPattern.append(Vector(0, 0.104294, 9.86432));
    tempPattern.append(Vector(0, 0.517636, 10.8453));
    tempPattern.append(Vector(0, 0.0492849, 12.5836));
    tempPattern.append(Vector(0, -2.07866, 13.7332));
    tempPattern.append(Vector(0, 0.425092, 10.9372));
    tempPattern.append(Vector(0, 0.208947, 9.64447));
    tempPattern.append(Vector(0, -0.812749, 8.01846));
    tempPattern.append(Vector(0, -2.02737, 9.97103));
    tempPattern.append(Vector(0, -1.75686, 11.0176));
    tempPattern.append(Vector(0, -2.59052, 11.1206));
    tempPattern.append(Vector(0, -2.0752, 13.6786));
    tempPattern.append(Vector(0, -0.370969, 12.6063));
    tempPattern.append(Vector(0, -0.0952038, 10.9787));
    tempPattern.append(Vector(0, 0.264437, 9.55156));
    Recoil_pattern_length = tempPattern.len()
    Recoil_bullet_delay = 0.5;
    return tempPattern
    }
::Pattern_ump45<-function(){
    local tempPattern = []
    tempPattern.append(Vector(0, 0.017181, -0.00400861));
    tempPattern.append(Vector(0, 0.127488, 1.42454));
    tempPattern.append(Vector(0, 1.76807, 5.99093));
    tempPattern.append(Vector(0, 2.77047, 15.4573));
    tempPattern.append(Vector(0, 5.12402, 27.2445));
    tempPattern.append(Vector(0, 10.6702, 38.7886));
    tempPattern.append(Vector(0, 10.8596, 50.5756));
    tempPattern.append(Vector(0, 5.93661, 59.6481));
    tempPattern.append(Vector(0, 7.77094, 66.2541));
    tempPattern.append(Vector(0, 3.38516, 72.6055));
    tempPattern.append(Vector(0, -5.90506, 75.1281));
    tempPattern.append(Vector(0, -12.7777, 78.5088));
    tempPattern.append(Vector(0, -12.9544, 81.3597));
    tempPattern.append(Vector(0, -15.1373, 83.4502));
    tempPattern.append(Vector(0, -15.1896, 85.2485));
    tempPattern.append(Vector(0, -19.3565, 84.6479));
    tempPattern.append(Vector(0, -22.6764, 84.4891));
    tempPattern.append(Vector(0, -15.4052, 86.3088));
    tempPattern.append(Vector(0, -6.42869, 85.9089));
    tempPattern.append(Vector(0, -6.81053, 86.0212));
    tempPattern.append(Vector(0, -13.2996, 84.5667));
    tempPattern.append(Vector(0, -21.7187, 81.9763));
    tempPattern.append(Vector(0, -19.2882, 82.1846));
    tempPattern.append(Vector(0, -9.30669, 82.7397));
    tempPattern.append(Vector(0, -7.1616, 82.9117));
    Recoil_pattern_length = tempPattern.len()
    Recoil_bullet_delay = 667/Pattern_ROF;
    return tempPattern
    }
::Pattern_negev<-function(){
    local tempPattern = []
    tempPattern.append(Vector(0, -1.0452, 0.181801));
    tempPattern.append(Vector(0, 0.684722, 2.47982));
    tempPattern.append(Vector(0, -0.34781, 4.90756));
    tempPattern.append(Vector(0, 0.111109, 13.6647));
    tempPattern.append(Vector(0, -0.639863, 25.056));
    tempPattern.append(Vector(0, -0.655625, 35.7365));
    tempPattern.append(Vector(0, 0.276238, 48.5199));
    tempPattern.append(Vector(0, 0.501991, 57.5034));
    tempPattern.append(Vector(0, 0.125776, 66.2232));
    tempPattern.append(Vector(0, 0.537827, 73.5911));
    tempPattern.append(Vector(0, -0.863923, 80.1574));
    tempPattern.append(Vector(0, 0.177949, 84.3169));
    tempPattern.append(Vector(0, 0.0693363, 85.9453));
    tempPattern.append(Vector(0, 0.342498, 87.5896));
    tempPattern.append(Vector(0, -0.650937, 89.0211));
    tempPattern.append(Vector(0, -0.0488708, 90.6039));
    tempPattern.append(Vector(0, -0.869692, 92.3394));
    tempPattern.append(Vector(0, 0.128195, 93.0916));
    tempPattern.append(Vector(0, -0.65192, 93.5914));
    tempPattern.append(Vector(0, 0.654261, 93.1711));
    tempPattern.append(Vector(0, -0.649093, 93.544));
    tempPattern.append(Vector(0, -0.664096, 92.5452));
    tempPattern.append(Vector(0, -0.0165798, 91.7756));
    tempPattern.append(Vector(0, 0.722357, 90.6973));
    tempPattern.append(Vector(0, -0.176613, 92.3596));
    tempPattern.append(Vector(0, 0.445703, 94.3309));
    tempPattern.append(Vector(0, 0.660491, 94.9334));
    tempPattern.append(Vector(0, -0.273346, 93.4064));
    tempPattern.append(Vector(0, 0.442427, 94.0144));
    tempPattern.append(Vector(0, 0.00968812, 94.8159));
    tempPattern.append(Vector(0, 0.507855, 95.7818));
    tempPattern.append(Vector(0, -0.00965523, 97.7187));
    tempPattern.append(Vector(0, -0.694893, 99.0387));
    tempPattern.append(Vector(0, 0.827676, 99.2853));
    tempPattern.append(Vector(0, -0.00367096, 100.324));
    tempPattern.append(Vector(0, -0.66621, 101.967));
    tempPattern.append(Vector(0, 0.0440284, 102.154));
    tempPattern.append(Vector(0, 0.72493, 101.363));
    tempPattern.append(Vector(0, -0.686366, 99.4521));
    tempPattern.append(Vector(0, 0.752815, 96.845));
    tempPattern.append(Vector(0, 0.0652327, 96.662));
    tempPattern.append(Vector(0, -0.00489216, 96.1325));
    tempPattern.append(Vector(0, -0.684651, 96.7894));
    tempPattern.append(Vector(0, -0.798074, 99.2404));
    tempPattern.append(Vector(0, 0.182496, 98.2471));
    tempPattern.append(Vector(0, 0.045799, 97.741));
    tempPattern.append(Vector(0, 0.178696, 97.5443));
    tempPattern.append(Vector(0, 0.655272, 97.8274));
    tempPattern.append(Vector(0, 0.446272, 98.1454));
    tempPattern.append(Vector(0, 0.141887, 96.4838));
    tempPattern.append(Vector(0, 0.446057, 96.7198));
    tempPattern.append(Vector(0, -0.332823, 97.7567));
    tempPattern.append(Vector(0, -0.987392, 99.8974));
    tempPattern.append(Vector(0, -0.0282396, 100.442));
    tempPattern.append(Vector(0, 1.04873, 99.2477));
    tempPattern.append(Vector(0, -0.502191, 98.4268));
    tempPattern.append(Vector(0, 0.442904, 97.257));
    tempPattern.append(Vector(0, 0.138553, 96.9891));
    tempPattern.append(Vector(0, 0.76046, 98.3758));
    tempPattern.append(Vector(0, 0.616733, 98.3417));
    tempPattern.append(Vector(0, 0.029209, 97.4761));
    tempPattern.append(Vector(0, -0.053137, 98.2964));
    tempPattern.append(Vector(0, -0.0325101, 99.3777));
    tempPattern.append(Vector(0, -0.0407168, 100.665));
    tempPattern.append(Vector(0, -0.289713, 102.979));
    tempPattern.append(Vector(0, 0.195742, 99.1691));
    tempPattern.append(Vector(0, 0.27919, 91.6243));
    tempPattern.append(Vector(0, -0.178183, 85.1034));
    tempPattern.append(Vector(0, 0.522077, 82.1021));
    tempPattern.append(Vector(0, 0.675169, 80.5008));
    tempPattern.append(Vector(0, -0.345105, 79.7674));
    tempPattern.append(Vector(0, 0.0921143, 82.7549));
    tempPattern.append(Vector(0, -0.236102, 84.1561));
    tempPattern.append(Vector(0, 0.156104, 86.9525));
    tempPattern.append(Vector(0, 0.18197, 89.4001));
    tempPattern.append(Vector(0, 0.087811, 91.1744));
    tempPattern.append(Vector(0, -0.667634, 90.4792));
    tempPattern.append(Vector(0, -0.00211756, 91.3724));
    tempPattern.append(Vector(0, 0.0996259, 91.7232));
    tempPattern.append(Vector(0, -0.537819, 93.0846));
    tempPattern.append(Vector(0, -0.00554867, 93.7571));
    tempPattern.append(Vector(0, 1.04621, 93.3472));
    tempPattern.append(Vector(0, 0.197057, 95.21));
    tempPattern.append(Vector(0, -0.171757, 94.0376));
    tempPattern.append(Vector(0, -0.985468, 94.1007));
    tempPattern.append(Vector(0, -0.684721, 92.2388));
    tempPattern.append(Vector(0, 0.196883, 92.5104));
    tempPattern.append(Vector(0, 0.0438698, 91.4187));
    tempPattern.append(Vector(0, 0.182142, 92.3723));
    tempPattern.append(Vector(0, 0.0161708, 94.4618));
    tempPattern.append(Vector(0, -0.273413, 94.16));
    tempPattern.append(Vector(0, -0.316088, 94.5525));
    tempPattern.append(Vector(0, -0.818222, 94.5815));
    tempPattern.append(Vector(0, -0.0758701, 94.9028));
    tempPattern.append(Vector(0, 0.128371, 97.2401));
    tempPattern.append(Vector(0, 0.156629, 97.4277));
    tempPattern.append(Vector(0, -0.67977, 98.0269));
    tempPattern.append(Vector(0, 0.296812, 100.164));
    tempPattern.append(Vector(0, -0.869625, 101.015));
    tempPattern.append(Vector(0, -0.670062, 101.384));
    tempPattern.append(Vector(0, -0.0205994, 101.736));
    tempPattern.append(Vector(0, -0.020598, 101.544));
    tempPattern.append(Vector(0, 0.022874, 99.6337));
    tempPattern.append(Vector(0, -0.668994, 96.7346));
    tempPattern.append(Vector(0, 0.024176, 96.5747));
    tempPattern.append(Vector(0, -0.501791, 96.0606));
    tempPattern.append(Vector(0, -0.800155, 96.7291));
    tempPattern.append(Vector(0, 0.557092, 99.0007));
    tempPattern.append(Vector(0, -0.0846992, 98.1044));
    tempPattern.append(Vector(0, 0.112834, 97.7065));
    tempPattern.append(Vector(0, -0.669066, 97.0557));
    tempPattern.append(Vector(0, -0.33287, 98.1804));
    tempPattern.append(Vector(0, -0.586765, 97.6949));
    tempPattern.append(Vector(0, 0.524527, 97.0957));
    tempPattern.append(Vector(0, 0.0228463, 96.0653));
    tempPattern.append(Vector(0, 0.212188, 98.7375));
    tempPattern.append(Vector(0, 0.685976, 100.345));
    tempPattern.append(Vector(0, -0.653434, 100.48));
    tempPattern.append(Vector(0, -0.0350315, 99.2728));
    tempPattern.append(Vector(0, 0.90711, 98.5339));
    tempPattern.append(Vector(0, -0.0677155, 97.6612));
    tempPattern.append(Vector(0, 0.26062, 97.8391));
    tempPattern.append(Vector(0, 0.11286, 98.3873));
    tempPattern.append(Vector(0, 0.269238, 97.4839));
    tempPattern.append(Vector(0, 0.364387, 97.4099));
    tempPattern.append(Vector(0, -0.00212238, 98.4148));
    tempPattern.append(Vector(0, -0.00334187, 99.5548));
    tempPattern.append(Vector(0, 0.23615, 101.269));
    tempPattern.append(Vector(0, 0.662346, 103.109));
    tempPattern.append(Vector(0, 0.507658, 98.553));
    tempPattern.append(Vector(0, 0.112585, 90.9717));
    tempPattern.append(Vector(0, -0.0405158, 85.3474));
    tempPattern.append(Vector(0, 0.675431, 81.8697));
    tempPattern.append(Vector(0, -0.643554, 79.6726));
    tempPattern.append(Vector(0, 0.16382, 80.8476));
    tempPattern.append(Vector(0, -0.331183, 81.9878));
    tempPattern.append(Vector(0, 0.141353, 84.5266));
    tempPattern.append(Vector(0, -0.0569716, 87.0938));
    tempPattern.append(Vector(0, 1.04495, 89.5804));
    tempPattern.append(Vector(0, -0.0213973, 91.3972));
    tempPattern.append(Vector(0, -0.931613, 90.776));
    tempPattern.append(Vector(0, -0.164, 90.6426));
    tempPattern.append(Vector(0, 0.448118, 90.8869));
    tempPattern.append(Vector(0, 0.583653, 93.2277));
    tempPattern.append(Vector(0, 0.274723, 94.5396));
    tempPattern.append(Vector(0, -0.298577, 92.6196));
    tempPattern.append(Vector(0, -0.0758529, 94.2152));
    tempPattern.append(Vector(0, -0.175939, 93.9751));
    tempPattern.append(Vector(0, -0.343267, 93.1576));
    tempPattern.append(Vector(0, 0.336574, 93.085));

    Recoil_pattern_length = tempPattern.len()
    Recoil_bullet_delay = 1000/Pattern_ROF;
    return tempPattern
    }

::Pattern_unknown<-function(){
        local tempPattern = []
        tempPattern.append(Center_pos);
        Recoil_pattern_length = tempPattern.len();
        Recoil_bullet_delay = 600/Pattern_ROF;
        return tempPattern
        }
function GetDistance(v1,v2){return sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y)+(v1.z-v2.z)*(v1.z-v2.z));}
