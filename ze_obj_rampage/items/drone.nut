SCRIPT_OWNER <- "7ychu5";
SCRIPT_TIME <- "2023年8月2日16:38:10";
SCRIPT_MAP <- "ze_obj_rampage";
SCRIPT_VERISON <- "0.1";

IncludeScript("7ychu5/utils.nut");

//////////user_variable///////////
//最终换了lotr的戒灵操作系统
//hannibal他妈的能不能滚出ze啊日你马
//全员活在你的阴影下苟延残喘十年了

drone_model <- "models/props_survival/drone/br_drone.mdl"   //无人机模型

drone_speed <- 3.0                    //无人机速度

drone_health_max <- 12;             //无人机基底血量
drone_health_gain <- 1;             //无人机增益血量
weapon_fire_cooldown <- 7           //抛雷冷却
weapon_fire_force <- 100000           //抛雷力度
weapon_fire_damage <- 1000          //爆雷伤害
weapon_fire_range <- 512            //爆雷范围（这个范围太小会导致伤害无法正常计算）

weapon_shock_cooldown <- 30         //震荡冷却
weapon_shock_range <- 256;          //震荡范围
FORCE_MOD <- 3.00;                  //震荡力度
weapon_shock_up_speed <- 250;       //震荡垂直向上的力


self.PrecacheModel(drone_model);
//////////sys_variable////////////

drone_user <- null;

drone_water <- null;
drone_hitbox <- null;
drone_prop <- null;

drone_health <- 0;
drone_fire_toggle <- true;
drone_shock_toggle <- true;

CT_NUM <- 0;

///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////

function confirm_which_is_which(id) {
    switch (id) {
        case 0:drone_water = caller;break;
        case 1:drone_hitbox = caller;break;
        case 2:drone_prop = caller;break;
        default:printl("WHO AM I?");break;
    }
}

function drone_give() {
    printl("11111");
    local name = "drone_user_" + RandomInt(1000, 9999).tostring();
    while(Entities.FindByName(null, name) != null){
        name = "drone_user_" + RandomInt(1000, 9999).tostring();
    }
    EntFireByHandle(activator, "AddOutput", "targetname "+name, 0.0, null, null);
    EntFireByHandle(stripper, "strip", "", 0.0, activator, caller);
    maker.__KeyValueFromString("EntityTemplate","drone_template");
    maker.SpawnEntityAtEntityOrigin(activator);

    // if(CT_NUM != 0) return;
    for(local ent; ent = Entities.FindByClassname(ent, "player");)
    {
        if(ent.GetTeam() == 3)
        {
            CT_NUM++;
            drone_health_max += drone_health_gain;
        }
    }
    drone_health = drone_health_max;
}

///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////

function drone_pickup() {
    if(activator.GetTeam() != 2)return;
    drone_user <- activator;

    self.ConnectOutput("PlayerOn", "PlayerOn");
	self.ConnectOutput("PlayerOff", "PlayerOff");
    self.ConnectOutput("PressedAttack", "drone_fire");
	self.ConnectOutput("PressedAttack2", "drone_weapon_shock");

    EntFireByHandle(self, "Activate", "", 0.01, drone_user, drone_user);

    local name = "drone_user_" + RandomInt(1000, 9999).tostring();
    while(Entities.FindByName(null, name) != null){
        name = "drone_user_" + RandomInt(1000, 9999).tostring();
    }
    EntFireByHandle(drone_user, "AddOutput", "targetname "+name, 0.0, null, null);
}


function PlayerOn() {
    speedmod.__KeyValueFromInt("spawnflags", 1);
    EntFireByHandle(speedmod, "ModifySpeed", drone_speed.tostring(), 0.0, drone_user, drone_user);

    EntFireByHandle(drone_water, "AddOutput", "rendermode 10", 0.0, null, null);
    //EntFireByHandle(drone_prop, "setglowcolor", "0 0 0", 0.0, null, null);
    //EntFireByHandle(drone_prop, "color", RandomInt(64, 255).tostring()+" "+RandomInt(64, 255).tostring()+" "+RandomInt(64, 255).tostring(), 0.0, null, null);//炫彩换色皮

    local text = CreateText();
    EntFireByHandle(text, "SetText", "左键扔雷 "+ weapon_fire_cooldown.tostring() +"秒一个\n右键对附近"+ weapon_shock_range.tostring() +"码范围的一个玩家进行震荡", 0.00, null, null);
    text.__KeyValueFromString("holdtime", "10");
    text.__KeyValueFromString("y", "0.7");
    EntFireByHandle(text, "Display", "", 0.02, drone_user, drone_user);
    EntFireByHandle(text, "kill", "", 10, null, null);
}

function PlayerOff() {
    EntFireByHandle(self, "kill", "", 0.02, drone_user, drone_user);
    EntFireByHandle(drone_water, "kill", "", 0.02, drone_user, drone_user);
    EntFireByHandle(drone_prop, "kill", "", 0.02, drone_user, drone_user);
    EntFireByHandle(drone_user, "SetHealth", "-1", 0.03, drone_user, drone_user);
    speedmod.__KeyValueFromInt("spawnflags", 0);
    EntFireByHandle(speedmod, "ModifySpeed", "1.0", 0.0, drone_user, drone_user);
    EntFireByHandle(drone_user, "AddOutput", "rendermode 0", 0.0, drone_user, drone_user);

    EntFireByHandle(drone_user, "AddOutput", "targetname ", 0.0, null, null);
}

function drone_fire(){
    if(drone_fire_toggle == true && activator.IsValid() && activator.GetHealth() > 0)
    {
        drone_fire_toggle <- false;
        EntFireByHandle(self, "RunScriptCode", "drone_fire_toggle = true", weapon_fire_cooldown, null, null);

        maker.__KeyValueFromString("EntityTemplate","drone_weapon_template");
        maker.__KeyValueFromInt("PostSpawnSpeed", weapon_fire_force);
        maker.__KeyValueFromString("PostSpawnDirection","0 "+(drone_user.GetAngles().y)+" 0");
        maker.SpawnEntityAtEntityOrigin(drone_user);

        //drone_user.SetHealth(drone_user_health);//每次攻击都回满血
    }
}

function drone_weapon_shock() {
    if(drone_shock_toggle == true)
    {
        drone_shock_toggle <- false;
        EntFireByHandle(self, "RunScriptCode", "drone_shock_toggle = true", weapon_shock_cooldown, null, null);

        local position = drone_user.GetOrigin();
        local humans = [];
        local h = null;
        while(null!=(h=Entities.FindInSphere(h,position,weapon_shock_range)))
        {
            if(h.GetClassname() == "player" && h.GetHealth()>0 && h.IsValid() && h.GetTeam()==3)
            {
                humans.push(h);
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
                (vec.x*(((dist)-weapon_shock_range)*FORCE_MOD)).tostring()+" "+
                (vec.y*(((dist)-weapon_shock_range)*FORCE_MOD)).tostring()+" "+
                (weapon_shock_up_speed).tostring(),0.00,null,null);
        }

        DispatchParticleEffect("explosion_hegrenade_brief", position, Vector(0,0,0));
    }

}


function drone_hp_change(a) {
    if(activator.GetTeam() == 2) return;

    drone_health_max += a;

    if(drone_health_max <= 0)
    {
        EntFireByHandle(caller, "kill", "", 0.0, drone_user, drone_user);
        EntFireByHandle(self, "Deactivate", "", 0.0, drone_user, drone_user);
    }

}

function Think() {
    if(drone_user.IsValid() && drone_user != null && drone_user.GetHealth() > 0 && drone_user.GetTeam() == 2) return;
    EntFireByHandle(drone_hitbox, "kill", "", 0.0, drone_user, drone_user);
    EntFireByHandle(self, "Deactivate", "", 0.0, drone_user, drone_user);
}

///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////

function drone_weapon_explode() {
    local origin = caller.GetOrigin();

    local boom = Entities.CreateByClassname("Env_explosion");
    boom.SetOrigin(origin);
    boom.__KeyValueFromInt("iMagnitude", weapon_fire_damage);
    boom.__KeyValueFromInt("iRadiusOverride", weapon_fire_range);
    EntFireByHandle(boom, "Explode", "", 0.0, null, null);
}
