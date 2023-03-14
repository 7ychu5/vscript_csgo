SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "ze_obj_filth";
SCRIPT_TIME <- " ";

function spawn_explobarrels(){
    local spawner = Entities.CreateByClassname("env_entity_maker");
    for(local j=1; j<=32; j++)
    {
        if(RandomInt(1, 4)<=2)
        {
            spawner.__KeyValueFromString("EntityTemplate", "explobarrels_template");
            spawner.SpawnEntityAtNamedEntityOrigin("explobarrels_target_"+j);
        }
    }
    EntFireByHandle(spawner, "kill", " ", 0.0, null, null)
}

function spawn_medibag(){
    local spawner = Entities.CreateByClassname("env_entity_maker");
    for(local j=1; j<=34; j++)
    {
        if(RandomInt(1, 4)<=2)
        {
            spawner.__KeyValueFromString("EntityTemplate", "medibag_template");
            spawner.SpawnEntityAtNamedEntityOrigin("medibag_target_"+j);
        }
    }
    EntFireByHandle(spawner, "kill", " ", 0.0, null, null)
}

function spawn_ammocratesmall(){
    local spawner = Entities.CreateByClassname("env_entity_maker");
    for(local j=1; j<=26; j++)
    {
        if(RandomInt(1, 4)<=2)
        {
            spawner.__KeyValueFromString("EntityTemplate", "ammocratesmall_template");
            spawner.SpawnEntityAtNamedEntityOrigin("ammocrate_target_"+j);
        }
    }
    EntFireByHandle(spawner, "kill", " ", 0.0, null, null)
}

