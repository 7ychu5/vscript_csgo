SCRIPT_ADAPTER <- "7ychu5";
SCRIPT_MAP <- "ze_mountain_escape_bbo";
SCRIPT_TIME <- "2022年9月3日20:47:07";
function mapstart() {
    ScriptPrintMessageChatAll("Modify:7ychu5 & ExG ZE server ");
    ScriptPrintMessageChatAll("Port form ze_mountain_escape_bbo_v1 in CSS,enjoy!");
    for (local ent; ent = Entities.FindByClassname(ent, "player");) {
        EntFireByHandle(ent, "AddOutput", "targetname  ", 0.0, null, null);
        EntFireByHandle(ent, "AddOutput", "rendercolor 255 255 255", 0.0, null, null);
        EntFireByHandle(ent, "AddOutput", "rendermode 1", 0.0, null, null);
    }
    local jugger_tele_back = Entities.FindByName(null, "jugger_tele_back");
    jugger_tele_back.__KeyValueFromString("target", "dr_out");

    local skyrim_item_back = Entities.FindByName(null, "skyrim_item_back");
    skyrim_item_back.__KeyValueFromString("target", "t_out");

    local barlog_tele_back = Entities.FindByName(null, "barlog_tele_back");
    barlog_tele_back.__KeyValueFromString("target", "t_out");

    local BossBallHurt = Entities.FindByName(null, "BossBallHurt");
    BossBallHurt.__KeyValueFromInt("damage", 10);
}

function tick() {
    EntFireByHandle(self, "FireUser1", " ", 1.0, null, null);
}