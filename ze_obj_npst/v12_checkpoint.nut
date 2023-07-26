SCRIPT_OWNER <- "7ychu5";
SCRIPT_TIME <- "2023年7月21日15点41分";
SCRIPT_MAP <- "ze_obj_npst_v1_2";
SCRIPT_VERISON <- "0.1";

//在起点出门拉一个trigger和一个func_dustmotes作为传送标记
//trigger checkpoint_teleport_trigger
//dustmotes checkpoint_teleport_dustmotes

//-743 8550 -1800
//1766 4103 -450
//3470 -2590 -695

//在经历了以上三个记录点的激活下一步trigger附近增添传送output

checkpoint_status <- 0;//检查点状态0 1 2 3
first_toggle <- true;

function checkpoint_status_update(status) {
    switch (status) {
        case 1:
            checkpoint_status <- 1;
            ScriptPrintMessageCenterAll("<font color='#55efc4'>存档点</font><font color='#ff1010'>“员工食堂”</font><font color='#55efc4'>已达成！</font>");
            SendToConsoleServer("zr_infect_mzombie_ratio 6");
            break;
        case 2:
            checkpoint_status <- 2;
            ScriptPrintMessageCenterAll("<font color='#55efc4'>存档点</font><font color='#74b9ff'>“空中访客”</font><font color='#55efc4'>已达成！</font>");
            SendToConsoleServer("zr_infect_mzombie_ratio 5");
            break;
        case 3:
            checkpoint_status <- 3;
            ScriptPrintMessageCenterAll("<font color='#55efc4'>存档点</font><font color='#e67e22'>“撤离起点”</font><font color='#55efc4'>已达成！</font>");
            SendToConsoleServer("zr_infect_mzombie_ratio 2.5");
            break;
        default:
            break;
    }
}

function checkpoint_teleport_activate() {
    switch (checkpoint_status) {
        case 0://什么也不会发生，一切正常
            if(first_toggle)
            {
                ScriptPrintMessageCenterAll("<font color='#55efc4'>存档点系统</font><font color='#ff1010'>已启动！</font><font color='#ffa502'>GLHF！</font>");
                first_toggle <- false;
            }
            break;
        case 1://餐厅传送，启动！
            if(activator.GetTeam() == 3)
            {
                activator.SetVelocity(Vector(0, 0, 0));
                activator.SetOrigin(Vector(-320, 10626, -1763));
                activator.SetAngles(0, -90, 0);
            }
            if(first_toggle)
            {
                first_toggle <- false;
                EntFire("office_template_06", "ForceSpawn", "", 0.0, null);
                EntFire("checkpoint_teleport_dustmotes", "Enable", "", 0.0, null);
            }
            break;
        case 2://停机坪ZM，启动！
            if(activator.GetTeam() == 3)
            {
                activator.SetVelocity(Vector(0, 0, 0));
                activator.SetOrigin(Vector(1754, 3960, -477));
                activator.SetAngles(0, 90, 0);
            }
            if(first_toggle)
            {
                first_toggle <- false;
                EntFire("checkpoint_teleport_dustmotes", "Enable", "", 0.0, null);
            }
            break;
        case 3://二次黄门，启动！
            if(activator.GetTeam() == 3)
            {
                activator.SetVelocity(Vector(0, 0, 0));
                activator.SetOrigin(Vector(3498, -2362, -722));
                activator.SetAngles(0, -90, 0);
            }

            if(first_toggle)
            {
                first_toggle <- false;
                EntFire("trigger_lua_18", "Enable", "", 0.0, null);
                EntFire("blyatgavnomocha", "ForceSpawn", "", 0.0, null);
                EntFire("sukablyat", "ForceSpawn", "", 0.0, null);
                EntFire("sukablyatgavno", "ForceSpawn", "", 0.0, null);
                EntFire("hyesos", "ForceSpawn", "", 0.0, null);
                EntFire("checkpoint_teleport_dustmotes", "Enable", "", 0.0, null);
            }
            break;
        default:break;
    }
}