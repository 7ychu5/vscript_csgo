IncludeScript("vs_library.nut");

//用监听器解决，这个没必要用game_ui了，虽然直接套track那套很方便，但是不利于后续cs2的移植，如果这套写的好的话，也许能反作用于track也说不定？
/*
先flick_ready瞄准 随机刻后生成bot
没打中的话也处决掉bot，
计数++
10个计数后结束计算
好像还挺简单？
*/

//1184 -2560 1184
//64 448 448

/////////////////参数变量/////////////////

spawn_count_time <- RandomFloat(2.0, 2.5);//太短的时间不够BOT复活......也许需要换成切阵营的方法？
spawn_count_num <- 5;

/////////////////////////////////////////

/*
ToDo：
击杀方位
区域击杀计时
*/
spawn_count_time_temp <- 0;
flick_fire_toggle <- false;
spawn_count_num_temp <- 1;
flick_time_sum <- 0;
flick_time_part_start <- 0;
flick_time_part_end <- 0;
flick_death <- 0;


function flick_mode_on() {
    activator.SetVelocity(Vector(0, 0, 0));
    activator.SetOrigin(Vector(64, -2560, 1124));
    activator.SetAngles(0, 0, 0);
    ::MODE_TYPE <- 5;
    ::SpawnBot();

    spawn_count_num_temp <- 1;
    flick_time_sum <- 0;
    flick_death <- 0;

    local weapon_equip = Entities.CreateByClassname("game_player_equip");
    weapon_equip.__KeyValueFromInt("weapon_awp", 1);
    weapon_equip.__KeyValueFromInt("spawnflags", 5);
    EntFireByHandle(weapon_equip, "Use", "", 0, ::PLAYER, null);
    weapon_equip.Destroy();

    ::SET_INFINITE_AMMO <- false;::ToggleAmmo();
    ScriptPrintMessageCenterAll("<font color='#55efc4'>欢迎来到</font><font color='#ff1010'>甩狙</font><font color='#55efc4'>测试！</font>\n<font color='#e67e22'>测试将持续10个击败数</font>\n<font color='#81ecec'>瞄准前方瞄点\n等待其变色即可开始！</font>");

    flick_ready();
}

function flick_ready() {
    local player = ToExtendedPlayer(::PLAYER);
    local eye = player.EyePosition();
    local pos = VS.TraceDir( eye, player.EyeForward(), 1536.0 ).GetPos();
    local tr = VS.TraceDir( player.EyePosition(), player.EyeForward(), MAX_COORD_FLOAT, player.self, MASK_SOLID );
    //DebugDrawBox(pos, Vector(2, 2, 2), Vector(-2, -2, -2), 0, 0, 0, 40, 3);
    //printl(tr.GetEnt(8));
    if(tr.GetEnt(8) == null){
        spawn_count_time_temp = 0;
        EntFire("flick_sign", "color", "255 255 255", 0.0, null);
    }
    else
    {
        if(tr.GetEnt(8).GetClassname() == "prop_dynamic" && tr.GetEnt(8).GetName() == "flick_sign"){
            spawn_count_time_temp += 0.01;
            printl(spawn_count_time_temp);
            EntFire("flick_sign", "color", "255 255 0", 0.0, null);
            if(spawn_count_time_temp >= spawn_count_time){
                EntFire("flick_sign", "color", "255 0 0", 0.0, null);
                flick_time_part_start <- Time();
                spawn_flick_bot();
                return;
            }
        }
        else{//视线飘走的话就清零计数器呗
            spawn_count_time_temp = 0;
            EntFire("flick_sign", "color", "255 255 255", 0.0, null);
        }
    }
    EntFire("logic_script", "RunScriptcode", "flick_ready();", 0.01, activator);
}

function spawn_flick_bot() {
    //先随机位置 然后生成
    local maker = Entities.CreateByClassname("env_entity_maker");
    maker.__KeyValueFromString("EntityTemplate", "flick_bot_template");
    local loc = Vector(RandomFloat(1152, 1216), RandomFloat(-2784, -2436), RandomFloat(1060, 1308));
    maker.SpawnEntityAtLocation(loc, Vector(0, 0, 0));
    local bot = Entities.FindByName(null, "bot");
    bot.SetOrigin(Vector(loc.x, loc.y, loc.z+20));
    bot.SetAngles(0, 180, 0);
    maker.Destroy();
    flick_fire_toggle <- true;
}

function flick_weapon_fire() {
    if(::MODE_TYPE == 5 && flick_fire_toggle == true){
        EntFire("flick_sign", "color", "255 255 255", 0.0, null);
        EntFire("logic_script", "RunScriptcode", "flick_ready();flick_fire_toggle<-false", 0.01, null);
        EntFire("flick_bot_pad", "kill", "", 0.01, null);
        EntFire("bot", "SetHealth", "-1", 0.00, null);

        flick_time_part_end <- Time();
        // printl(flick_time_sum);
        // printl(flick_time_part_start);
        // printl(flick_time_part_end);
        // printl("/////////////////////");
        flick_time_sum += (flick_time_part_end - flick_time_part_start);

        ScriptPrintMessageCenterAll("进度：  " + spawn_count_num_temp + " / " + spawn_count_num);

        if(spawn_count_num_temp >= spawn_count_num) EntFire("logic_script", "RunScriptcode", "flick_mode_stop();", 0.02, null);
        else spawn_count_num_temp++;
    }
}

VS.ListenToGameEvent( "weapon_fire", function( event )
{
    if(::MODE_TYPE == 5) EntFire("logic_script", "RunScriptcode", "flick_weapon_fire();", 0.00, null);
}, "listen_flick_mode_weapon_fire" );

VS.ListenToGameEvent( "player_hurt", function( event )
{
    if(::MODE_TYPE == 5) if(event.attacker != null && event.attacker != event.userid) EntFire("logic_script", "RunScriptcode", "++flick_death;", 0.0, null);
}, "listen_flick_mode_death" );

function flick_mode_stop() {
    EntFire("user", "SetHealth", "-1", 0.0, null);
    ::MODE_TYPE <- 1;::SpawnBot();

    ScriptPrintMessageCenterAll("测试结束，在左下角获取您的得分\n已默认回到热身模式");


    ScriptPrintMessageChatAll("共计用时："+format("%.2f",flick_time_sum)+"秒  平均用时："+format("%.2f",flick_time_sum/flick_death)+ "秒");
    ScriptPrintMessageChatAll("有效命中："+flick_death);
}