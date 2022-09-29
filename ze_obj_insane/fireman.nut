SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "ze_obj_insane_v1";
SCRIPT_TIME <- "2022年9月2日22:31:10";

fireman <- null;
fireman_item <- Entities.FindByName(null, "item_fireman_gun");
fireman_pos1 <- fireman_item.GetOrigin();

function become_fireman() {
    fireman = activator;
}

function IsFireman1() {
    printl("1_1");
    if(fireman_item.GetOwner() == activator && fireman.GetTeam().tostring() == "3")
    {
        printl("1_2");
        EntFire("fireman_trigger1", "FireUser1", " ", 0.0, fireman);

    }
}

function UseFireman() {
    local fireman_pos2 = fireman_item.GetOrigin();
    DebugDrawLine(fireman_pos1, fireman_pos2, 255, 80, 80, false, 5.0);
}