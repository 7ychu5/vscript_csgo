SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "ze_mountain_escape_bbo";
SCRIPT_TIME <- "2022年9月4日12:02:13";

exg_toggle <- 0;

function check() {
    exg_toggle <- 1;
    return exg_toggle;
}

function modestart() {
    check();
    local BossBallHurt = Entities.FindByName(null, "BossBallHurt");
    BossBallHurt.__KeyValueFromInt("damage", 3);
    local game_text = Entities.CreateByClassname("game_text");
    game_text.__KeyValueFromString("spawnflags", "1");
    EntFireByHandle(game_text, "SetText", "Current mode: ExG Brawl mode", 0.0, null, null);
    EntFireByHandle(game_text, "Display", " ", 2.0, null, null);
    EntFireByHandle(game_text, "kill", " ", 5.1, null, null);
    EntFire("wind_telespawn_exg", "ForceSpawn", " ", 0.0, null);
    EntFire("barlog_tele", "kill", " ", 0.0 ,null);
    EntFire("dr_tele", "Disable", " ", 0.0 ,null);
    EntFire("minas_item_jugger", "kill", " ", 0.0 ,null);
    EntFire("minas_item_supply", "kill", " ", 0.0 ,null);
    EntFire("minas_item_balrog", "kill", " ", 0.0 ,null);
    EntFire("minas_item_totem", "kill", " ", 0.0 ,null);
    EntFire("minas_item_troll", "kill", " ", 0.0 ,null);
    EntFire("triggers_spawan2t", "Disable", " ", 0.0 ,null);
    EntFire("triggers_spawant", "Disable", " ", 0.0 ,null);
    EntFire("triggers_spawan", "Disable", " ", 0.0 ,null);
    EntFire("triggers_spawan2", "Disable", " ", 0.0 ,null);
    EntFire("barlog_tele", "Disable", " ", 0.0 ,null);
    EntFire("h_item_4_t", "Disable", " ", 0.0 ,null);
    EntFire("jugger_tele", "Disable", " ", 0.0 ,null);
    EntFire("doh_t", "Disable", " ", 0.0 ,null);
    EntFire("barlog_tele_exg", "Enable", " ", 0.0 ,null);
    EntFire("dr_tele_exg", "Enable", " ", 0.0 ,null);

    local jugger_tele_back = Entities.FindByName(null, "jugger_tele_back");
    jugger_tele_back.__KeyValueFromString("target", "br_fail3_1");

    local skyrim_item_back = Entities.FindByName(null, "skyrim_item_back");
    skyrim_item_back.__KeyValueFromString("target", "skyrim_fail");//dragon_in

    local barlog_tele_back = Entities.FindByName(null, "barlog_tele_back");
    barlog_tele_back.__KeyValueFromString("target", "skyrim_fail");//t_out

    if(RandomInt(1, 2) == 1)
    {
        EntFire("bgm_exg_wfl", "playsound", " ", 2.0, null);
        EntFire("bgm_exg_numb", "playsound", " ", 210.0, null);
    }
    else
    {
        EntFire("bgm_exg_numb", "playsound", " ", 2.0, null);
        EntFire("bgm_exg_wfl", "playsound", " ", 187.0, null);
    }
}
function exg_bonus_item_laser_start() {
    local target = "exg_bonus_item_laser_template_" + RandomInt(1, 4).tostring();
    EntFire(target, "FireUser1", " ", 0.0, null);
    EntFire("exg_bonus_item_laser_*", "open", " ", 0.01, null);
    EntFire("blade_out_sound", "playsound", " ", 0.00, null);
    EntFireByHandle(self, "RunScriptCode", "exg_bonus_item_laser_start()", 1.3, null, null);
}

function ExgOrMinas2() {
    if(exg_toggle == 0)
    {
        EntFire("musica_extreme", "PlaySound", " ", 0.0, null);
    }
}

function ExgOrMinas1() {
    if(exg_toggle == 0)
    {
        EntFire("Music_4_2", "PlaySound", " ", 0.0, null);
    }
    else
    {
        EntFire("Music_4_2", "volume", "0", 2.0, null);
    }
}

function ExgOrMinas() {
    if(exg_toggle == 1)
    {
        EntFire("bgm_exg_numb", "volume", "0", 0.0, null);
        EntFire("bgm_exg_wfl", "volume", "0", 0.0, null);
        EntFire("effect_sound", "Volume", "0", 0.0,null);
        EntFire("bgm_exg_ite", "playsound", " ", 1.0, null);
        EntFire("stage_4_relay_3_noraml_exg", "Trigger", " ", 1.0, null);
    }
    else
    {
        EntFire("stage_4_relay_3_noraml", "Trigger", " ", 0.0, null);
    }
}

function infinite_ammo() {
    EntFire("logic_supply", "Trigger", " ", 1.0, null);
    for (local ent; ent = Entities.FindByClassname(ent, "weapon_*");) {
        if(ent.GetClassname() != "weapon_axe" &&
            ent.GetClassname() != "weapon_knife" &&
            ent.GetClassname() != "weapon_breachcharge" &&
            ent.GetClassname() != "weapon_c4" &&
            ent.GetClassname() != "weapon_decoy" &&
            ent.GetClassname() != "weapon_diversion" &&
            ent.GetClassname() != "weapon_flashbang" &&
            ent.GetClassname() != "weapon_healthshot" &&
            ent.GetClassname() != "weapon_hegrenade" &&
            ent.GetClassname() != "weapon_incgrenade" &&
            ent.GetClassname() != "weapon_hammer" &&
            ent.GetClassname() != "weapon_knifegg" &&
            ent.GetClassname() != "weapon_molotov" &&
            ent.GetClassname() != "weapon_smokegrenade" &&
            ent.GetClassname() != "weapon_snowball" &&
            ent.GetClassname() != "weapon_spanner" &&
            ent.GetClassname() != "weapon_tagrenade" &&
            ent.GetClassname() != "weapon_taser" &&
            ent.GetClassname() != "weapon_bumpmine")
            EntFireByHandle(ent,"SetAmmoAmount","100",0.00,null,null);
    }
    //EntFire("logic_script", "RunScriptCode", "infinite_ammo()", 1.0, null);
}

function ff_last_egg() {
    local target = "ff_last_egg_laser_" + RandomInt(1, 2).tostring() + "_template";
    EntFire(target, "FireUser1", " ", 0.0, null);
    EntFire("ff_last_egg_laser_*", "open", " ", 0.01, null);
    EntFire("espad", "playsound", " ", 0.00, null);
}

function mako_seph_laser() {
    local target = "mako_seph_laser_template_" + RandomInt(1, 4).tostring();
    EntFire(target, "FireUser1", " ", 0.0, null);
    EntFire("mako_seph_laser_*", "open", " ", 0.01, null);
    EntFire("espad", "playsound", " ", 0.00, null);
}
//////////items///////////
zm_heal_owner <- null;
items_zm_heal_gun <- Entities.FindByName(null, "items_zm_heal_gun");

function pick_zm_heal() {
    zm_heal_owner = activator;
    local game_text = Entities.CreateByClassname("game_text");
    game_text.__KeyValueFromString("color","255 236 61");
	game_text.__KeyValueFromString("color2","255 236 61");
    game_text.__KeyValueFromString("x","0.01");
	game_text.__KeyValueFromString("y","0.41");
	game_text.__KeyValueFromString("channel","1");
	game_text.__KeyValueFromString("holdtime","5.0");
    EntFireByHandle(game_text, "SetText", "大回复术：给你周围的皮肤神器回复当前血量的20%！"+"\n"+"冷却时间：50秒", 0.0, zm_heal_owner, zm_heal_owner);
    EntFireByHandle(game_text, "Display", " ", 0.1, zm_heal_owner, zm_heal_owner);
    EntFireByHandle(game_text, "kill", " ", 5.1, null, null);
}

function use_zm_heal() {
    local h = null;
    if(null!=(h=Entities.FindInSphere(h,items_zm_heal_gun.GetOrigin(),2048)))
	{
		if(h.GetClassname() == "func_physbox_multiplayer" && h.IsValid())
        {
            local temp = h.GetKeyInt("health");
            temp*=0.2;
            h.__KeyValueFromInt("health", temp);
		}
	}
}