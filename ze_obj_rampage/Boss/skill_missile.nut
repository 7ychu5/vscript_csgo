SCRIPT_OWNER <- "7ychu5";
SCRIPT_TIME <- "2023年8月6日09:51:49";
SCRIPT_MAP <- "ze_obj_rampage";
SCRIPT_VERISON <- "0.1";

IncludeScript("7ychu5/utils.nut");
//这个版本也莫名奇妙能穿墙，func_physbox不应该一撞就碎吗？
//////////user_variable///////////

speed <- 0.0;                          //火箭弹初始速度
speed_acceleration <- 2.5;             //火箭弹加速度
speed_max <- 25.0;                     //火箭弹最大飞行速度
lock_radius <- 10000.0;                //索敌范围
weapon_fire_damage <- 10.0;            //火箭弹伤害
weapon_fire_range <- 512;              //火箭弹范围（这个范围太小会导致伤害无法正常计算）

//////////sys_variable////////////

target <- null;
death_status <- false;
start_status <- true;

t2 <- Vector(0, 0, 0);

//////////////////////////////////

function Tick()
{
    if(start_status){
        SearchTarget();
        if(target != null && target.IsValid() && target.GetHealth() > 0 && self != null && self.IsValid())
        {
            t2 = target.GetOrigin();
            t2.z += 60;
            start_status <- false;
        }
        else{
            EntFireByHandle(self, "FireUser4", "", 0.0, null, null);
            return;
        }
    }

    local t1 = self.GetOrigin();
    local dir = Vector(t2.x - t1.x, t2.y - t1.y, t2.z - t1.z);
    local length = dir.Norm();
    self.SetForwardVector(Vector(dir.x * length, dir.y * length, dir.z * length));
    local newpos = self.GetOrigin() + (self.GetForwardVector()*speed);
    self.SetOrigin(newpos);
    if(speed < speed_max)
        speed += speed_acceleration;
    if(GetDistance(t1, t2) <= speed_max)
    {
        death_status <- true;
    }

    if(death_status)
    {
        EntFireByHandle(self, "FireUser4", "", 0.0, null, null);

        local boom = Entities.CreateByClassname("Env_explosion");
        if(target == null){EntFireByHandle(boom, "kill", "", 0.0, null, null);return;}
        boom.SetOrigin(t2);
        boom.__KeyValueFromInt("iMagnitude", weapon_fire_damage);
        boom.__KeyValueFromInt("iRadiusOverride", weapon_fire_range);
        EntFireByHandle(boom, "Explode", "", 0.0, null, null);

    }
    EntFireByHandle(self, "RunScriptCode", "Tick();", 0.01, null, null);
}
function SearchTarget()
{
    if(!death_status)
    {
        if(target != null && target.IsValid() && target.GetHealth() > 0){return;}
        else
        {
            target = null;
            speed = 0.0;
        }
        local p = null;
        local pa = [];
        while(null != (p = Entities.FindByClassnameWithin(p, "player", self.GetOrigin(), lock_radius)))
        {
            if(p.GetTeam() == 3)
            {
                local ppos = p.EyePosition();
                //printl(TraceLine(self.GetOrigin(),ppos,self));
                if(TraceLine(self.GetOrigin(),ppos,self) == 1.0)
                pa.push(p);
            }
        }
        if(pa.len() > 0) target = pa[RandomInt(0, pa.len()-1)];
        else EntFireByHandle(self, "FireUser4", "", 0.0, null, null);
    }
}