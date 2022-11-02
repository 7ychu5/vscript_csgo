////////////////////////////////
////item_zm_thunder_summoner////
////////////////////////////////
thunder_summoner_OWNER <- null;

function PickUp_thunder_summoner() {
    thunder_summoner_OWNER = activator;
    ScriptPrintMessageChatAll("**thunder_summoner登场**");
    EntFire("item_zm_thunder_summoner_model", "setanimation", "walk", 0.0, null);
}

function Use_thunder_summoner() {
    if(activator == thunder_summoner_OWNER && thunder_summoner_OWNER.IsValid() && thunder_summoner_OWNER != null)
    {
        local victim = Entities.FindByClassnameNearest("player", thunder_summoner_OWNER.GetOrigin(), 1000);//player
        if(victim.IsValid() && victim.GetTeam() == 3)
        {
            printl(victim.GetOrigin());
        }
        else printl("NO victim!!!");
    }
}

////////////////////////////////
///////item_zm_push_freak///////
////////////////////////////////
push_freak_OWNER <- null;
DISTANCE <- 768;
FORCE_MOD <- 1.00;
UP_SPEED <- 400;

function PickUp_push_freak() {
    push_freak_OWNER = activator;
    ScriptPrintMessageChatAll("**push_freak登场**");
    EntFire("item_zm_push_freak_model", "setanimation", "walk", 0.0, null);
}

function Use_push_freak() {
    if(activator == push_freak_OWNER && push_freak_OWNER.IsValid() && push_freak_OWNER != null)
    {
        local humans = [];
	    local spos = push_freak_OWNER.GetOrigin();
	    local hlist = [];
	    local h = null;
	    while(null!=(h=Entities.FindInSphere(h,push_freak_OWNER.GetOrigin(),DISTANCE)))
	    {
		    if(h.GetClassname() == "player" && h.GetHealth()>0)
		    {
			    if(InSight(spos,GVO(h.GetOrigin(),0,0,48))) humans.push(h);
		    }
	    }
	    foreach(target in humans)
	    {
		    local spos = push_freak_OWNER.GetOrigin();
		    local tpos = target.GetOrigin();
		    local vec = spos-tpos;
		    local dist = GetDistance(spos,GVO(target.GetOrigin(),0,0,48));
		    vec.Norm();
		    EntFireByHandle(target,"AddOutput","basevelocity "+
		    (vec.x*(((dist)-DISTANCE)*FORCE_MOD)).tostring()+" "+
		    (vec.y*(((dist)-DISTANCE)*FORCE_MOD)).tostring()+" "+
		    (UP_SPEED).tostring(),0.00,null,null);
	    }
    }
}
function GVO(vec,_x,_y,_z){return Vector(vec.x+_x,vec.y+_y,vec.z+_z);}
function InSight(start,target){if(TraceLine(start,target,self)<1.00)return false;return true;}
function GetDistance(v1,v2){return sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y)+(v1.z-v2.z)*(v1.z-v2.z));}
function GetDistanceZ(v1,v2){return sqrt((v1.z-v2.z)*(v1.z-v2.z));}

////////////////////////////////
///////item_zm_noise_maker//////
////////////////////////////////
noise_maker_OWNER <- null;

function PickUp_noise_maker() {
    noise_maker_OWNER = activator;
    ScriptPrintMessageChatAll("**noise_maker登场**");
    EntFire("item_zm_noise_maker_model", "setanimation", "walk", 0.0, null);
}

function Use_noise_maker() {
    if(activator == noise_maker_OWNER && noise_maker_OWNER.IsValid() && noise_maker_OWNER != null)
    {
        EntFire("item_zm_noise_maker_music", "PlaySound", " ", 0.0,null);
		EntFire("item_zm_noise_maker_particle", "Start", " ", 0.0,null);
		EntFire("item_zm_noise_maker_particle", "Stop", " ", 5.0,null);
    }
}

////////////////////////////////
///////item_zm_inflatable///////
////////////////////////////////
inflatable_OWNER <- null;

function PickUp_inflatable() {
    inflatable_OWNER = activator;
    ScriptPrintMessageChatAll("**inflatable登场**");
    EntFire("item_zm_inflatable_model", "setanimation", "walk", 0.0, null);
}

function Use_inflatable() {
    if(activator == inflatable_OWNER && inflatable_OWNER.IsValid() && inflatable_OWNER != null)
    {
        local n,m=5;
        for(n=1;n<=5;n+=0.01)
        {
            EntFireByHandle(inflatable_OWNER, "AddOutput", "modelscale "+n, n, null, null)
            EntFireByHandle(inflatable_OWNER, "AddOutput", "modelscale "+m, 10+n, null, null)
            m-=0.01;
        }
    }
}


/*我做不到，终究是梦幻泡影
////////////////////////////////
///////TimeTraveller_show///////
////////////////////////////////
TimeTraveller <- null;

function Enter_show() {
    TimeTraveller = activator;
    printl("Get in");
    local TimeTraveller_show_relay = Entities.CreateByClassname("logic_relay");
    TimeTraveller_show_relay.__KeyValueFromString("targetname", "TimeTraveller_show_relay");
    TimeTraveller_show_relay.__KeyValueFromString("vscripts", "7ychu5/ze_opt_ktp/items.nut");
    TimeTraveller_show_relay.__KeyValueFromInt("spawnflags", 2);
    local TimeTraveller_show_mm = Entities.CreateByClassname("logic_measure_movement");
    TimeTraveller_show_mm.__KeyValueFromString("targetname","TimeTraveller_show_mm");
    TimeTraveller_show_mm.__KeyValueFromString("Target","TimeTraveller_show_target");
    TimeTraveller_show_mm.__KeyValueFromString("TargetReference","TimeTraveller_show_tr");
    TimeTraveller_show_mm.__KeyValueFromString("MeasureTarget","TimeTraveller");//???
    TimeTraveller_show_mm.__KeyValueFromString("MeasureReference","TimeTraveller_show_mr");
    //EntFire("item_zm_noise_maker_music", "PlaySound", " ", 0.0,null);
    EntFire("TimeTraveller_show_mm", "Enable", " ", 0,null);
    //EntFire(string target, string action, string value = "", float delay = 0.0, handle activator = null)
    printl("0");
}
function Leave_show() {
    printl("Get out");
    EntFire("TimeTraveller_show_mr", "kill", " ", 0,null);
}
function TimeTraveller_show() {
    printl("1");
    EntFire("TimeTraveller_show_mm", "Enable", " ", 0,null);
    EntFire("TimeTraveller_show_mr", "RunScriptCode", "TimeTraveller_show()", 0.1, null);
}
*/