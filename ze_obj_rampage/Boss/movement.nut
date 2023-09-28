SCRIPT_OWNER <- "7ychu5";
SCRIPT_TIME <- "2023年8月4日14:28:35";
SCRIPT_MAP <- "ze_obj_rampage";
SCRIPT_VERISON <- "0.1";

IncludeScript("7ychu5/utils.nut");

//////////user_variable///////////

prop_helikopter_smashed_model <- "models/props_vehicles/helicopter_rescue_smashed.mdl";//直升机崩坏模型（改上面那个记得把下面这个也改了）

helikopter_health_base <- 100                                   //直升机基础血量
helikopter_health_gain <- 96                                    //直升机增益血量

target_origin_center <- Vector(-12101, -9825, 4200);            //直升机始终朝向的坐标
move_origin_center <- Vector(-9000, -10000, 5250);              //直升机的运行中心点
move_origin_center_2 <- Vector(-9396, -9070, 4329)              //直升机冲水的运行位置（记得把skill.nut里的也改了）
move_origin_center_end <- Vector(-11872, -10816, 4128)          //直升机死亡的落点
scapegoat_model_origin <- Vector(-11900, -10700, 4060)          //直升机残骸的生成位置
move_origin_y <- 800;                                           //直升机左右摇摆的最大距离
move_origin_x <- 200;                                           //直升机前后摇摆的最大距离
move_origin_z <- 400;                                           //直升机上下运行的最大距离
SPEED_UP <- 2500.00                                             //向上起飞的力度（重力系数是800，如果力度低于重力系数，直升机将无法保持高度）
SPEED_DOWN <- 0.00                                              //超过运行范围高度后托举的力度
SPEED_FORWARD <- 8000.00;                                       //前后摇摆的速度
SPEED_SIDE <- 50000.00;                                         //左右摇摆的力度
TICKRATE <- 0.02;                                               //直升机运行的频率

drone_disable_delay <- 10.00                                    //直升机血量归零多久后无人机延时爆炸
disappear_delay <- 9999.00                                      //直升机残骸距离生成后多少秒消失

self.PrecacheModel(prop_helikopter_smashed_model);
//////////sys_variable////////////

helikopter_health <- helikopter_health_base;
helikopter_health_max <- 0;

helikopter_death_status <- false;

target <- null;
tf <- null;
ts <- null;
ticking <- false;

stage_2_status <- false;
death_status <- false;

temp_origin <- Vector(0, 0, 0);

time_start <- 0.00;

//////////////////////////////////


function Start(){if(!ticking){time_start <- Time();health_initialization();ticking = true;Tick();}}
function Stop(){if(ticking){ticking = false;}}
function Tick()
{
    if(ticking)EntFireByHandle(self,"RunScriptCode","Tick();",TICKRATE,null,null);
    else
    {
        EntFireByHandle(tf,"Deactivate","",0.00,null,null);
        EntFireByHandle(ts,"Deactivate","",0.00,null,null);
        return;
    }
    if(Time()-time_start >= 60) stage_2_start();

    local target_origin = move_origin_center;
    //高度
    if(self.GetOrigin().z < target_origin.z - move_origin_z)
    {
        EntFire("helikopter_thruster_up", "Deactivate", "", 0.0, null);
        EntFire("helikopter_thruster_up", "AddOutput", "force "+SPEED_UP.tostring(), 0.0, null);
        EntFire("helikopter_thruster_up", "Activate", "", 0.01, null);
    }
    else if(self.GetOrigin().z >= target_origin.z + move_origin_z)
    {
        EntFire("helikopter_thruster_up", "Deactivate", "", 0.0, null);
        EntFire("helikopter_thruster_up", "AddOutput", "force "+SPEED_DOWN.tostring(), 0.0, null);
        EntFire("helikopter_thruster_up", "Activate", "", 0.01, null);
    }


    EntFireByHandle(tf,"Deactivate","",0.00,null,null);
    EntFireByHandle(ts,"Deactivate","",0.00,null,null);
    EntFireByHandle(tf,"Activate","",0.01,null,null);
    EntFireByHandle(ts,"Activate","",0.01,null,null);

    local self_origin = self.GetOrigin();

    self.SetAngles(GetTargetPitch(self_origin, target_origin_center), GetTargetYaw(self_origin, target_origin_center), 0);

    if(self_origin.y <= move_origin_center.y - move_origin_y){
        EntFireByHandle(ts, "AddOutput", "angles 0 90 0", 0.0, null, null);
    }
    else if(self_origin.y > move_origin_center.y + move_origin_y){
        EntFireByHandle(ts, "AddOutput", "angles 0 270 0", 0.0, null, null);
    }
    if(self_origin.x <= move_origin_center.x - move_origin_x){
        EntFireByHandle(tf, "AddOutput", "angles 0 0 0", 0.0, null, null);
    }
    else if(self_origin.x > move_origin_center.x + move_origin_x){
        EntFireByHandle(tf, "AddOutput", "angles 0 180 0", 0.0, null, null);
    }

    EntFireByHandle(tf,"AddOutput","force "+SPEED_FORWARD.tostring(),0.00,null,null);
    EntFireByHandle(ts,"AddOutput","force "+SPEED_SIDE.tostring(),0.00,null,null);
}

function SetThruster(forward){if(forward)tf=caller;else ts=caller;}

function stage_2_start() {
    if(stage_2_status) return;
    stage_2_status <- true;



    local sm_tt = Entities.FindByName(null, "helicopter_tracktrain");
    sm_tt.SetOrigin(self.GetOrigin());
    EntFireByHandle(self, "SetParent", "helicopter_tracktrain", 0.01, null, null);

    local sm_pt_1 = Entities.FindByName(null, "sm_pt_1");
    sm_pt_1.SetOrigin(self.GetOrigin());
    temp_origin <- self.GetOrigin();

    local sm_pt_2 = Entities.FindByName(null, "sm_pt_2");
    sm_pt_2.SetOrigin(move_origin_center_2);

    EntFire("helicopter_tracktrain", "SetSpeedReal", "500", 0.00, null);
    EntFire("helicopter_tracktrain", "StartForward", "", 1.0, null);
}

function stage_2_end() {
    // EntFire("helicopter_tracktrain", "SetSpeedReal", "200", 0.00, null);
    EntFire("helicopter_tracktrain", "StartBackward", "", 1.0, null);
    EntFireByHandle(self, "ClearParent", "", 0.0, null, null);

    EntFire("helicopter_tracktrain", "AddOutput", "Angles 0 0 0", 1.0, null);
    EntFireByHandle(self, "RunScriptcode", "Start();", 1.0, null, null);
    EntFire("cliff_warehouse_inner_gate", "AddOutput", "origin -13400 -10080 4179", 0.0, null);
    EntFire("cliff_warehouse_particle_gas", "start", " ", 0.0, null);
    EntFire("cliff_warehouse_particle_broken", "start", " ", 0.0, null);


    ScriptPrintMessageChatAll("\xB \xB[Rampage]\x04我操！那个卷帘门后面全是危化品！我们不能待在这里了！");

    for (local ent; ent = Entities.FindByClassname(ent, "player"); )
    {
        if(ent.GetTeam()==3)
        {
            EntFireByHandle(ent, "SetDamageFilter", "filter_ct_ignore_t", 0, null, null);
        }
    }

    EntFire("cliff_warehouse_trigger_hurt", "Enable", "", 0.0, null);
}

function Death() {
    //-11872 -10816 4128
    //EntFireByHandle(self, "kill", "", 0.01, activator, caller);
    EntFire("helikopter_thruster_forward", "kill", "", 2.0, null);
    EntFire("helikopter_thruster_up", "kill", "", 2.0, null);
    EntFire("helikopter_thruster_side", "kill", "", 2.0, null);
    EntFire("helikopter_keepupright", "kill", "", 2.0, null);

    local sm_tt = Entities.FindByName(null, "helicopter_tracktrain");
    sm_tt.SetOrigin(self.GetOrigin());
    EntFireByHandle(self, "SetParent", "helicopter_tracktrain", 0.01, null, null);

    local sm_pt_1 = Entities.FindByName(null, "sm_pt_1");
    sm_pt_1.SetOrigin(self.GetOrigin());

    local sm_pt_2 = Entities.FindByName(null, "sm_pt_2");
    sm_pt_2.SetOrigin(move_origin_center_end);

    EntFire("helicopter_tracktrain", "SetSpeedReal", "5000", 0.02, null);
    EntFire("helicopter_tracktrain", "StartForward", "", 0.03, null);

}

function what_should_i_do() {
    if(death_status){
        clean_all_these_shit();

        EntFire("cliff_warehouse_inner_gate", "AddOutput", "origin -13400 -10080 4243", 0.0, null);
        return;
    }
    if(stage_2_status){
        Stop();
        EntFire("helicopter_prop", "RunScriptcode", "flush_water()", 0.00, null);
        return;
    }
}

function clean_all_these_shit() {
    EntFire("v2explosion_prop", "kill", "", 0.01, null);
    EntFireByHandle(self, "break", "", 0.0, null, null);
    EntFire("helicopter_tracktrain", "kill", "", 0.00, null);
    EntFire("sm_pt_1", "kill", "", 0.00, null);
    EntFire("sm_pt_2", "kill", "", 1.00, null);

    DispatchParticleEffect("explosion_coop_mission_c4", move_origin_center_end, Vector(0, 0, 0))

    EntFire("helicopter_particle_broken", "kill", "", 0.0, null);

    EntFire("logic_script", "RunScriptcode", "play_music(3)", 0.0, null);
    local scapegoat_model = CreateProp("prop_dynamic", scapegoat_model_origin, prop_helikopter_smashed_model, 0);
    EntFireByHandle(scapegoat_model, "AddOutput", "Angles 0 295 0", 0.0, null, null);
    scapegoat_model.__KeyValueFromString("targetname", "scapegoat_model");
    EntFireByHandle(scapegoat_model, "FadeAndKill", "", disappear_delay, null, null);

    EntFire("missile*", "kill", "", 0.0, null);

    for (local ent; ent = Entities.FindByClassname(ent, "player"); )
    {
        if(ent.GetTeam()==3)
        {
            EntFireByHandle(ent, "SetDamageFilter", "", 0, null, null);
        }
    }
}
//////////////////////////////////

function health_initialization() {
    if(stage_2_status) return;
    for (local ent; ent = Entities.FindByClassname(ent, "player"); )
    {
        if(ent.GetTeam() != 3 || ent.GetHealth() <= 0 || !ent.IsValid()) continue;
        helikopter_health += helikopter_health_gain;
    }
    helikopter_health_max = helikopter_health;
}

function health_change(a) {
    if(helikopter_death_status) return;
    if(activator.GetTeam() == 3) helikopter_health += a;
    if(helikopter_health == floor(helikopter_health_max/3*2))
    {
        stage_2_start();
    }

    if(helikopter_health == floor(helikopter_health_max/4))
    {
        stage_2_status <- false;
        stage_2_start();
    }

    if(helikopter_health == floor(helikopter_health_max/3))
    {
        local particle = Entities.FindByName(null, "helikopter_particle_broken_1");
        local ent = Entities.FindByName(null, "helicopter_prop");
        particle.SetOrigin(ent.GetAttachmentOrigin(ent.LookupAttachment("cam_pos")));

        EntFire("helicopter_prop", "SetAnimation", "fly_generic", 1.00, null);
        EntFire("helicopter_shooter", "Shoot", "", 0.0, null);
        EntFire("helicopter_particle_broken", "start", "", 0.0, null);
        EntFireByHandle(particle, "start", "", 0.02, null, null);
        EntFireByHandle(particle, "kill", "", 3.02, null, null);
    }
    if(helikopter_health <= 0)
    {
        helikopter_death_status <- true;
        local particle = Entities.FindByName(null, "helikopter_particle_broken_2");
        local ent = Entities.FindByName(null, "helicopter_prop");
        particle.SetOrigin(ent.GetAttachmentOrigin(ent.LookupAttachment("cam_pos")));
        EntFireByHandle(particle, "start", "", 0.02, null, null);
        EntFireByHandle(particle, "kill", "", 3.02, null, null);

        EntFire("drone_ui*", "RunScriptcode", "drone_hp_change(-50)", drone_disable_delay, null);
        Stop();

        EntFire("helikopter_thruster_up", "AddOutput", "force 1000", 0.00, null);
        EntFire("helikopter_thruster_up", "Activate", "", 0.00, null);

        //EntFire("helikopter_thruster_side", "AddOutput", "spawnflags 28", 0.0, null);
        //EntFire("helikopter_thruster_side", "AddOutput", "force 1500", 0.0, null);
        death_status <- true;
        Death();
    }
}