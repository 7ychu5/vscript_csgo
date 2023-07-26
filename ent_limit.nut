if(null == Entities.FindByName(null, "count_limit_text"))
{
    count_limit_text <- Entities.CreateByClassname("game_text");
    count_limit_text.__KeyValueFromFloat("x", 0.55);
    count_limit_text.__KeyValueFromFloat("y", 0.025);
    count_limit_text.__KeyValueFromString("channel", "5");
    count_limit_text.__KeyValueFromString("targetname", "count_limit_text");
    count_limit_text.__KeyValueFromString("color", "255 0 0");
    count_limit_text.__KeyValueFromString("spawnflags","1");
    count_limit_text.__KeyValueFromString("holdtime","1.0");
    count_limit_text.__KeyValueFromString("fadein","0");
    count_limit_text.__KeyValueFromString("fadeout","0");
    count_limit_text.__KeyValueFromString("fxtime","0");
}
if(null == Entities.FindByName(null, "count_limit_relay"))
{
    count_relay <- Entities.CreateByClassname("logic_relay");
    count_relay.__KeyValueFromString("targetname", "count_limit_relay");
}

limit_weapon <- [
    "weapon_negev",
    "weapon_molotov",
    "weapon_incgrenade",
];
limit_number <- 3;

function ent_limit() {
    local ent_count = 0;
    for (local ent; ent = Entities.FindByClassname(ent, "*");) {
        for (local j=0; j<limit_weapon.len(); j++) {
            if(ent.IsValid() && ent.GetClassname() == limit_weapon[j] && ent.GetName() == "")
            {
                ent_count++;
                if(ent_count>limit_number)
                {
                    local user = ent.GetMoveParent();
                    local hudhint = Entities.CreateByClassname("env_hudhint");
                    hudhint.__KeyValueFromString("message", "<font color='#111111'> 地图限制购买内格夫与火瓶哦~ </font>");
                    EntFireByHandle(hudhint, "ShowHudHint", " ", 0.0, user, null);
                    EntFireByHandle(hudhint, "kill", "", 3.0, null, null);
                    EntFireByHandle(ent, "kill", "", 0.0, null, null);
                }
            }
        }
    }
    EntFireByHandle(count_limit_text, "SetText", ent_count+"/"+limit_number, 0.00, null, null);
    EntFireByHandle(count_limit_text, "Display", " ", 0.01, null, null);

    EntFire("logic_script", "RunScriptCode", "ent_limit()", 1.0, null);
}