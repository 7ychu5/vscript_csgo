self.PrecacheScriptSound("7ychu5/zeyftxyessir.mp3");
self.PrecacheScriptSound("7ychu5/siryessir.mp3");
self.PrecacheScriptSound("7ychu5/fuckyou.mp3");
self.PrecacheScriptSound("7ychu5/oooooo.mp3");

////////////////////////////////////////
/////////////喇叭（已完工）////////////
////////////////////////////////////////
horn_CD <- 30.0;
horn_use_toggle <- true;

function player_set_job8() {
    local name = activator.GetScriptScope().name;
    local sid = activator.GetScriptScope().networkid;
    Chat(TextColor.Uncommon+"[MAP]  "+ TextColor.Immortal + name + TextColor.Award + " [" + sid + "]" + TextColor.Location +" 专心倾听......\n ");
    local text = ::CreateText();
    EntFireByHandle(text, "SetText", "您好，大喇叭！", 0.0, activator, null);
    EntFireByHandle(text, "Display", "", 0.01, activator, null);
    EntFireByHandle(text, "kill", "", 3, activator, null);
}

function player_use_job8() {
    if(horn_use_toggle == true)
    {
        horn_use_toggle = false;

        local maker = Entities.CreateByClassname("env_entity_maker");
        maker.__KeyValueFromString("EntityTemplate","item_horn_sprite_template");

        local target_candidates = [];
        for(local h;h=Entities.FindByClassnameWithin(h, "cs_bot", activator.GetOrigin(), 2048);)
        {
            if(h==null||!h.IsValid()||h.GetHealth()<=0||h.GetTeam()==activator.GetTeam()) continue;
            target_candidates.push(h);
        }
        // if(target_candidates.len()<=0) return;
        for(local a = 0; a < target_candidates.len(); a++)
        {
            maker.SpawnEntityAtLocation(target_candidates[a].GetOrigin(), Vector(0, 0, 0));
            switch (RandomInt(1, 4)) {
                case 1:
                    target_candidates[a].EmitSound("7ychu5/zeyftxyessir.mp3");
                    break;
                case 2:
                    target_candidates[a].EmitSound("7ychu5/siryessir.mp3");
                    break;
                case 2:
                    target_candidates[a].EmitSound("7ychu5/fuckyou.mp3");
                    break;
                case 2:
                    target_candidates[a].EmitSound("7ychu5/oooooo.mp3");
                    break;
                default:
                    break;
            }
        }

        EntFireByHandle(maker, "kill", "", 0.01, null, null);
        EntFire("item_horn_sprite", "kill", "", 5.0, null);
        local text = CreateText();
        local horn_CD = 30;
        for(local j=0;j<30;j+=0.1)
        {
            EntFireByHandle(text, "SetText", "喇叭冷却： "+horn_CD+" 秒", j, activator, null);
            EntFireByHandle(text, "Display", "", j, activator, null);
            horn_CD-=0.1;
        }
        EntFireByHandle(text, "kill", "", 30.0, activator, null);
        EntFireByHandle(self, "RunScriptCode", "horn_use_toggle = true", 30, null);
        EntFireByHandle(text, "SetText", "喇叭准备就绪！", 30, activator, null);
        EntFireByHandle(text, "Display", "", 30, activator, null);
        EntFireByHandle(text, "kill", "", 30.01, activator, null);
    }
}
