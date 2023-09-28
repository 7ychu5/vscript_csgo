SCRIPT_OWNER <- "7ychu5";
SCRIPT_TIME <- "2023年7月10日13点53分";
SCRIPT_MAP <- "GLOBAL";
SCRIPT_VERISON <- "0.1";

//////////////////////////////////////////////

ent_text <- null;
ent_num <- 0;

function CreateText() {
    if(ent_text != null) return ent_text;
    if(Entities.FindByName(null, "ent_text") != null) return(ent_text = Entities.FindByName(null, "ent_text"));
    local ent_text = Entities.CreateByClassname("game_text");
    ent_text.__KeyValueFromString("targetname", "ent_text");
    ent_text.__KeyValueFromString("effect", "0");
    ent_text.__KeyValueFromString("fadein", "0");
    ent_text.__KeyValueFromString("fadeout", "0");
    ent_text.__KeyValueFromString("holdtime", "1");
    ent_text.__KeyValueFromString("x", "0.56");
    ent_text.__KeyValueFromString("y", "0");
    ent_text.__KeyValueFromString("color", "0 255 255");
    ent_text.__KeyValueFromString("channel", "0");
    ent_text.__KeyValueFromString("spawnflags", "1");
    return ent_text;
}

function ent_count() {
    local ent_text = CreateText();
    for(local ent;ent = Entities.FindByClassname(ent, "*");)
    {
        ent_num++;
    }
    EntFireByHandle(ent_text, "SetText", ent_num + "/2048", 0.0, null, null);
    ent_num = 0;
    EntFireByHandle(ent_text, "Display", "", 0.01, null, null);
    EntFireByHandle(self, "RunScriptcode", "ent_count();", 1.0, null, null);
}