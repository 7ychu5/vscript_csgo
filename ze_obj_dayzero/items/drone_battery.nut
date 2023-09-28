SCRIPT_OWNER <- "7ychu5";
SCRIPT_TIME <- "2023年8月2日16:38:10";
SCRIPT_MAP <- "ze_obj_dayzero";
SCRIPT_VERISON <- "0.1";

IncludeScript("7ychu5/utils.nut");

//////////user_variable///////////
battery_model <- "models/props/de_nuke/hr_nuke/nuke_vending_machine/nuke_snacks01.mdl"
battery_sound <- "ui/panorama/cards_select_01.wav"

energy_max <- 25;

self.PrecacheModel(battery_model);
self.PrecacheScriptSound(battery_sound);
//////////sys_variable////////////

battery_prop <- Entities.FindByNameNearest("drone_battery_prop*", self.GetOrigin(), 128);

//////////////////////////////////

function check_activator() {
    if(activator.GetTeam() != 3 || activator.GetHealth() <=0 || activator == null || !activator.IsValid() || activator.GetName().slice(0,11) != "drone_user_") return;
    local ent = Entities.FindByNameNearest("drone_btn*", self.GetOrigin(), 512);
    EntFireByHandle(ent, "RunScriptcode", "drone_energy_update(25)", 0.0, null, self);
}

function clear_shit() {
    self.EmitSound(battery_sound);
    self.Destroy();
    battery_prop.Destroy();
}