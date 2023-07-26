SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "ze_obj_insane";
SCRIPT_TIME <- "2023年4月10日21:38:10";
SCRIPT_VERSION <- "v1.0";

gonarch_prop <- Entities.FindByName(null, "gonarch_prop");
gonarch_physbox <- Entities.FindByName(null, "gonarch_physbox");
gonarch_mortar_maker <- Entities.FindByName(null, "gonarch_skill_mortor_maker");
gonarch_mover_assist <- Entities.FindByName(null, "gonarch_mover_assist");

gonarch_health <- 0;
gonarch_stuck_count <- 0;
gonarch_origin <- Vector(0, 0, 0);


function Intro() {
    // gonarch_mover_assist.__KeyValueFromString("movedir", "-90 0 0");
    // gonarch_mover_assist.__KeyValueFromString("speed", "20");
    // gonarch_mover_assist.__KeyValueFromString("movedistance", "100");
    // EntFireByHandle(gonarch_mover_assist, "Open", "", 0.0, null, null);
    EntFireByHandle(gonarch_physbox, "AddOutput", "Origin 3044 3072 1120", 1.0, null, null);
    EntFireByHandle(gonarch_physbox, "AddOutput", "Origin 3044 3072 1160", 2.0, null, null);
    EntFireByHandle(gonarch_physbox, "AddOutput", "Origin 3044 3072 1180", 3.0, null, null);
    EntFireByHandle(gonarch_prop, "SetAnimation", "Intro", 0.0, null, null);
    EntFireByHandle(gonarch_physbox, "AddOutput", "Origin 3044 3072 1040", 6.1, null, null);
    EntFire("gonarch_particle", "start", "", 5, null);
    // gonarch_mover_assist.__KeyValueFromString("movedir", "90 0 0");
    // gonarch_mover_assist.__KeyValueFromString("speed", "340");
    // gonarch_mover_assist.__KeyValueFromString("movedistance", "100");
    EntFireByHandle(gonarch_prop, "SetAnimation", "Idle", 6.1, null, null);
    // EntFireByHandle(gonarch_mover_assist, "close", "", 5.8, null, null);
}

function GetDistance(v1,v2){return sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y)+(v1.z-v2.z)*(v1.z-v2.z));}

function SearchTarget() {
    ttime = 0.00;
    local target_candidates = [];
	for(local h;h=Entities.FindByClassnameWithin(h,"player",self.GetOrigin(),10000);)
	{
		if(h==null||!h.IsValid()||h.GetTeam()!=3||h.GetHealth()<=0)return;
        //if(TraceLine(self.GetOrigin()+Vector(0,0,0),h.GetOrigin()+Vector(0,0,80),self)==1.00)
        target_candidates.push(h);
	}
    if(target_candidates.len()<=0){
        EntFireByHandle(gonarch_prop, "SetAnimation", "idleSearch", 0.0, null, null);
    }
    //EntFireByHandle(gonarch_prop, "SetAnimation", "walk", 0.0, null, null);
	return target_candidates[RandomInt(0,target_candidates.len()-1)];
}

//----------[VARIABLES]----------\\
TICKRATE 		<- 	0.10;	//the rate (seconds) in which the logic should tick
RETARGET_TIME 	<- 	7.50;	//the amount of time to run before picking a new target
SPEED_FORWARD 	<- 	1.00;	//forward speed modifier 	(0.5=half, 2.0=double, etc)
SPEED_TURNING 	<- 	2.00;	//side speed modifier 	 	(0.5=half, 2.0=double, etc)
//----------[THE MAIN SCRIPT]----------\\
target <- null;
tf <- null;
ts <- null;
ttime <- 0.00;
ticking <- false;
function Start(){if(!ticking){ticking = true;EntFireByHandle(gonarch_prop, "SetAnimation", "walk", 0.0, null, null);Tick();}}
function Stop(){if(ticking){ticking = false;EntFireByHandle(gonarch_prop, "SetAnimation", "idle", 0.0, null, null);}}
function Tick()
{
    if(ticking)EntFireByHandle(self,"RunScriptCode","Tick();",TICKRATE,null,null);
    else
    {
        EntFireByHandle(tf,"Deactivate","",0.00,null,null);
        EntFireByHandle(ts,"Deactivate","",0.00,null,null);
        return;
    }
    EntFireByHandle(tf,"Deactivate","",0.00,null,null);
    EntFireByHandle(ts,"Deactivate","",0.00,null,null);
    target = SearchTarget();
    if(target == null || ttime>=RETARGET_TIME)return SearchTarget();
    ttime+=TICKRATE;
    EntFireByHandle(tf,"Activate","",0.02,null,null);
    EntFireByHandle(ts,"Activate","",0.02,null,null);
    local sa = self.GetAngles().y;
    local ta = GetTargetYaw(self.GetOrigin(),target.GetOrigin());
    local ang = abs((sa-ta+360)%360);
    if(ang>=180)EntFireByHandle(ts,"AddOutput","angles 0 90 0",0.00,null,null);
    else EntFireByHandle(ts,"AddOutput","angles 0 270 0",0.00,null,null);
    local angdif = (sa-ta-180);
    while(angdif>360){angdif-=180;}
    while(angdif<(-180)){angdif+=360;}
    angdif=abs(angdif);
    local tdist = GetDistance(self.GetOrigin(),target.GetOrigin());
    local tdistz = (target.GetOrigin().z-self.GetOrigin().z);
    EntFireByHandle(tf,"AddOutput","force "+(3000*SPEED_FORWARD).tostring(),0.00,null,null);
    EntFireByHandle(ts,"AddOutput","force "+((3*SPEED_TURNING)*angdif).tostring(),0.00,null,null);
}

function GetTargetYaw(start,target)
{
    local yaw = 0.00;
    local v = Vector(start.x-target.x,start.y-target.y,start.z-target.z);
    local vl = sqrt(v.x*v.x+v.y*v.y);
    yaw = 180*acos(v.x/vl)/3.14159;
    if(v.y<0)yaw=-yaw;
    return yaw;
}
function SetThruster(forward){if(forward)tf=caller;else ts=caller;}

function checkstuck() {
    local temp_origin = gonarch_prop.GetOrigin();
    if(GetDistance(gonarch_origin,temp_origin)<=32) gonarch_stuck_count++;
    else gonarch_stuck_count=0;
    gonarch_origin = gonarch_prop.GetOrigin();
    if(gonarch_stuck_count >= 10){gonarch_physbox.SetOrigin(Vector(3044,3072,1040));ScriptPrintMessageCenterAll("归位！");}
    EntFireByHandle(self, "RunScriptcode", "checkstuck()", 1.0, null, null);
}

function health_change() {
    gonarch_health++;
    ScriptPrintMessageChatAll(gonarch_health.tostring());
}

function mortar_ready() {
    local victim = SearchTarget();
    local dis = (GetDistance(gonarch_prop.GetOrigin(),victim.GetOrigin())+350)/1.66; //根据线性回归计算，当距离超过2000时严重失准，需要重新计算
    EntFireByHandle(gonarch_prop, "SetAnimation", "MortarSpit", 0.0, null, null);
    EntFireByHandle(gonarch_prop, "SetAnimation", "idle", 6.0, null, null);
    EntFireByHandle(gonarch_mortar_maker, "Addoutput", "PostSpawnDirection -45 "+GetTargetYaw(victim.GetOrigin(),self.GetOrigin())+" 0", 0.0, null, null);
    EntFireByHandle(gonarch_mortar_maker, "Addoutput", "PostSpawnSpeed "+dis, 0.0, null, null);
    EntFireByHandle(gonarch_mortar_maker, "ForceSpawn", "", 2.0, null, null);
    EntFireByHandle(self, "RunScriptcode", "Stop();", 0.0, null, null);
    EntFireByHandle(self, "RunScriptcode", "start();", 6.0, null, null);
}

function splash_ready() {
    local victim = SearchTarget();
    local dis = (GetDistance(gonarch_prop.GetOrigin(),victim.GetOrigin())+350)/1.66; //根据线性回归计算，当距离超过2000时严重失准，需要重新计算
    EntFireByHandle(gonarch_prop, "SetAnimation", "MortarSpit", 0.0, null, null);
    EntFireByHandle(gonarch_prop, "SetAnimation", "idle", 6.0, null, null);
    EntFireByHandle(gonarch_mortar_maker, "Addoutput", "PostSpawnDirection -45 "+GetTargetYaw(victim.GetOrigin(),self.GetOrigin())+" 0", 0.0, null, null);
    EntFireByHandle(gonarch_mortar_maker, "Addoutput", "PostSpawnSpeed "+dis, 0.0, null, null);
    EntFireByHandle(gonarch_mortar_maker, "ForceSpawn", "", 2.0, null, null);
    EntFireByHandle(self, "RunScriptcode", "Stop();", 0.0, null, null);
    EntFireByHandle(self, "RunScriptcode", "start();", 6.0, null, null);
}

function SpawnSplash(e,toggle) {
    local spawner = Entities.CreateByClassname("env_entity_maker");
    spawner.__KeyValueFromString("EntityTemplate", "gonarch_skill_splash_template");
    spawner.SpawnEntityAtEntityOrigin(e);
    EntFire("gonarch_skill_splash_trigger" ,"Enable", "", 0.0, null);
    EntFire("gonarch_skill_splash_trigger" ,"kill", "", 5.0, null);
}

function charge() {
    EntFireByHandle(self, "RunScriptcode", "Stop();", 0.0, null, null);
    local victim = SearchTarget();
    local sa = self.GetAngles().y;
    local ta = GetTargetYaw(self.GetOrigin(),victim.GetOrigin());
    local angdif = (sa-ta-180);
    while(angdif>360){angdif-=180;}
    while(angdif<(-180)){angdif+=360;}
    angdif=abs(angdif);
    if(angdif >= 10){ScriptPrintMessageCenterAll("与目标切角过大，无法执行冲撞！");Start();return;}
    ScriptPrintMessageCenterAll("冲撞！");
    EntFireByHandle(gonarch_prop, "SetAnimation", "idle", 0.0, null, null);
    EntFireByHandle(gonarch_prop, "SetAnimation", "idletoCharge", 0.7, null, null);
    EntFireByHandle(gonarch_prop, "SetAnimation", "charge", 3.0, null, null);
    EntFire("npc_thruster_charge", "Activate", "", 3.0, null);
    EntFire("npc_thruster_charge", "Deactivate", "", 6.0, null);
    EntFireByHandle(gonarch_prop, "SetAnimation", "walk", 6.0, null, null);
    EntFireByHandle(self, "RunScriptcode", "start();", 6.0, null, null);
}