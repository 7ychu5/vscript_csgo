function Precache() {

}

function Random_music() {
    if(Entities.FindByName(null, "music")==null) local music = Entities.CreateByClassname("ambient_generic");
    else music = Entities.FindByName(null, "music");

    music.__KeyValueFromString("targetname", "music");
    music.__KeyValueFromString("spawnflags", "49");
    music.__KeyValueFromString("message", "hold_boring/Bgm/Agiel.mp3");
    local n = RandomInt(1, 48);
    switch (n) {
        case 1:
            music.__KeyValueFromString("message", /*要改的音乐路径*/);EntFireByHandle(music, "PlaySound", " ", 0.0, null, null);break;
        case 2:
            music.__KeyValueFromString("message", /*要改的音乐路径*/);EntFireByHandle(music, "PlaySound", " ", 0.0, null, null);break;
        case 3:
            music.__KeyValueFromString("message", /*要改的音乐路径*/);EntFireByHandle(music, "PlaySound", " ", 0.0, null, null);break;
        case 4:
            music.__KeyValueFromString("message", /*要改的音乐路径*/);EntFireByHandle(music, "PlaySound", " ", 0.0, null, null);break;
        default:
            printl(" ");break;
    }
}

local ModelTrigger = Entities.FindByName(null,"");

function ChangeModel() {
    local h = Entities.FindByClassnameNearest("player", ModelTrigger.GetOrigin(), 512);
    h.SetModel(modelname);
}