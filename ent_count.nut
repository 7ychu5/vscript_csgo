count_text <- Entities.CreateByClassname("game_text");
count_relay <- Entities.CreateByClassname("logic_relay");
count_relay.__KeyValueFromString("targetname", "count_relay");
count_text.__KeyValueFromFloat("x", 0.55);
count_text.__KeyValueFromFloat("y", 0);
count_text.__KeyValueFromString("targetname", "count_text");
count_text.__KeyValueFromString("color", "0 255 255");
count_text.__KeyValueFromString("spawnflags","1");
count_text.__KeyValueFromString("holdtime","1.0");
count_text.__KeyValueFromString("fadein","0");
count_text.__KeyValueFromString("fadeout","0");
count_text.__KeyValueFromString("fxtime","0");

function ent_count_display() {
    local ent_count = 0;
    for (local ent; ent = Entities.FindByClassname(ent, "*");) {
        if(ent.IsValid()
        && ent.GetClassname()!=("prop_static")
        && ent.GetClassname()!=("env_cubemap")
        && ent.GetClassname()!=("infodecal")
        && ent.GetClassname()!=("sprite_clientside")
        )ent_count++;
    }

    EntFireByHandle(count_text, "SetText", ent_count+"/2048", 0.00, null, null);
    EntFireByHandle(count_text, "Display", " ", 0.01, null, null);

    EntFire("logic_script", "RunScriptCode", "ent_count_display()", 1.0, null);
}