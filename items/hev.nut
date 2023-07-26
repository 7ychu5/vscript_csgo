SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "UNKNOWN";
SCRIPT_TIME <- "2023年6月3日01:09:29";
SCRIPT_VERSION <- "v1.0";

v_model_test <- "models/weapons/zombieden/ttt/v_crowbar_fix.mdl";
self.PrecacheModel(v_model_test);

hev_user <- null;

function identify() {
    if(activator.GetTeam()!=3 || !activator.IsValid() || activator.GetHealth()<=0 || activator.GetName()!="") return;
    local name = "hev" + RandomInt(0, 9999).tostring();
    while(null != Entities.FindByName(null, name))
    {
        name = "hev" + RandomInt(0, 9999).tostring();
    }
    EntFireByHandle(activator, "addoutput", "targetname "+name, 0.01, null, null);

    local stripper = Entities.CreateByClassname("player_weaponstrip");
    local maker = Entities.CreateByClassname("env_entity_maker");
    EntFireByHandle(stripper, "Strip", " ", 0.0, activator, null);
    maker.__KeyValueFromString("EntityTemplate","item_hev_get_template");
    maker.SpawnEntityAtLocation(activator.GetOrigin(), Vector(0, 0, 0));
    EntFireByHandle(stripper, "kill", " ", 0.01, null, null);
    EntFireByHandle(maker, "kill", "", 0.01, null, null);
}

function SetUser() {
    activator = hev_user;
    ScriptPrintMessageChatAll("有人的HEV防护服已穿戴整齐");
    tick();
}

function tick() {
    local ent;
    while((ent = Entities.FindByClassname(ent, "*") ) != null)
    {
        if(ent.GetOwner() == hev_user)
        {
            if(ent.GetClassname() == "predicted_viewmodel")
            {
                if(ent.GetModelName().find("knife", 0) != null)
                {
                    ent.SetModel(v_model_test);
                }
            }
        }
    }
    EntFireByHandle(self, "RunScriptCode", "tick()", 1, null, null);
}