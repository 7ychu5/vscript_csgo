SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "ze_obj_insane_v1";
SCRIPT_TIME <- "2022年8月30日01:36:31";
/////////////////////////////////////
weapon_type <- "weapon_negev" //武器种类
weapon_num <- 5; //调整武器上限
/////////////////////////////////////
//fireman_item <- Entities.FindByName(null, "item_fireman_gun");//隔壁的救火员

function weapon_limit() {
    local j = 0;
    for (local ent; ent = Entities.FindByClassname(ent, weapon_type);) {
        if (j >= weapon_num) {
            EntFireByHandle(ent, "kill", " ", 0.0, null, null);
        }
        j++;
    }
    //EntFire("weapon_limit_text", "SetText", "内格夫数量 " + j.tostring() + "/" + weapon_num.tostring(), 0.00, self);
    // if(fireman_item.GetOwner()!=null)
    // {
    //     local fireman_text = Entities.CreateByClassname("game_text");
    //     fireman_text.__KeyValueFromString("x", "0.01");
    //     fireman_text.__KeyValueFromString("y", "0.44");
    //     fireman_text.__KeyValueFromString("channel", "3");
    //     fireman_text.__KeyValueFromString("color", "255 0 0");
    //     fireman_text.__KeyValueFromString("spawnflags","1");
    //     fireman_text.__KeyValueFromString("holdtime","1.0");
	//     fireman_text.__KeyValueFromString("fadein","0");
	//     fireman_text.__KeyValueFromString("fadeout","0");
	//     fireman_text.__KeyValueFromString("fxtime","0");
    //     EntFireByHandle(fireman_text, "SetText", "灭火器携带者 " + ::GetNameByUserid(fireman_item.GetOwner().GetScriptScope().userid).tostring(), 0.00, null, null);
    //     EntFireByHandle(fireman_text, "Display", " ", 0.00, null, null);
    //     EntFireByHandle(fireman_text, "kill", " ", 1.00, null, null);
    // }
    //EntFire("weapon_limit_text", "Display", "", 0.02, self);
    EntFire("weapon_limit_relay", "FireUser1", " ", 1.0, null)
}