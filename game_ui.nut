SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "UNKNOWN";
SCRIPT_TIME <- "2023年1月15日11:08:41";

IncludeScript("vs_library");

function Use_Gameui(activator) {
    EntFire("game_ui", "Activate", " ", 0.0, activator);
    printl(activator);
}