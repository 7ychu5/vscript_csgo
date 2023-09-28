SCRIPT_OWNER <- "7ychu5";
SCRIPT_TIME <- "2023年8月29日15:01:44";
SCRIPT_MAP <- "GLOBAL";
SCRIPT_VERISON <- "0.1";

IncludeScript("7ychu5/utils.nut");
//////////user_variable///////////

rocket_use_times_max <- 20;         //火箭弹存量
cooldown <- 120;                    //火箭弹冷却时间
damage_distance <- 386;             //火箭弹伤害半径
damage <- 50;                       //火箭弹造成伤害
speed_min <- 0.1;                   //火箭弹减速比例，减到这个值
restore_time <- 3.0;                //受伤恢复时间

//////////sys_variable////////////

rocket_user <- null;
rocket_use_times <- rocket_use_times_max;

logic_mm <- null;
prop <- null;
Target <- null;
launcher <- null;
particle <- null;
particle_boom <- null;
ambient <- null;

//////////////////////////////////

function id(id) {
    switch (id) {
        case 0:prop = caller;break;
        case 1:logic_mm = caller;break;
        case 2:Target = caller;break;
        case 3:launcher = caller;break;
        case 4:particle = caller;break;
        case 5:particle_boom = caller;break;
    }
}

function Think() {
    if(rocket_user == null) EntFireByHandle(prop, "AddOutput", "Rendermode 0", 0.0, null, null);
    else{
        if(rocket_user.GetHealth() <= 0 || !rocket_user.IsValid() || rocket_user.GetTeam() != 3){
            EntFireByHandle(prop, "AddOutput", "Rendermode 10", 0.0, null, null);
        }
        else{
            EntFireByHandle(prop, "AddOutput", "Rendermode 0", 0.0, null, null);
        }
    }
}

function pick_up() {
    rocket_user = activator;
    //EntFireByHandle(Target, "SetParent", prop.GetName(), 0.00, null, null);
    // EntFire("rockct_user", "AddOutput", "targetname ", 0.00, null);
    if(rocket_user.GetName() == ""){
        local name = "rockct_user#" + RandomInt(1000, 9999).tostring();
        while(Entities.FindByName(null, name) != null){
            name = "rockct_user#" + RandomInt(1000, 9999).tostring();
        }
        EntFireByHandle(activator, "AddOutput", "targetname "+name, 0.03, null, null);

    }
    EntFireByHandle(self, "RunScriptcode", "bind()", 0.05, null, null);
}

function bind() {
    EntFireByHandle(logic_mm, "SetMeasureTarget", rocket_user.GetName(), 0.00, null, null);
    EntFireByHandle(prop, "SetParent", rocket_user.GetName(), 0.02, null, null);
    //EntFireByHandle(prop, "SetParentAttachment", "weapon_hand_L", 0.05, null, null);
}

function button_pressed() {
    if(activator != rocket_user) return;
    if(rocket_user == null || rocket_user.GetHealth() <= 0 || !rocket_user.IsValid()) return;
    if(rocket_use_times <= 0) return;
    rocket_use_times--;
    EntFireByHandle(launcher, "ForceSpawn", "", 0.0, null, null);
    EntFireByHandle(particle, "Start", "", 0.0, null, null);
    EntFireByHandle(particle, "Stop", "", 1.0, null, null);
    EntFireByHandle(self, "RunScriptcode", "rocket_use_times++;", cooldown, null, null);
    EntFireByHandle(ambient, "PlaySound", "", 0.05, null, null);
}

function trigger_who() {
    if(activator.GetTeam() != 2) return;
    EntFireByHandle(self, "break", "", 0.0, null, null);
}

function explosion(origin) {
    local h = null;
	while(null!=(h=Entities.FindInSphere(h,origin,damage_distance)))
	{
		if(h.GetClassname()=="player"&&h.GetTeam()!=3&&h.GetHealth()>=0) vic(h);
        if(h.GetClassname()=="cs_bot"&&h.GetTeam()!=3&&h.GetHealth()>=0) vic(h);
	}
    DispatchParticleEffect("explosion_hegrenade_brief", origin, Vector(0, 0, 0));
    local particle_boom = Entities.FindByName(null, "rocket_particle_boom*");
    particle_boom.SetOrigin(origin);
    EntFireByHandle(particle_boom, "Start", "", 0.0, null, null);
    EntFireByHandle(particle_boom, "Stop", "", 1.0, null, null);
}

function vic(h) {
    local hp = h.GetHealth();
    if(hp >= damage) EntFireByHandle(h, "SetHealth", (hp-damage).tostring(), 0.0, null, null);
    else EntFireByHandle(h, "SetHealth", "-1", 0.0, null, null);

    EntFire("speedmod", "ModifySpeed", speed_min.tostring(), 0.0, h);
    EntFireByHandle(h, "ignitelifetime", restore_time.tostring(), 0.0, null, null);
    EntFire("speedmod", "ModifySpeed", "1.0", restore_time, h);
}