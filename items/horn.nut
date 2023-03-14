SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "UNKNOWN";
SCRIPT_TIME <- "2022年11月2日20:19:58";

v_model_hand <- "models/player/custom_player/exg/master_chief/master_chief_v3.mdl"
v_model_hand2 <- "models/player/custom_player/exg/master_chief/master_chief_arms.mdl"
v_model_test <- "models/weapons/exg/crowbar/v_crowbar.mdl";
w_model_test <- "models/weapons/zombieden/aot/w_giantsword.mdl";
self.PrecacheScriptSound("7ychu5/zeyftxyessir.mp3");
self.PrecacheModel(v_model_hand);
self.PrecacheModel(v_model_hand2);
self.PrecacheModel(v_model_test);
self.PrecacheModel(w_model_test);

::spawner <- Entities.CreateByClassname("env_entity_maker");
::spawner.__KeyValueFromString("EntityTemplate", "item_horn_temp");
horn_gameui <- Entities.CreateByClassname("game_ui");
::horn_gun <- Entities.FindByName(null, "item_horn_gun")
horn_gameui.__KeyValueFromString("targetname", "horn_gameui");
horn_gameui.__KeyValueFromString("vscripts", "7ychu5/items/horn.nut");
horn_gameui.__KeyValueFromFloat("FieldOfView", -1);

::horn_guy <- null;
if(horn_gameui.ValidateScriptScope())
{
    local scope = horn_gameui.GetScriptScope();
    scope["PressedAttack2"] <- function ()
    {
        printl(self.GetName());printl(::horn_gun.GetClassname());
        printl("Angles:"+::horn_guy.GetAngles());
        printl("UpVector:"+::horn_guy.GetUpVector());
        printl("ForwardVector:"+::horn_guy.GetForwardVector());
        local eye = ::horn_guy.EyePosition();
        local yaw = ::horn_guy.GetAngles().y;
        local face = Vector(eye.x+cos(yaw * PI / 180.0)*1,eye.y+sin(yaw * PI / 180.0)*1,eye.z);
        printl("Face:"+face);
        //::horn_guy.__KeyValueFromVector("basevelocity", Vector(::horn_guy.GetAngles().x+250, ::horn_guy.GetAngles().y+250, 0));
    }
    scope["sweephorn"] <- function ()
    {
        EntFire("item_horn_sprite", "Kill", " ", 5.0, null);
    }
}

function tick() {
    local ent;
    while ( ( ent = Entities.FindByClassname(ent, "*") ) != null )
    {
        if ( ent.GetClassname() == "predicted_viewmodel" )
        {
            //if ( ent.GetMoveParent() == ::horn_guy || ent.GetOwner() == ::horn_guy )
            {
                if ( ent.GetModelName().find("knife", 0) != null || ent.GetModelName() == "" )
                {
                    ent.SetModel(v_model_test);
                }
            }
        }
        if ( ent.GetClassname() == "weaponworldmodel" )
        {
            //if ( ent.GetMoveParent() == ::horn_guy || ent.GetOwner() == ::horn_guy )
            {
                if ( ent.GetModelName().find("knife", 0) != null || ent.GetModelName() == "" )
                {
                    ent.SetModel(w_model_test);
                }
            }
        }
    }

    EntFireByHandle(self, "RunScriptCode", "tick()", 0.1, null, null);
}

function PickupHornGun()
{
    tick();
    ::horn_guy = activator;
    ::horn_guy.SetModel(v_model_hand);
    //EntFireByHandle(::horn_guy, "SetBodyGroup", "512", 0.00, null, null);
    horn_gameui.ConnectOutput("PressedAttack2", "PressedAttack2");
    EntFireByHandle(horn_gameui,"Activate","",0.0,horn_guy,null);
    ScriptPrintMessageChatAll("horn");
}