pvm <- null;
function Start() {
    pvm <- Entities.CreateByClassname("point_viewcontrol_multiplayer");
    pvm.SetOrigin(Vector(0, 0, 40));
    pvm.SetAngles(7.5, 205.5, 0);
    pvm.__KeyValueFromString("targetname", "boss_pvm");
    pvm.__KeyValueFromInt("pov", 100);
    EntFireByHandle(pvm, "Enable", "", 0.1, null, null);
}
//主要的问题是重置回合后会有中断
//那我在出生点加一个生成的trigger
//看看能不能冲掉
function pvm_clear() {
    local start_pvm = Entities.CreateByClassname("point_viewcontrol_multiplayer");
    start_pvm.SetOrigin(Vector(0, 0, 40));
    start_pvm.SetAngles(90, 205.5, 0);
    start_pvm.__KeyValueFromString("targetname", "start_pvm");
    start_pvm.__KeyValueFromInt("pov", 100);
    EntFireByHandle(start_pvm, "Enable", "", 0.1, null, null);
    EntFireByHandle(start_pvm, "Disable", "", 0.12, null, null);
    EntFireByHandle(start_pvm, "kill", "", 0.13, null, null);
}