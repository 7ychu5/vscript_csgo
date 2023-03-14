////////////////////////////////////////
////////////刀锋僵尸（已完工）////////////
////////////////////////////////////////
CD <- 10.0;
use_toggle <- true;

function player_set_job5() {
    local name = activator.GetScriptScope().name;
    local sid = activator.GetScriptScope().networkid;
    Chat(TextColor.Uncommon+"[MAP]  "+ TextColor.Immortal + name + TextColor.Award + " [" + sid + "]" + TextColor.Location +" 掌握了火之精髓！\n ");
    local text = ::CreateText();
    EntFireByHandle(text, "SetText", "您好，火球投手！", 0.0, activator, null);
    EntFireByHandle(text, "Display", "", 0.01, activator, null);
    EntFireByHandle(text, "kill", "", 0.01, activator, null);
}

function player_use_job5(){
    if(use_toggle == true)
    {
        use_toggle = false;
        local player = ToExtendedPlayer( VS.GetPlayerByUserid( activator.GetScriptScope().userid ) );
        local eyePos = player.EyePosition();
        local eyeAngle = player.EyeAngles();
        local pos = VS.TraceDir( eyePos, player.EyeForward(), 2048.0 ).GetPos();

        local maker = Entities.CreateByClassname("env_entity_maker");
        maker.__KeyValueFromString("EntityTemplate","item_blade_spawn_template");
        maker.SpawnEntityAtLocation(eyePos, eyeAngle);
        EntFireByHandle(maker, "kill", "", 0.01, null, null);

        local track_end = null
        while (track_end = Entities.FindByName(track_end, "item_blade_track2*"))
        {
            if(::GetDistance(track_end.GetOrigin(), eyePos)<=128)
            {
                track_end.SetOrigin(pos);
                break;
            }
        }
        local blade_mover = Entities.FindByClassnameNearest("func_tracktrain", eyePos, 16);
        EntFireByHandle(blade_mover, "StartForward", "", 0.02, null, null);

        local text = ::CreateText();
        CD = 10.0;
        for(local j=0.0;j<10;j+=0.1)
        {
            EntFireByHandle(text, "SetText", "火球冷却： "+CD+" 秒", j, activator, null);
            EntFireByHandle(text, "Display", "", j, activator, null);
            CD-=0.1;
        }
        EntFireByHandle(self, "RunScriptCode", "use_toggle = true", 10, null);
        EntFireByHandle(text, "SetText", "火球准备就绪！", 10, activator, null);
        EntFireByHandle(text, "Display", "", 10, activator, null);
        EntFireByHandle(text, "kill", "", 10.01, activator, null);
    }
}
