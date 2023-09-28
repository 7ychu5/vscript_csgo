SCRIPT_OWNER <- "7ychu5";
SCRIPT_TIME <- "2023年8月11日16:03:58";
SCRIPT_MAP <- "UNKNOWN";
SCRIPT_VERISON <- "0.1";

//////////user_variable///////////

player <- null

//////////sys_variable////////////

score <- 0;
best_score <- 0;
physbox <- null;
thurster <- null;

//////////////////////////////////

function confirm(id) {
    switch (id) {
        case 0:
            physbox <- caller;
            break;
        case 1:
            thurster <- caller;
            break;
        default:
            break;
    }
}

function start() {
    player = activator;
    self.ConnectOutput("PlayerOn","PlayerOn");
    self.ConnectOutput("PlayerOff","PlayerOff");
    self.ConnectOutput("PressedAttack","PressedAttack");
    EntFireByHandle(self, "activate", "", 0.0, player, caller);
}

function PlayerOn() {
    ScriptPrintMessageChatAll("PlayerOn");
}

function PlayerOff() {
    ScriptPrintMessageChatAll("PlayerOff");
}

function PressedAttack() {
    // local speed = physbox.GetVelocity();
    // printl(speed);
    // speed += Vector(0, 0, 400);
    // physbox.SetVelocity(speed);
    EntFireByHandle(thurster, "Activate", "", 0.0, null, null);
    EntFireByHandle(thurster, "Deactivate", "", 0.1, null, null);
    //physbox.SetVelocity(speed);
}