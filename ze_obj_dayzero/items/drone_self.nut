SCRIPT_OWNER <- "7ychu5";
SCRIPT_TIME <- "2023年8月2日16:38:10";
SCRIPT_MAP <- "ze_obj_dayzero";
SCRIPT_VERISON <- "0.1";

IncludeScript("7ychu5/utils.nut");

//////////user_variable///////////
drone_model <- "models/props_survival/drone/br_drone.mdl"   //无人机模型
reviver_skin <- "models/player/custom_player/legacy/ctm_heavy.mdl";//被买活的人换个皮肤

drone_energy_max <- 200;                                    //无人机能量最多
drone_energy_gain <- 25;                                    //无人机拾取电池奖励
drone_skill_shield_energy <- 50;                            //无人机能量护盾耗费
drone_skill_shield_cooldown <- 15;                          //无人机能量护盾冷却
drone_skill_rescue_range <- 512;                            //无人机治疗范围
drone_skill_rescue_energy <- 100;                           //无人机治疗耗费
drone_skill_rescue_cooldown <- 60;                          //无人机治疗冷却
drone_skill_revive_energy <- 100;                           //无人机买活耗费
drone_skill_revive_cooldown <- 120;                         //无人机买活冷却


bar_energy <- "0 255 255"       //能量条颜色

self.PrecacheModel(reviver_skin);
self.PrecacheModel(drone_model);
//////////sys_variable////////////

drone_user <- null;
drone_user_name <- "";
drone_prop <- null;
drone_btn <- null;
drone_ui <- null;

drone_energy <- 200;

text_energy <- null;

drone_skill_rescue_toggle <- true;
drone_skill_shield_toggle <- true;

//////////////////////////////////

function drone_pickup() {
    drone_user <- activator;
    local name = "drone_user_" + RandomInt(1000, 9999).tostring();
    while(Entities.FindByName(null, name) != null){
        name = "drone_user_" + RandomInt(1000, 9999).tostring();
    }
    EntFireByHandle(activator, "AddOutput", "targetname "+name, 0.0, null, null);
    drone_btn = Entities.FindByNameNearest("drone_btn*", self.GetOrigin(), 512);
    drone_prop = Entities.FindByNameNearest("drone_prop*", self.GetOrigin(), 512);
    drone_ui = Entities.FindByNameNearest("drone_ui*", self.GetOrigin(), 512);

    //EntFireByHandle(drone_prop, "SetParent", name, 0.0, null, null);

    text_energy <- CreateText();
    text_energy.__KeyValueFromString("x", "0");
    text_energy.__KeyValueFromString("y", "0.39");
    text_energy.__KeyValueFromString("channel", "4");
    text_energy.__KeyValueFromString("color",bar_energy);
    EntFireByHandle(text_energy, "Display", "", 0.0, drone_user, null);
    EntFireByHandle(self, "RunScriptCode", "text_energy_display()", 0.0, null, null);
}

function rescue_start() {
    if(!drone_skill_rescue_toggle) return;

    drone_skill_rescue_toggle = false;
    EntFireByHandle(self, "RunScriptCode", "drone_skill_rescue_toggle = true", drone_skill_rescue_cooldown, null, null);

    skill_rescue();
}

function skill_rescue() {
    if(!drone_energy_update(-100)) return;
    local origin = drone_prop.GetOrigin();
    for(local h;h=Entities.FindByClassnameWithin(h, "cs_bot", origin, drone_skill_rescue_range);)                   //提醒我最终上线前把这个CS_BOT改成PLAYER！
    {
        if(h==null || !h.IsValid() || h.GetTeam()!=3 || h.GetHealth()<=0) continue;
        local hp = h.GetHealth();
        // local laser = Entities.CreateByClassname("env_beam");
        // local name = "laser_" + RandomInt(1000, 9999).tostring();
        // while(Entities.FindByName(null, name) != null){
        //     name = "laser_" + RandomInt(1000, 9999).tostring();
        // }

        // laser.__KeyValueFromString("targetname", name);
        // laser.__KeyValueFromString("life", "0");
        // laser.__KeyValueFromString("BoltWidth", "5");
        // laser.__KeyValueFromString("NoiseAmplitude", "10");
        // laser.__KeyValueFromString("LightningStart", drone_prop.GetName());
        // laser.__KeyValueFromString("LightningEnd", name);
        // laser.__KeyValueFromString("texture", "sprites/laserbeam.vmt");
        // laser.__KeyValueFromString("spawnflags", "33");

        // laser.SetOrigin(h.GetOrigin());
        //EntFireByHandle(laser, "kill", "", 1.0, null, null)


        h.SetMaxHealth(200);
        EntFireByHandle(h, "SetHealth", "200", 0.5, null, null );
    }
}

function revive_start() {
    local ent;
    while((ent = Entities.FindByClassname(ent, "*") ) != null)
    {
        if(ent.GetClassname() == "predicted_viewmodel")
        {
            if(ent.GetMoveParent() == drone_user)
            {
                if(ent.GetModelName().find("knife", 0) != null)
                {
                    skill_revive();
                }
            }
        }
    }
}

function skill_revive() {
    if(!drone_energy_update(-200)) return;
    local candidates = [];
	for (local h; h = Entities.FindByClassname(h, "cs_bot"); )                //上线前改回player
    {
        if(h==null||!h.IsValid()||h.GetTeam()!=2||h.GetHealth()<=0) continue;
		candidates.push(h);
    }
	if(candidates.len()<=0)return;
	local h = candidates[RandomInt(0,candidates.len()-1)];

    EntFireByHandle(h, "AddOutput", "teamnumber 3", 0.00, null, null);
    h.SetOrigin(drone_user.GetOrigin());
    h.SetModel(reviver_skin);
}

function text_energy_display() {
    EntFireByHandle(text_energy, "SetText", "能量剩余："+drone_energy+"/200", 0.00, null, null);
    EntFireByHandle(text_energy, "Display", " ", 0.01, drone_user, null);

    EntFireByHandle(self, "RunScriptCode", "text_energy_display()", 1.0, null, null);
}

function drone_energy_update(a) {
    if(drone_energy + a > drone_energy_max){
        drone_energy = drone_energy_max;
        local text = CreateText();
        text.__KeyValueFromString("x", "-1");
        text.__KeyValueFromString("y", "0.7");
        text.__KeyValueFromString("holdtime", "5.00");
        EntFireByHandle(text, "SetText", "能量满溢", 0.0, activator, caller);
        EntFireByHandle(text, "Display", "", 0.02, activator, caller);
        EntFireByHandle(text, "kill", "", 5.0, activator, caller);
    }
    else if(drone_energy + a < 0){
        drone_energy = drone_energy;
        local text = CreateText();
        text.__KeyValueFromString("x", "-1");
        text.__KeyValueFromString("y", "0.7");
        text.__KeyValueFromString("holdtime", "5.00");
        EntFireByHandle(text, "SetText", "能量不足", 0.0, activator, caller);
        EntFireByHandle(text, "Display", "", 0.02, activator, caller);
        EntFireByHandle(text, "kill", "", 5.0, activator, caller);
        return false;
    }
    else{
        drone_energy += a;
        if(a>0) EntFireByHandle(caller, "RunScriptcode", "clear_shit()", 0.0, null, null);
    }
    return true;
}