SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "UNKNOWN";
SCRIPT_TIME <- "2023年7月9日19:57:09";

/*
另一个是锁定类神器，
锁定2000hammer单位半径内的一名ct玩家，
然后在他头上生成一个提示特效代表他被锁定了，
5秒后武器会射向玩家一共造成100伤害和3秒定身
*/

//////////////////参数////////////////////
Cooldown <- 30;                         //冷却时间
lock_radius <- 2000                     //锁定半径

speed <- 0.0;                           //发射初速度
speed_acceleration <- 0.1;              //发射加速度
speed_max <- 15.0;                      //最大速度

Damage <- 1000;                          //伤害
Damage_range <- 256;                     //伤害半径

bar_cooldown <- "255 0 255"             //冷却条颜色

Damage_sound <- "player/damage1.wav"    //普攻命中声

//////////////////////////////////////////

IncludeScript("7ychu5/ze_emiya/utils.nut");
self.PrecacheScriptSound(Damage_sound);

//////////////////////////////////////////

Gaebolg_user <- null;
Gaebolg_prop <- null;
Gaebolg_use_toggle <- true;
text_cooldown <- null;
death_status <- false;
target <- null;

function PickUpGaebolg() {
    Gaebolg_user <- null;Gaebolg_user <- activator;
    Gaebolg_prop <- Entities.FindByNameNearest("item_Gaebolg_prop", self.GetOrigin(), 128);
}

function UseGaebolg() {
    if(Gaebolg_use_toggle == true && activator == Gaebolg_user)
    {
        Gaebolg_use_toggle = false;

        local text = CreateText();
        text.__KeyValueFromString("y", "0.44");
        text.__KeyValueFromString("color",bar_cooldown);
        local Cooldown_tick = Cooldown;
        for(local j=0;j<Cooldown;j+=0.1)
        {
            EntFireByHandle(text, "SetText", "准备长矛： "+format("%.1f",Cooldown_tick)+" 秒", j, null, null);
            EntFireByHandle(text, "Display", "", j, Gaebolg_user, null);
            Cooldown_tick-=0.1;
        }
        EntFireByHandle(self, "RunScriptCode", "Gaebolg_use_toggle = true", Cooldown, null, null);

        EntFire("item_gaebolg_prop", "AddOutput", "rendermode 1", 0.0, null);
        EntFire("item_gaebolg_prop", "AddOutput", "renderamt 64", 0.0, null);
        EntFire("item_gaebolg_prop", "AddOutput", "rendermode 0", Cooldown, null);
        EntFire("item_gaebolg_prop", "AddOutput", "renderamt 255", Cooldown, null);

        EntFireByHandle(text, "SetText", "准备就绪！", Cooldown, null, null);
        EntFireByHandle(text, "Display", "", Cooldown, Gaebolg_user, null);
        EntFireByHandle(text, "kill", "", Cooldown, null, null);
        local maker = Entities.CreateByClassname("env_entity_maker");
        maker.__KeyValueFromString("EntityTemplate","item_gaebolg_throw_temp");
        maker.SpawnEntityAtLocation(Vector(activator.GetOrigin().x, activator.GetOrigin().y, activator.GetOrigin().z+100), Vector(0,0,0));
        EntFire("item_gaebolg_throw_prop*", "RunScriptCode", "Tick()", 0.01, "item_gaebolg_throw_prop*")
        EntFireByHandle(maker, "kill", "", 0.01, null, null);
    }
}
function Tick()
{
	if(target != null && target.IsValid() && target.GetHealth() > 0)
	{
		local t1 = self.GetOrigin();
		local t2 = target.GetOrigin();
		t2.z += 60;
		//if(retarget <= 0.0 || TraceLine(self.GetOrigin(),t2,self) < 1.0) SearchTarget();
		// else
		// {
			local dir = Vector(t2.x - t1.x, t2.y - t1.y, t2.z - t1.z);
			local length = dir.Norm();
			self.SetForwardVector(Vector(dir.x * length, dir.y * length, dir.z * length));
			local newpos = self.GetOrigin() + (self.GetForwardVector()*speed);
			self.SetOrigin(newpos);
			if(speed < speed_max)
				speed += speed_acceleration;
		// }
        if(GetDistance(t1, t2) <= 10)
        {
            death_status <- true;
        }
	}
    else SearchTarget();
    if(death_status)
	{
        EntFireByHandle(self, "kill", "", 0.00, null, null);
        EntFire("item_gaebolg_throw_particle*", "start", "", 0.0, null);//建议用一个能自我kill的particle

        local speedmod = Entities.CreateByClassname("player_speedmod");
        speedmod.__KeyValueFromInt("spawnflags", 0);
        EntFireByHandle(speedmod, "ModifySpeed", "0.00", 0.00, target, null);
        EntFireByHandle(speedmod, "ModifySpeed", "1.00", 3.00, target, null);
        target.EmitSound(Damage_sound);
        speedmod.Destroy();

        local boom = Entities.CreateByClassname("Env_explosion");
        boom.SetOrigin(target.GetOrigin());
        boom.__KeyValueFromInt("iMagnitude", Damage);
        boom.__KeyValueFromInt("iRadiusOverride", Damage_range);
        EntFireByHandle(boom, "Explode", "", 0.0, Gaebolg_user, Gaebolg_user);
	}
	EntFireByHandle(self, "RunScriptCode", " Tick() ", 0.01, null, null);
}

function SearchTarget()
{
	if(!death_status)
	{
		if(target != null && target.IsValid() && target.GetHealth() > 0){return;}//这算什么？保险措施？见鬼
		else
		{
			target = null;
			speed = 0.0;
		}
		local p = null;
		local pa = [];
		while(null != (p = Entities.FindByClassnameWithin(p, "cs_bot", self.GetOrigin(), lock_radius)))
		{
			if(p.GetTeam() == 2)
			{
				//local ppos = p.GetOrigin();ppos.z+=48;
				//if(TraceLine(self.GetOrigin(),ppos,self) == 1.0) //直视判定，既然必中，何必在意？
				pa.push(p);
			}
		}
		if(pa.len() > 0)
		{
            target = pa[RandomInt(0, pa.len()-1)];
			local maker = Entities.CreateByClassname("env_entity_maker");
            maker.__KeyValueFromString("EntityTemplate","item_gaebolg_hint_temp");
            maker.SpawnEntityAtEntityOrigin(target);
            EntFireByHandle(maker, "kill", "", 0.01, null, null);
		}
        else
        {
            EntFireByHandle(self, "kill", "", 0.0, null, null);
            //EntFireByHandle(self, "RunScriptCode", "Gaebolg_use_toggle = true", 0.0, null, null);//本来是想空放后回满CD的，但是好像现在的写法不支持了，真是愚蠢啊
        }
	}
}