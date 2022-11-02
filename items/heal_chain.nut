SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "UNKNOWN";
SCRIPT_TIME <- "2022年10月14日20:01:54";

healchain_OWNER <- null;
healchain_toggle <- 0;
healchain_gun <- Entities.FindByName(null, "item_healchain_gun");
item_healchain_particles_tp <- Entities.FindByName(null, "item_healchain_particles_tp");
item_healchain_particles_tp_end <- Entities.FindByName(null, "item_healchain_particles_tp_end");
times <- 0;

function Pickup_healchain()
{
    healchain_OWNER = activator;
}

function swap(a, b) {
    return b,a;
}

function use_healchain()
{
	local target_candidates = [];
	for(local h;h=Entities.FindByClassnameWithin(h,"player",healchain_gun.GetOrigin(),1024);)
	{
		if(h==null||!h.IsValid()||h.GetTeam()!=3||h.GetHealth()<=0) continue;
		target_candidates.push(h);
	}
	if(target_candidates.len()<=0) return;
    for(local j=target_candidates.len()-1; j>0; j--){
        if(target_candidates[j-1].GetHealth()>target_candidates[j].GetHealth())
        {
            swap(target_candidates[j-1],target_candidates[j]);
        }
    }
	local h = target_candidates[0];

}