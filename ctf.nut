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

::PlayerUse <- function (params) {
    if (::target != null) {
        local sc = ::target.GetScriptScope();
        sc.userid <- params.userid;
        ::target = null;
        return;
    }
}

::OnGameEvent_player_death <- function( event ) {
    if(event.userid == ::ct_flag_owner_id)
    {
        ScriptPrintMessageChatAll("CT旗帜掉落！");
        ::flag_toggle_CT = true;
        ::ct_flag_owner = null;
        ::ct_flag_owner_id = null;
        EntFire("flag_CT_trigger","Enable"," ",0.0,null);


    }
    if(event.userid == ::t_flag_owner_id)
    {
        ScriptPrintMessageChatAll("T旗帜掉落！");
        ::flag_toggle_T = true;
        ::t_flag_owner = null;
        ::t_flag_owner_id = null;
        EntFire("flag_T_trigger","Enable"," ",0.0,null);

    }
}

::OnGameEvent_round_start <- function ( event ) {
    ::ct_flag_owner <- null;
    ::flag_toggle <- true;
    ::ct_point <- 0;
    ::t_point <- 0;
}

::ct_point <- 0;
::t_point <- 0;

function scoreboard() {
    EntFire("scoreboard", "SetText", "CT得分："+::ct_point.tostring()+"\nT得分："+::t_point.tostring(), 0.00, self);
	EntFire("scoreboard", "Display", "", 0.02, self);
	EntFireByHandle(self, "RunScriptCode", " scoreboard(); ", 0.20, null, null);
}

::ct_flag_owner_id <- null;
::t_flag_owner_id <- null;
::ct_flag_owner <- null;
::t_flag_owner <- null;
::flag_toggle_CT <- true;
::flag_toggle_T <- true;

function trigger_flag_CT() {
    if(::flag_toggle_CT==true) {
        if(activator.GetTeam()==2)//抢到了对面旗帜
        {
            ::ct_flag_owner_id = activator.GetScriptScope().userid;
            local flag_CT = Entities.FindByName(null, "flag_CT");
            ScriptPrintMessageChatAll(GetNameByUserid(activator.GetScriptScope().userid)+"拿到了旗帜！");
            EntFire("flag_CT_trigger","Disable"," ",0.0,null);
            ::ct_flag_owner = Entities.FindByClassnameNearest("player", flag_CT.GetOrigin(), 512);
            EntFire("tick","RunScriptCode","showthemwhoweare_CT()",0.0,null);
            ::flag_toggle_CT = false;
        }
        if(activator.GetTeam()==3)//CT抢回了自己的旗帜
        {
            //ScriptPrintMessageChatAll(GetNameByUserid(activator.GetScriptScope().userid)+"夺回了旗帜！");
            local ct_target = Entities.FindByName(null, "flag_CT_target");
            EntFire("flag_CT_relay","FireUser1"," ",0.0,null);
            local drop_flag_CT_trigger = Entities.FindByNameNearest("flag_CT_trigger", activator.GetOrigin(), 48);
            local drop_flag_CT = Entities.FindByNameNearest("flag_CT", activator.GetOrigin(), 96);
            //EntFireByHandle(drop_flag_CT_trigger,"kill","",0.0,null,null);
            EntFireByHandle(drop_flag_CT,"kill","",0.0,null,null);
        }
    }
}

function trigger_flag_T() {
    if(::flag_toggle_T==true) {
        if(activator.GetTeam()==3)
        {
            ::t_flag_owner_id = activator.GetScriptScope().userid;
            local flag_T = Entities.FindByName(null, "flag_T");
            ScriptPrintMessageChatAll(GetNameByUserid(activator.GetScriptScope().userid)+"拿到了旗帜！");
            EntFire("flag_T_trigger","Disable"," ",0.0,null);
            ::t_flag_owner = Entities.FindByClassnameNearest("player", flag_T.GetOrigin(), 512);
            EntFire("tick","RunScriptCode","showthemwhoweare_T()",0.0,null);
            ::flag_toggle_T = false;
        }
        if(activator.GetTeam()==2)
        {
            //ScriptPrintMessageChatAll(GetNameByUserid(activator.GetScriptScope().userid)+"夺回了旗帜！");
            local t_target = Entities.FindByName(null, "flag_T_target");
            EntFire("flag_T_relay","FireUser1"," ",0.0,null);
            local drop_flag_T_trigger = Entities.FindByNameNearest("flag_T_trigger", activator.GetOrigin(), 48);
            local drop_flag_T = Entities.FindByNameNearest("flag_T", activator.GetOrigin(), 96);
            //EntFireByHandle(drop_flag_T_trigger,"kill","",0.0,null,null);
            EntFireByHandle(drop_flag_T,"kill","",0.0,null,null);
        }
    }
}

function trigger_home_CT()
{
    if(activator.GetScriptScope().userid == ::t_flag_owner_id)
    {
        ::flag_toggle_T = true;
        ::t_flag_owner = null;
        ::t_flag_owner_id = null;
        ::ct_point++;
        local t_target = Entities.FindByName(null, "flag_T_target");
        EntFire("flag_T_relay","FireUser1"," ",0.0,null);
        local drop_flag_T_trigger = Entities.FindByNameNearest("flag_T_trigger", activator.GetOrigin(), 48);
        local drop_flag_T = Entities.FindByNameNearest("flag_T", activator.GetOrigin(), 96);
        EntFireByHandle(drop_flag_T,"kill","",0.0,null,null);
        if(::ct_point>=5)
        {
            ScriptPrintMessageCenterAll("CT获胜\n十秒后重置游戏");
            EntFire("command","command", "mp_restartgame 10",0.0,null);
        }
    }
}

function trigger_home_T()
{
    if(activator.GetScriptScope().userid == ::ct_flag_owner_id)
    {
        ::flag_toggle_CT = true;
        ::ct_flag_owner = null;
        ::ct_flag_owner_id = null;
        ::t_point++;
        local ct_target = Entities.FindByName(null, "flag_CT_target");
        EntFire("flag_CT_relay","FireUser1"," ",0.0,null);
        local drop_flag_CT_trigger = Entities.FindByNameNearest("flag_CT_trigger", activator.GetOrigin(), 48);
        local drop_flag_CT = Entities.FindByNameNearest("flag_CT", activator.GetOrigin(), 96);
        EntFireByHandle(drop_flag_CT,"kill","",0.0,null,null);
        if(::t_point>=5)
        {
            ScriptPrintMessageCenterAll("T获胜\n十秒后重置游戏");
            EntFire("command","command", "mp_restartgame 10",0.0,null);
        }
    }
}

function showthemwhoweare_CT() {
    local flag_CT = Entities.FindByName(null, "flag_CT");
    flag_CT.SetOrigin(::ct_flag_owner.GetOrigin());
    EntFire("tick","RunScriptCode","showthemwhoweare_CT()",0.001,null);
}
function showthemwhoweare_T() {
    local flag_T = Entities.FindByName(null, "flag_T");
    flag_T.SetOrigin(::t_flag_owner.GetOrigin());
    EntFire("tick","RunScriptCode","showthemwhoweare_T()",0.001,null);
}