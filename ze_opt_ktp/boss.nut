SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "ze_opt_ktp";
SCRIPT_TIME <- "2022年9月30日11:43:40 ";

boss_arena_template <- Entities.FindByName(null, "boss_arena_template");
boss_arena_template_origin <- boss_arena_template.GetOrigin();

pl_max <- 5;

function pl_count_max(){
    pl_max++;
    return pl_max;
}

function boss_show(){
    local spawner = Entities.CreateByClassname("env_entity_maker");
    spawner.__KeyValueFromString("EntityTemplate", "penguin_prop_rock_template");
    spawner.SpawnEntityAtLocation(Entities.FindByName(null, "penguin_prop_rock_template").GetOrigin(), Vector(0, 0, 0));
    EntFire("penguin_prop_particles_ball" ,"start", " ", 1, null);
    EntFireByHandle(spawner, "kill", " ", 1.0, null, null);
    
    EntFire("penguin_prop_particles_ball" ,"stop", " ", 2.5, null);
    EntFire("penguin_prop_rock","break"," ",1.5,null);
    EntFire("penguin_prop_rock_shooter_under","Shoot"," ",1.5,null);
    EntFire("logic_script", "RunScriptCode", "boss_show_2()", 2.0, null);
}

function boss_show_2(){
    local spawner = Entities.CreateByClassname("env_entity_maker");
    spawner.__KeyValueFromString("EntityTemplate", "penguin_prop_rock_after_template"); 
    spawner.SpawnEntityAtLocation(Entities.FindByName(null, "penguin_prop_rock_after_template").GetOrigin(), Vector(0, 0, 0));
    EntFireByHandle(spawner, "kill", " ", 1.0, null, null);
    EntFire("penguin_prop_particles_split" ,"start", " ", 1.5, null);

    EntFire("logic_script", "RunScriptCode", "boss_show_3()", 2, null);
}

function boss_show_3(){
    local env_fade = Entities.CreateByClassname("env_fade");
    env_fade.__KeyValueFromString("targetname", "env_fade");
    env_fade.__KeyValueFromString("rendercolor", "255 255 255");
    env_fade.__KeyValueFromString("duration", "1");
    EntFireByHandle(env_fade, "Fade", " ", 1, null, null);
    
    EntFire("penguin_prop_rock_after","EnableMotion"," ",1.0,null);
    EntFire("penguin_prop_rock_shooter","Shoot"," ",1.01,null);
    EntFire("penguin_prop_rock_physexposion","Explode"," ",1.01,null);

    EntFire("penguin_prop_particles_split" ,"stop", " ", 1.0, null);

    EntFire("logic_script", "RunScriptCode", "boss_show_4()", 2.0, null);
    
}

function boss_show_4(){
    EntFire("penguin_prop_rock_after", "Kill", " ", 0.0, null);
    
    boss_ready();
}

function boss_ready() {
    local count = 1;
    local spawner = Entities.CreateByClassname("env_entity_maker");
    spawner.__KeyValueFromString("EntityTemplate", "boss_arena_template");
    for(local j=4;j>0;j--)
    {
        for(local i=4;i>0;i--)
        {
            spawner.SpawnEntityAtLocation(boss_arena_template_origin, Vector(0, 0, 0));
            local new_boss_arena_breakable = Entities.FindByName(null, "boss_arena_breakable");
            local new_boss_arena_trigger = Entities.FindByName(null, "boss_arena_trigger");
            new_boss_arena_breakable.__KeyValueFromString("targetname", "boss_arena_breakable_"+count);
            new_boss_arena_trigger.__KeyValueFromString("targetname", "boss_arena_trigger_"+count);
            count++;
            boss_arena_template_origin.x+=384;
        }
        boss_arena_template_origin.y-=384;
        boss_arena_template_origin.x-=1536;
    }
    EntFireByHandle(spawner, "kill", " ", 1.0, null, null);
}
function trigger_for_break() {
    local center_pos = self.GetCenter();
    local bounding_max = center_pos+self.GetBoundingMaxs();
    local bounding_min = center_pos+self.GetBoundingMins();
    local pl_count = 0;
    for (local pent;pent = Entities.FindByClassname(pent, "cs_bot");)
    {
        if(pent==null || !pent.IsValid() || pent.GetHealth ()<=0) continue;
        local pent_origin = pent.GetCenter();
        local r1=pent_origin-bounding_min;
        local r2=pent_origin-bounding_max;
        if(r1.Dot(r2)>0) continue;
        else
        {
            pl_count++;
            self.__KeyValueFromString("Color", "255,0,0")
            //if(pl_count)
        }
    }
}