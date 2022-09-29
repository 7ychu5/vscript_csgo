SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "UNKNOWN";
SCRIPT_TIME <- "2022年9月14日22:08:39";

//TODO:就近选取还是很奇怪，会变成随机。

Alpharaid_OWNER <- null;
Alpharaid_toggle <- 0;
Alpharaid_gun <- Entities.FindByName(null, "item_Alpharaid_gun");
item_Alpharaid_particles_tp <- Entities.FindByName(null, "item_Alpharaid_particles_tp");
item_Alpharaid_particles_tp_end <- Entities.FindByName(null, "item_Alpharaid_particles_tp_end");
times <- 0;

function GetDistance(v1,v2){return sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y)+(v1.z-v2.z)*(v1.z-v2.z));}

function Pickup_Alpharaid() {
    Alpharaid_OWNER = activator;
}

function swap(a, b) {
    return b,a;
}

function Use_Alpharaid() {
    if(activator == Alpharaid_OWNER && Alpharaid_OWNER.IsValid() && Alpharaid_OWNER != null)
    {

        local target_candidates = [];
        if(Alpharaid_toggle >= 4)
        {
            EntFireByHandle(Alpharaid_OWNER, "addoutput", "rendermode 0", 0.0, null, null);
            Alpharaid_toggle = 0;
            return;
        }

        local target_candidates = [];
        for(local h;h=Entities.FindByClassnameWithin(h,"cs_bot",Alpharaid_gun.GetOrigin(),1024);)
        {
            if(h==Alpharaid_OWNER||h==null||!h.IsValid()||h.GetTeam()!=3||h.GetHealth()<=0) continue;//h==Alpharaid_OWNER||
            target_candidates.push(h);
        }
        if(target_candidates.len()<=0)
        {
            EntFireByHandle(Alpharaid_OWNER, "addoutput", "rendermode 0", 0.0, null, null);
            return;
        }
        for(local j=target_candidates.len()-1; j>0; j--){
            if(GetDistance(target_candidates[j].GetOrigin(),Alpharaid_OWNER.GetOrigin()) < GetDistance(target_candidates[j-1].GetOrigin(), Alpharaid_OWNER.GetOrigin()))
            {
                swap(target_candidates[j-1],target_candidates[j]);
            }
        }
        local v = target_candidates[0];
        printl(v);
        //local v = target_candidates[RandomInt(0,target_candidates.len()-1)];
        EntFireByHandle(Alpharaid_OWNER, "addoutput", "rendermode 10", 0.0, null, null);

        local spawner = Entities.CreateByClassname("env_entity_maker");
        spawner.__KeyValueFromString("EntityTemplate", "item_Alpharaid_particles_template_victim");
        spawner.SpawnEntityAtEntityOrigin(v);
        EntFireByHandle(spawner, "kill", " ", 0.1, null, null);
        printl(Vector(v.GetOrigin().x, v.GetOrigin().y, v.GetOrigin().z+40));
        //item_Alpharaid_particles_tp.__KeyValueFromString("cpoint1", v.GetName());
        item_Alpharaid_particles_tp.SetOrigin(Vector(Alpharaid_OWNER.GetOrigin().x, Alpharaid_OWNER.GetOrigin().y, Alpharaid_OWNER.GetOrigin().z+40));
        item_Alpharaid_particles_tp_end.SetOrigin(Vector(v.GetOrigin().x, v.GetOrigin().y, v.GetOrigin().z+40));

        EntFireByHandle(item_Alpharaid_particles_tp, "start", " ", 0.0, null, null);
        EntFireByHandle(item_Alpharaid_particles_tp, "stop", " ", 0.1, null, null);
        //EntFireByHandle(item_Alpharaid_particles_tp_end, "stop", " ", 0.5, null, null);
        Alpharaid_OWNER.SetOrigin(v.GetOrigin());

        EntFire("item_Alpharaid_particles_victim*", "start", " ", 0.0, null);
        EntFire("item_Alpharaid_particles_victim*", "kill", " ", 0.5, null);

        EntFireByHandle(v, "kill", " ", 0.1, Alpharaid_gun.GetOwner(), Alpharaid_gun.GetOwner());
        Alpharaid_toggle++;
        //Use_Alpharaid();
        EntFire("logic_script", "RunScriptCode", "Use_Alpharaid()", 0.5, Alpharaid_gun.GetOwner());
    }
}



function weird_look() {
    local text1 = Entities.CreateByClassname("game_text");
        text1.__KeyValueFromFloat("x", RandomFloat(0.01, 0.99));
        text1.__KeyValueFromFloat("y", RandomFloat(0.01, 0.99));
        text1.__KeyValueFromString("channel", "1");
        text1.__KeyValueFromString("color", "255 0 0");
        text1.__KeyValueFromString("spawnflags","1");
        text1.__KeyValueFromString("holdtime","3.0");
	    text1.__KeyValueFromString("fadein","0");
	    text1.__KeyValueFromString("fadeout","0");
	    text1.__KeyValueFromString("fxtime","0");
        EntFireByHandle(text1, "SetText", "你在看什么？", 0.00, null, null);
        EntFireByHandle(text1, "Display", " ", 0.00, null, null);
        EntFireByHandle(text1, "kill", " ", 3.00, null, null);
        local text2 = Entities.CreateByClassname("game_text");
        text2.__KeyValueFromFloat("x", RandomFloat(0.01, 0.99));
        text2.__KeyValueFromFloat("y", RandomFloat(0.01, 0.99));
        text2.__KeyValueFromString("channel", "2");
        text2.__KeyValueFromString("color", "255 0 0");
        text2.__KeyValueFromString("spawnflags","1");
        text2.__KeyValueFromString("holdtime","3.0");
	    text2.__KeyValueFromString("fadein","0");
	    text2.__KeyValueFromString("fadeout","0");
	    text2.__KeyValueFromString("fxtime","0");
        EntFireByHandle(text2, "SetText", "我在这里", 0.00, null, null);
        EntFireByHandle(text2, "Display", " ", 0.00, null, null);
        EntFireByHandle(text2, "kill", " ", 3.00, null, null);
        local text3 = Entities.CreateByClassname("game_text");
        text3.__KeyValueFromFloat("x", RandomFloat(0.01, 0.99));
        text3.__KeyValueFromFloat("y", RandomFloat(0.01, 0.99));
        text3.__KeyValueFromString("channel", "3");
        text3.__KeyValueFromString("color", "255 0 0");
        text3.__KeyValueFromString("spawnflags","1");
        text3.__KeyValueFromString("holdtime","3.0");
	    text3.__KeyValueFromString("fadein","0");
	    text3.__KeyValueFromString("fadeout","0");
	    text3.__KeyValueFromString("fxtime","0");
        EntFireByHandle(text3, "SetText", "不要看这里", 0.00, null, null);
        EntFireByHandle(text3, "Display", " ", 0.00, null, null);
        EntFireByHandle(text3, "kill", " ", 3.00, null, null);
        local text4 = Entities.CreateByClassname("game_text");
        text4.__KeyValueFromFloat("x", RandomFloat(0.01, 0.99));
        text4.__KeyValueFromFloat("y", RandomFloat(0.01, 0.99));
        text4.__KeyValueFromString("channel", "4");
        text4.__KeyValueFromString("color", "255 0 0");
        text4.__KeyValueFromString("spawnflags","1");
        text4.__KeyValueFromString("holdtime","3.0");
	    text4.__KeyValueFromString("fadein","0");
	    text4.__KeyValueFromString("fadeout","0");
	    text4.__KeyValueFromString("fxtime","0");
        EntFireByHandle(text4, "SetText", "我在这里", 0.00, null, null);
        EntFireByHandle(text4, "Display", " ", 0.00, null, null);
        EntFireByHandle(text4, "kill", " ", 3.00, null, null);
        local text5 = Entities.CreateByClassname("game_text");
        text5.__KeyValueFromFloat("x", RandomFloat(0.01, 0.99));
        text5.__KeyValueFromFloat("y", RandomFloat(0.01, 0.99));
        text5.__KeyValueFromString("channel", "5");
        text5.__KeyValueFromString("color", "255 0 0");
        text5.__KeyValueFromString("spawnflags","1");
        text5.__KeyValueFromString("holdtime","3.0");
	    text5.__KeyValueFromString("fadein","0");
	    text5.__KeyValueFromString("fadeout","0");
	    text5.__KeyValueFromString("fxtime","0");
        EntFireByHandle(text5, "SetText", "那是真的吗？", 0.00, null, null);
        EntFireByHandle(text5, "Display", " ", 0.00, null, null);
        EntFireByHandle(text5, "kill", " ", 3.00, null, null);
        local text0 = Entities.CreateByClassname("game_text");
        text0.__KeyValueFromFloat("x", RandomFloat(0.01, 0.99));
        text0.__KeyValueFromFloat("y", RandomFloat(0.01, 0.99));
        text0.__KeyValueFromString("channel", "0");
        text0.__KeyValueFromString("color", "255 0 0");
        text0.__KeyValueFromString("spawnflags","1");
        text0.__KeyValueFromString("holdtime","3.0");
	    text0.__KeyValueFromString("fadein","0");
	    text0.__KeyValueFromString("fadeout","0");
	    text0.__KeyValueFromString("fxtime","0");
        EntFireByHandle(text0, "SetText", "HELP！\nHELP！\nHELP！", 0.00, null, null);
        EntFireByHandle(text0, "Display", " ", 0.00, null, null);
        EntFireByHandle(text0, "kill", " ", 3.00, null, null);
        EntFire("tick", "FireUser1", " ", 3.0, null);
}