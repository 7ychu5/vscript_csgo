SCRIPT_OWNER <- "7ychu5";
SCRIPT_TIME <- "2023年8月14日15:36:05";
SCRIPT_MAP <- "ze_obj_dayzero";
SCRIPT_VERISON <- "0.1";

//////////user_variable///////////

TARGET_DISTANCE <- 256;             //索敌范围
explosion_damage <- 500;            //爆炸伤害
explosion_range <- 384              //爆炸范围

//////////sys_variable////////////

mine_user <- null;
canbepickup <- true;
Think_status <- false;
team_status <- 3;
prop <- null;
thurster_up <- null;
thurster_side <- null;
button <- null;

//////////////////////////////////
function spawn(team) {
    switch (team) {
        case 2:
            team_status = 2;
            EntFireByHandle(prop, "color", "255 0 0", 0.0, null, null);
            Think_status = true;
            canbepickup = false;
            break;
        case 3:
            team_status = 3;
            EntFireByHandle(prop, "color", "0 255 0", 0.0, null, null)
            break;
        default:
            break;
    }
}
function pickup() {
    if(canbepickup)
    {
        printl(activator.GetName())
        mine_user = activator;
        canbepickup = false;
        if(activator.GetName() != "") return;
        local name = "mine_user_" + RandomInt(1000, 9999).tostring();
        while(Entities.FindByName(null, name) != null){
            name = "mine_user_" + RandomInt(1000, 9999).tostring();
        }
        EntFireByHandle(activator, "AddOutput", "targetname "+name, 0.0, null, null);
        EntFireByHandle(self, "SetParent", name, 0.02, null, null);
    }
    else
    {
        if(activator != mine_user) return;
        EntFireByHandle(activator, "AddOutput", "targetname ", 0.0, null, null);
        EntFireByHandle(self, "ClearParent", "", 0.0, null, null);
        EntFireByHandle(caller, "kill", "", 0.0, null, null);
        Think_status <- true;
    }
}

function Think() {
    if(!Think_status) return;
    local h;
    if(null!=(h=Entities.FindInSphere(h,self.GetOrigin(),TARGET_DISTANCE)))
	{
        switch (team_status) {
            case 2:
                if(h.GetClassname()=="player" && h.GetTeam() == 3 && h.GetHealth() > 0 && h.IsValid() && h != null)
                {
                    trap_on();
                }
                break;
            case 3:
                if(h.GetClassname()=="player" && h.GetTeam() == 2 && h.GetHealth() > 0 && h.IsValid() && h != null)
                {
                    trap_on();
                }
                break;
            default:
                break;
        }
	}
}

function confirm_who_am_i(id) {
    switch (id) {
        case 0:
            prop = caller;
            break;
        case 1:
            thurster_up = caller;
            break;
        case 2:
            thurster_side = caller;
            break;
        case 3:
            button = caller;
            break;
        default:
            break;
    }
}

function trap_on() {
    Think_status = false;
    EntFireByHandle(thurster_up, "activate", "", 0.0, null, null);
    EntFireByHandle(thurster_side, "activate", "", 0.0, null, null);
    EntFireByHandle(self, "RunScriptcode", "boom();", 1.0, null, null);
}

function boom() {
    local explosion = Entities.CreateByClassname("env_explosion");
    explosion.SetOrigin(self.GetOrigin());
    explosion.__KeyValueFromInt("iMagnitude", explosion_damage);
    explosion.__KeyValueFromInt("iRadiusOverride", explosion_range);
    EntFireByHandle(explosion, "Explode", "", 0.01, null, null);
    EntFireByHandle(self, "RunScriptcode", "clear_all_shit();", 0.02, null, null);
}

function clear_all_shit() {
    prop.Destroy();
    button.Destroy();
    thurster_up.Destroy();
    thurster_side.Destroy();
    self.Destroy();
}