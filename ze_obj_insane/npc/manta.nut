SCRIPT_OWNER <- "Nino";
SCRIPT_MAP <- "ze_obj_insane_v1";
SCRIPT_TIME <- "2022年9月12日00:01:12";

manta2_HP <- 256; //幅鲼初始血量为128血
manta2_HP_max <- 0;
manta_prop2 <- Entities.FindByName(null, "manta_prop2");

function manta2_HP_add(a) {
    manta2_HP += a;

    manta2_HP_max = manta2_HP/15;
    //local manta2_HP_hud = Entities.CreateByClassname("env_hudhint");
}
function HealthChanged(a) {
    if(manta2_HP > 0)
    {
        manta2_HP -= a;
        local manta2_HP_temp = manta2_HP;

        local value = "幅鲼血量：■"
        for(local j=1;j<=15;j++)
        {
            if(manta2_HP_temp-manta2_HP_max>=0)
            {
                manta2_HP_temp-=manta2_HP_max;
                value = value + "■";
            }
            else
            {
                value = value + "□";
            }
        }
        ScriptPrintMessageCenterAll(value);
    }
    else if(manta2_HP <= 0)
    {
        ScriptPrintMessageCenterAll("幅鲼血量：□□□□□□□□□□□□□□□□");
        local manta2_explosion_die = Entities.CreateByClassname("env_explosion");
        manta2_explosion_die.SetOrigin(manta_prop2.GetOrigin());

        EntFire("manta2_physbox", "kill", " ", 0.0, null);
        EntFire("manta_tracktrain", "Stop", " ", 0, null);
        EntFire("manta_prop2", "Kill", " ", 0, null);//死亡
        EntFire("manta_particle_laser", "Stop", " ", 0, null);
        EntFire("manta2_hurt", "kill", " ", 0, null);
        EntFireByHandle(manta2_explosion_die, "Explode", " ", 4, null, null);//死亡特效
        EntFireByHandle(manta2_explosion_die, "kill", " ", 5, null, null);
     }
}