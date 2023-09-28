SCRIPT_OWNER <- "7ychu5";
SCRIPT_TIME <- "2023年8月16日09:24:10";
SCRIPT_MAP <- "ze_obj_rampage";
SCRIPT_VERISON <- "0.1";

IncludeScript("7ychu5/utils.nut");

//////////user_variable///////////

drone_add <- "ui/panorama/game_ready_02.wav"                //drone +1
online_num_limit <- 3;                                      //同屏在线限制

self.PrecacheScriptSound(drone_add);
//////////sys_variable////////////



//////////////////////////////////
function Think() {
    local drone_num = 0;
    for (local ent; ent = Entities.FindByName(ent, "drone_user_*"); )
    {
        drone_num++;
    }
    if(drone_num < online_num_limit)
    {
        local luckyer;
        while(null != (luckyer = Entities.FindByClassnameNearest("player", self.GetOrigin(), 73.0)))
        {
            if(RandomInt(1, 100) <= 98) return;
            EntFire("drone_button", "RunScriptCode", "drone_give();", 0.0, luckyer);
            luckyer.SetOrigin(Vector(2048,2048,1476));
        }

    }
}