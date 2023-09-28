SCRIPT_OWNER <- "7ychu5";
SCRIPT_TIME <- "2023年7月10日13点53分";
SCRIPT_MAP <- "GLOBAL";
SCRIPT_VERISON <- "0.1";

// function CreateText() {
//     local text = Entities.CreateByClassname("game_text");
//     text.__KeyValueFromString("effect", "0");
//     text.__KeyValueFromString("fadein", "0");
//     text.__KeyValueFromString("fadeout", "0");
//     text.__KeyValueFromString("holdtime", "1");
//     text.__KeyValueFromString("x", "-1");
//     text.__KeyValueFromString("y", "-1");
//     text.__KeyValueFromString("color", "0 255 255");
//     text.__KeyValueFromString("channel", "0");
//     text.__KeyValueFromString("spawnflags", "1");
//     return text;
// }

function CreateHudhint() {
    local hudhint = Entities.CreateByClassname("Env_hudhint");
    //hudhint.__KeyValueFromString("spawnflags", "0");
    return hudhint;
}

function CreateHint() {
    local hint = Entities.CreateByClassname("Env_instructor_hint");
    hint.__KeyValueFromString("hint_static", "0");
    hint.__KeyValueFromString("hint_color", "113 145 64");
    hint.__KeyValueFromString("hint_nooffscreen", "0");
    hint.__KeyValueFromString("hint_icon_onscreen", "icon_tip");
    hint.__KeyValueFromString("hint_timeout", "5");
    hint.__KeyValueFromString("hint_forcecaption", "1");
    return hint;
}