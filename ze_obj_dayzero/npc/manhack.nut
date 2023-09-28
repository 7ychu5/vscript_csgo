SCRIPT_OWNER <- "7ychu5";
SCRIPT_TIME <- "2023年8月2日16:38:10";
SCRIPT_MAP <- "ze_obj_dayzero";
SCRIPT_VERISON <- "0.1";

IncludeScript("7ychu5/utils.nut")

//////////user_variable///////////
manhack_model <- "models/props_survival/drone/br_drone.mdl"

attack_sound_1 <- "manhack/grind_flesh1.wav";
attack_sound_2 <- "manhack/grind_flesh2.wav";
attack_sound_3 <- "manhack/grind_flesh3.wav";
damage_sound_1 <- "manhack/grind1.wav";
damage_sound_2 <- "manhack/grind2.wav";
damage_sound_3 <- "manhack/grind3.wav";
damage_sound_4 <- "manhack/grind4.wav";
damage_sound_5 <- "manhack/grind5.wav";

TICKRATE 		<- 	0.10;	//the rate (seconds) in which the logic should tick
TARGET_DISTANCE <- 	5000;	//the distance to search for targets
RETARGET_TIME 	<- 	7.50;	//the amount of time to run before picking a new target
SPEED_FORWARD 	<- 	2500.00;	//forward speed modifier 	(0.5=half, 2.0=double, etc)
SPEED_TURNING 	<- 	0.75;	//side speed modifier 	 	(0.5=half, 2.0=double, etc)

HEALTH <- 10;
DAMAGE <- 2;

self.PrecacheModel(manhack_model);
self.PrecacheScriptSound(attack_sound_1);
self.PrecacheScriptSound(attack_sound_2);
self.PrecacheScriptSound(attack_sound_3);
self.PrecacheScriptSound(damage_sound_1);
self.PrecacheScriptSound(damage_sound_2);
self.PrecacheScriptSound(damage_sound_3);
self.PrecacheScriptSound(damage_sound_4);
self.PrecacheScriptSound(damage_sound_5);
//////////sys_variable////////////

health_bar <- null;
target <- null;
tf <- null;
ts <- null;
tu <- null;
ambient <- null;
ttime <- 0.00;
ticking <- false;
HEALTH_MAX <- HEALTH

//////////////////////////////////

function Start(){if(!ticking){ticking = true;Tick();}}
function Stop(){if(ticking){ticking = false;}}
function SetAmbient() {
	ambient = caller;
	local name = "npc_manhack_" + RandomInt(1000, 9999).tostring();
    while(Entities.FindByName(null, name) != null){
        name = "npc_manhack_" + RandomInt(1000, 9999).tostring();
    }
    EntFireByHandle(self, "AddOutput", "targetname "+name, 0.0, null, null);
	// if(health_bar == null){
    //     maker.__KeyValueFromString("EntityTemplate", "template_health_bar");
    //     maker.SpawnEntityAtEntityOrigin(self);
    //     health_bar = Entities.FindByClassnameNearest("prop_money_crate", self.GetOrigin(), 64);
    //     health_bar.SetMaxHealth(HEALTH_MAX);
    //     health_bar.SetHealth(HEALTH_MAX+1);
    // }
	if(self.GetName()!="") return;
}
function Tick()
{
	if(ticking)
		EntFireByHandle(self,"RunScriptCode","Tick();",TICKRATE,null,null);
	else
	{
		EntFireByHandle(tf,"Deactivate","",0.00,null,null);
		EntFireByHandle(ts,"Deactivate","",0.00,null,null);
		EntFireByHandle(tu,"Deactivate","",0.00,null,null);
		return;
	}
	// health_bar.SetOrigin(self.GetOrigin());

	EntFireByHandle(tf,"Deactivate","",0.00,null,null);
	EntFireByHandle(ts,"Deactivate","",0.00,null,null);
	EntFireByHandle(tu,"Deactivate","",0.00,null,null);
	if(target==null||!target.IsValid()||target.GetHealth()<=0.00||target.GetTeam()!=3||ttime>=RETARGET_TIME)
		return SearchTarget();
	ttime+=TICKRATE;
	EntFireByHandle(tf,"Activate","",0.02,null,null);
	EntFireByHandle(ts,"Activate","",0.02,null,null);
	EntFireByHandle(tu,"Activate","",0.02,null,null);
	local sa = self.GetAngles().y;
	local ta = GetTargetYaw(self.GetOrigin(),target.GetOrigin());
	local ang = abs((sa-ta+360)%360);
	if(ang>=180)EntFireByHandle(ts,"AddOutput","angles 0 270 0",0.00,null,null);
	else EntFireByHandle(ts,"AddOutput","angles 0 90 0",0.00,null,null);
	local angdif = (sa-ta-180);
	while(angdif>360){angdif-=180;}
	while(angdif< -180){angdif+=360;}
	angdif=abs(angdif);
	local tdist = GetDistance(self.GetOrigin(),target.GetOrigin());
	local tdistz = (target.GetOrigin().z-self.GetOrigin().z);
	EntFireByHandle(tf,"AddOutput","force "+SPEED_FORWARD.tostring(),0.00,null,null);
	EntFireByHandle(ts,"AddOutput","force "+(SPEED_TURNING*angdif).tostring(),0.00,null,null);

    if(self.GetOrigin().z < target.GetOrigin().z+80){
        EntFireByHandle(tu, "AddOutput", "force 1600", 0.00, null, null);
    }
    else if(self.GetOrigin().z >= target.GetOrigin().z+80){
        EntFireByHandle(tu, "AddOutput", "force 0", 0.00, null, null);
    }


	for(local h;h=Entities.FindByClassnameWithin(h, "cs_bot", self.GetOrigin(), 48);)                   //提醒我最终上线前把这个CS_BOT改成PLAYER！
    {
        if(h==null || !h.IsValid() || h.GetTeam()!=3 || h.GetHealth()<=0) continue;
        local hp = h.GetHealth();

		if(hp - DAMAGE <= 0) EntFireByHandle(h, "SetHealth", "-1", 0.00, null, null);
		else h.SetHealth(hp -= DAMAGE);
		DispatchParticleEffect("blood_impact_basic", h.GetOrigin()+Vector(0, 0, 60), Vector(0, 0, 0));
		h.EmitSound("manhack/grind_flesh"+RandomInt(1, 3)+".wav");
    }
}
function SearchTarget()
{
	ttime = 0.00;
	target = null;
	local h = null;
	local candidates = [];
	while(null!=(h=Entities.FindInSphere(h,self.GetOrigin(),TARGET_DISTANCE)))
	{
		if(h.GetClassname()=="player"&&h.GetTeam()==3&&h.GetHealth()>0)
		{
			if(TraceLine(self.GetOrigin()+Vector(0,0,40),h.GetOrigin()+Vector(0,0,48),self)==1.00)
				candidates.push(h);
		}
	}
	if(candidates.len()==0)return;
	target = candidates[RandomInt(0,candidates.len()-1)];
}
function GetTargetYaw(start,target)
{
	local yaw = 0.00;
	local v = Vector(start.x-target.x,start.y-target.y,start.z-target.z);
	local vl = sqrt(v.x*v.x+v.y*v.y);
	yaw = 180*acos(v.x/vl)/3.14159;
	if(v.y<0)
		yaw=-yaw;
	return yaw;
}
function SetThruster(type)
{
	switch (type) {
		case 0:
			tf=caller;
			break;
		case 1:
			ts=caller;
			break;
		case 2:
			tu=caller;
			break;
	}
}
function GetDistance(v1,v2){return sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y)+(v1.z-v2.z)*(v1.z-v2.z));}

function Health_update() {
	if(activator.GetTeam()!=3) return;
	HEALTH -= 1;

	// hurter.__KeyValueFromString("Damage", "1");
    // hurter.__KeyValueFromString("DamageType", "32");
    // hurter.__KeyValueFromString("DamageTarget", health_bar.GetName());
    // EntFire("hurter", "hurt", "", 0.0, activator)
	local text = Entities.CreateByClassname("game_text");
    text.__KeyValueFromString("effect", "0");
    text.__KeyValueFromString("fadein", "0");
    text.__KeyValueFromString("fadeout", "0");
    text.__KeyValueFromString("holdtime", "1");
    text.__KeyValueFromString("color", "0 255 255");
    text.__KeyValueFromString("channel", "0");
    text.__KeyValueFromString("spawnflags", "0");
	text.__KeyValueFromFloat("x", -1);
	text.__KeyValueFromFloat("y", 0.67);
	local counttemp = HEALTH;
	local value = "飞锯耐久度：";
	for(local j=1;j<=10;j++)
	{
		if(counttemp-floor(HEALTH_MAX/10)>=0)
		{
			counttemp -= floor(HEALTH_MAX/10);
			value = value + "■";
		}
		else
		{
			value = value + "□";
		}
	}
	EntFireByHandle(text, "SetText", value, 0.0, activator, null);
	EntFireByHandle(text, "Display", "", 0.01, activator, null);
	EntFireByHandle(text, "kill", "", 1, activator, null);
	self.EmitSound("manhack/grind"+RandomInt(1, 5)+".wav");

	if(HEALTH <= 0) suicide();
}

function suicide() {
	//health_bar.Destroy();
	tf.Destroy();
	ts.Destroy();
	tu.Destroy();
	ambient.Destroy();
	EntFireByHandle(self, "break", "", 0.02, null, null);
}