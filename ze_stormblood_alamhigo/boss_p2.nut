speedmod <- Entities.CreateByClassname("player_speedmod");
spawner <- Entities.CreateByClassname("env_entity_maker");
subtitle <- Entities.CreateByClassname("game_text");
command <- Entities.CreateByClassname("point_servercommand");


function debug() {
    command.__KeyValueFromString("targetname", "command");[]
    EntFireByHandle(command, "Command", "sv_cheats 1;bot_stop 1;", 0.0, null, null);
    EntFire("worldtext_p1", "AddOutput", "message soul_out", 0.0, null);
}

function GVO(vec,_x,_y,_z){return Vector(vec.x+_x,vec.y+_y,vec.z+_z);}
function InSight(start,target){if(TraceLine(start,target,self)<1.00)return true;return true;}//false
function GetDistance(v1,v2){return sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y)+(v1.z-v2.z)*(v1.z-v2.z));}
function GetDistanceZ(v1,v2){return sqrt((v1.z-v2.z)*(v1.z-v2.z));}

DISTANCE <- 2048;
FORCE_MOD <- 1.00;
UP_SPEED <- 300;
boss_p2_prop <- Entities.FindByName(null, "boss_p2_prop");

function soul_out() {
    subtitle.__KeyValueFromFloat("x", -1);
    subtitle.__KeyValueFromFloat("y", 0.8);
    subtitle.__KeyValueFromString("channel", "2");
    subtitle.__KeyValueFromString("color", "255 255 255");
    subtitle.__KeyValueFromString("spawnflags","1");
    subtitle.__KeyValueFromString("holdtime","5.0");
	subtitle.__KeyValueFromString("fadein","0");
	subtitle.__KeyValueFromString("fadeout","0");
	subtitle.__KeyValueFromString("fxtime","0");
    EntFireByHandle(subtitle, "SetText", "奥卢斯 玛尔 亚希纳：来展现研究的成果吧！", 0.00, null, null);
    EntFireByHandle(subtitle, "Display", " ", 0.00, null, null);
    EntFireByHandle(subtitle, "SetText", "奥卢斯 玛尔 亚希纳：灵魂分离！", 5.00, null, null);
    EntFireByHandle(subtitle, "Display", " ", 5.00, null, null);
    EntFireByHandle(subtitle, "SetText", "奥卢斯 玛尔 亚希纳：哈哈哈......实验成功！", 8.00, null, null);
    EntFireByHandle(subtitle, "Display", " ", 8.00, null, null);


    EntFire("viewcontrol", "Enable", " ", 0.0, null);
    EntFire("logic_script", "RunScriptCode", "inhale(boss_p2_prop)", 4.0, null);
    //EntFire("logic_script", "RunScriptCode", "inhale(boss_p2_prop)", 4.0, null);
    EntFire("logic_script", "RunScriptCode", "exhale(boss_p2_prop)", 7.0, null);
    EntFire("trigger_getback*", "Enable", " ", 8.0, null);
    EntFire("viewcontrol", "Disable", " ", 10.0, null);


}

function get_back() {
    //while(null!=(h=Entities.FindInSphere(h,centre.GetOrigin(),DISTANCE)))
    if(activator.GetName()=="ghost"){
        EntFireByHandle(activator, "AddOutput", "targetname ", 0.0, null, null);
        EntFireByHandle(speedmod, "ModifySpeed", "1", 0.0, activator, null);
        EntFireByHandle(activator, "AddOutput", "rendermode 0", 0.0, null, null);
    }


}

function inhale(centre) {
    local humans = [];
	local spos = boss_p2_prop.GetOrigin();
	local hlist = [];
	local h = null;
	while(null!=(h=Entities.FindInSphere(h,centre.GetOrigin(),DISTANCE)))
	{
		if(h.GetClassname() == "player" && h.GetHealth()>0)
		{
			if(InSight(spos,GVO(h.GetOrigin(),0,0,48))) humans.push(h);
		}
	}
	foreach(target in humans)
	{
		local spos = centre.GetOrigin();
		local tpos = target.GetOrigin();
		local vec = spos-tpos;
		local dist = GetDistance(spos,GVO(target.GetOrigin(),0,0,40));
		vec.Norm();
		EntFireByHandle(target,"AddOutput","basevelocity "+
		    (vec.x*(((dist))*FORCE_MOD)).tostring()+" "+
		    (vec.y*(((dist))*FORCE_MOD)).tostring()+" "+
		    (UP_SPEED).tostring(),0.00,null,null);
	}
}

function exhale(centre) {
    local humans = [];
	local spos = boss_p2_prop.GetOrigin();
	local hlist = [];
	local h = null;
    spawner.__KeyValueFromString("EntityTemplate", "temp_fakeman");
	while(null!=(h=Entities.FindInSphere(h,centre.GetOrigin(),DISTANCE)))
	{
		if(h.GetClassname() == "player" && h.GetHealth()>0)
		{
			if(InSight(spos,GVO(h.GetOrigin(),0,0,48))) humans.push(h);
		}
	}
	foreach(target in humans)
	{
		local spos = centre.GetOrigin();
		local tpos = target.GetOrigin();
		local vec = spos-tpos;
		local dist = GetDistance(spos,GVO(target.GetOrigin(),0,0,40));
		vec.Norm();
		EntFireByHandle(target,"AddOutput","basevelocity "+
		    (vec.x*(((dist)-DISTANCE)*FORCE_MOD)).tostring()+" "+
		    (vec.y*(((dist)-DISTANCE)*FORCE_MOD)).tostring()+" "+
		    (UP_SPEED).tostring(),0.00,null,null);
        spawner.SpawnEntityAtEntityOrigin(target);
        EntFireByHandle(target, "AddOutput", "targetname ghost", 0.0, null, null);
        EntFireByHandle(target, "AddOutput", "rendermode 10", 0.0, null, null);
        EntFireByHandle(speedmod, "ModifySpeed", "0.25", 1.0, target, null);
	}
}