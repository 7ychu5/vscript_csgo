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

class text_input
{
    title="";
    maintain=["“""自""讨""苦""吃""”""\n"
	"第""5""天""-""18"":""35"":""53""\n"
	"列""兵""詹""姆""斯""丶""拉""米""雷""斯""\n"
	"75""游""骑""兵""团""1""营""\n"
	"美""国""，""华""盛""顿""特""区""\n"];
	symbol=["|""  ""  ""  ""  ""Б ""Р ""Ж ""Щ ""Э "];
}

function test_text() {
	local text = Entities.CreateByClassname("game_text");
    text.__KeyValueFromFloat("x", 0.17);
    text.__KeyValueFromFloat("y", 0);
    text.__KeyValueFromString("channel", "1");
	text.__KeyValueFromString("effect","0");
    text.__KeyValueFromString("color", "82 196 26");
    text.__KeyValueFromString("spawnflags","1");
    text.__KeyValueFromString("holdtime","10");
	text.__KeyValueFromString("fadein","0");
	text.__KeyValueFromString("fadeout","0");
	//text.__KeyValueFromString("fxtime","1");
	local output = "";
	local output2 = "";
	local output3 = "";
	local output4 = "";
	local num = text_input.maintain.len().tofloat();
	local relay = 0.0;
	for(local j=0.0;j<num;j++)
	{
		if(j==num-1) EntFireByHandle(text, "SetText", output+=text_input.maintain[j], relay, null, null);
		else EntFireByHandle(text, "SetText", output+=text_input.maintain[j]+text_input.symbol[RandomInt(0, 0)], relay, null, null);
    	EntFireByHandle(text, "Display", " ", relay, null, null);
		output = output.slice(0,-1);
		if(text_input.maintain[j] == "\n")
		{
			relay += 1.0;
			output2 += text_input.maintain[j];
			output3 += text_input.maintain[j];
			output4 += text_input.maintain[j];
		}
		else
		{
			relay += 0.1;
			if (RandomInt(0, 4)<1) {
				output2 += text_input.maintain[j];
				output3 += text_input.maintain[j];
				output4 += text_input.maintain[j];
			}
			else{
				output2 += text_input.symbol[RandomInt(4, 9)];
				output3 += text_input.symbol[RandomInt(1, 7)];
				output4 += text_input.symbol[RandomInt(1, 5)];
			}
		}
	}
	EntFireByHandle(text, "SetText", output2, relay+1.0, null, null);
	EntFireByHandle(text, "Display", " ", relay+1.0, null, null);
	EntFireByHandle(text, "SetText", output3, relay+1.5, null, null);
	EntFireByHandle(text, "Display", " ", relay+1.5, null, null);
	EntFireByHandle(text, "SetText", output4, relay+2.0, null, null);
	EntFireByHandle(text, "Display", " ", relay+2.0, null, null);
	EntFireByHandle(text, "SetText", "", relay+2.5, null, null);
	EntFireByHandle(text, "Display", " ", relay+2.5, null, null);
    EntFireByHandle(text, "kill", " ", relay+2.5, null, null);
}