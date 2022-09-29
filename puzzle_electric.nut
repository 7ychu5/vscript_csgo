/*
制作
一个开头点(electric_start)
一个结尾点(electric_end)

按E安放electric_relay；

在落点GetOrigin spawn一根小柱子(electric_relay)；
electric_relay自动播放particles_coordinate；
if(electric_start搜寻nearest64的electric_relay)
{
	GetOrigin()；
	将Origin写进particles_laser的control point；
	kill particles_coordinate；
}
if(electric_relay自动搜寻nearest64的electric_relay存在 && nearest64 particles_laser没打开 && nearest64 particles_coordinate打开)
{
	GetOrigin()；
	将Origin写进particles_laser的control point；
	kill particles_coordinate；
}
if(electric_relay自动搜寻nearest64的electric_end && !self particles_laser没打开)
{
	GetOrigin()；
	将Origin写进particles_laser的control point；
	触发特定IO事件；
}
*/
function max(v1,v2)
{
	if(v1 > v2) return v1;
	return v2;
}
function min(v1,v2)
{
	if(v1 < v2) return v1;
	return v2;
}
puzzle_electric_start <- Entities.FindByName(null,"puzzle_electric_start_prop");
puzzle_electric_end <- Entities.FindByName(null,"puzzle_electric_end_prop");
puzzle_electric_start_origin <- puzzle_electric_start.GetOrigin();
puzzle_electric_end_origin <- puzzle_electric_end.GetOrigin();

//FindByNameNearest(string targetname, Vector origin, float radius)
//__KeyValueFromString(string key, string value)

//void EntFireByHandle(handle target, string action, string value, float delay, handle activator, handle caller)

function check_puzzle_electric_start()
{
	printl("0");
	if(Entities.FindByNameNearest("puzzle_electric_relay_prop*", puzzle_electric_start_origin, 128) != null && Entities.FindByNameNearest("puzzle_electric_particles_range*", puzzle_electric_start_origin, 128) != null)
	{
		printl("1");
		local puzzle_electric_relay_prop = Entities.FindByNameNearest("puzzle_electric_relay_prop*", puzzle_electric_start_origin, 128);//查一下name_fix的内容，锁错人了
		local puzzle_electric_particles_laser = Entities.FindByNameNearest("puzzle_electric_particles_laser*", puzzle_electric_start_origin, 64);
		puzzle_electric_particles_laser.__KeyValueFromString("cpoint1", puzzle_electric_relay_prop.GetName());//
		EntFireByHandle(puzzle_electric_particles_laser, "start", " ", 0.0, null, null);
		local puzzle_electric_particles_range = Entities.FindByNameNearest("puzzle_electric_particles_range*", puzzle_electric_start_origin, 128);
		EntFireByHandle(puzzle_electric_particles_range, "kill", " ", 0.0, null, null);
	}
}

item_electric_toggle <- true;
item_electric_sp_toggle <- true;
item_electric_user_gun <- Entities.FindByName(null,"item_electric_user_gun");
item_electric_show_prop <- Entities.FindByName(null,"item_electric_show_prop");
function item_electric_use()
{
	if(item_electric_toggle == true)
	{
		if(item_electric_sp_toggle == true)
		{
			//handle FindByClassnameNearest(string class, Vector origin, float radius)
			local item_electric_user_maker = Entities.CreateByClassname("env_entity_maker");
			item_electric_user_maker.__KeyValueFromString("EntityTemplate", "item_electric_1_template");
			item_electric_user_maker.SpawnEntityAtLocation(item_electric_show_prop.GetOrigin(), Vector(0, 0, 0));
			item_electric_sp_toggle <- false;
		}
		else if(item_electric_sp_toggle == false)
		{
			local item_electric_user_maker = Entities.CreateByClassname("env_entity_maker");
			item_electric_user_maker.__KeyValueFromString("EntityTemplate", "item_electric_2_template");
			item_electric_user_maker.SpawnEntityAtLocation(item_electric_show_prop.GetOrigin(), Vector(0, 0, 0));
			EntFireByHandle(item_electric_show_prop,"kill"," ",0.0,null,null);
			item_electric_sp_toggle=!item_electric_sp_toggle;
			item_electric_toggle <- false;
			item_electric_sp_toggle <- true;
			item_electric_calc();
		}
	}
	else printl("nope");
}
function item_electric_calc()
{
	local item_electric_1_particles_laser_1 = Entities.FindByName(null,"item_electric_1_particles_laser_1");
	local item_electric_1_particles_laser_2 = Entities.FindByName(null,"item_electric_1_particles_laser_2");
	local item_electric_1_particles_laser_3 = Entities.FindByName(null,"item_electric_1_particles_laser_3");
	local item_electric_2_particles_laser_1 = Entities.FindByName(null,"item_electric_2_particles_laser_1");
	local item_electric_2_particles_laser_2 = Entities.FindByName(null,"item_electric_2_particles_laser_2");
	local item_electric_2_particles_laser_3 = Entities.FindByName(null,"item_electric_2_particles_laser_3");
	item_electric_1_particles_laser_1.__KeyValueFromString("cpoint1", item_electric_2_particles_laser_1.GetName());
	item_electric_1_particles_laser_2.__KeyValueFromString("cpoint1", item_electric_2_particles_laser_2.GetName());
	item_electric_1_particles_laser_3.__KeyValueFromString("cpoint1", item_electric_2_particles_laser_3.GetName());
	EntFire("item_electric_1_particles_range", "kill"," ",0.0,null);
	EntFire("item_electric_2_particles_range", "kill"," ",0.0,null);
	EntFireByHandle(item_electric_1_particles_laser_1,"start"," ",0.0,null,null);
	EntFireByHandle(item_electric_1_particles_laser_2,"start"," ",0.0,null,null);
	EntFireByHandle(item_electric_1_particles_laser_3,"start"," ",0.0,null,null);
	check_sb_in_electric();
}
function check_sb_in_electric()
{
	local item_electric_1_particles_laser_1 = Entities.FindByName(null,"item_electric_1_particles_laser_1");
	local item_electric_1_particles_laser_1_origin = item_electric_1_particles_laser_1.GetOrigin();
	local item_electric_2_particles_laser_3 = Entities.FindByName(null,"item_electric_2_particles_laser_3");
	local item_electric_2_particles_laser_3_origin = item_electric_2_particles_laser_3.GetOrigin();
	local electric_x_max = max(item_electric_1_particles_laser_1_origin.x,item_electric_2_particles_laser_3_origin.x);
	local electric_x_min = min(item_electric_1_particles_laser_1_origin.x,item_electric_2_particles_laser_3_origin.x);
	local electric_y_max = max(item_electric_1_particles_laser_1_origin.y,item_electric_2_particles_laser_3_origin.y);
	local electric_y_min = min(item_electric_1_particles_laser_1_origin.y,item_electric_2_particles_laser_3_origin.y);
	local electric_z_max = max(item_electric_1_particles_laser_1_origin.z,item_electric_2_particles_laser_3_origin.z);
	local electric_z_min = min(item_electric_1_particles_laser_1_origin.z,item_electric_2_particles_laser_3_origin.z);
	electric_z_min -=40;
	for (local ent; ent = Entities.FindByClassname(ent, "player"); )
	{
		local ent_origin_x = ent.GetOrigin().x;
		local ent_origin_y = ent.GetOrigin().y;
		local ent_origin_z = ent.GetOrigin().z;
		if(ent_origin_x > electric_x_min && ent_origin_x < electric_x_max){
			if(ent_origin_y > electric_y_min && ent_origin_y < electric_y_max){
				if(ent_origin_z > electric_z_min && ent_origin_z < electric_z_max){
					//void EntFire(string target, string action, string value = "", float delay = 0.0, handle activator = null)
					EntFire("player_speedmod","ModifySpeed","0.1",0.0,ent);
					EntFire("item_electric_suffer_particle","start"," ",0.0,ent);
					EntFire("player_speedmod","ModifySpeed","1",3.0,ent);
					EntFire("item_electric_suffer_particle","stop"," ",2.8,ent);
				}
			}
		}
	}
	EntFire("logic_script","RunScriptCode","check_sb_in_electric()",0.01,null);
}