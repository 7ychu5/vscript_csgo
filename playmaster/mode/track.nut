SCRIPT_OWNER <- "7ychu5";
SCRIPT_TIME <- "2023年7月11日11点51分";
SCRIPT_MAP <- "playmaster";
SCRIPT_VERISON <- "0.1";

IncludeScript("vs_library.nut");
IncludeScript("7ychu5/playmaster/utils.nut");

///////////////////////////////////////////////////////////////

File_name <- "PlayMaster";

///////////////////////////////////////////////////////////////

count_time <- 30;
track_time <- 0;
track_score <- 0;
count <- 0;

///////////////////////////////////////////////////////////////

player_ui <- null;

///////////////////////////////////////////////////////////////


function track_mode_on() {
    activator.SetOrigin(Vector(0, 3328, 1092));
    GetTrackUI();
    ::MODE_TYPE <- 2;
    ::SpawnBot();
    ScriptPrintMessageCenterAll("<font color='#55efc4'>欢迎来到</font><font color='#ff1010'>跟枪</font><font color='#55efc4'>测试！</font>\n<font color='#e67e22'>测试将持续30秒钟\n准星跟随时间越久得分越高</font>\n<font color='#81ecec'>按下左键即可开始！</font>");
}

function track_mode_off() {
    EntFire("user", "SetHealth", "-1", 0.0, null);
    // SendToConsole("developer 0;con_timestamp 0;con_logfile cfg/" + File_name + ".log");                                             //打开读写文件指令
    // SendToConsole("echo Track:"+player_ui.GetScriptScope().track_time);                                                             //开始记录
    // SendToConsole("con_logfile \"\";");                                                                                             //将读写记录转移到另一个根目录去
    // ScriptPrintMessageChatAll(File_name + ".log已保存至cfg文件夹");
    // ScriptPrintMessageCenterAll("测试结束，在左下角获取您的得分");
    //track_mode_stop();
}

function GetTrackUI() {
    player_ui <- Entities.CreateByClassname("game_ui");
    player_ui.__KeyValueFromString("spawnflags", "0");
    player_ui.__KeyValueFromString("FieldOfView", "-1");
    player_ui.ConnectOutput("PlayerOn", "PlayerOn");
	player_ui.ConnectOutput("PlayerOff", "PlayerOff");
	player_ui.ConnectOutput("PressedAttack", "PressedAttack");
    // player_ui.ConnectOutput("PressedAttack2", "PressedAttack2");
    if(player_ui.ValidateScriptScope())
    {
        local scope = player_ui.GetScriptScope();
        scope["count_time"] <- 0.00;
        scope["track_time"] <- 0.00;
        scope["trace_toggle"] <- false;
        scope["PlayerOn"] <- function ()
        {
            ScriptPrintMessageChatAll("已上线");
        }
        scope["PlayerOff"] <- function ()
        {
            ScriptPrintMessageChatAll("已离线");
            EntFire("logic_script", "RunScriptcode", "track_mode_off()", 0, null);
            EntFireByHandle(self, "Deactivate", "", 0.01, activator ,null);
            EntFireByHandle(self, "kill", "", 0.1, null, null);
        }
        scope["PressedAttack"] <- function ()
        {
            if(trace_toggle == false){
                trace_toggle = true;
                TraceHit();
            }
        }
        // scope["PressedAttack2"] <- function ()
        // {
        //     EntFireByHandle(self, "Deactivate", "", 0.00, activator, null);
        //     EntFireByHandle(self, "kill", "", 0.01, null, null);
        // }
        scope["TraceHit"] <- function ()
        {
            local player = ToExtendedPlayer(activator);
            local eye = player.EyePosition();
            local pos = VS.TraceDir( eye, player.EyeForward(), 1024.0 ).GetPos();
            local tr = VS.TraceDir( player.EyePosition(), player.EyeForward(), MAX_COORD_FLOAT, player.self, MASK_SOLID );
            //DebugDrawLine(eye, pos, 255, 255, 255, false, 5);
            //DebugDrawBox(pos, Vector(2, 2, 2), Vector(-2, -2, -2), 0, 0, 0, 40, 3);
            //printl(tr.GetEnt(80));
            if(tr.GetEnt(80) != null) if(tr.GetEnt(80).GetClassname() == "cs_bot" || (tr.GetEnt(80).GetClassname() == "player" && tr.GetEnt(80).GetTeam() == 2)) track_time += 0.01;
            local dis_time = format("%.1f", count_time);
            ScriptPrintMessageCenterAll(dis_time + "/30.0");
            if(count_time >= 30.00){
                PlayerOff();
                //EntFire("logic_script", "RunScriptcode", "track_time <- "+track_time, 0, null);
                ScriptPrintMessageChatAll("本次Track时长为："+track_time.tostring());
            }
            if(player.GetHealth()>0 && count_time < 30.00) EntFireByHandle(self, "RunScriptcode", "TraceHit();", 0.01, activator, null);
            count_time += 0.01;
        }
    }
    EntFireByHandle(player_ui, "Activate", "", 0.0, activator ,null);
}

function track_mode_stop() {
    ScriptPrintMessageCenterAll("\x07\x07因为意外发生致使测试强制关停\n");
}

// Default: \x01
// Dark Red: \x02
// Purple: \x03
// Green: \x04
// Light Green: \x05
// Lime Green: \x06
// Red: \x07
// Grey: \x08
// Orange: \x09
// Brownish Orange: \x10
// Gray: \x08
// Very faded blue: \x0A
// Faded blue: \x0B
// Dark blue: \x0C