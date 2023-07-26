SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "ze_xanthey";
SCRIPT_TIME <- "2023年5月12日22:58:31";
//此脚本引用了大量Luffaran的prefab，致以感谢！
//----------[VARIABLES]----------\\
	TICKRATE 		<- 	0.10;	//the rate (seconds) in which the logic should tick
	TARGET_DISTANCE <- 	280;	//the distance to search for targets
	RETARGET_TIME 	<- 	2.50;	//the amount of time to run before picking a new target
	SPEED_FORWARD 	<- 	1.00;	//forward speed modifier 	(0.5=half, 2.0=double, etc)
	SPEED_TURNING 	<- 	3.00;	//side speed modifier 	 	(0.5=half, 2.0=double, etc)
//===============================================================\\
GVO<-function(vec,_x,_y,_z){return Vector(vec.x+_x,vec.y+_y,vec.z+_z);}
InSight<-function(start,target){if(TraceLine(start,target,self)<1.00)return true;return true;}//false
GetDistance<-function(v1,v2){return sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y)+(v1.z-v2.z)*(v1.z-v2.z));}
GetDistanceZ<-function(v1,v2){return sqrt((v1.z-v2.z)*(v1.z-v2.z));}
//----------[THE Luffaren's SCRIPT]----------\\
target <- null;
tf <- null;
ts <- null;
ttime <- 0.00;
ticking <- false;
function Start(){if(!ticking){ticking = true;Tick();}}
function Stop(){if(ticking){ticking = false;}}
function Tick()
{
	if(ticking)
		EntFireByHandle(self,"RunScriptCode","Tick();",TICKRATE,null,null);
	else
	{
		EntFireByHandle(tf,"Deactivate","",0.00,null,null);
		EntFireByHandle(ts,"Deactivate","",0.00,null,null);
		return;
	}
	EntFireByHandle(tf,"Deactivate","",0.00,null,null);
	EntFireByHandle(ts,"Deactivate","",0.00,null,null);
	if(target==null||!target.IsValid()||target.GetHealth()<=0.00||target.GetTeam()!=3||ttime>=RETARGET_TIME)
		return SearchTarget();
	ttime+=TICKRATE;
	EntFireByHandle(tf,"Activate","",0.02,null,null);
	EntFireByHandle(ts,"Activate","",0.02,null,null);
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
	EntFireByHandle(tf,"AddOutput","force "+(3000*SPEED_FORWARD).tostring(),0.00,null,null);
	EntFireByHandle(ts,"AddOutput","force "+((3*SPEED_TURNING)*angdif).tostring(),0.00,null,null);


	local npc_model = Entities.FindByNameNearest("npc_model*", self.GetOrigin(), 64);
	local h = null;
	if(null!=(h=Entities.FindInSphere(h,npc_model.GetOrigin(),40)))
	{
		if(h.GetClassname()=="player"&&h.GetTeam()==3&&h.GetHealth()>0){
			EntFireByHandle(self, "RunScriptcode","Stop();",0.0,null,null);
			EntFireByHandle(npc_model, "SetAnimation","attack",0.0,null,null);
			EntFireByHandle(self, "RunScriptcode","shock();",0.5,null,null);
			EntFireByHandle(npc_model, "FireUser1"," ",1.0,null,null);
		}
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

	local npc_model = Entities.FindByNameNearest("npc_model*", self.GetOrigin(), 64);
	EntFireByHandle(npc_model, "SetAnimation","sleeptostand3",0.0,null,null);
	EntFireByHandle(npc_model, "SetAnimation","run",1.0,null,null);
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
function SetThruster(forward){if(forward)tf=caller;else ts=caller;}
//===============================================================\\
function shock() {
	local position = self.GetOrigin();
	local DISTANCE = 320;
	local FORCE_MOD = 1.00;
	local UP_SPEED = 300;
	local humans = [];
	local h = null;
	while(null!=(h=Entities.FindInSphere(h,position,DISTANCE)))
	{
		if(h.GetClassname() == "player" && h.GetHealth()>0)
		{
			if(InSight(position,GVO(h.GetOrigin(),0,0,48))) humans.push(h);
		}
	}
	foreach(target in humans)
	{
		local position = position;
		local tpos = target.GetOrigin();
		local vec = position-tpos;
		local dist = GetDistance(position,GVO(target.GetOrigin(),0,0,40));
		vec.Norm();
		EntFireByHandle(target,"AddOutput","basevelocity "+
			(vec.x*(((dist)-DISTANCE)*FORCE_MOD)).tostring()+" "+
			(vec.y*(((dist)-DISTANCE)*FORCE_MOD)).tostring()+" "+
			(UP_SPEED).tostring(),0.00,null,null);
	}
	DispatchParticleEffect("explosion_hegrenade_brief", self.GetOrigin(), Vector(0,0,0));
}
