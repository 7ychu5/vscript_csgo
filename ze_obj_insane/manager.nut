SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "ze_obj_insane_v1";
SCRIPT_TIME <- "2022年8月11日22:01:46";

MAPPER_SID <- [
    "STEAM_1:0:92422507",//7ychu5
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