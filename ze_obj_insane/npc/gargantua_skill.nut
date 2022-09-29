SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "ze_obj_insane_v1";
SCRIPT_TIME <- " ";

gargantua_skill_freemissile <- Entities.FindByName(null, "gargantua_skill_freemissile");

function start() {
    local h = null;
    //local gargantua_skill_freemissile_prop = Entities.FindByName(null, "gargantua_skill_freemissile");
    if(null!=(h=Entities.FindInSphere(h,gargantua_skill_freemissile.GetOrigin(),2048)))
	{
		if(h.GetClassname()=="player"&&h.GetTeam()==3&&h.GetHealth()>0)
        {
            local h_origin = Vector(h.GetOrigin().x, h.GetOrigin().y, h.GetOrigin().z+40);
            local spawner = Entities.CreateByClassname("env_entity_maker");
            spawner.__KeyValueFromString("EntityTemplate", "gargantua_skill_freemissile_template");
            spawner.SpawnEntityAtNamedEntityOrigin("gargantua_skill_freemissile_template");
            EntFireByHandle(spawner, "kill", " ", 0.1, null, null);
            local gargantua_skill_freemissile_path_2 = Entities.FindByName(null, "gargantua_skill_freemissile_path_2*");
            local gargantua_skill_freemissile_explosion = Entities.FindByName(null, "gargantua_skill_freemissile_explosion*");
            gargantua_skill_freemissile_path_2.SetOrigin(h_origin);
            gargantua_skill_freemissile_explosion.SetOrigin(h_origin);
            local gargantua_skill_freemissile_mover = Entities.FindByName(null, "gargantua_skill_freemissile_mover*");
            EntFireByHandle(gargantua_skill_freemissile_mover, "StartForward", " ", 0.05, null, null);
		}
	}
}