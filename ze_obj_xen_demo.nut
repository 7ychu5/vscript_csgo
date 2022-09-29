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
        local NowTravelOrigin = TimeTraveller_OWNER.GetOrigin()
        if(TravelToggle)
        {
            NowTravelOrigin.z = NowTravelOrigin.z-3686;
            TravelToggle = false;
        }
        else
        {
            NowTravelOrigin.z = NowTravelOrigin.z+3856;
            TravelToggle = true;
        }
        TimeTraveller_OWNER.SetOrigin(NowTravelOrigin);
    }
}
