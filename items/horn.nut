SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "UNKNOWN";
SCRIPT_TIME <- "2022年11月2日20:19:58";

self.PrecacheScriptSound("7ychu5/zeyftxyessir.mp3");

::spawner <- Entities.CreateByClassname("env_entity_maker");
::spawner.__KeyValueFromString("EntityTemplate", "item_horn_temp");
horn_gameui <- Entities.CreateByClassname("game_ui");
horn_gameui.__KeyValueFromString("targetname", "horn_gameui");
horn_gameui.__KeyValueFromString("vscripts", "7ychu5/items/horn.nut");
horn_gameui.__KeyValueFromFloat("FieldOfView", -1);

::horn_guy <- null;

if(horn_gameui.ValidateScriptScope())
{
    local scope = horn_gameui.GetScriptScope();
    scope["PressedAttack2"] <- function ()
    {
        local target_candidates = [];
	    for(local h;h=Entities.FindByClassnameWithin(h,"cs_bot",::horn_guy.GetOrigin(),1024);)
	    {
		    if(h==null||!h.IsValid()||h.GetTeam()!=3||h.GetHealth()<=0) continue;
		    target_candidates.push(h);
	    }
	    if(target_candidates.len()<=0) return;
        for(local j=0;j<target_candidates.len();j++)
        {
            ::spawner.SpawnEntityAtEntityOrigin(target_candidates[j]);
            target_candidates[j].EmitSound("7ychu5/zeyftxyessir.mp3");
        }
        sweephorn();
        //EntFireByHandle(self, "RunScriptCode", "sweephorn", 5.0, null, null);
    }
    scope["sweephorn"] <- function ()
    {
        EntFire("item_horn_sprite", "Kill", " ", 5.0, null);
    }
}

function PickupHornGun()
{
    ::horn_guy = activator;
    horn_gameui.ConnectOutput("PressedAttack2", "PressedAttack2");
    EntFireByHandle(horn_gameui,"Activate","",0.0,horn_guy,null);
    ScriptPrintMessageChatAll("horn");
}