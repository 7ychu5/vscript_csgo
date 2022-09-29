SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "ze_obj_insane_v1";
SCRIPT_TIME <- " ";

barnacle_HP <- 12;
victim <- null;
function spawn_barnacle(){
    local spawner = Entities.CreateByClassname("env_entity_maker");
    for(local j=1; j<=3; j++)//遍历target
    {
        if(RandomInt(1, 2)==1)//藤壶生成的概率
        {
            spawner.__KeyValueFromString("EntityTemplate", "barnacle_template");
            spawner.SpawnEntityAtNamedEntityOrigin("barnacle_target_"+j);
        }
    }
    EntFireByHandle(spawner, "kill", " ", 0.0, null, null)
}

function I_catch_U(){
    local player_speedmod = Entities.CreateByClassname("player_speedmod");
    victim = activator;
    EntFireByHandle(player_speedmod, "ModifySpeed", "0.0", 0, victim, null);
    local trigger = Entities.FindByClassnameNearest("trigger_multiple", victim.GetOrigin(), 128);
    local barnacle = Entities.FindByNameNearest("barnacle*", victim.GetOrigin(), 512);
    trigger = trigger.GetOrigin();
    victim.SetOrigin(Vector(trigger.x, trigger.y, victim.GetOrigin().z+10));
    hang_on();
    //EntFireByHandle(barnacle,"SetAnimation","eat_humanoid",0.0,null,null)
    EntFireByHandle(barnacle,"FireUser2"," ",0.0,null,null)
    //EntFire("barnacle_prop", "SetAnimation", "chew_humanoid", 0.0, null);//动画无法正常调用
    EntFireByHandle(victim, "SetHealth", "-1", 2.0, null, null);//处死时间2.0固定
    EntFireByHandle(player_speedmod, "kill", " ", 0.0, null, null)
}

function hang_on() {
    local barnacle = Entities.FindByNameNearest("barnacle*", victim.GetOrigin(), 512);
    victim.SetOrigin(Vector(victim.GetOrigin().x, victim.GetOrigin().y, victim.GetOrigin().z+10));
    if(victim.GetOrigin().z >= barnacle.GetOrigin().z) return;
    else EntFire("logic_script", "RunScriptCode", "hang_on()", 0.1, null);
}