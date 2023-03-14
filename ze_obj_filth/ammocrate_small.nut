SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "ze_obj_filth";
SCRIPT_TIME <- " ";

function spawn_ammocratesmall(){
    local spawner = Entities.CreateByClassname("env_entity_maker");
    for(local j=1; j<=25; j++)
    {
        if(RandomInt(1, 4)<=3)
        {
            spawner.__KeyValueFromString("EntityTemplate", "ammocratesmall_template");
            spawner.SpawnEntityAtNamedEntityOrigin("ammocrate_target_"+j);
        }
    }
    EntFireByHandle(spawner, "kill", " ", 0.0, null, null)
}

function add()
	{
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
            	ent.GetClassname() != "weapon_bumpmine")
            	if(ent.GetMoveParent()==activator)EntFireByHandle(ent,"SetAmmoAmount","100",0.00,null,null);
    	}
}
