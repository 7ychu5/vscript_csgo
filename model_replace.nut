SCRIPT_OWNER <- "7ychu5";
SCRIPT_TIME <- "2023年8月20日10:18:27";
SCRIPT_MAP <- "GLOBAL";
SCRIPT_VERISON <- "0.1";

IncludeScript("7ychu5/utils.nut");
IncludeScript("vs_library.nut");
//////////user_variable///////////

vm <- "models/weapons/ZombiEden/xrole/v_cyst_knife.mdl";

weapon <- "knife";

self.PrecacheModel(vm);

//////////sys_variable////////////

::logic_script <- Entities.FindByName(null, "logic_script");

//////////////////////////////////

VS.ListenToGameEvent( "round_start", function( event )
{

    EntFireByHandle(::logic_script, "RunScriptcode", "tick()", 0.0, null, null);

}, "" );

function tick() {
    local ent;
    while((ent = Entities.FindByClassname(ent, "*") ) != null)
    {
        if(ent.GetClassname() == "predicted_viewmodel")
        {
            if(ent.GetModelName().find(weapon, 0) != null || ent.GetModelName() == "" )
            {
                ent.SetModel(vm);
            }
        }
        if(ent.GetClassname() == "weaponworldmodel" )
        {
            if(ent.GetModelName().find(weapon, 0) != null || ent.GetModelName() == "")
            {
                //ent.SetModel(w_model_test);
            }
        }
    }
    EntFireByHandle(self, "RunScriptCode", "tick()", 0.01, null, null);
}