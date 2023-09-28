function perceive_calc(hitx,hity,hitz) {
    if(perceive_fire_toggle == true)
    {
        hitz = bot_origin.z;//只算平面差异角度
        local player_origin = ::PLAYER.GetOrigin();
        local angle1 = GetTargetYaw(player_origin, bot_origin);
        local angle2 = GetTargetYaw(player_origin, Vector(hitx, hity, hitz));

        ScriptPrintMessageChatAll((angle1-angle2).tostring());

        SendToConsole("r_screenoverlay /");
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

function test_1() {
    printl("test_1 on");
    printl();
    test_2("bridge from 1 to 2");
}

function test_2(a) {
    printl("test_2 on");
    printl(a);
}