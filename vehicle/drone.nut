IncludeScript("vs_library");

Drone_model <- "models/props_survival/drone/br_drone.mdl";self.PrecacheModel(Drone_model);
//起步先抬起无人机，直到略高于触发者头顶
//开始循环飞行过程，做触发者判定范围，在头顶周围的圆盘，如果超出水平范围，则朝向activator飞去；超出垂直范围，则减小或增加竖直推力
//巡航状态：以自身为圆球搜索目标，开始推送火球；//bug:穿墙锁人
//定点状态：以触发者副武器impact为落点圆球范围搜索目标，如果搜不到，攻击impact落点；
//手动操作：切换视角进入无人机背后，左键类似电磁铁吸起prop_physics并保持parent姿势，再次按下解除parent。
drone_master <- null;
tick_toggle <- false;

function SearchMaster(target) {return target.GetOrigin();}

function Activate_drone() {
    EntFire("drone_thruster_up", "activate", "", 0.0, activator);
    drone_master = activator;
    local drone_origin = self.GetOrigin();
    local target_origin = SearchMaster(activator);


    local angles = VS.GetAngle(drone_origin, target_origin);
    angles = VecToString(angles);

    EntFire("drone_thruster_dir","AddOutput","angles "+angles,0.10,null);
    EntFire("drone_thruster_dir","AddOutput","force 100",0.10,null);
    EntFire("drone_thruster_forward","AddOutput","force 800",0.10,null);
    EntFire("drone_thruster_dir","Activate","",0.10,null);
    EntFire("drone_thruster_dir","Deactivate","",0.20,null);

    EntFire("drone_prop", "RunScriptCode", "tick()", 0.30, null);
}

function tick() {
    if(!tick_toggle)
    {
        local target_origin = SearchMaster(drone_master);
        local drone_origin =  self.GetOrigin();
        //高度
        if(target_origin.z+120>self.GetOrigin().z)
        {
            EntFire("drone_thruster_up", "Deactivate", "", 0.0, null);
            //EntFire("drone_thruster_up", "AddOutput", "angles -90 0 0", 0.0, null);
            EntFire("drone_thruster_up", "AddOutput", "force 1000", 0.0, null);
            EntFire("drone_thruster_up", "Activate", "", 0.0, null);
        }
        else if(target_origin.z+180<self.GetOrigin().z)
        {
            EntFire("drone_thruster_up", "Deactivate", "", 0.0, null);
            //EntFire("drone_thruster_up", "AddOutput", "angles 90 0 0", 0.0, null);
            EntFire("drone_thruster_up", "AddOutput", "force 500", 0.0, null);
            EntFire("drone_thruster_up", "Activate", "", 0.0, null);
        }

        //水平yaw抓人
        EntFire("drone_thruster_dir", "Deactivate", "", 0.00, null);
        EntFire("drone_thruster_forward", "Dectivate", "", 0.00, null);
        local sa = self.GetAngles().y;
        local ta = GetTargetYaw(drone_origin, target_origin);
        local ang = abs((sa-ta+360)%360);
        if(ang>=180)EntFire("drone_thruster_dir","AddOutput","angles 0 270 0",0.00,null);
        else EntFire("drone_thruster_dir","AddOutput","angles 0 90 0",0.00,null);
        local angdif = (sa-ta-180);
        while(angdif>360){angdif-=180;}
        while(angdif< -180){angdif+=360;}
        angdif=abs(angdif);

        EntFire("drone_thruster_dir", "AddOutput", "force "+(9*angdif).tostring(), 0.0, null);
        EntFire("drone_thruster_forward", "Activate", "", 0.02, null);
        EntFire("drone_thruster_dir", "Activate", "", 0.02, null);

        //循环
        EntFireByHandle(self, "RunScriptCode", "tick()", 0.1, null);
    }
    else return;
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




function change() {
    activator.SetModel(Drone_model);
    activator.__KeyValueFromInt("movetype", 4);
}

function fly_high(toggle) {
    const Charge_Scale = 5;
    local drone_prop2 = Entities.FindByName(null, "drone_prop2");
    if(toggle){
        drone_prop2.GetOrigin();
        drone_prop2.SetAbsOrigin(drone_prop2.GetOrigin() + Vector(0, 0, 10));
    }
    else{
        printl(drone_prop2.GetVelocity());
        //drone_prop2.SetVelocity(Vector(0, 0, Charge_Scale*-89));
    }
}

function fly_forward(toggle) {
    const Charge_Scale = 5;
    local drone_prop2 = Entities.FindByName(null, "drone_prop2");
    if(toggle){
        drone_prop2.GetOrigin();
        drone_prop2.SetAbsOrigin(drone_prop2.GetOrigin() + Vector(0, 10, 0));
    }
    else{
        printl(drone_prop2.GetVelocity());
        //drone_prop2.SetVelocity(Vector(0, 0, Charge_Scale*-89));
    }
}