SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "ze_obj_insane_v1";
SCRIPT_TIME <- "2022年8月30日01:36:31";

heal_owner <- null;
heal_count <- 0;
heal_count_max <- 4;
heal_item <- Entities.FindByName(null, "item_heal_gun")

function pick_heal() {
    heal_owner = activator;
}

function heal_display() {
    if (heal_owner == null) EntFire("heal_display_text", "SetText", "欢迎来到ze_obj_insane_v1", 0.00, null);
    else if (heal_item.GetOwner() == heal_owner && heal_owner.GetTeam().tostring() == "3") {
        EntFire("heal_display_text", "SetText", "紧急治疗 " + heal_count.tostring() + "/" + heal_count_max.tostring() + " " +::GetNameByUserid(heal_item.GetOwner().GetScriptScope().userid).tostring(), 0.00, null);
    } else if (heal_item.GetOwner() != heal_owner) {
        EntFire("heal_display_text", "SetText", "紧急治疗神器已掉落！", 0.00, null);
    } else if (heal_owner.GetTeam().tostring() == "2") {
        EntFire("heal_display_text", "SetText", "紧急治疗被卖了，找回医疗包！", 0.00, null);
    } else {
        EntFire("heal_display_text", "SetText", "欢迎来到ze_obj_insane_v1", 0.00, null);
    }
    EntFire("heal_display_text", "Display", "", 0.02, null);
}

function CastHeal() {
    if (heal_count < heal_count_max) {
        heal_count++;
        if (activator == heal_owner && heal_owner.IsValid() && heal_owner.GetHealth() > 0) {
            EntFire("item_heal_trigger", "Enable", "", 0.00, null);
            EntFire("item_heal_trigger", "Disable", "", 0.50, null);
        }
    }
}