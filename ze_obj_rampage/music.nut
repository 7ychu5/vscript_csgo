SCRIPT_OWNER <- "7ychu5";
SCRIPT_TIME <- "2023年8月7日14:42:42";
SCRIPT_MAP <- "ze_obj_rampage";
SCRIPT_VERISON <- "0.1";

//////////user_variable///////////

music_array <- [
    "music/half-life01.mp3",
    "music/half-life02.mp3",//helicopter_boss_start
    "music/half-life17.mp3",
    "music/suspense05.mp3",//open_cliff_warehouse
    "music/suspense07.mp3",//helicopter_death
]

//////////sys_variable////////////

foreach (i in music_array) {
    self.PrecacheScriptSound(i);
}

//////////////////////////////////

function play_music(scene) {
    switch (scene) {
        case 1://open_cliff_warehouse
            self.EmitSound("music/suspense05.mp3");
            ScriptPrintMessageChatAll("\xB \xB[Rampage]\x04他妈的，怎么是个空仓库？");
            ScriptPrintMessageChatAll("\xB \xB[Rampage]\x04去看看那道卷帘门后是什么！试一下控制台还能不能用！");
            break;
        case 2://helicopter_boss_start
            self.EmitSound("music/half-life02.mp3");
            ScriptPrintMessageChatAll("\xB \xB[Rampage]\x04条子来了！这是个陷阱！");
            break;
        case 3://helicopter_death
            self.EmitSound("music/suspense07.mp3");
            break;
        default:
            break;
    }
}