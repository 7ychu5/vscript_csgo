SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "UNKNOWN";
SCRIPT_TIME <- "2022年11月23日21:25:14";

//写路径一定用“/”，不要用\
/////////////////////////////////////////////////////////////////////
attach_model <- "models/7ychu5/titan_ronin_sword/titan_ronin_sword.mdl"
v_model_test <- "models/weapons/exg/cfhdawp/v_snip_awp.mdl";
w_model_test <- "models/weapons/exg/cfhdawp/w_snip_awp.mdl";
weapon <- "awp";
////////////////////////////////////////////////////////////////////

self.PrecacheModel(attach_model);
self.PrecacheModel(v_model_test);
self.PrecacheModel(w_model_test);
self.PrecacheModel("models/player/custom_player/uuz/newbone/mamama/foxmiku.mdl");
self.PrecacheModel("models/player/custom_player/uuz/newbone/mamama/foxmiku_arms_skin0.mdl");

attach_test <- CreateProp("prop_dynamic", Vector(1200, 950, 600), attach_model, 0);

function tick() {
    local ent;
    while((ent = Entities.FindByClassname(ent, "*") ) != null)
    {
        if(ent.GetClassname() == "predicted_viewmodel")
        {
            if(ent.GetModelName().find(weapon, 0) != null)
            {
                ent.SetModel(v_model_test);
            }
        }
        if(ent.GetClassname() == "weaponworldmodel" )
        {
            if(ent.GetModelName().find(weapon, 0) != null)
            {
                ent.SetModel(w_model_test);
            }
        }
        if(ent.GetModelName().find("ctm", 0) != null || ent.GetModelName().find("glove", 0) != null)
        {
            //ent.GetAttachmentOrigin(1);
            ent.__KeyValueFromString("targetname", "attach_ent");
            ent.SetModel("models/player/custom_player/uuz/newbone/mamama/foxmiku.mdl");
            EntFireByHandle(attach_test, "SetParent", "attach_ent", 0.01, null,null);
            EntFireByHandle(attach_test, "SetParentAttachment", "c4", 0.02, null, null);
        }
        if(ent.GetModelName().find("awp_dropped", 0) != null ||ent.GetModelName().find("awp_dropped", 0) != null)
        {
            printl(ent.GetClassname());
            ent.SetModel(w_model_test);
        }
        //printl(ent.GetModelName());
    }
    EntFireByHandle(self, "RunScriptCode", "tick()", 0.01, null, null);
}