SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "UNKNOWN";
SCRIPT_TIME <- "2022年10月27日14:04:41";

//////////////////////////////
/////////////Lure/////////////
//////////////////////////////
Lure_Owner <- null;
function PickUpLure()
{
	Lure_Owner = activator;
	ScriptPrintMessageChatAll("人类黑洞已拾取");
}
function CastLure()
{
	if(activator == Lure_Owner && Lure_Owner.IsValid() && Lure_Owner != null)
	{
		EntFireByHandle(self, "FireUser1", "", 0.00, Lure_Owner, Lure_Owner);
	}
}

//////////////////////////////
/////////////fire/////////////
//////////////////////////////
fire <- null;
function fire_Owner()
{
    fire = activator;
    ScriptPrintMessageChatAll("人类火已获取");
}

function firecast()
{
	if(activator == fire && fire.IsValid() && fire != null)
	{
		EntFireByHandle(self, "FireUser1", "", 0.00, fire, fire);
	}
}

//////////////////////////////
////////////water/////////////
//////////////////////////////
water <- null;
function water_Owner()
{
    water = activator;
    ScriptPrintMessageChatAll("人类水已获取");
}

function watercast()
{
	if(activator == water && water.IsValid() && water != null)
	{
		EntFireByHandle(self, "FireUser1", "", 0.00, water, water);
	}
}

//////////////////////////////
/////////////heal/////////////
//////////////////////////////
heal <- null;
function heal_Owner()
{
    heal = activator;
    ScriptPrintMessageChatAll("僵尸奶已获取");
}

function CastHeal()
{
	if(activator == heal && heal.IsValid() && heal != null)
	{
		EntFireByHandle(self, "FireUser1", "", 0.00, heal, heal);
	}
}

//////////////////////////////
/////////////hurt/////////////
//////////////////////////////
hurt <- null;
function hurt_Owner()
{
    hurt = activator;
    ScriptPrintMessageChatAll("僵尸秒杀已获取");
}

function hurtcast()
{
	if(activator == hurt && hurt.IsValid() && hurt != null)
	{
		EntFireByHandle(self, "FireUser1", "", 0.00, hurt, hurt);
	}
}