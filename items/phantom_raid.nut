SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "UNKNOWN";
SCRIPT_TIME <- "2022年11月5日22:06:10";

PhantomRaid_guy <- null;
function CreateText()
{
	local text = Entities.CreateByClassname("game_text");
	text.__KeyValueFromString("message","PhantomRaid_guy IS YOU");
	text.__KeyValueFromString("color","255 255 255");
	text.__KeyValueFromString("color2","255 255 255");
	text.__KeyValueFromString("effect","2");
	text.__KeyValueFromString("x","-1");
	text.__KeyValueFromString("y","0.7");
	text.__KeyValueFromString("channel","3");
	text.__KeyValueFromString("spawnflags","0");
	text.__KeyValueFromString("holdtime","5");
	text.__KeyValueFromString("fadein","0");
	text.__KeyValueFromString("fadeout","0");
	text.__KeyValueFromString("fxtime","0");
	return text;
}

function CreateUI()
{
	local ui = Entities.CreateByClassname("game_ui");
	ui.__KeyValueFromString("spawnflags", "96");
	ui.__KeyValueFromString("FieldOfView", "-1.0");
    ui.ConnectOutput("PlayerOn", "PlayerOn");
	ui.ConnectOutput("PlayerOff", "PlayerOff");
	ui.ConnectOutput("PressedAttack", "PressedAttack");
    ui.ConnectOutput("PressedAttack2", "PressedAttack2");
	//EntFireByHandle(ui, "RunScriptCode", "Init()", 0.02, null,null);
	return ui;
}

function Pickup_PhantomRaid()
{
    PhantomRaid_guy = activator;
    ScriptPrintMessageChatAll("PhantomRaid");
}

PhantomRaid_toggle <- false;
PhantomRaid_gameui <- null;
PhantomRaid_text <- null;
function toggle_PhantomRaid()
{
    ScriptPrintMessageChatAll(Time().tostring());
    ScriptPrintMessageChatAll(PhantomRaid_toggle.tostring());
    if(PhantomRaid_toggle == false)
    {
        PhantomRaid_toggle = true;
        PhantomRaid_gameui <- CreateUI();
        PhantomRaid_text <- CreateText();
        PhantomRaid_gameui.__KeyValueFromString("vscripts", "7ychu5/items/PhantomRaid.nut");
        EntFireByHandle(PhantomRaid_gameui,"Activate","",0.0,PhantomRaid_guy,null);
        EntFireByHandle(PhantomRaid_text, "Display", " ", 0.0, PhantomRaid_guy, null);
    }
    else
    {
        PhantomRaid_toggle = false;
        EntFireByHandle(PhantomRaid_gameui,"Deactivate","",0.0,PhantomRaid_guy,null);
        EntFireByHandle(PhantomRaid_gameui, "kill", " ", 0.0, null, null);
        EntFireByHandle(PhantomRaid_text, "kill", " ", 0.0, null, null);
    }
}
