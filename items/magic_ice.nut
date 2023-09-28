SCRIPT_OWNER <- "7ychu5";
SCRIPT_TIME <- "2023年9月22日09:56:19";
SCRIPT_MAP <- "GLOBAL";
SCRIPT_VERISON <- "0.1";

IncludeScript("7ychu5/utils.nut");


//////////user_variable///////////

vm <- "models/7ychu5/weapon/cast.mdl";

weapon <- "knife";

self.PrecacheModel(vm);

//////////sys_variable////////////

ice_user <- null;

logic_mm <- null;
particle <- null;
trigger <- null;

vm_ent <- null;
prev_ent <- null;

//////////////////////////////////

function id(num) {
    switch (num) {
        case 0:
            logic_mm = caller;
            break;
        case 1:
            particle = caller;
            break;
        case 2:
            trigger = caller;
            break;
    }
}

function magic_ice_get() {
    ice_user = activator;
    EntFireByHandle(logic_mm, "SetMeasureTarget", ice_user.GetName(), 0.00, null, null);
}

function magic_ice_cast() {
    local ent;
    while((ent = Entities.FindByClassname(ent, "*") ) != null)
    {
        if(ent.GetClassname() == "predicted_viewmodel")
        {
            if(ent.GetMoveParent() == ice_user)
            {
                if(ent.GetModelName().find(weapon, 0) != null || ent.GetModelName() == "" ) continue;
                else return;
            }
        }
    }

    while((ent = Entities.FindByClassname(ent, "*") ) != null)
    {
        if(ent.GetClassname() == "predicted_viewmodel")
        {
            if(ent.GetMoveParent() == ice_user)
            {
                vm_ent = ent;
                prev_ent = ent.GetModelName();
                ent.SetModel(vm);
                EntFireByHandle(ent, "SetAnimation", "cast", 0.0, null, null);
                EntFireByHandle(ent, "SetAnimation", "casting", 3.0, null, null);
            }
        }
    }
    EntFireByHandle(trigger, "Enable", "", 3.2, null, null);
    EntFireByHandle(particle, "Start", "", 3.0, null, null);

    EntFireByHandle(trigger, "Disable", "", 10.2, null, null);
    EntFireByHandle(particle, "Stop", "", 10.0, null, null);

    EntFireByHandle(self, "RunScriptcode", "restore_model(vm_ent, prev_ent);", 10.0, null, null);
}

function restore_model(vm_ent, prev_ent) {
    vm_ent.SetModel(prev_ent);
}

::magic_ice_hurt <- function () {
    EntFire("speedmod", "AddOutput", "Spawnflags 0", 0.0, null);
    EntFire("speedmod", "ModifySpeed", "0.1", 0.0, activator);
    EntFire("speedmod", "ModifySpeed", activator.GetScriptScope().xp_speed.tostring(), 5.0, activator);
}