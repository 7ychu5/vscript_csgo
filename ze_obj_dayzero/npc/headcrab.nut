SCRIPT_OWNER <- "7ychu5";
SCRIPT_TIME <- "2023年8月23日16:06:52";
SCRIPT_MAP <- "";
SCRIPT_VERISON <- "0.1";

IncludeScript("7ychu5/utils.nut")

/*
猎头蟹是一种头脑很简单的生物
接近最近的敌人，达到一个阈值后
转头速度还挺快的，反正我是没觉得和动画能匹配得上
向前推进器关闭，进行扑击

与人类接触的话造成少量伤害
如果与EyePosition的距离很低的话，进入处决环节
*/

//////////user_variable///////////
sound_alert <- "npc/headcrab/alert.wav";
sound_attack1 <- "npc/headcrab/attack1.wav";
sound_attack2 <- "npc/headcrab/attack2.wav";
sound_attack3 <- "npc/headcrab/attack3.wav";
sound_die1 <- "npc/headcrab/die1.wav";
sound_die2 <- "npc/headcrab/die2.wav";
sound_headbite <- "npc/headcrab/headbite.wav";
sound_headcrab_burning_loop2  <- "npc/headcrab/headcrab_burning_loop2.wav";
sound_idle1 <- "npc/headcrab/idle1.wav";
sound_idle2 <- "npc/headcrab/idle2.wav";
sound_idle3 <- "npc/headcrab/idle3.wav";
sound_pain1 <- "npc/headcrab/pain1.wav";
sound_pain2 <- "npc/headcrab/pain2.wav";
sound_pain3 <- "npc/headcrab/pain3.wav";

TICKRATE 		<- 	0.10;
TARGET_DISTANCE <- 	5000;
RETARGET_TIME 	<- 	7.50;
SPEED_FORWARD 	<- 	1200.00;
SPEED_TURNING 	<- 	3.0;

HEALTH <- 10;
DAMAGE <- 2;

catch_range <- 128;

speed <- 10.000;                           //发射初速度
speed_acceleration <- 0.00;              //发射加速度
speed_max <- 10.000;                      //最大速度

self.PrecacheScriptSound(sound_alert);
self.PrecacheScriptSound(sound_attack1);
self.PrecacheScriptSound(sound_attack2);
self.PrecacheScriptSound(sound_attack3);
self.PrecacheScriptSound(sound_die1);
self.PrecacheScriptSound(sound_die2);
self.PrecacheScriptSound(sound_headbite);
self.PrecacheScriptSound(sound_headcrab_burning_loop2);
self.PrecacheScriptSound(sound_idle1);
self.PrecacheScriptSound(sound_idle2);
self.PrecacheScriptSound(sound_idle3);
self.PrecacheScriptSound(sound_pain1);
self.PrecacheScriptSound(sound_pain2);
self.PrecacheScriptSound(sound_pain3);
//////////sys_variable////////////

Think_status <- true;       //循环状态
move_toggle <- true;        //行走状态
trap_status <- true;        //扑击状态
health_bar <- null;

prop <- null;
target <- null;
tf <- null;
ts <- null;
ambient <- null;
temp_hurter <- null;

prop_animation <- "";

angdif <- 180;
HEALTH_MAX <- HEALTH

//////////////////////////////////

function confirm_who_am_i(id) {
    switch (id) {
        case 0:
            prop = caller;
            break;
        case 1:
            tf = caller;
            break;
        case 2:
            ts = caller;
            break;
        case 3:
            ambient = caller;
            break;
        case 4:

            break;
        default:
            break;
    }
}

function Think() {//每秒10次
    if(!Think_status) return;
    if(RandomFloat(1, 100) <= 4){
        EntFireByHandle(ambient, "AddOutput", "message npc/headcrab/idle"+RandomInt(1, 3)+".wav", 0.0, null, null);
        EntFireByHandle(ambient, "PlaySound", "", 0.02, null, null);
    }
    if(trap_status){SearchVictim();Move();}
    else{if(target.GetHealth()<=0){
        suicide();
    }}

}

function SearchVictim() {
    local target_origin = Vector(0, 0, 0);
	local h = null;
	local candidates = [];
	while(null!=(h=Entities.FindInSphere(h,self.GetOrigin(),TARGET_DISTANCE)))
	{
		if(h.GetClassname()=="player"&&h.GetTeam()==3&&h.GetHealth()>0)
		{
			if(TraceLine(self.GetOrigin()+Vector(0,0,40),h.GetOrigin()+Vector(0,0,48),self)==1.00)
				if(GetDistance(self.GetOrigin(), h.GetOrigin()) < GetDistance(self.GetOrigin(), target_origin)){
                    target = h;
                    target_origin = target.GetOrigin();
                }
		}
	}
}

function Move() {
    if(!move_toggle) return;
    //rotate_self();
    shift_self();

    local range = GetDistance(self.GetOrigin(), target.GetOrigin());
    printl(range);
    printl(angdif);
    if((angdif <= 5) && (range <= catch_range)){
        move_toggle = false;
        EntFireByHandle(prop, "SetAnimation", "jumpattack_broadcast", 0.0, null, null);
        EntFireByHandle(self, "RunScriptcode", "trap_on();", 0.3, null, null);
    }
}

function rotate_self() {
    EntFireByHandle(ts,"Deactivate","",0.00,null,null);
    if(!move_toggle) return;
    EntFireByHandle(ts,"Activate","",0.02,null,null);
    local sa = self.GetAngles().y;
	local ta = luff_GetTargetYaw(self.GetOrigin(),target.GetOrigin());
	local ang = abs((sa-ta+360)%360);
	if(ang>=180){
        EntFireByHandle(ts,"AddOutput","angles 0 270 0",0.00,null,null);
        if(prop_animation != "T_R"){
            prop_animation = "T_R";
            EntFireByHandle(prop, "SetAnimation", "TurnRight", 0.02, null, null);
        }
    }
	else{
        EntFireByHandle(ts,"AddOutput","angles 0 90 0",0.00,null,null);
        if(prop_animation != "T_L"){
            prop_animation = "T_L";
            EntFireByHandle(prop, "SetAnimation", "TurnLeft", 0.02, null, null);
        }
    }
	local temp_angdif = (sa-ta-180);
	while(temp_angdif>360){temp_angdif-=180;}
	while(temp_angdif< -180){temp_angdif+=360;}
	angdif = abs(temp_angdif);

	EntFireByHandle(ts,"AddOutput","force "+(SPEED_TURNING*angdif).tostring(),0.00,null,null);
}

function shift_self() {
    EntFireByHandle(tf,"Deactivate","",0.00,null,null);
    if(!move_toggle) return;
    if(prop_animation != "R"){
        prop_animation = "R";
        EntFireByHandle(prop, "SetAnimation", "Run1", 0.02, null, null);
    }
    EntFireByHandle(tf,"Activate","",0.02,null,null);
    EntFireByHandle(tf,"AddOutput","force "+SPEED_FORWARD.tostring(),0.00,null,null);
}

function trap_on() {
    if(!trap_status) return;
    local t1 = self.GetOrigin();
    local t2 = target.EyePosition();
    local dir = Vector(t2.x - t1.x, t2.y - t1.y, t2.z - t1.z);
    local length = dir.Norm();
    self.SetForwardVector(Vector(dir.x * length, dir.y * length, dir.z * length));
    local newpos = self.GetOrigin() + (self.GetForwardVector()*speed);
    self.SetOrigin(newpos);
    if(speed < speed_max)
        speed += speed_acceleration;

    if(GetDistance(t1, t2) <= speed)
    {
        trap_status = false;
        Execute();
    }
    EntFireByHandle(self, "RunScriptCode", "trap_on()", 0.01, null, null);
}

function Execute() {
    trap_status = false;
    EntFireByHandle(ambient, "AddOutput", "message npc/headcrab/headbite.wav", 0.0, null, null);
    EntFireByHandle(ambient, "PlaySound", "", 0.02, null, null);
    EntFireByHandle(prop, "SetAnimation", "headcrabbedpost", 0.0, null, null);
    EntFireByHandle(prop, "SetParent", target.GetName(), 0.0, null, null);
    EntFireByHandle(prop, "SetParentAttachment", "clip_limit", 0.0, null, null);

    temp_hurter <- Entities.CreateByClassname("point_hurt");
    temp_hurter.__KeyValueFromString("Damage", "1");
    temp_hurter.__KeyValueFromString("DamageDelay", "0.1");
    temp_hurter.__KeyValueFromString("DamageType", "4");
    temp_hurter.__KeyValueFromString("DamageTarget", target.GetName());
    EntFireByHandle(temp_hurter, "TurnOn", "", 0.0, null, null);
}

function suicide() {
    prop.Destroy();
    ts.Destroy();
    tf.Destroy();
    ambient.Destroy();
    self.Destroy();
    EntFireByHandle(temp_hurter, "kill", "", 0.0, null, null);
}