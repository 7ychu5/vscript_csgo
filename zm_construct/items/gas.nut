////////////////////////////////////////
/////////////毒气（已完工）////////////
////////////////////////////////////////
gas_CD <- 45.0;
gas_use_toggle <- true;

function player_set_job7() {
    local name = activator.GetScriptScope().name;
    local sid = activator.GetScriptScope().networkid;
    Chat(TextColor.Uncommon+"[MAP]  "+ TextColor.Immortal + name + TextColor.Award + " [" + sid + "]" + TextColor.Location +" 领略了气之奥义！\n ");
    local text = ::CreateText();
    EntFireByHandle(text, "SetText", "您好，毒气！", 0.0, activator, null);
    EntFireByHandle(text, "Display", "", 0.01, activator, null);
    EntFireByHandle(text, "kill", "", 3, activator, null);
}

function player_use_job7() {
    if(gas_use_toggle == true)
    {
        gas_use_toggle = false;

        local maker = Entities.CreateByClassname("env_entity_maker");
        maker.__KeyValueFromString("EntityTemplate","gas_smoke_template");
        maker.SpawnEntityAtLocation(Vector(activator.GetOrigin().x , activator.GetOrigin().y, activator.GetOrigin().z+40), Vector(0, 0, 0));
        local smoke_third = Entities.FindByNameNearest("gas_smoke_third*", activator.GetOrigin(), 64);
        local smoke_trigger = Entities.FindByNameNearest("gas_smoke_trigger*", activator.GetOrigin(), 64);
        EntFireByHandle(smoke_third, "start", "", 0.0, null, null);
        EntFireByHandle(smoke_third, "kill", "", 10.0, null, null);
        EntFireByHandle(smoke_trigger, "kill", "", 10.0, null, null);

        EntFireByHandle(maker, "kill", "", 0.01, null, null);
        local text = ::CreateText();
        local gas_CD = 45;
        for(local j=0;j<45;j+=0.1)
        {
            EntFireByHandle(text, "SetText", "毒气冷却： "+gas_CD+" 秒", j, activator, null);
            EntFireByHandle(text, "Display", "", j, activator, null);
            gas_CD-=0.1;
        }
        EntFireByHandle(text, "kill", "", 45.0, activator, null);
        EntFireByHandle(self, "RunScriptCode", "gas_use_toggle = true", 45, null);
        EntFireByHandle(text, "SetText", "毒气准备就绪！", 45, activator, null);
        EntFireByHandle(text, "Display", "", 45, activator, null);
        EntFireByHandle(text, "kill", "", 45.01, activator, null);
    }
}

function player_trigger_job7() {
                // local smoke_screen = Entities.FindByNameNearest("gas_smoke_screen*", activator.GetOrigin(), 180);
                // EntFireByHandle(smoke_screen, "start", "", 0.0, activator, null);
                // EntFireByHandle(smoke_screen, "stop", "", 3.0, activator, null);

    local hp = activator.GetHealth();
    EntFireByHandle(activator, "SetHealth", (hp-=10).tostring(), 1.0, null, null);
    local speedmod = Entities.CreateByClassname("player_speedmod");
    EntFireByHandle(speedmod, "ModifySpeed", "0.3", 0.0, activator, null);
    EntFireByHandle(speedmod, "ModifySpeed", "1", 3.0, activator, null);
    EntFireByHandle(speedmod, "kill", "", 3.1, null, null);
}
