SCRIPT_OWNER <- "7ychu5";
SCRIPT_TIME <- "2023年8月13日13:22:17";
SCRIPT_MAP <- "ze_obj_rampage";
SCRIPT_VERISON <- "0.1";

IncludeScript("7ychu5/utils.nut");
IncludeScript("vs_library.nut");

//////////user_variable///////////

//////////////限速器//////////////

SPEED_LIMIT <- 600;                         //最高限速，无论在空中还是地下
TICKRATE <- 0.02                            //频率(0.01~)，频率越大，越容易逼近限速值
ACCURACY <- 0.1                             //精度(0.000~1.000)，这个值越小，运算压力越大，这个值越大，超过阈值的人越容易被杀回零速

//////////////////////////////////

/////////////////////////////////////
////////////////权男/////////////////
/////////////////////////////////////

::MAPPER_SID <- [
    "STEAM_1:0:92422507",//7ychu5
    "STEAM_0:0:243840573",//nino
];

::infinite_player <- [];

VS.ListenToGameEvent( "player_say", function( event )
{
	local player = VS.GetPlayerByUserid( event.userid );
    local player = ToExtendedPlayer(player);
    foreach (i in ::MAPPER_SID) {
        if(player.GetNetworkIDString() == i)
        {
            local msg = event.text;
            if(msg.slice(0,1) != "$") return;
            local argv = split(msg, " ");
            //local argc = argv.len();
            if(argv[0].tolower() == "$noclip") ::cvar_noclip(event.userid,msg);
            if(argv[0].tolower() == "$give_weapon") ::cvar_give_weapon(event.userid,msg);
            if(argv[0].tolower() == "$ent_fire") ::cvar_ent_fire(event.userid,msg);
            if(argv[0].tolower() == "$infinite_ammo") ::cvar_infinite_ammo(event.userid,msg);
            if(argv[0].tolower() == "$modify_speed") ::cvar_modify_speed(event.userid,msg);

        }
    }
}, "" );

::cvar_noclip <- function(uid,cmd) {
    local argv = split(cmd, " ");
    local argc = argv.len();
    local p = VS.GetPlayerByUserid(uid);
    if(argc == 2)
    {
        if(argv[1].slice(0,1) == "#")
        {
            local p = VS.GetPlayerByUserid(argv[1].slice(1));
            switch (p.IsNoclipping()) {
                case true:
                    EntFireByHandle(p, "AddOutput", "movetype 2", 0.00, null, null);
                    break;
                case false:
                    EntFireByHandle(p, "AddOutput", "movetype 8", 0.00, null, null);
                    break;
            }
        }
        else if(argv[1].slice(0,1) == "@")
        {
            if(argv[1].tolower() == "@ct"){
                for (local ent; ent = Entities.FindByClassname(ent, "player"); )
                {
                    if(ent.GetTeam()==3)
                    {
                        switch (p.IsNoclipping()) {
                            case true:
                                EntFireByHandle(p, "AddOutput", "movetype 2", 0.00, null, null);
                                break;
                            case false:
                                EntFireByHandle(p, "AddOutput", "movetype 8", 0.00, null, null);
                                break;
                        }
                    }
                }
            }
            else if(argv[1].tolower() == "@t"){
                for (local ent; ent = Entities.FindByClassname(ent, "player"); )
                {
                    if(ent.GetTeam()==2)
                    {
                        switch (p.IsNoclipping()) {
                            case true:
                                EntFireByHandle(p, "AddOutput", "movetype 2", 0.00, null, null);
                                break;
                            case false:
                                EntFireByHandle(p, "AddOutput", "movetype 8", 0.00, null, null);
                                break;
                        }
                    }
                }
            }
            else if(argv[1].tolower() == "@all"){
                for (local ent; ent = Entities.FindByClassname(ent, "player"); )
                {
                    switch (p.IsNoclipping()) {
                        case true:
                            EntFireByHandle(p, "AddOutput", "movetype 2", 0.00, null, null);
                            break;
                        case false:
                            EntFireByHandle(p, "AddOutput", "movetype 8", 0.00, null, null);
                            break;
                    }
                }
            }
            else return;
        }
        else{
            local h = VS.GetAllPlayers();
            foreach (i in h) {
                local player = ToExtendedPlayer(i);
                if(player.GetPlayerName() == argv[1])
                {
                    switch (p.IsNoclipping()) {
                        case true:
                            EntFireByHandle(p, "AddOutput", "movetype 2", 0.00, null, null);
                            break;
                        case false:
                            EntFireByHandle(p, "AddOutput", "movetype 8", 0.00, null, null);
                            break;
                    }
                }
            }
        }
    }
    else if(argc == 1){
        switch (p.IsNoclipping()) {
            case true:
                EntFireByHandle(p, "AddOutput", "movetype 2", 0.00, null, null);
                break;
            case false:
                EntFireByHandle(p, "AddOutput", "movetype 8", 0.00, null, null);
                break;
        }
    }
    else
    {
        return;
    }
}

::cvar_give_weapon <- function(uid,cmd){
    local argv = split(cmd, " ");
    local argc = argv.len();
    local p = VS.GetPlayerByUserid(uid);
    if(argc == 1) return;
    else if(argc == 2)
    {
        EntFire("equiper", "AddOutput", argv[1] + " 1", 0.0, null);
        EntFire("equiper", "use", "", 0.0, p);
    }
    else if(argc ==3)
    {
        local h = VS.GetAllPlayers();
        if(argv[2].slice(0,1) == "#")
        {
            foreach (i in h) {
                local player = ToExtendedPlayer(i);
                if(player.userid.tostring() == argv[2].slice(1))
                {
                    EntFire("equiper", "AddOutput", argv[1] + " 1", 0.0, null);
                    EntFire("equiper", "use", "", 0.0, p);
                }
            }
        }
        else if(argv[2].slice(0,1) == "@")
        {
            if(argv[2].tolower() == "@all" || argv[2].tolower() == "@ct")
            {
                for (local ent; ent = Entities.FindByClassname(ent, "player"); )
                {
                    if(ent.GetTeam()==3)
                    {
                        EntFire("equiper", "AddOutput", argv[1] + " 1", 0.0, null);
                        EntFire("equiper", "use", "", 0.0, p);
                    }
                }
            }
            else return;
        }
        else
        {
            foreach (i in h) {
                local player = ToExtendedPlayer(i);
                if(player.GetPlayerName() == argv[2])
                {
                    EntFire("equiper", "AddOutput", argv[1] + " 1", 0.0, null);
                    EntFire("equiper", "use", "", 0.0, p);
                }
            }
        }
    }
    else return;
}

::cvar_ent_fire <- function(uid,cmd) {
    local argv = split(cmd, " ");
    local argc = argv.len();
    local p = VS.GetPlayerByUserid(uid);
    //ent_fire <target> [action] [value] [delay] [activator]
    switch (argc) {
        case 3:
            DoEntFire(argv[1].tostring(), argv[2].tostring(), "", 0.0, null, null);
            break;
        case 4:
            DoEntFire(argv[1].tostring(), argv[2].tostring(), argv[3].tostring(), 0.0, null, null);
            break;
        case 5:
            DoEntFire(argv[1].tostring(), argv[2].tostring(), argv[3].tostring(), argv[4].tofloat(), null, null);
            break;
        default:
            break;
    }

}

::cvar_infinite_ammo <- function(uid,cmd) {
    local argv = split(cmd, " ");
    local argc = argv.len();
    if(argc == 1)
    {
        local count = 0;
        foreach (i in ::infinite_player) {
            if(uid.tostring() == i)
            {
                ::infinite_player.remove(count);
                return;
            }
            count++;
        }
        ::infinite_player.push(uid);
    }
    else if(argc == 2){
        if(argv[1].slice(0,1) == "#")
        {
            local count = 0;
            foreach (i in ::infinite_player) {
                if(argv[1].slice(1) == i)
                {
                    ::infinite_player.remove(count);
                    return;
                }
                count++;
            }
            ::infinite_player.push(argv[1].slice(1));
        }
        else{
            local h = VS.GetAllPlayers();
            foreach (i in h) {
                local player = ToExtendedPlayer(i);
                if(player.GetPlayerName() == argv[1])
                {
                    local count = 0;
                    foreach (i in ::infinite_player) {
                        if(player.userid.tostring() == i)
                        {
                            ::infinite_player.remove(count);
                            return;
                        }
                        count++;
                    }
                    ::infinite_player.push(player.userid);
                }
            }
        }
    }
    else return;
}

::cvar_modify_speed <- function(uid,cmd) {
    local argv = split(cmd, " ");
    local argc = argv.len();
    local p = VS.GetPlayerByUserid(uid);

    if(argc == 1) return;
    else if(argc == 2){
        EntFire("speedmod", "ModifySpeed", argv[1].tostring(), 0.0, p);
    }
    else if(argc == 3){
        if(argv[2].slice(0,1) == "#")
        {
            local h = VS.GetAllPlayers();
            foreach (i in h) {
                local player = ToExtendedPlayer(i);
                if(player.userid.tostring() == argv[2].slice(1))
                {
                    EntFire("speedmod", "ModifySpeed", argv[1].tostring(), 0.0, i);
                }
            }
        }
        else if(argv[2].slice(0,1) == "@")
        {
            if(argv[2].tolower() == "@ct")
            {
                for (local ent; ent = Entities.FindByClassname(ent, "player"); )
                {
                    if(ent.GetTeam()==3)
                    {
                        EntFire("speedmod", "ModifySpeed", argv[1].tostring(), 0.0, ent);
                    }
                }
            }
            else if(argv[2].tolower() == "@t")
            {
                for (local ent; ent = Entities.FindByClassname(ent, "player"); )
                {
                    if(ent.GetTeam()==2)
                    {
                        EntFire("speedmod", "ModifySpeed", argv[1].tostring(), 0.0, ent);
                    }
                }
            }
            else if(argv[2].tolower() == "@all")
            {
                for (local ent; ent = Entities.FindByClassname(ent, "player"); )
                {
                    EntFire("speedmod", "ModifySpeed", argv[1].tostring(), 0.0, ent);
                }
            }
            else return;
        }
    }


}
VS.ListenToGameEvent( "item_equip", function( event )
{
    foreach (i in ::infinite_player) {
        if(event.userid.tostring() == i)
        {
            local weapon = "weapon_" + event.item;
            for (local ent; ent = Entities.FindByClassname(ent, weapon); )
            {
                if(ent.GetMoveParent() == VS.GetPlayerByUserid(event.userid)){
                    EntFireByHandle(ent, "SetAmmoAmount", "999", 0.13, null, null);
                }
            }
        }
    }

}, "" );
/////////////////////////////////////
///////////////限速器////////////////
/////////////////////////////////////

::check_speed_toggle <- false;
::player_detected_speed <- null;

function start_check_speed() {
    ::check_speed_toggle <- true;
    ScriptPrintMessageChatAll("限速器已开启");
}
function stop_check_speed() {::check_speed_toggle <- false;ScriptPrintMessageChatAll("限速器已关闭");}
::check_speed <- function(player) {
    if(::check_speed_toggle == false) return;
    ::player_detected_speed = player;
    printl(player);
    EntFire("logic_script", "RunScriptcode", "change_speed()", 0.1, null);
}
function change_speed() {
    local speed = ::player_detected_speed.GetVelocity();
    local x = speed.x;local y = speed.y;local z = speed.z;
    speed = sqrt(x*x + y*y + z*z);

    if(speed >= SPEED_LIMIT)
    {
        while (sqrt(x*x + y*y + z*z) > 400) {
            x -= x*ACCURACY;
            y -= y*ACCURACY;
            z -= z*ACCURACY;
        }
        h.SetVelocity(Vector(x, y, z));
    }
}

VS.ListenToGameEvent( "player_hurt", function( event )
{
	local player = VS.GetPlayerByUserid( event.userid );
    if(player.GetTeam() == 2) ::check_speed(player);

}, "" );

