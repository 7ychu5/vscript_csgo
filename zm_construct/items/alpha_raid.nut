Alpharaid_toggle <- 0;
times <- 0;
use_toggle <- true;
CD <- 20.0;

function player_set_Alpha()
{
    local name = activator.GetScriptScope().name;
    local sid = activator.GetScriptScope().networkid;
    Chat(TextColor.Uncommon+"[MAP]  "+ TextColor.Immortal + name + TextColor.Award + " [" + sid + "]" + TextColor.Location +" *#￥@*##……@#*!\n ");
    local text = CreateText();
    text.__KeyValueFromString("color", "255 0 0")
    EntFireByHandle(text, "SetText", "最后的幸存者！杀戮时刻！", 0.0, activator, null);
    EntFireByHandle(text, "Display", "", 0.01, activator, null);
    EntFireByHandle(text, "kill", "", 3, activator, null);
}

function Use_Alpharaid() {
    if(use_toggle == true)
    {
        if(Alpharaid_toggle >= 4)
        {
            EntFireByHandle(activator, "addoutput", "rendermode 0", 0.0, null, null);
            Alpharaid_toggle = 0;
            use_toggle = false;
            local text = CreateText();
            text.__KeyValueFromString("color", "255 0 0")
            CD = 20.0;
            for(local j=0.0;j<20;j+=0.1)
            {
                EntFireByHandle(text, "SetText", "突袭冷却： "+CD+" 秒", j, activator, null);
                EntFireByHandle(text, "Display", "", j, activator, null);
                CD-=0.1;
            }
            EntFireByHandle(self, "RunScriptCode", "use_toggle = true", 20, null);
            EntFireByHandle(text, "SetText", "继续杀戮！", 20, activator, null);
            EntFireByHandle(text, "Display", "", 20, activator, null);
            EntFireByHandle(text, "kill", "", 20.01, activator, null);
            return;
        }

        local target_candidates = [];
        for(local h;h=Entities.FindByClassnameWithin(h, "player", activator.GetOrigin(), 1024);)
        {
            if(h==activator||h==null||!h.IsValid()||h.GetTeam()==3||h.GetHealth()<=0) continue;
            target_candidates.push(h);
        }
        if(target_candidates.len()<=0)
        {
            EntFireByHandle(activator, "addoutput", "rendermode 0", 0.0, null, null);
            use_toggle = false;
            local text = CreateText();
            text.__KeyValueFromString("color", "255 0 0")
            CD = 20.0;
            for(local j=0.0;j<20;j+=0.1)
            {
                EntFireByHandle(text, "SetText", "突袭冷却： "+CD+" 秒", j, activator, null);
                EntFireByHandle(text, "Display", "", j, activator, null);
                CD-=0.1;
            }
            EntFireByHandle(self, "RunScriptCode", "use_toggle = true", 20, null);
            EntFireByHandle(text, "SetText", "继续杀戮！", 20, activator, null);
            EntFireByHandle(text, "Display", "", 20, activator, null);
            EntFireByHandle(text, "kill", "", 20.01, activator, null);
            return;
        }
        local victim = target_candidates[0];
        EntFireByHandle(activator, "addoutput", "rendermode 10", 0.0, null, null);

        local item_Alpharaid_particles_tp_start = Entities.FindByName(null, "item_Alpharaid_particles_tp_start*");
        local item_Alpharaid_particles_tp_end = Entities.FindByName(null, "item_Alpharaid_particles_tp_end*");
        local Sorigin = activator.GetOrigin();
        item_Alpharaid_particles_tp.SetOrigin(Sorigin);
        item_Alpharaid_particles_tp_end.SetOrigin(Vector(victim.GetOrigin().x, victim.GetOrigin().y, victim.GetOrigin().z+40));
        printl(item_Alpharaid_particles_tp.GetOrigin());
        printl(item_Alpharaid_particles_tp_end.GetOrigin());

        EntFireByHandle(item_Alpharaid_particles_tp, "start", " ", 0.0, null, null);
        EntFireByHandle(item_Alpharaid_particles_tp, "stop", " ", 0.3, null, null);

        //activator.SetOrigin(victim.GetOrigin());
        EntFireByHandle(victim, "SetHealth", "-1", 0.1, activator, activator);
        Alpharaid_toggle++;
        EntFireByHandle(self, "RunScriptCode", "Use_Alpharaid()", 0.5, activator, null);
    }
}