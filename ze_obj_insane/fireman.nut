SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "ze_obj_insane_v1";
SCRIPT_TIME <- "2022年9月2日22:31:10";

::fireman <- null;
::fireman_item <- Entities.FindByName(null, "item_fireman_gun");

function become_fireman() {
    ::fireman = activator;
}

function IsFireman1() {
    if(::fireman_item.GetOwner() == activator && ::fireman.GetTeam().tostring() == "3")
    {
        EntFire("fireman_trigger1", "FireUser1", "0.0", 0.0, fireman);
    }
}

function IsFireman2() {
    if(::fireman_item.GetOwner() == activator && ::fireman.GetTeam().tostring() == "3")
    {
        EntFire("fireman_trigger2", "FireUser1", "0.0", 0.0, fireman);
    }
}

function IsFireman3() {
    if(::fireman_item.GetOwner() == activator && ::fireman.GetTeam().tostring() == "3")
    {
        EntFire("fireman_trigger3", "FireUser1", "0.0", 0.0, fireman);
    }
}