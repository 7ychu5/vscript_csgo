////////////////////////////////////////
/////////////潜伏者（已完工）////////////
////////////////////////////////////////
CD <- 10.0;
use_toggle <- true;

function player_set_job6()
{
    local name = activator.GetScriptScope().name;
    local sid = activator.GetScriptScope().networkid;
    Chat(TextColor.Uncommon+"[MAP]  "+ TextColor.Immortal + name + TextColor.Award + " [" + sid + "]" + TextColor.Location +" 学会了......人呢？\n ");
    local text = ::CreateText();
    EntFireByHandle(text, "SetText", "您好，潜伏者！按右键和身边的人进入隐形状态！", 0.0, activator, null);
    EntFireByHandle(text, "Display", "", 0.01, activator, null);
    EntFireByHandle(text, "kill", "", 3, activator, null);
}


function player_use_job6()
{
    if(use_toggle == true)
    {
        use_toggle = false;
        local target_candidates = [];
        for(local h;h=Entities.FindByClassnameWithin(h, "player", activator.GetOrigin(), 256);)
        {
            if(h==null||!h.IsValid()||h.GetHealth()<=0||h.GetTeam()!=activator.GetTeam()) continue;
            target_candidates.push(h);
        }
        if(target_candidates.len()<=0) return;
        for(local a = 0; a < target_candidates.len(); a++)
        {
            EntFireByHandle(target_candidates[a], "AddOutput", "rendermode 10", 0.0, null, null);
            local text = ::CreateText();
            EntFireByHandle(text, "SetText", "已进入潜伏！", 0.0, activator, null);
            EntFireByHandle(text, "Display", "", 0.01, target_candidates[a], null);
            EntFireByHandle(text, "kill", "", 0.01, target_candidates[a], null);
            EntFireByHandle(target_candidates[a], "AddOutput", "rendermode 0", 10.0, null, null);
        }

        local text = ::CreateText();
        CD = 30.0;
        for(local j=0.0;j<30;j+=0.1)
        {
            EntFireByHandle(text, "SetText", "潜伏冷却： "+CD+" 秒", j, activator, null);
            EntFireByHandle(text, "Display", "", j, activator, null);
            CD-=0.1;
        }
        EntFireByHandle(self, "RunScriptCode", "use_toggle = true", 30, null);
        EntFireByHandle(text, "SetText", "潜伏准备就绪！", 30, activator, null);
        EntFireByHandle(text, "Display", "", 30, activator, null);
        EntFireByHandle(text, "kill", "", 30.01, activator, null);
    }
}