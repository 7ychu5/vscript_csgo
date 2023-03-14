////////////////////////////////////////
/////////////喇叭（已完工）////////////
////////////////////////////////////////
portal_CD <- 30.0;
portal_use_toggle <- true;
pos <- null;

function player_set_job9() {
    local name = activator.GetScriptScope().name;
    local sid = activator.GetScriptScope().networkid;
    Chat(TextColor.Uncommon+"[MAP]  "+ TextColor.Immortal + name + TextColor.Award + " [" + sid + "]" + TextColor.Location +" 学会了撕裂空间！\n ");
    local text = ::CreateText();
    EntFireByHandle(text, "SetText", "您好，裂缝制造者！", 0.0, activator, null);
    EntFireByHandle(text, "Display", "", 0.01, activator, null);
    EntFireByHandle(text, "kill", "", 3, activator, null);
}

function player_use_job9() {
    if(portal_use_toggle == true)
    {
        portal_use_toggle = false;
        local player = ToExtendedPlayer( VS.GetPlayerByUserid( activator.GetScriptScope().userid ) );
        local eyePos = player.EyePosition();
        local eyeAngle = player.EyeAngles();
        local pos = VS.TraceDir( eyePos, player.EyeForward(), 1024.0 ).GetPos();

        local maker = Entities.CreateByClassname("env_entity_maker");
        maker.__KeyValueFromString("EntityTemplate","item_portal_spawn_template");
        maker.SpawnEntityAtLocation(eyePos, eyeAngle);
        EntFireByHandle(maker, "kill", "", 0.01, null, null);

        local portal_start = Entities.FindByNameNearest("item_portal_start_particle*", eyePos, 16);
        local portal_end = Entities.FindByNameNearest("item_portal_end_particle*", eyePos, 16);
        portal_end.SetOrigin(pos);
        local speedmod = Entities.CreateByClassname("player_speedmod");
        EntFireByHandle(speedmod, "ModifySpeed", "0.01", 0.0, activator, null);
        EntFireByHandle(speedmod, "ModifySpeed", "1", 3.0, activator, null);
        EntFireByHandle(speedmod, "kill", "", 3.01, null, null);
        EntFireByHandle(portal_start, "kill", "", 3.01, null, null);
        EntFireByHandle(portal_end, "kill", "", 3.01, null, null);
        activator.SetOrigin(pos);
        activator.SetHealth(3000);

        local text = ::CreateText();
        local portal_CD = 60;
        for(local j=0;j<60;j+=0.1)
        {
            EntFireByHandle(text, "SetText", "裂缝制造冷却： "+portal_CD+" 秒", j, activator, null);
            EntFireByHandle(text, "Display", "", j, activator, null);
            portal_CD-=0.1;
        }
        EntFireByHandle(text, "kill", "", 60.0, activator, null);
        EntFireByHandle(self, "RunScriptCode", "portal_use_toggle = true", 60, null);
        EntFireByHandle(text, "SetText", "新的裂缝准备就绪！", 60, activator, null);
        EntFireByHandle(text, "Display", "", 60, activator, null);
        EntFireByHandle(text, "kill", "", 60.01, activator, null);
    }
}
