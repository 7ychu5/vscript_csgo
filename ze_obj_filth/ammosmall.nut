SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "ze_obj_filth";
SCRIPT_TIME <- "2023年3月6日00:31:46";
SCRIPT_VERSION <- "1.0";

count_max <- 1;
count <- count_max;
function use_ammo() {
    if(activator.GetName() != "ammo_user")
    {
        EntFireByHandle(activator, "AddOutput", "targetname ammo_user", 0.0, null, null);
        EntFireByHandle(activator, "AddOutput", "targetname ", 20.0, null, null);
        if(count>1)
        {
            count--;
            local prop = Entities.FindByNameNearest("supply_ammosmall_prop*", self.GetOrigin(), 8);

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
	    ent.GetClassname() != "weapon_awp" &&
	    ent.GetClassname() != "weapon_aug" &&
	    ent.GetClassname() != "weapon_sg553" &&
	    ent.GetClassname() != "weapon_mag7" &&
	    ent.GetClassname() != "weapon_sawedoff" &&
	    ent.GetClassname() != "weapon_deagle" &&
	    ent.GetClassname() != "weapon_revolver" &&
	    ent.GetClassname() != "weapon_g3sg1" &&
                    ent.GetClassname() != "weapon_bumpmine")
                    if(ent.GetMoveParent() == activator) EntFireByHandle(ent,"SetAmmoAmount","150",0.00,null,null);
            }
        }
        else{
            local prop = Entities.FindByNameNearest("supply_ammosmall_prop*", self.GetOrigin(), 8);

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
	    ent.GetClassname() != "weapon_awp" &&
	    ent.GetClassname() != "weapon_aug" &&
	    ent.GetClassname() != "weapon_sg553" &&
	    ent.GetClassname() != "weapon_mag7" &&
	    ent.GetClassname() != "weapon_sawedoff" &&
	    ent.GetClassname() != "weapon_deagle" &&
	    ent.GetClassname() != "weapon_revolver" &&
	    ent.GetClassname() != "weapon_g3sg1" &&
                    ent.GetClassname() != "weapon_bumpmine")
                    if(ent.GetMoveParent() == activator) EntFireByHandle(ent,"SetAmmoAmount","150",0.00,null,null);
            }

            EntFireByHandle(prop, "FadeAndKill", "", 0.1, null, null);
            EntFireByHandle(self, "Kill", "", 0.0, null, null);
        }
    }
    else{
        local hp = activator.GetHealth();
        EntFireByHandle(activator, "SetHealth", (hp-=1).tostring(), 1.0, null, null);
    }
}