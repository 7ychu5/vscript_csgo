SCRIPT_OWNER <- "7ychu5";
SCRIPT_TIME <- "2023年8月2日09:51:28";
SCRIPT_MAP <- "UNKNOWN";
SCRIPT_VERISON <- "0.1";

//////////user_variable///////////

helicopter_destroy_model <- "models/props_vehicles/helicopter_rescue_smashed.mdl";

self.PrecacheModel(helicopter_destroy_model);


//////////sys_variable////////////

helicopter_user <- null;
helicopter_camera <- null;
helicopter_prop <- null;

speedmod <- null;
    if(Entities.FindByName(null, "speedmod") == null)
        {
            speedmod <- Entities.CreateByClassname("player_speedmod");
            speedmod.__KeyValueFromString("targetname", "speedmod");
            speedmod.__KeyValueFromInt("spawnflags", 11);
        }
    else speedmod <- Entities.FindByName(null, "speedmod");

//////////////////////////////////

function helicopter_start() {
    helicopter_user <- activator;
    helicopter_camera <- Entities.FindByNameNearest("helicopter_camera*", self.GetOrigin(), 2048);
    helicopter_prop <- Entities.FindByNameNearest("helicopter_prop*", self.GetOrigin(), 2048);

    EntFireByHandle(helicopter_camera, "Enable", "", 0.0, helicopter_user, helicopter_user);

    EntFireByHandle(helicopter_prop, "SetAnimation", "2start", 0.0, helicopter_user, helicopter_user);
    EntFireByHandle(helicopter_prop, "SetAnimation", "3ready", 13.3, helicopter_user, helicopter_user);
}

function helicopter_off() {
    EntFireByHandle(helicopter_camera, "Disable", "", 0.0, helicopter_user, helicopter_user);
    EntFireByHandle(helicopter_camera, "kill", "", 0.02, helicopter_user, helicopter_user);

    helicopter_prop.SetModel(helicopter_destroy_model);
}