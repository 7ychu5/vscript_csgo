SCRIPT_OWNER <- "7ychu5";
SCRIPT_TIME <- "2023年8月2日09:51:28";
SCRIPT_MAP <- "UNKNOWN";
SCRIPT_VERISON <- "0.1";
//for test game_ui XY 逼用没有，我操你妈
IncludeScript("7ychu5/utils.nut");
//////////user_variable///////////



//////////sys_variable////////////

game_ui <- null;
    if(Entities.FindByName(null, "game_ui") == null)
        {
            game_ui <- Entities.CreateByClassname("game_ui");
            game_ui.__KeyValueFromString("targetname", "game_ui");
            game_ui.__KeyValueFromString("vscripts", "7ychu5/misc/game_ui.nut");
            game_ui.__KeyValueFromInt("spawnflags", 0);
        }
    else game_ui <- Entities.FindByName(null, "game_ui");
game_ui_user <- null;
game_ui_toggle <- false;

//////////////////////////////////

function gameui_start() {
    game_ui_user <- activator;
	game_ui.ConnectOutput("PlayerOn", "PlayerOn");
	game_ui.ConnectOutput("PlayerOff", "PlayerOff");
	game_ui.ConnectOutput("PressedAttack2", "PressedAttack2");
    game_ui.ConnectOutput("UnPressedAttack2", "UnPressedAttack2");
    EntFireByHandle(game_ui, "Activate", "", 0.0, activator, caller);
}

function PlayerOn()
{
	ScriptPrintMessageChatAll("Game_ui ON");

}


function PlayerOff()
{
	ScriptPrintMessageChatAll("Game_ui OFF");
}

function PressedAttack2()
{
    game_ui_toggle <- true;
    LockUp();
}

function UnPressedAttack2()
{
    game_ui_toggle <- false;
}

function LockUp() {
    if(!game_ui_toggle) return;
    else EntFireByHandle(self, "RunScriptcode", "LockUp();", 0.02, game_ui_user, null);

    local victims = [];
        for(local h;h=Entities.FindByClassnameWithin(h, "player", self.GetOrigin(), 4096);)
        {
            if(h==null || !h.IsValid() || h.GetTeam()!=2 || h.GetHealth()<=0) continue;
            victims.push(h);
        }
        for(local h;h=Entities.FindByClassnameWithin(h, "cs_bot", self.GetOrigin(), 4096);)
        {
            if(h==null || !h.IsValid() || h.GetTeam()!=2 || h.GetHealth()<=0) continue;
            victims.push(h);
        }
        if(victims.len()<=0) return;
        victim <- victims[RandomInt(0,victims.len()-1)];
    local victim_origin = victim.EyePosition();
    local user_origin = game_ui_user.EyePosition();

    local pitch = GetTargetPitch(victim_origin, user_origin);
    local yaw = GetTargetYaw(victim_origin, user_origin);

    game_ui_user.SetAngles(pitch, yaw, 0);
}