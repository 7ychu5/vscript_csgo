SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "UNKNOWN";
SCRIPT_TIME <- "2023年7月8日12:12:58";

//需要特效：弓箭、弓箭爆能显示特效、弓箭爆能发射特效、弓箭爆炸特效

//////////////////参数////////////////////
Cooldown <- 5;                  //冷却时间

Energy_count <- 0;              //能量从此计数
Energy_max <- 100;              //爆能阈值

Damage_normal <- 10;            //普攻伤害
Damage_extreme <- 1000;         //爆能伤害

bar_energy <- "0 255 255"       //能量条颜色
bar_cooldown <- "255 0 255"     //冷却条颜色

Damage_sound <- "player/damage1.wav"//普攻命中声

//////////////////////////////////////////

IncludeScript("7ychu5/ze_emiya/utils.nut");
self.PrecacheScriptSound(Damage_sound);

//////////////////////////////////////////

Bow_user <- null;
Bow_prop <- null;
Bow_use_toggle <- true;
text_cooldown <- null;
text_energy <- null;

function PickUpBow() {
    Bow_user <- null;Bow_user <- activator;
    Bow_prop <- Entities.FindByNameNearest("item_bow_prop*", self.GetOrigin(), 128);
    text_energy <- CreateText();
    text_energy.__KeyValueFromString("channel", "4");
    text_energy.__KeyValueFromString("color",bar_energy);
    EntFireByHandle(text_energy, "Display", "", 0.0, Bow_user, null);
    EntFireByHandle(self, "RunScriptCode", "text_energy_display()", 0.0, null, null);
}

function text_energy_display() {
    EntFireByHandle(text_energy, "SetText", "弓箭充能："+Energy_count+"/100", 0.00, null, null);
    EntFireByHandle(text_energy, "Display", " ", 0.01, Bow_user, null);

    EntFireByHandle(self, "RunScriptCode", "text_energy_display()", 1.0, null, null);
}

function UseBow() {
    if(Bow_use_toggle == true && activator == Bow_user)
    {
        Bow_use_toggle = false;
        local maker = Entities.CreateByClassname("env_entity_maker");
        maker.__KeyValueFromString("EntityTemplate","item_arrow_temp");

        if(Energy_count>=Energy_max)
        {
            EntFireByHandle(self, "RunScriptcode", "Energy_count -= Energy_max;", Cooldown, null, null);
            // if(Energy_count>=Energy_max)
            // {
            //     printl("弓箭进入爆能状态")//判定弓箭是否展示爆能特效
            // }
            maker.__KeyValueFromString("EntityTemplate","item_arrow_extreme_temp");
            EntFire("item_bow_particle", "Start", "", 0.0, null);//爆能射箭外观效果
        }

        maker.__KeyValueFromString("PostSpawnSpeed","20000");
        maker.__KeyValueFromString("PostSpawnDirection","0 "+(Bow_prop.GetAngles().y+90.0)+" 0");

        maker.SpawnEntityAtEntityOrigin(Bow_prop);

        EntFireByHandle(maker, "kill", "", 0.01, null, null);
        local text = CreateText();
        text.__KeyValueFromString("y", "0.44");
        text.__KeyValueFromString("color",bar_cooldown);//CD显示颜色
        local Cooldown_tick = Cooldown;
        for(local j=0;j<Cooldown;j+=0.1)
        {
            EntFireByHandle(text, "SetText", "张弓搭箭： "+Cooldown_tick+" 秒", j, null, null);
            EntFireByHandle(text, "Display", "", j, Bow_user, null);
            Cooldown_tick-=0.1;
        }
        EntFireByHandle(text, "kill", "", Cooldown, null, null);
        EntFireByHandle(self, "RunScriptCode", "Bow_use_toggle = true", Cooldown, null, null);
        EntFireByHandle(text, "SetText", "准备就绪！", Cooldown, null, null);
        EntFireByHandle(text, "Display", "", Cooldown, Bow_user, null);
        EntFireByHandle(text, "kill", "", Cooldown, null, null);
    }
}

function TouchEnemy() {
    if(activator.GetTeam() != 2 || activator.GetHealth() <=0 || !activator.IsValid()) return;
    if(Energy_count>=Energy_max)
    {
        local boom = Entities.CreateByClassname("Env_explosion");
        boom.SetOrigin(activator.GetOrigin());
        boom.__KeyValueFromString("iMagnitude", "1000");
        boom.__KeyValueFromString("iRadiusOverride", "256");
        EntFireByHandle(boom, "Explode", "", 0.0, Bow_user, null);
        //爆能
    }

    local hp = activator.GetHealth();if(hp>Damage_normal) activator.SetHealth(hp-Damage_normal);

    Energy_count += 5;
    printl(Energy_count);
    if(Energy_count>=Energy_max)//判定放最后判定弓箭是否展示爆能特效
    {
        EntFire("item_bow_particle", "Start", "", 0.0, null);
        printl("弓箭进入爆能状态")//判定弓箭是否展示爆能特效
    }
    activator.EmitSound("player/damage1.wav");
    EntFireByHandle(caller, "FireUser1", "", 0.0, null, null);//如果希望弓箭带有穿透效果请删除此行。BUG：可能会射一半突然完成充能引发爆炸
}

function Energy_charge(mount) {
    if(activator != Bow_user || activator.GetHealth() <=0 || !activator.IsValid()) return;
    Energy_count += mount;
}