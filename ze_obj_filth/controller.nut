SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "ze_obj_filth";
SCRIPT_TIME <- "2023年3月16日22:17:42";
SCRIPT_VERSION <- "0.1";

Drone_model <- "models/props_survival/drone/br_drone.mdl";self.PrecacheModel(Drone_model);

controller_prop <- null;
controller_thruster_up <- null;

function set_controller() {
    controller_prop = Entities.FindByNameNearest("controller_prop*", self.GetOrigin(), 256);
    controller_thruster_up = Entities.FindByNameNearest("controller_thruster_up*", self.GetOrigin(), 256);
    activator.SetModel(Drone_model);
    activator.__KeyValueFromInt("movetype", 4);

}