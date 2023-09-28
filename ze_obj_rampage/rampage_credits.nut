IncludeScript("7ychu5/utils.nut");
IncludeScript("vs_library.nut");

text_eng <- [
    " Mapper: Trazix \n\n CSGO Porter: Tupu \n\n Script(gmod): jaek"
    " Map update: Nino \n\n Script author: 7ychu5 \n\n Particles author: @Seth"
    " Special thanks: Crowbar Crowbars and their BlackMesa"
    " AND......"
]
text_chn <- [
    " 地图作者：Trazix \n\n CSGO移植：Tupu \n\n 脚本移植(gmod)：jaek"
    " 地图更新：Nino \n\n 脚本作者：7ychu5 \n\n 特效作者：@Seth"
    " 特别感谢：Crowbar撬棍组和他们的黑山起源"
    " 还有......"
]
text_delay <- 5.0;
text_2_delay <- 5.0;
text_color <- "255 0 0";
text_2_color <- "0 255 255";
text_2_num <- 8;

text <- text_chn;

function credits_display() {
    local delay = 0;
    for(local j=0;j<text.len();j++)
    {
        local Gtext = ::CreateText();
        Gtext.__KeyValueFromInt("Channel",5);
        Gtext.__KeyValueFromFloat("holdtime",text_delay);
        Gtext.__KeyValueFromString("color", text_color);
        Gtext.__KeyValueFromString("x","0.2");
        Gtext.__KeyValueFromString("y","0.2");
        Gtext.__KeyValueFromString("fadein", "1");
        Gtext.__KeyValueFromString("fadeout", "1");
        if(j%2!=0){
            Gtext.__KeyValueFromString("y","0.6");
        }
        EntFireByHandle(Gtext, "SetText", text[j], delay, null, null)
        EntFireByHandle(Gtext, "Display", "", delay, null, null);
        EntFireByHandle(Gtext, "kill", "", delay, null, null);
        delay+=text_delay;
    }
    EntFireByHandle(self, "RunScriptcode", "credits_display_player()", text.len()*text_delay, null, null);
}

player_name <- [];

function credits_display_player() {
    player_name.clear();
    local delay = 0;
    local value = "";
    for (local ent; ent = Entities.FindByClassname(ent, "player"); )
    {
        if(!ent.IsValid() && ent == null) continue;
        if(ent.GetScriptScope().name==null||ent.GetScriptScope().name=="") continue;
        player_name.push(ent.GetScriptScope().name);
    }
    for(local j=0;j<player_name.len();j++)
    {

        local Gtext = ::CreateText();
        Gtext.__KeyValueFromInt("Channel",5);
        Gtext.__KeyValueFromFloat("holdtime",text_2_delay);
        Gtext.__KeyValueFromString("color", text_2_color);
        Gtext.__KeyValueFromString("x","0.2");
        Gtext.__KeyValueFromString("y","0.1");
        Gtext.__KeyValueFromString("fadein", "1");
        Gtext.__KeyValueFromString("fadeout", "1");

        value = value + player_name[j] + "\n";
        if(j == player_name.len()-1 || (j+1) % text_2_num == 0 )
        {
            EntFireByHandle(Gtext, "SetText", value, delay, null, null)
            EntFireByHandle(Gtext, "Display", "", delay, null, null);
            EntFireByHandle(Gtext, "kill", "", delay, null, null);
            value = "";
            delay+=text_2_delay;
        }
    }
}