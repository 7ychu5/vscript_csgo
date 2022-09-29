SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "ze_Obj_npst_v1_3fix";
SCRIPT_TIME <- "2022年8月11日22:01:46";

MAPPER_SID <- [
    "STEAM_1:0:92422507",//7ychu5
    "STEAM_1:0:214019946",//individual
    "STEAM_0:0:243840573",//nino
];

::PlayerConnect <- function (params) {
    local tb = getconsttable();
    tb[params.userid] <- params.name;
    tb[params.userid.tostring()] <- params.networkid;
    setconsttable(tb);
    __DumpScope(3,"ConstTable_Data "+tb[params.userid].tostring());
}

::target <- null;
::Think <- function () {
    user <- null;
    while ((user = Entities.FindByClassname(user, "*")) != null) {
        if (user.GetClassname() == "player" || user.GetClassname() == "cs_bot") {
            if (user.ValidateScriptScope()) {
                if (::target == null) {
                    if (!("userid" in user.GetScriptScope())) {
                        user.GetScriptScope().userid <- 1;
                        ::target = user;
                        EntFire("info_game_event_proxy", "GenerateGameEvent", "", 0.00, user);
                    }
                }
            }
        }
    }
}

::GetPlayerByUserid <- function (uid) {
    user <- null;
    while ((user = Entities.FindByClassname(user, "*")) != null) {
        if (user.GetClassname() == "player" || user.GetClassname() == "cs_bot") {
            if (user.ValidateScriptScope()) {
                if ("userid" in user.GetScriptScope()) {
                    if (user.GetScriptScope().userid == uid) {
                        return user;
                        break;
                    }
                }
            }
        }
    }
}

::GetNameByUserid <- function (uid) {
    user <- null;
    while ((user = Entities.FindByClassname(user, "*")) != null) {
        if (user.GetClassname() == "player" || user.GetClassname() == "cs_bot") {
            if (user.ValidateScriptScope()) {
                if ("userid" in user.GetScriptScope()) {
                    if (user.GetScriptScope().userid == uid) {
                        local tb = getconsttable();
                        return tb[user.GetScriptScope().userid];
                    }
                }
            }
        }
    }
}

::Get32IDByUserid <- function (uid) {
    user <- null;
    while ((user = Entities.FindByClassname(user, "*")) != null) {
        if (user.GetClassname() == "player" || user.GetClassname() == "cs_bot") {
            if (user.ValidateScriptScope()) {
                if ("userid" in user.GetScriptScope()) {
                    if (user.GetScriptScope().userid == uid) {
                        local tb = getconsttable();
                        return tb[user.GetScriptScope().userid.tostring()];
                    }
                }
            }
        }
    }
}

::PlayerUse <- function (params) {
    if (::target != null) {
        local sc = ::target.GetScriptScope();
        sc.userid <- params.userid;
        ::target = null;
        return;
    }
}
function race()
{
    local uid = activator.GetScriptScope().userid;
    local sid = Get32IDByUserid(uid);
    for(local a = 0; a < MAPPER_SID.len(); a++)
    {
        if(sid == MAPPER_SID[a])
        {
            //填入需要的IO事件，格式如下

            EntFire("race_button", "press", "", 5, 0);
            ScriptPrintMessageChatAll("五秒后开启RACE MODE");
        }
        break;
    }
}

//////////////////////////
/////////end_time/////////
//////////////////////////
function enter_showdown(activator){
    activator.__KeyValueFromString("targetname", "winner");
    EntFire("trigger_showdown_door", "Toggle", " ", 0, 0);
    EntFire("logic_script", "RunScriptCode", "SayGoodBye()", 5, 0);
}
function out_showdown(activator){
    activator.__KeyValueFromString("targetname", " ");
}
function SayGoodBye() {
    local h = null;
    while(null!=(h=Entities.FindByClassname(h,"player")))//如果要测试bot请把player换成cs_bot
	{
		if(h.GetName() != "winner" && h.GetHealth()>0)
		{
            EntFireByHandle(h, "SetHealth", "-1", 0.0, null, null);
            //h.SetHealth(0);//这玩意儿弄不死人？
			//h.SetTeam(2);//不知道为啥没用，但是能直接把人干死，可以在服务器里试试
		}
	}
    local command = Entities.CreateByClassname("point_servercommand");
    EntFireByHandle(command, "Command", "mp_restartgame 5", 0, null, null);
}