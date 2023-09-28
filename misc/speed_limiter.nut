SCRIPT_OWNER <- "7ychu5";
SCRIPT_TIME <- "2023年8月9日16:43:55";
SCRIPT_MAP <- "GLOBAL";
SCRIPT_VERISON <- "0.1";

//////////user_variable///////////

SPEED_LIMIT <- 600;                         //最高限速，无论在空中还是地下
TICKRATE <- 0.02                            //频率(0.01~)，频率越大，越容易逼近限速值
ACCURACY <- 0.1                             //精度(0.000~1.000)，这个值越小，运算压力越大，这个值越大，超过阈值的人越容易被杀回零速

//////////sys_variable////////////

check_speed_toggle <- false;

//////////////////////////////////

function start_check_speed() {check_speed_toggle <- true;check_speed();}
function stop_check_speed() {check_speed_toggle <- false;}
function check_speed() {
    if(check_speed_toggle == false) return;
    else EntFireByHandle(self, "RunScriptcode", "check_speed()", TICKRATE, null, null);
    for(local h;h = Entities.FindByClassname(h, "player");)
    {
        if(h==null||!h.IsValid()||h.GetHealth()<=0) continue;
        local speed = h.GetVelocity();
        local x = speed.x;local y = speed.y;local z = speed.z;
        speed = sqrt(x*x + y*y + z*z);

        if(speed >= SPEED_LIMIT)
        {
            while (sqrt(x*x + y*y + z*z) > 400) {
                x -= x*ACCURACY;
                y -= y*ACCURACY;
                z -= z*ACCURACY;
            }
            h.SetVelocity(Vector(x, y, z));
        }
    }
}