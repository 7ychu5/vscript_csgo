SCRIPT_OWNER <- "7ychu5";
SCRIPT_TIME <- "2023年8月2日16:38:10";
SCRIPT_MAP <- "UNKNOWN";
SCRIPT_VERISON <- "0.1";

IncludeScript("7ychu5/utils.nut");

//////////user_variable///////////
drone_model <- "models/props_survival/drone/br_drone.mdl"   //无人机模型
drone_user_model <- "models/player/custom_player/legacy/tm_phoenix_heavy.mdl"//无人机摧毁后先变人再死亡

drone_user_health <- 65535          //用户血量（绝对不能让用户肉体直接死亡！！！会导致不可预料的结果！！！）
drone_health_max <- 50              //允许被击中次数

weapon_fire_cooldown <- 7           //抛雷冷却
weapon_fire_force <- 100000           //抛雷力度
weapon_fire_damage <- 1000          //爆雷伤害
weapon_fire_range <- 512            //爆雷范围（这个范围太小会导致伤害无法正常计算）

catch_range <- 256;                 //抓人范围

/*
抓人用的是一个球形查找，也就是说
这个范围指的是
假设抓人范围是 x
无人机的Origin，在 Z 轴上减去 x
然后以这个计算后的值
形成一个半径为 x 值的球
寻找其中一个受害者
所以这玩意儿是能穿墙抓人的
抓人范围仔细调一下
*/

self.PrecacheModel(drone_model);
self.PrecacheModel(drone_user_model);
//////////sys_variable////////////

drone_user <- null;
victim <- null;

catch_toggle <- false;
drone_health <- drone_health_max;

//////////////////////////////////

function drone_give() {
    //if(activator.GetName() != "") return;
    local stripper = Entities.CreateByClassname("Player_weaponstrip");
    EntFireByHandle(stripper, "strip", "", 0.0, activator, caller);
    local maker = Entities.CreateByClassname("env_entity_maker");
    maker.__KeyValueFromString("EntityTemplate","drone_template");
    maker.SpawnEntityAtEntityOrigin(activator);
    EntFireByHandle(maker, "kill", "", 0.01, null, null);
    EntFireByHandle(stripper, "kill", "", 0.01, null, null);
}

///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////

function drone_pickup() {
    drone_user <- activator;
    EntFireByHandle(self, "Activate", "", 0.0, drone_user, drone_user);
    drone_user.SetMaxHealth(drone_user_health);
    drone_user.SetHealth(drone_user_health);


    self.ConnectOutput("PlayerOn", "PlayerOn");
	self.ConnectOutput("PlayerOff", "PlayerOff");
    self.ConnectOutput("PressedAttack", "drone_fire");
	self.ConnectOutput("PressedAttack2", "drone_weapon_catch");


    EntFireByHandle(drone_user, "AddOutput", "targetname drone_user", 0.0, null, null);
    drone_user.SetModel(drone_model);
    EntFireByHandle(drone_user, "AddOutput", "movetype 4", 0.0, null, null);

}


function PlayerOn() {
    local text = CreateText();
    EntFireByHandle(text, "SetText", "面朝地板按S往上飞\n左键扔雷 "+ weapon_fire_cooldown.tostring() +"秒一个\n右键逮捕脚下"+ catch_range.tostring() +"码范围的一个玩家", 0.00, null, null);
    text.__KeyValueFromString("holdtime", "10");
    text.__KeyValueFromString("y", "0.7");
    EntFireByHandle(text, "Display", "", 0.02, drone_user, drone_user);
    EntFireByHandle(text, "kill", "", 10, null, null);
}

function PlayerOff() {
    ScriptPrintMessageChatAll("炸弹小飞机已下线");
    EntFireByHandle(drone_user, "AddOutput", "targetname ", 0.0, null, null);
    EntFireByHandle(self, "kill", "", 0.02, drone_user, drone_user);
    drone_user.SetModel(drone_user_model);
    EntFireByHandle(drone_user, "AddOutput", "movetype 2", 0.0, null, null);
    EntFireByHandle(drone_user, "SetHealth", "-1", 0.03, drone_user, drone_user);
}

function drone_fire(){
    //printl("fire");
    local maker = Entities.CreateByClassname("env_entity_maker");
    maker.__KeyValueFromString("EntityTemplate","drone_weapon_template");
    maker.__KeyValueFromInt("PostSpawnSpeed", weapon_fire_force);
    maker.__KeyValueFromString("PostSpawnDirection","0 "+(drone_user.GetAngles().y)+" 0");
    maker.SpawnEntityAtEntityOrigin(drone_user);
    EntFireByHandle(maker, "kill", "", 0.01, null, null);

    drone_user.SetHealth(drone_user_health);//每次攻击都回满血
}

function drone_weapon_catch() {
    if(catch_toggle == true)
    {
        local origin = drone_user.GetOrigin();
        origin = Vector(origin.x, origin.y, origin.z-catch_range)
        local victims = [];
        for(local h;h=Entities.FindByClassnameWithin(h,"cs_bot",origin,catch_range);)                   //提醒我最终上线前把这个CS_BOT改成PLAYER！
        {
            if(h==null||!h.IsValid()||h.GetTeam()!=3||h.GetHealth()<=0) continue;
            victims.push(h);
        }
        if(victims.len()<=0) return;
        victim <- victims[RandomInt(0,victims.len()-1)];

        EntFireByHandle(speedmod, "ModifySpeed", "0", 0.0, victim, null);

        catch_toggle <- false;
        catch_tick();
    }
    else
    {
        Release_victim();
    }

}

function catch_tick() {
    if(!catch_toggle)
    {
        local origin = drone_user.GetOrigin();
        victim.SetOrigin(Vector(origin.x, origin.y, origin.z-112));
        EntFireByHandle(self, "RunScriptcode", "catch_tick()", 0.01, null, null);
    }
}

function drone_hp_change(a) {
    drone_health += a;
    printl(drone_health);
    printl(self);printl(caller);
    if(drone_health <= 0)
    {
        EntFireByHandle(caller, "kill", "", 0.0, drone_user, drone_user);
        EntFireByHandle(self, "Deactivate", "", 0.0, drone_user, drone_user);
    }

}

function Release_victim() {
    EntFireByHandle(speedmod, "ModifySpeed", "1.00", 0.0, victim, null);
    victim <- null;
    catch_toggle <- true;
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
