function Precache() {
    self.PrecacheScriptSound("7ychu5/开始相位转移.wav");
}
::OnGameEvent_round_end <- function (event) {
    local winner = event.winner;
    // if(winner.tostring()==2)
    // {
    //     rage_size++;
    //     for (local ent; ent = Entities.FindByClassname(ent, "info_player_counterterrorist"); )
    //     {
    //         EntFireByHandle(SpeedModifierEntity,"ModifySpeed"," "+speedModifierAttribute.tostring(),0.05,ent,null);
    //         ent.SetHealth(rage_size*0.1*100);
    //     }
    // }
}
function SetSpeedGlobal(){
	pl <- null;
	while(null != (pl = Entities.FindByClassname(pl, "player"))){
	if(pl.GetMaxHealth() == 100){
			EntFire("player_speedmod", "ModifySpeed", "3", 0.0, pl);
			EntFireByHandle(pl, "AddOutput", "gravity 0.3", 0.0, null, null);
		} else if(pl.GetMaxHealth() == 275){
			EntFire("speedMod", "ModifySpeed", "0.88", 0.0, pl); //0.86
			EntFireByHandle(pl, "AddOutput", "gravity 1.08", 0.0, null, null);
		} else if(pl.GetMaxHealth() == 99999){
			EntFire("speedMod", "ModifySpeed", "0.70", 0.0, pl);
			EntFireByHandle(pl, "AddOutput", "gravity 2", 0.0, null, null);
		} else if(pl.GetMaxHealth() == 101){
			EntFire("speedMod", "ModifySpeed", "1.5", 0.0, pl);
		} else if(pl.GetMaxHealth() == 200){
			EntFire("speedMod", "ModifySpeed", "1", 0.0, pl);
		} else if(pl.GetMaxHealth() == 125){
			EntFire("speedMod", "ModifySpeed", "1", 0.0, pl);
		} else if(pl.GetMaxHealth() == 60000){
			EntFire("speedMod", "ModifySpeed", "3", 0.0, pl);
		} else if(pl.GetMaxHealth() == 9000){
			EntFire("speedMod", "ModifySpeed", "1.25", 0.0, pl);
		} else if(pl.GetMaxHealth() == 100000){
			EntFire("speedMod", "ModifySpeed", "0.9", 0.0, pl);
		} else if(pl.GetMaxHealth() == 70000){
			EntFire("speedMod", "ModifySpeed", "1", 0.0, pl);
		} else if(pl.GetMaxHealth() == 71000){
			EntFire("speedMod", "ModifySpeed", "1.35", 0.0, pl);
			EntFireByHandle(pl, "AddOutput", "gravity 0.8", 0.0, null, null);
		}
	}
}
//////////////////////////
////item_TimeTraveller////
//////////////////////////
TimeTraveller_OWNER <- null;
TravelToggle <- true;
function PickUpTimeTraveller()
{
    TimeTraveller_OWNER = activator;
    ScriptPrintMessageChatAll("**一名玩家取得了时空背包！**");
}

function UseTimeTraveller()
{
    if(activator == TimeTraveller_OWNER && TimeTraveller_OWNER.IsValid() && TimeTraveller_OWNER != null)
    {
        EntFire("item_TimeTraveller_tesla", "DoSpark", "", 0.0);
        EntFire("item_TimeTraveller_beam_down", "TurnOn", "", 0.0);
        EntFire("item_TimeTraveller_sound", "PlaySound", "", 0.0);
        EntFire("item_TimeTraveller_tesla", "DoSpark", "", 0.5);
        EntFire("item_TimeTraveller_tesla", "DoSpark", "", 1.0);
        EntFire("item_TimeTraveller_tesla", "DoSpark", "", 1.5);
        EntFire("item_TimeTraveller_fade", "FadeReverse", "", 1.9);
        EntFire("item_TimeTraveller_tesla", "DoSpark", "", 2.0);
        EntFire("item_TimeTraveller_button", "RunScriptCode", "TimeTraveller()", 2.0, -1);
        EntFire("item_TimeTraveller_tesla", "DoSpark", "", 3.0);
        EntFire("item_TimeTraveller_beam_down", "TurnOff", "", 3.0);
    }
}
function TimeTraveller()
{
    local NowTravelOrigin = TimeTraveller_OWNER.GetOrigin()
    if(TravelToggle)
    {
        NowTravelOrigin.z = NowTravelOrigin.z-380;
        TravelToggle = false;
    }
    else
    {
        NowTravelOrigin.z = NowTravelOrigin.z+516;
        TravelToggle = true;
    }
    TimeTraveller_OWNER.SetOrigin(NowTravelOrigin);
}


//////////////////////////
//////item_Sacrifice//////need fix the filter
//////////////////////////
Sacrifice_OWNER <- null;
function PickUpSacrifice()
{
    Sacrifice_OWNER = activator;
    ScriptPrintMessageChatAll("**有玩家已经做好准备为正义做出牺牲！**");
}

function UseSacrifice()
{
    if(activator == Sacrifice_OWNER && Sacrifice_OWNER.IsValid() && Sacrifice_OWNER != null)
    {
        ScriptPrintMessageChatAll("**一场华丽的悲剧即将上演！**");
        //function EntFire(string target, string action, string value, float delay = 0.0, handle activator = null)
        EntFire("item_Sacrifice_sound", "PlaySound");
        EntFire("item_Sacrifice_particle", "Start");
        EntFire("item_Sacrifice_particle", "Stop","",6.0);
        EntFire("item_Sacrifice_explosion", "Explode","",6.1);
    }
}


//////////////////////////
//item_AirStrikeSummoner//need fix the filter
//////////////////////////
//用户1拿起来成为为使用者；如果丢出去的探测雷userid检测为用户1，则执行第三段function
AirStrikeSummoner_OWNER <- null;
function PickUpAirStrikeSummoner(){
    AirStrikeSummoner_OWNER = activator;
    ScriptPrintMessageChatAll("**有人拿到了对讲机，可以呼叫超时空打击了！**");
    printl(AirStrikeSummoner_OWNER);
}

::OnGameEvent_tagrenade_detonate <- function (event) {
    // if(event.userid==AirStrikeSummoner_OWNER_userid)
    // {
        local AirStrikeOrigin = Vector(event.x,event.y,event.z);
        local spawner = Entities.CreateByClassname("env_entity_maker");
        spawner.__KeyValueFromString("EntityTemplate", "item_AirStrikeSummoner_summon");
        spawner.SpawnEntityAtLocation(AirStrikeOrigin, Vector(0,0,0));
    // }
}

//////////////////////////
///////////HEAL///////////need fix the particle
//////////////////////////
HEAL_OWNER <- null;
function PickUpHeal()
{
    HEAL_OWNER = activator;
    ScriptPrintMessageChatAll("** Heal item has been picked up **");
}

function UseHeal()
{
    if(activator == HEAL_OWNER && HEAL_OWNER.IsValid() && HEAL_OWNER != null)
    {
        EntFireByHandle(self, "FireUser1", "", 0.00, HEAL_OWNER, HEAL_OWNER);
    }
}
//////////////////////////
//////////Sniper//////////
//////////////////////////