/*

开枪后显示敌人位置，需要击杀敌人(根据开第一枪偏移角度和总时间计算分数)

    a. 听声辩位时间
    b. 开枪偏移角度

开始模式后给玩家戴上头套，alpha值拉到255
头套......如果用SetParent的话，玩家蹲下会避开；SetParentAttachment的话，摄像机视角是一直抖动的；如果用ScreenOverlay的话，贴图会撕裂（unlitgeneric不撕裂）

ent_fire env_fog_controller SetEndDist 128用快速循环拉大
头套 7ychu5/face_mask

发生枪响，开始计时
检测bullet_impact，头套alpha归零，生成（发亮的？）bot
player_hurt后进入下一循环


ToDo：BYD这个bot生成太慢了

绝对不能用弱智EmitSound了，这几把函数真的有声音来源吗，到处都是一样大小的声音，操

*/

//model_face_mask <- "models/props_interiors/toiletpaperdispenser_residential.mdl";

//self.PrecacheModel(model_face_mask);

face_mask <- null;
fog_enddist <- 696;
perceive_time_count <- 0;
perceive_time <- 10;

perceive_start_time <- 0;
perceive_end_time <- 0;
perceive_sum_time <- 0;
perceive_sum_ang <- 0;

perceive_fire_toggle <- false;
perceive_sound_toggle <- false;

bot_origin <- Vector(0, 0, 0);//-3312 1776 2185 / -2800 2288 2185

model_sound <- "weapons/c4/c4_beep2.wav"

self.PrecacheScriptSound(model_sound);

function perceive_mode_on() {
    activator.SetOrigin(Vector(-3055, 2032, 2185));
    //activator.SetOrigin(Vector(64, -2560, 1124));
    //activator.SetAngles(0, 0, 0);
    perceive_time_count <- 0;
    ::MODE_TYPE <- 6;
    ::SpawnBot();

    perceive_start_time <- 0;
    perceive_end_time <- 0;
    perceive_sum_time <- 0;
    perceive_sum_ang <- 0;
    //EntFire("env_fog_controller", "SetColor", "0 0 0", 0.0, null);
    //EntFire("env_fog_controller", "SetStartDist ", "0", 0.0, null);
    //EntFire("env_fog_controller", "SetendDist ", "696", 0.0, null);
    //EntFire("env_fog_controller", "TurnOn", "", 0.0, null);

    ScriptPrintMessageCenterAll("<font color='#55efc4'>欢迎来到</font><font color='#ff1010'>听力</font><font color='#55efc4'>测试！</font>\n<font color='#e67e22'>测试将持续10个击败数</font>\n<font color='#81ecec'>仔细听\n五秒后测试开始！</font>");

    //EntFire("logic_script", "RunScriptcode", "spawn_flick_bot", 3.0, null);
    EntFire("logic_script", "RunScriptcode", "perceive_location_ready();", 3.0, null);

    // local env_screenoverlay = Entities.CreateByClassname("env_screenoverlay");
    // env_screenoverlay.__KeyValueFromString("OverlayName1", "dev/dev_slime");
    // env_screenoverlay.__KeyValueFromString("OverlayTime1", "5");
    // EntFireByHandle(env_screenoverlay, "StartOverlays", "", 0.0, null, null);

    // local face_mask_origin = Vector(::PLAYER.GetOrigin().x, ::PLAYER.GetOrigin().y, ::PLAYER.GetOrigin().z+62);
    // face_mask <- CreateProp("prop_dynamic", face_mask_origin, model_face_mask, 0);
    // EntFireByHandle(face_mask, "SetParent", "user", 0.0, null, null);
    // EntFireByHandle(face_mask, "SetParentAttachment", "facemask", 0.0, null, null);

}

function perceive_location_ready() {
    SendToConsole("r_screenoverlay 7ychu5/face_mask");
    // fog_enddist <- 696;
    // for(local i=0;i<=3;i+=0.01)
    // {
    //     fog_enddist-=2;
    //     EntFire("env_fog_controller", "SetEndDist ", fog_enddist.tostring(), i, null);
    // }
    local bot_origin_x = RandomFloat(-3312, -2800);while(bot_origin_x > -3152 && bot_origin_x < -2952) bot_origin_x = RandomFloat(-3312, -2800);
    local bot_origin_y = RandomFloat(1776, 2288);while(bot_origin_y > 1952 && bot_origin_y < 2112) bot_origin_y = RandomFloat(1776, 2288);
    bot_origin <- Vector(bot_origin_x, bot_origin_y, 2184.031250);

    EntFire("logic_script", "RunScriptcode", "spawn_perceive_sound();", 5.0, null);
}

function spawn_perceive_sound() {
    //local temp_sound_model = CreateProp("prop_dynamic", bot_origin, sound_model, 0);
    //temp_sound_model.__KeyValueFromString("targetname", "temp_sound_model");
    //temp_sound_model.__KeyValueFromString("rendermode", "1");
    //temp_sound_model.__KeyValueFromString("renderamt", "1");
    // local temp_ambient = Entities.CreateByClassname("ambient_generic");
    //temp_ambient.__KeyValueFromString("SourceEntityName", "temp_sound_model");
    // temp_ambient.__KeyValueFromString("targetname", "temp_ambient");
    // temp_ambient.__KeyValueFromString("message", "player/pl_respawn.wav");
    perceive_sound_toggle <- true;perceive_start_sound();

    perceive_start_time <- Time();

    //temp_ambient.Destroy();
    perceive_fire_toggle <- true;
}

function perceive_start_sound() {
    if(perceive_sound_toggle == false) return;

    local perceive_ambient = Entities.FindByName(null, "perceive_ambient");
    perceive_ambient.SetOrigin(bot_origin);
    EntFire("perceive_ambient", "PlaySound", "", 0.00, null);

    //VS.DrawSphere(bot_origin, 16, 16, 8, 255, 0, 0, true, 1 );
    EntFire("logic_script", "RunScriptcode", "perceive_start_sound();", 1.0, null);

}

VS.ListenToGameEvent( "bullet_impact", function( event )
{
    if(::MODE_TYPE == 6){
        local x = event.x;
        local y = event.y;
        local z = event.z;
        local pos = Vector(x, y, z);
        //printl("tempPattern.append(Vector("+x+", "+y+", "+z+"));");
        //DebugDrawBox(Vector(x, y, z), Vector(1, 1, 1), Vector(-1, -1, -1), 0, 255, 255, 40, 3);
        EntFire("logic_script", "RunScriptcode", "perceive_calc(\""+x+"\",\""+y+"\",\""+z+"\")", 0.0, null);
        EntFire("temp_sound_model", "kill", "", 0.00, null);
    }
}, "listen_perceive_mode_bullet_impact" );

function perceive_calc(hitx,hity,hitz) {
    if(perceive_fire_toggle == true)
    {
        hitz = bot_origin.z;//只算平面差异角度
        local player_origin = ::PLAYER.GetOrigin();
        local angle1 = GetTargetYaw(player_origin, bot_origin);
        local angle2 = GetTargetYaw(player_origin, Vector(hitx.tofloat(), hity.tofloat(), hitz.tofloat()));

        ScriptPrintMessageChatAll((angle1-angle2).tostring());

        SendToConsole("r_screenoverlay /");

        perceive_end_time <- Time();
        perceive_sum_time += perceive_end_time - perceive_start_time;
        perceive_sum_ang += abs(angle1-angle2);

        perceive_sound_toggle <- false;
        perceive_fire_toggle <- false;
        spawn_perceive_bot();
    }
}

function GetTargetYaw(start,target)
{
    local yaw = 0.00;
    local v = Vector(start.x-target.x,start.y-target.y,start.z-target.z);
    local vl = sqrt(v.x*v.x+v.y*v.y);
    yaw = 180*acos(v.x/vl)/3.14159;
    if(v.y<0)yaw=-yaw;
    return yaw;
}

function spawn_perceive_bot() {
    // for(local i=0;i<=1;i+=0.01)
    // {
    //     fog_enddist+=6;
    //     EntFire("env_fog_controller", "SetEndDist ", fog_enddist.tostring(), i, null);
    // }
    local bot = Entities.FindByName(null, "bot");
    bot.SetOrigin(bot_origin);
    EntFire("bot", "SetHealth", "1", 0.02, null);
}

VS.ListenToGameEvent( "player_death", function( event )
{
    if(::MODE_TYPE == 6) EntFire("logic_script", "RunScriptcode", "perceive_location_again()", 0.0, null);
}, "listen_perceive_mode_death" );

function perceive_location_again(){
    perceive_time_count++;
    if(perceive_time_count <= perceive_time){
        ScriptPrintMessageCenterAll(perceive_time_count + " / " + perceive_time);
        perceive_location_ready();
    }
    else perceive_mode_off();
}

function perceive_mode_off() {
    EntFire("user", "SetHealth", "-1", 0.0, null);
    ::MODE_TYPE <- 1;::SpawnBot();
    EntFire("env_fog_controller", "TurnOff", "", 0.0, null);
    SendToConsole("r_screenoverlay /");

    local perceive_avg_time = perceive_sum_time/perceive_time_count;
    local perceive_avg_ang = perceive_sum_ang/perceive_time_count;
    ScriptPrintMessageChatAll("平均用时："+perceive_avg_time);
    ScriptPrintMessageChatAll("平均偏角："+perceive_avg_ang);


    ScriptPrintMessageCenterAll("测试结束，在左下角获取您的得分\n已默认回到热身模式");
}