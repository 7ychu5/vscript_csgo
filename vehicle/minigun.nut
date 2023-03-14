SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "UNKNOWN";
SCRIPT_TIME <- "2023年3月6日18:33:25";
SCRIPT_VERSION <- "1.0";

function detect_user() {
    if(activator.GetTeam()==2)
    {
        EntFire("minigun_destroy","trigger","",0.0,null);
        EntFireByHandle(activator,"kill","",0.0,null,null);
    }
}