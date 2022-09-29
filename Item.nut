//////////////////////////
////item_TimeTraveller////
//////////////////////////
TimeTraveller_OWNER <- null;
TravelToggle <- true;

function PickUpTimeTraveller() {
    TimeTraveller_OWNER = activator;
    ScriptPrintMessageChatAll("**一名玩家取得了时空背包！**");
}

function UseTimeTraveller() {
    if (activator == TimeTraveller_OWNER && TimeTraveller_OWNER.IsValid() && TimeTraveller_OWNER != null) {
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

function TimeTraveller() {
    local NowTravelOrigin = TimeTraveller_OWNER.GetOrigin()
    if (TravelToggle) {
        NowTravelOrigin.z = NowTravelOrigin.z - 380;
        TravelToggle = false;
    } else {
        NowTravelOrigin.z = NowTravelOrigin.z + 516;
        TravelToggle = true;
    }
    TimeTraveller_OWNER.SetOrigin(NowTravelOrigin);
}


//////////////////////////
//////item_Sacrifice//////need cooler particle
//////////////////////////
Sacrifice_OWNER <- null;

function PickUpSacrifice() {
    Sacrifice_OWNER = activator;
    ScriptPrintMessageChatAll("**有玩家已经做好准备为正义做出牺牲！**");
}

function UseSacrifice() {
    if (activator == Sacrifice_OWNER && Sacrifice_OWNER.IsValid() && Sacrifice_OWNER != null) {
        ScriptPrintMessageChatAll("**一场华丽的悲剧即将上演！**");
        //function EntFire(string target, string action, string value, float delay = 0.0, handle activator = null)
        EntFire("item_Sacrifice_sound", "PlaySound");
        EntFire("item_Sacrifice_particle", "Start");
        EntFire("item_Sacrifice_particle", "Stop", "", 6.0);
        EntFire("item_Sacrifice_explosion", "Explode", "", 6.1);
    }
}

//////////////////////////
///////////HEAL///////////need fix the particle
//////////////////////////
HEAL_OWNER <- null;

function PickUpHeal() {
    HEAL_OWNER = activator;
    ScriptPrintMessageChatAll("** Heal item has been picked up **");
}

function UseHeal() {
    if (activator == HEAL_OWNER && HEAL_OWNER.IsValid() && HEAL_OWNER != null) {
        EntFireByHandle(self, "FireUser1", "", 0.00, HEAL_OWNER, HEAL_OWNER);
    }
}


//////////////////////////
//////Barrier_scifi//////
//////////////////////////
Barrier_Wooden_OWNER <- null;

function PickUpBarrier_Wooden() {
    Barrier_Wooden_OWNER = activator;
    ScriptPrintMessageChatAll("**TRIM**");
}

function UseBarrier_Wooden() {
    if (activator == Barrier_Wooden_OWNER && Barrier_Wooden_OWNER.IsValid() && Barrier_Wooden_OWNER != null) {
        EntFire("test_crate_show", "kill");
        EntFire("barrier_wooden_maker", "ForceSpawn");
        EntFire("barrier_wooden_maker_button", "kill");
        EntFire("barrier_wooden_particle_start", "start");
        EntFire("barrier_wooden_particle_start", "stop", " ", 1.0);
    }
}

//////////////////////////
//item_AirStrikeSummoner//need fix the filter
//////////////////////////
//用户1拿起来成为为使用者，如果使用者按下按钮为用户1，则执行第二段function；如果丢出去的探测雷userid检测为用户1，则执行第三段function
AirStrikeZMLeader_OWNER <- null;
function PickUpAirStrikeSummoner() {
    AirStrikeZMLeader_OWNER = activator;
    ScriptPrintMessageChatAll("**有人拿到了对讲机，可以呼叫超时空打击了！**");
    printl(AirStrikeZMLeader_OWNER);
}

function UseAirStrikeSummoner() {
    if (activator == AirStrikeZMLeader_OWNER && AirStrikeZMLeader_OWNER.IsValid() && AirStrikeZMLeader_OWNER != null) {
        ScriptPrintMessageChatAll("**已呼叫超时空支援！请尽快投放信标！**");
        printl(activator.userid());
    }
}

::OnGameEvent_tagrenade_detonate <- function(event) {
    // if(event.userid==AirStrikeZMLeader_OWNER_userid)
    // {
    local AirStrikeOrigin = Vector(event.x, event.y, event.z);
    local spawner = Entities.CreateByClassname("env_entity_maker");
    spawner.__KeyValueFromString("EntityTemplate", "item_AirStrikeSummoner_summon");
    spawner.SpawnEntityAtLocation(AirStrikeOrigin, Vector(0, 0, 0));
    // }
}


//////////////////////////
//////item_ZMLeader///////
//////////////////////////
ZMLeader_OWNER <- null;
ZMLeader_TOGGLE <- true;
ZOMBIE <- [];
function PickUpZMLeader() {
    ZMLeader_OWNER = activator;
    ScriptPrintMessageChatAll("**ZM首领已选出**");
}

function UseZMLeader() {//废案，老子不会写登记系统，真他吗废物啊我。不过我开发了复仇系统，应该能弥补一二 。
    //if (activator == ZMLeader_OWNER && ZMLeader_OWNER.IsValid() && ZMLeader_OWNER != null) {
        // ScriptPrintMessageChatAll("**召唤！**");
        // local NowZMLeaderOrigin = ZMLeader_OWNER.GetOrigin();
        // NowZMLeaderOrigin.z = NowZMLeaderOrigin.z + 80;
        // for (local ent; ent = Entities.FindByClassnameNearest("info_player_terrorist", ZMLeader_OWNER.GetOrigin(), 1024); ) {
        //     ent.SetOrigin(NowZMLeaderOrigin);
        // }
    //}
    if(activator == ZMLeader_OWNER && ZMLeader_OWNER.IsValid() && ZMLeader_OWNER != null)
    {
        ScriptPrintMessageChatAll("**召唤**");
        try
        {
            if(ZMLeader_OWNER.GetHealth() > 0 && ZMLeader_OWNER.GetTeam() == 2 && ZMLeader_TOGGLE)
            {
                ZMLeader_TOGGLE = false;
                FindPlayer();
                EntFireByHandle(self, "RunScriptCode", "ZMLeader_TOGGLE=true", 5.00, ZMLeader_OWNER, ZMLeader_OWNER);
                ScriptPrintMessageChatAll("**成功了吗？**");
            }
        }
        catch(error)
        {
            ScriptPrintMessageChatAll("**失败**");
            return;
        }
    }
}

function FindPlayer()
{
	local sbzm = null;
    while(null != (sbzm = Entities.FindByClassname(sbzm, "player")))
	{
		if(sbzm.GetTeam() == 2 && sbzm.GetHealth() > 0 && sbzm.IsValid())
		{
			ZOMBIE.push(sbzm);
		}
	}
    if(ZOMBIE.len() > 0)
    {
        local leader = ZMLeader_OWNER.GetOrigin();
        local SelectZm = ZOMBIE[RandomInt(0,ZOMBIE.len()-1)];
        EntFireByHandle(SelectZm,"AddOutput","origin "+leader.x+" "+leader.y+" "+leader.z,0.00,null,null);
        ZOMBIE.clear();
        return;
    }
}