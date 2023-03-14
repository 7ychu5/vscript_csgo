SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "UNKNOWN";
SCRIPT_TIME <- "2022年10月28日00:22:10";

spawner <- Entities.CreateByClassname("env_entity_maker");
ultrakill_gameui <- Entities.CreateByClassname("game_ui");
ultrakill_gameui.__KeyValueFromString("targetname", "ultrakill_gameui");
ultrakill_gameui.__KeyValueFromString("vscripts", "7ychu5/items/ultrakill.nut");
ultrakill_gameui.__KeyValueFromFloat("FieldOfView", -1);

ultrakill_guy <- null;

function tick()
{
    for (local ent; ent = Entities.FindByClassname(ent, "func_physbox_multiplayer");)
    {
        if(ent.GetVelocity()==0) EntFireByHandle(ent, "break", " ", 0.0, null, null);
    }
    //printl("sweep");
    EntFire("logic_script", "RunScriptCode", "tick()", 1.0, null);
}

if(ultrakill_gameui.ValidateScriptScope())
{
    local scope = ultrakill_gameui.GetScriptScope();
    scope["PressedAttack2"] <- function ()
    {
        //printl(ultrakill_guy);
        EntFire("ultrakill_coin_push_up", "Enable", " ", 0.0, null);
        EntFire("ultrakill_maker", "ForceSpawn", " ", 0.02, null);
        EntFire("ultrakill_coin_push_up", "Disable", " ", 0.02, null);
    }
    scope["PressedMoveLeft"] <- function ()
    {
        EntFire("ultrakill_coin_push_right", "Enable", " ", 0.0, null);
    }
    scope["UnpressedMoveLeft"] <- function ()
    {
        EntFire("ultrakill_coin_push_right", "Disable", " ", 0.0, null);
    }
    scope["PressedMoveRight"] <- function ()
    {
        EntFire("ultrakill_coin_push_left", "Enable", " ", 0.0, null);
    }
    scope["UnpressedMoveRight"] <- function ()
    {
        EntFire("ultrakill_coin_push_left", "Disable", " ", 0.0, null);
    }
    scope["PressedForward"] <- function ()
    {
        EntFire("ultrakill_coin_push_forward", "Enable", " ", 0.0, null);
    }
    scope["UnpressedForward"] <- function ()
    {
        EntFire("ultrakill_coin_push_forward", "Disable",   " ", 0.0, null);
    }
    scope["PressedBack"] <- function ()
    {
        EntFire("ultrakill_coin_push_backward", "Enable", " ", 0.0, null);
    }
    scope["UnpressedBack"] <- function ()
    {
        EntFire("ultrakill_coin_push_backward", "Disable", " ", 0.0, null);
    }
}

function PickupCoinGun()
{
    ultrakill_guy = activator;
    ultrakill_guy.__KeyValueFromString("targetname", "ultrakill_guy");
    ultrakill_gameui.ConnectOutput("PressedAttack2", "PressedAttack2");
    ultrakill_gameui.ConnectOutput("PressedMoveLeft", "PressedMoveLeft");
    ultrakill_gameui.ConnectOutput("UnpressedMoveLeft", "UnpressedMoveLeft");
    ultrakill_gameui.ConnectOutput("PressedMoveRight", "PressedMoveRight");
    ultrakill_gameui.ConnectOutput("UnpressedMoveRight", "UnpressedMoveRight");
    ultrakill_gameui.ConnectOutput("PressedForward", "PressedForward");
    ultrakill_gameui.ConnectOutput("UnpressedForward", "UnpressedForward");
    ultrakill_gameui.ConnectOutput("PressedBack", "PressedBack");
    ultrakill_gameui.ConnectOutput("UnpressedBack", "UnpressedBack");
    EntFireByHandle(ultrakill_gameui,"Activate","",0.0,ultrakill_guy,null);
    ScriptPrintMessageChatAll("ULTRAKILL");
}

function coin_hit()
{
    printl("1");
    local target_candidates = [];
    local h=Entities.FindByClassnameNearest("func_physbox_multiplayer", self.GetOrigin(), 2048);
    if(h != null)
    {
        local h_origin = Vector(h.GetOrigin().x, h.GetOrigin().y, h.GetOrigin().z);
        laser_fly(h_origin);
    }
    else
    {
        local h=Entities.FindByClassnameNearest("cs_bot", self.GetOrigin(), 2048);
        if(h!=null)
        {
            local h_origin = Vector(h.GetOrigin().x, h.GetOrigin().y, h.GetOrigin().z+70);
            laser_fly(h_origin);
        }
        else ScriptPrintMessageChatAll("NULL");
    }

}

function laser_fly(origin)
{
    printl(origin);
    spawner.__KeyValueFromString("EntityTemplate", "temp_ultrakill_coin_fly");
    spawner.SpawnEntityAtLocation(activator.GetOrigin(), Vector(0,0,0));
    printl(activator.GetOrigin());
    // local ultrakill_coin_path_1 = Entities.FindByName(null, "ultrakill_coin_path_1");
    local ultrakill_coin_path_2 = Entities.FindByName(null, "ultrakill_coin_path_2*");
    ultrakill_coin_path_2.SetOrigin(origin);
    EntFire("ultrakill_coin_explosion*", "AddOutput", "origin "+origin, 0.0, null);
    EntFire("ultrakill_coin_mover*", "StartForward", " ", 0.05, null);

}