IncludeScript("vs_library.nut");

///////////////////////////////////////////////////////////////

File_name <- "PlayMaster";

///////////////////////////////////////////////////////////////

count_death_max <- 10;
count_death <- -1;
count_hurt <- 0;
count_fire <- 0;
start_time <- 0.00;

damage_position <-[
    0,//"World"//0
    0,//"Head"//1
    0,//"UpperBody"//2
    0,//"LowerBody"//3
    0,//"LeftArm"//4
    0,//"RightArm"//5
    0,//"LeftLeg"//6
    0,//"RightLeg"//7
]

///////////////////////////////////////////////////////////////

VS.ListenToGameEvent( "player_hurt", function( event )
{
    if(::MODE_TYPE == 3) switch (event.hitgroup) {
        case 1:EntFire("logic_script", "RunScriptcode", "aim_mode_player_hurt_update(1)", 0.0, null);break;
        case 2:EntFire("logic_script", "RunScriptcode", "aim_mode_player_hurt_update(2)", 0.0, null);break;
        case 3:EntFire("logic_script", "RunScriptcode", "aim_mode_player_hurt_update(3)", 0.0, null);break;
        case 4:EntFire("logic_script", "RunScriptcode", "aim_mode_player_hurt_update(4)", 0.0, null);break;
        case 5:EntFire("logic_script", "RunScriptcode", "aim_mode_player_hurt_update(5)", 0.0, null);break;
        case 6:EntFire("logic_script", "RunScriptcode", "aim_mode_player_hurt_update(6)", 0.0, null);break;
        case 7:EntFire("logic_script", "RunScriptcode", "aim_mode_player_hurt_update(7)", 0.0, null);break;
        default:break;
    }
}, "listen_aim_mode_player_hurt" );

VS.ListenToGameEvent( "weapon_fire", function( event )
{
    if(::MODE_TYPE == 3) EntFire("logic_script", "RunScriptcode", "aim_mode_weapon_fire_update()", 0.0, null);
}, "listen_aim_mode_weapon_fire" );

VS.ListenToGameEvent( "player_death", function( event )
{
    if(::MODE_TYPE == 3) if(event.attacker != null && event.attacker != event.userid) EntFire("logic_script", "RunScriptcode", "aim_mode_player_death_update()", 0.0, null);
}, "listen_aim_mode_death" );

function aim_mode_on() {
    count_death <- -1;
    count_hurt <- 0;
    count_fire <- 0;
    start_time <- 0.00;
    damage_position <-[0,0,0,0,0,0,0,0];
    activator.SetOrigin(Vector(3704, 2380, -867));
    ::MODE_TYPE <- 3;
    ::SET_INFINITE_AMMO <- false;::ToggleAmmo();
    ::CURR_ARMOR <- 2;
    ::SET_DIST_NEAR_ENABLED <- true;EntFire("bot_spawn_near_sign", "ShowSprite", "", 0.00, null);
    ::SET_DIST_MID_ENABLED <- true;EntFire("bot_spawn_middle_sign", "ShowSprite", "", 0.00, null);
    ::SET_DIST_FAR_ENABLED <- true;EntFire("bot_spawn_far_sign", "ShowSprite", "", 0.00, null);
    EntFire("btn_bot_spawn_middle", "lock", "", 0.05, null);
    EntFire("btn_bot_spawn_far", "lock", "", 0.05, null);
    EntFire("btn_bot_spawn_near", "lock", "", 0.05, null);
    ::SpawnBot();

    ScriptPrintMessageCenterAll("<font color='#55efc4'>欢迎来到</font><font color='#ff1010'>KPM计算</font><font color='#55efc4'>测试！</font>\n<font color='#e67e22'>测试将持续10个击败数\n</font><font color='#81ecec'>击败第一个敌人即可开始！</font>");

}

function aim_mode_player_hurt_update(hitgroup) {
    count_hurt++;
    damage_position[hitgroup]++;
}

function aim_mode_weapon_fire_update() {
    count_fire++;
}

function aim_mode_player_death_update() {
    count_death++;
    ScriptPrintMessageCenterAll(count_death + " / " + count_death_max);
    if(::MODE_TYPE == 3 && count_death == 0){
        start_time <- Time();
        count_hurt <- 0;
        count_fire <- 0;
        damage_position <-[0,0,0,0,0,0,0,0];
    }
    if(::MODE_TYPE == 3 && count_death >= count_death_max)
    {
        local end_time = Time();
        local distime = end_time - start_time;
        ScriptPrintMessageChatAll("共计用时："+distime+"  平均击杀时间："+distime/count_death);
        ScriptPrintMessageChatAll("射击次数："+count_fire+" 命中次数："+count_hurt);
        ScriptPrintMessageChatAll("头部命中次数："+damage_position[1]);
        ScriptPrintMessageChatAll("胸腹命中次数："+damage_position[2]+"  腰部命中次数："+damage_position[3]);
        ScriptPrintMessageChatAll("左臂命中次数："+damage_position[4]+"  右臂命中次数："+damage_position[5]);
        ScriptPrintMessageChatAll("左腿命中次数："+damage_position[6]+"  右腿命中次数："+damage_position[7]);

        SendToConsole("sm_logtogame "+ distime.tostring());
        SendToConsole("sm_logtogame "+ (distime/count_death).tostring());
        SendToConsole("sm_logtogame "+ count_fire.tostring());
        SendToConsole("sm_logtogame "+ count_hurt.tostring());
        for(local j=1; j<=7; j++){
            SendToConsole("sm_logtogame "+ damage_position[j].tostring());
        }

        aim_mode_off();
    }
}

function aim_mode_off() {
    ::MODE_TYPE <- 1;::SpawnBot();
    ScriptPrintMessageCenterAll("测试结束，在左下角获取您的得分\n已默认回到热身模式");
}

////////////////////////////
//////////aim_ball//////////
////////////////////////////

//展示球 -2681 -2866 1095

////人工变量////
aim_ball_number <- 10;
aim_ball_size <- 0;//0 = Large;1 = Middle;2 = Small;
spawn_count_time <- 2.00;

////程序临时变量////
aim_ball_state <- false;
aim_ball_count <- 0;
aim_ball_shoot <- 0;
aim_ball_time_start <- 0;
aim_ball_time_end <- 0;
aim_ball_display_toggle <- true;
draw_ball_timer <- null;
spawn_count_time_temp <- 0;

function aim_ball_mode_clear() {
    aim_ball_count <- 0;
    aim_ball_shoot <- 0;
    aim_ball_time_start <- 0;
    aim_ball_time_end <- 0;
}

function aim_ball_mode_on() {
    ::MODE_TYPE <- 7;
    EntFire("aim_ball_worldtext_1", "SetDisplaytext", "数量选择", 0.0, null);
    EntFire("aim_ball_worldtext_2", "SetDisplaytext", "大小选择", 0.0, null);
    EntFire("aim_ball_worldtext_3", "SetDisplaytext", "开启行动", 0.0, null);
    EntFire("aim_ball_worldtext_4", "SetDisplaytext", "数据统计  数量:XX ;用时:XX:XX;精确度:XX%", 0.0, null);
    EntFire("aim_ball_btn_state_brush", "Color", "0 255 0", 0.0, null);
    activator.SetOrigin(Vector(-2728, -3394, 1189));
    activator.SetAngles(0, 0, 0);
    ::SET_INFINITE_AMMO <- false;::ToggleAmmo();
    aim_ball_mode_clear();
    ::SpawnBot();
    aimball_ready();
}

function aimball_ready() {
    if(::MODE_TYPE != 7 || aim_ball_state) return;
    local player = ToExtendedPlayer(::PLAYER);
    local eye = player.EyePosition();
    local pos = VS.TraceDir( eye, player.EyeForward(), 1536.0 ).GetPos();
    local tr = VS.TraceDir( player.EyePosition(), player.EyeForward(), MAX_COORD_FLOAT, player.self, MASK_SOLID );
    //DebugDrawBox(pos, Vector(2, 2, 2), Vector(-2, -2, -2), 0, 0, 0, 40, 3);
    //printl(tr.GetEnt(8));
    if(tr.GetEnt(8) == null){
        spawn_count_time_temp = 0;
        EntFire("aimball_sign", "color", "255 255 255", 0.0, null);
    }
    else
    {
        if(tr.GetEnt(8).GetClassname() == "prop_dynamic" && tr.GetEnt(8).GetName() == "aimball_sign"){
            spawn_count_time_temp += 0.01;
            printl(spawn_count_time_temp);
            //EntFire("aimball_sign", "color", "255 255 0", 0.0, null);
            EntFire("aimball_sign", "AddOutput", "renderamt "+ (255-255/spawn_count_time*spawn_count_time_temp).tostring(), 0.0, null);
            if(spawn_count_time_temp >= spawn_count_time){
                EntFire("aimball_sign", "AddOutput", "rendermode 10", 0.0, null);
                aim_ball_state_change();
                aim_ball_shoot++;
                return;
            }
        }
        else{//视线飘走的话就清零计数器呗
            spawn_count_time_temp = 0;
            EntFire("aimball_sign", "AddOutput", "renderamt 255", 0.0, null);
        }
    }
    EntFire("logic_script", "RunScriptcode", "aimball_ready();", 0.01, activator);
}

function aim_ball_number_change(num) {
    if(aim_ball_number <= 1){
        aim_ball_number = 1;
        ScriptPrintMessageChatAll("我是有底线的！");
    }
    if(aim_ball_number >= 30){
        aim_ball_number = 30;
        ScriptPrintMessageChatAll("我是有上限的！");
    }

    aim_ball_number += num;
    EntFire("point_worldtext_aim_ball_number", "AddOutput", "message "+aim_ball_number, 0.0, null);
}

function aim_ball_size_change() {
    aim_ball_size++;
    if(aim_ball_size > 2) aim_ball_size = 0;
    //-2681, -2866, 1095
    EntFireByHandle(draw_ball_timer, "kill", "", 0.0, null, null);
    draw_ball_timer <- VS.Timer( false, 0.1, function() {
        if(::MODE_TYPE != 7 ) draw_ball_timer.Destroy();
        switch (aim_ball_size) {
            case 0:
                VS.DrawSphere( Vector(-2681, -2866, 1095), 16, 16, 8, 255, 0, 0, true, 0.1 )
                break;
            case 1:
                VS.DrawSphere( Vector(-2681, -2866, 1095), 12, 16, 8, 0, 255, 0, true, 0.1 )
                break;
            case 2:
                VS.DrawSphere( Vector(-2681, -2866, 1095), 8, 16, 8, 0, 0, 255, true, 0.1 )
                break;
    }} )
    //aim_ball_display_size(aim_ball_size);
}

function aim_ball_display_size(size) {

    if(aim_ball_display_toggle) EntFire("logic_script", "RunScriptcode", "aim_ball_display_size("+size+")", 1.0, null);
}

function aim_ball_state_change() {
    if(aim_ball_state == false)
    {
        aim_ball_state <- true;
        EntFire("aim_ball_btn_state_brush", "Color", "255 0 0", 0.0, null);
        EntFire("aim_ball_btn_*", "Lock", "", 0.0, null);
        EntFire("aim_ball_btn_state", "Unlock", "", 0.02, null);
        aim_ball_mode_clear();
        aim_ball_time_start <- Time();
        aim_ball_state_start();
        EntFire("aimball_sign", "AddOutput", "rendermode 10", 0.0, null);
    }
    else
    {
        aim_ball_shoot--;
        aim_ball_count--;
        aim_ball_state <- false;
        EntFire("aim_ball_target_breakable_*", "RemoveHealth", "1", 0.0, null);
        EntFire("aim_ball_btn_state_brush", "Color", "0 255 0", 0.0, null);
        EntFire("aim_ball_btn_*", "Unlock", "", 0.0, null);

        EntFire("aimball_sign", "AddOutput", "rendermode 2", 0.0, null);
        EntFire("aimball_sign", "color", "255 255 255", 0.0, null);
        aimball_ready();
        spawn_count_time_temp <- 0;
    }
}

function aim_ball_state_start() {
    if(aim_ball_state && aim_ball_count == aim_ball_number){
        EntFire("logic_script", "RunScriptcode", "aimball_ready();", 0.02, null);
    }

    if(aim_ball_state && aim_ball_count < aim_ball_number -2)
    {
        aim_ball_count++;
        ScriptPrintMessageCenterAll("进度：  " + aim_ball_count + " / " + aim_ball_number);
        spawn_ball();
        if(aim_ball_count == 1){
            for(local i = 1; i <= 2 ; i++)
            {
                spawn_ball();
            }
        }
    }
    else if(aim_ball_state && aim_ball_count < aim_ball_number)
    {
        aim_ball_count++;
        ScriptPrintMessageCenterAll("进度：  " + aim_ball_count + " / " + aim_ball_number);
    }
    else
    {
        //aim_ball_state_change();
        EntFire("aim_ball_target_breakable_*", "RemoveHealth", "1", 0.0, null);
        EntFire("aim_ball_btn_state_brush", "Color", "0 255 0", 0.0, null);
        EntFire("aim_ball_btn_*", "Unlock", "", 0.0, null);

        EntFire("aimball_sign", "AddOutput", "rendermode 2", 0.0, null);
        EntFire("aimball_sign", "AddOutput", "renderamt 255", 0.0, null);
        spawn_count_time_temp <- 0;


        aim_ball_state <- false;

        if(aim_ball_shoot == 0) return;
        ScriptPrintMessageCenterAll("已完成！请查看您的数据统计信息！");
        aim_ball_time_end <- Time();
        local hit_rate = format("%.2f",(aim_ball_count.tofloat()/aim_ball_shoot)*100)+"%";
        local time_sum = format("%.2f",aim_ball_time_end-aim_ball_time_start)+"秒";
        local time_avg = format("%.2f",(aim_ball_time_end-aim_ball_time_start)/aim_ball_count)+"秒";
        ScriptPrintMessageChatAll("\x08射击次数：\x04"+aim_ball_shoot.tostring()+"  \x08命中率：\x04"+hit_rate.tostring());
        ScriptPrintMessageChatAll("\x08总时间：\x04"+time_sum.tostring()+"\x08平均定位时间：\x04"+time_avg.tostring());
        SendToConsole("sm_logtogame "+ aim_ball_shoot.tostring());
        SendToConsole("sm_logtogame "+ hit_rate.tostring());
        SendToConsole("sm_logtogame "+ time_sum.tostring());
        SendToConsole("sm_logtogame "+ time_avg.tostring())

        aim_ball_mode_clear();
    }
}

function spawn_ball() {
    local maker = Entities.CreateByClassname("env_entity_maker");
    switch (aim_ball_size) {
        case 0:
            maker.__KeyValueFromString("EntityTemplate", "aim_ball_target_template_L");
            break;
        case 1:
            maker.__KeyValueFromString("EntityTemplate", "aim_ball_target_template_M");
            break;
        case 2:
            maker.__KeyValueFromString("EntityTemplate", "aim_ball_target_template_S");
            break;
        default:
            break;
    }
    //-1832 -3392 1344
    //16w 1376l 640h
    //
    local spawn_loc_x = RandomFloat(-1832-16/2, -1832+16/2);
    local spawn_loc_y = RandomFloat(-3392-1340/2, -3392+1340/2);
    local spawn_loc_z = RandomFloat(1344-620/2, 1344+620/2);
    local spawn_loc = Vector(spawn_loc_x, spawn_loc_y, spawn_loc_z);
    maker.SpawnEntityAtLocation(spawn_loc, Vector(0, 0, 0));
    maker.Destroy();

}

VS.ListenToGameEvent( "weapon_fire", function( event )
{
    if(::MODE_TYPE == 7) EntFire("logic_script", "RunScriptcode", "aim_ball_fire_update();", 0.00, null);
}, "listen_aim_ball_mode_weapon_fire" );

function aim_ball_fire_update() {
    if(aim_ball_state) aim_ball_shoot++;
}

/////////////////////
////////zombie///////
/////////////////////
function zombie_mode_on() {
    ::MODE_TYPE <- 8;
    ::SpawnBot();
    EntFire("trigger_zombie_teleport", "Enable", "", 0.0, null);
}

function zombie_touch() {
    if(activator.GetTeam() == 2 && activator.IsValid() && activator.GetHealth() > 0)
    {
        EntFireByHandle(activator, "SetHealth", "-1", 0.0, activator, null);
        ::LookAtPlayer();
    }
}