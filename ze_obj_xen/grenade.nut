SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "ze_obj_xen";
SCRIPT_TIME <- "2023年1月1日22:30:01";

GrenadeGun_gameui <- null;
GrenadeGun_User <- null;
function PickupGrenadeGun() {
    local GrenadeGun_gameui = Entities.CreateByClassname("game_ui");
    GrenadeGun_gameui.__KeyValueFromString("targetname", "GrenadeGun_gameui");
    GrenadeGun_gameui.__KeyValueFromString("vscripts", "7ychu5/ze_obj_xen/grenade.nut");
    GrenadeGun_gameui.__KeyValueFromFloat("FieldOfView", -1);

    GrenadeGun_gameui.ConnectOutput("PressedAttack2", "PressedAttack2");
    for (local ent = null; ent = Entities.FindByName(ent, "grenade_gun"); )//找不到对应目标
    {
        GrenadeGun_User = ent.GetRootMoveParent();
        EntFireByHandle(GrenadeGun_gameui, "activate", " ", 0.0, GrenadeGun_User, null);
        printl("0");
    }
    printl("0.0");
}

grenade <- null;
grenade_status <- false;
function PressedAttack2() {
    printl("1");
    if(grenade_status==false)
        {
            local ent = FindByName(null, "grenade_gun");
            grenade <- CreateProp("hegrenade_projectile", ent.GetOrigin(), "models/weapons/w_mp5grenade.mdl", 0);
            grenade_status=true;
        }
        else
        {
            EntFireByHandle(grenade, "InitializeSpawnFromWorld", " ", 0, null, null);
            grenade <- null;
            grenade_status=false;
        }
}