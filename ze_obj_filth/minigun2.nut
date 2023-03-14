SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "UNKNOWN";
SCRIPT_TIME <- "2023年3月6日18:33:25";
SCRIPT_VERSION <- "1.0";

sec_max <- 16;
sec <- 0;
tick_toggle <- true;
on_toggle <- true;

function detect_user() {
    if(activator.GetTeam()==2)
    {
        local user = activator;
        EntFire("minigun_ui2","Deactivate","",0.0,null);
        EntFire("minigun_destroy2","trigger","",0.0,null);
        EntFireByHandle(user, "SetHealth", "-1", 0.0, null, null);
    }
}

function minigun_display() {
    local text;
    if(null == Entities.FindByName(null, "game_text_minigun2"))
    {
        text = Entities.CreateByClassname("game_text");
        text.__KeyValueFromString("targetname", "game_text_minigun2")
        text.__KeyValueFromString("message","game_text");
        text.__KeyValueFromString("color","24 131 248");
        text.__KeyValueFromString("color2","255 255 255");
        text.__KeyValueFromString("effect","2");
        text.__KeyValueFromString("x","-1");
        text.__KeyValueFromString("y","0.7");
        text.__KeyValueFromString("channel","4");
        text.__KeyValueFromString("spawnflags","0");
        text.__KeyValueFromString("holdtime","5");
        text.__KeyValueFromString("fadein","0");
        text.__KeyValueFromString("fadeout","0");
        text.__KeyValueFromString("fxtime","0");
    }
    else text = Entities.FindByName(null, "game_text_minigun2");

    local value = "";
    for(local j=1;j<=sec;j++)
    {
        value += "■";
    }
    for(local i=1;i<=16-sec;i++)
    {
        value += "□";
    }
    value += "℃";
    EntFireByHandle(text, "Settext", value, 0.0, null, null);
    local minigun_user2 = Entities.FindByName(null, "minigun_user2");
    EntFireByHandle(text, "Display", "", 0.0, minigun_user2, null);
}

function tick_add(tick_toggle) {
    if(tick_toggle == true)
    {
        if (sec<6) {
            EntFire("minigun_gunfire_push2", "AddOutput", "speed 200", 0.0, null);
            EntFire("minigun_gunfire_push2", "enable", "", 0.0, activator);
            EntFire("minigun_gunfire_push2", "disable", "", 0.2, activator);
        }
        else if(sec<11){
            EntFire("minigun_gunfire_push2", "AddOutput", "speed 250", 0.0, null);
            EntFire("minigun_gunfire_push2", "enable", "", 0.0, activator);
            EntFire("minigun_gunfire_push2", "disable", "", 0.4, activator);
        }
        else if(sec<sec_max){
            EntFire("minigun_gunfire_push2", "AddOutput", "speed 350", 0.0, null);
            EntFire("minigun_gunfire_push2", "enable", "", 0.0, activator);
            EntFire("minigun_gunfire_push2", "disable", "", 0.6, activator);
        }
        else{
            switch (RandomInt(1, 3)) {
                case 1:
                    ScriptPrintMessageChatAll(" \xb\xb[Minigun] \x4 好烧！要烧起来了！");
                    break;
                case 2:
                    ScriptPrintMessageChatAll(" \xb\xb[Minigun] \x4 哈利路亚！");
                    break;
                default:
                    ScriptPrintMessageChatAll(" \xb\xb[Minigun] \x4 过载了！要爆炸了！");
                    break;
            }
            EntFire("minigun_destroy2","trigger","",1.0,null);//是否摧毁minigun本体
            local boom = Entities.CreateByClassname("Env_explosion");
            boom.SetOrigin(self.GetOrigin());
            boom.__KeyValueFromString("iMagnitude", "50");
            boom.__KeyValueFromString("iRadiusOverride", "0");
            EntFireByHandle(boom, "Explode", "", 1.0, activator, null);
        }
        sec++;minigun_display();
        EntFireByHandle(self, "RunScriptcode", "tick_add(tick_toggle)", RandomFloat(0.6, 1.2), null, null);
    }
    else
    {
        return;
    }
}

function tick_sub(tick_toggle) {
    if(tick_toggle == false && sec > 0)
    {
        sec--;minigun_display();
        EntFireByHandle(self, "RunScriptCode", "tick_sub(tick_toggle);", RandomFloat(0.2, 0.4), null, null);
    }
    else
    {
        return;
    }
}



// if(ent_origin_x > -7680 && ent_origin_x < -6400){
//     if(ent_origin_y > -5952 && ent_origin_y < -4928){
//         if(ent_origin_z > 368 && ent_origin_z < 1168){