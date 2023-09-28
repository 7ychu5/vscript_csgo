SCRIPT_OWNER <- "7ychu5";
SCRIPT_TIME <- "2023年8月3日19:56:10";
SCRIPT_MAP <- "ze_obj_rampage";
SCRIPT_VERISON <- "0.2";
/*
PATCH NOTE:
v0.2（2023年8月22日09:20:58）
    删除全部过场动画，换成简短的单镜头，并采用IO控制

*/

IncludeScript("7ychu5/utils.nut");


//////////user_variable///////////


// helikopter_prop_origin <- [
//     Vector(-5497, 1666, -13627),
//     Vector(-1049, 3102, -13907),
// ]

// helikopter_path_track_origin <- [
//     Vector(-4505, -2942, -13986),
//     Vector(-4352, 1216, -14152),
// ]

// viewcontrol_origin <- [
//     Vector(-5497, 1666, -12527),
//     Vector(-5049, 2961, -14506),
//     Vector(-1794, 2998, -13853),
// ]

// viewcontrol_angles <- [
//     90, 270, 0,
//     11, -217, 0,
//     25, 225, 0,
// ]

// speed <- 7.500;                           //发射初速度
// speed_acceleration <- 0.00;              //发射加速度
// speed_max <- 7.500;                      //最大速度

//////////sys_variable////////////

// point_viewcontrol_multiplayer <- null;
// prop_helikopter <- null;

// move_toggle <- false;

viewcontrol_status <- 0;

end_only_once_toggle <- true;

//////////////////////////////////
//2023年8月4日16:20:42 tracktrain死妈了

// function spawn_prop_and_connect() {
//     prop_helikopter <- Entities.FindByName(null, "prop_helikopter_intro");
//     prop_helikopter.__KeyValueFromString("targetname", "helikopter_prop");
//     prop_helikopter.__KeyValueFromString("solid", "0");
//     EntFireByHandle(prop_helikopter, "SetAnimation", "idle", 0.01, null, null);

//     EntFire("ambient_helikopter", "SetParent", "helikopter_prop", 0.0, null);
//     EntFire("ambient_helikopter", "SetParentAttachment", "gun", 0.0, null);
//     EntFire("ambient_helikopter", "PlaySound", "", 0.1, null);

//     speedmod.__KeyValueFromInt("spawnflags", 3);
//     for (local ent; ent = Entities.FindByClassname(ent, "player"); )
//     {
//         EntFireByHandle(speedmod, "ModifySpeed", "0.99", 0.0, ent, ent);
//         SendToConsole("r_screenoverlay 7ychu5/drama/cinematic_overlay");
//     }

//     viewcontrol_start_1();

//     move_toggle <- true;
//     path_end_origin <- helikopter_path_track_origin[0];
//     prop_helikopter_move();

//     //prop_skydome <- CreateProp("prop_dynamic", Vector(-7744, -2304, -13814), prop_skydome_model, 0);
//     //prop_skydome.__KeyValueFromString("rendercolor", "255 0 0");
// }

// function prop_helikopter_move() {
//     if(!move_toggle) return;
//     local t1 = prop_helikopter.GetOrigin();
//     local t2 = path_end_origin;
//     local dir = Vector(t2.x - t1.x, t2.y - t1.y, t2.z - t1.z);
//     local length = dir.Norm();
//     prop_helikopter.SetForwardVector(Vector(dir.x * length, dir.y * length, dir.z * length));
//     local newpos = prop_helikopter.GetOrigin() + (prop_helikopter.GetForwardVector()*speed);
//     prop_helikopter.SetOrigin(newpos);
//     if(speed < speed_max)
//         speed += speed_acceleration;

//     if(GetDistance(t1, t2) <= 50)
//     {
//         move_toggle <- false;
//         viewcontrol_status++;
//         viewcontrol_stop();
//         return;
//     }
//     EntFireByHandle(self, "RunScriptCode", " prop_helikopter_move() ", 0.01, null, null);
// }

// function viewcontrol_start_1() {
//     point_viewcontrol_multiplayer <- Entities.CreateByClassname("point_viewcontrol_multiplayer");
//     point_viewcontrol_multiplayer.SetOrigin(viewcontrol_origin[0])
//     point_viewcontrol_multiplayer.SetAngles(viewcontrol_angles[0], viewcontrol_angles[1], viewcontrol_angles[2])
//     point_viewcontrol_multiplayer.__KeyValueFromString("spawnflags", "2");
//     point_viewcontrol_multiplayer.__KeyValueFromString("targetname", "point_viewcontrol_multiplayer");
//     point_viewcontrol_multiplayer.__KeyValueFromString("fov", "100");
//     EntFireByHandle(point_viewcontrol_multiplayer, "SetParent", "helikopter_prop", 0.01, null, null);


//     // EntFireByHandle(point_viewcontrol_multiplayer, "Enable", "", 0.1, null, null);
//     EntFireByHandle(point_viewcontrol_multiplayer, "Enable", "", 0.0, null, null);
// }

// function viewcontrol_start_2() {

//     point_viewcontrol_multiplayer.SetOrigin(viewcontrol_origin[1])
//     point_viewcontrol_multiplayer.SetAngles(viewcontrol_angles[3], viewcontrol_angles[4], viewcontrol_angles[5]);

//     EntFireByHandle(self, "RunScriptcode", "viewcontrol_status++;", 5.0, null, null);
//     EntFireByHandle(self, "RunScriptcode", "viewcontrol_stop()", 5.0, null, null);
// }

// function viewcontrol_start_3() {
//     prop_helikopter.SetOrigin(helikopter_prop_origin[1]);
//     point_viewcontrol_multiplayer.SetOrigin(viewcontrol_origin[2])
//     point_viewcontrol_multiplayer.SetAngles(viewcontrol_angles[6], viewcontrol_angles[7], viewcontrol_angles[8]);

//     move_toggle <- true;
//     path_end_origin <- helikopter_path_track_origin[1];
//     prop_helikopter_move();

//     viewcontrol_status++;
//     EntFireByHandle(self, "RunScriptcode", "viewcontrol_stop()", 12.0, null, null);
// }

function viewcontrol_stop() {
    switch (viewcontrol_status) {
        // case 1:
        //     EntFireByHandle(point_viewcontrol_multiplayer, "ClearParent", "", 0.00, null, null);
        //     viewcontrol_start_2();
        //     break;
        // case 2:
        //     viewcontrol_start_3();
        //     break;
        default:
            if(!end_only_once_toggle) return;
            end_only_once_toggle <- false;
            //maker.__KeyValueFromString("EntityTemplate", "template_helikopter");
            //maker.SpawnEntityAtLocation(Vector(8615, -5565, 7400), Vector(0,0,0));
            EntFireByHandle(pvm, "Disable", "", 0.0, null, null);
            EntFireByHandle(pvm, "kill", "", 0.1, null, null);

            EntFire("template_helikopter", "forcespawn","",0.0,null);

            EntFire("helicopter_particle_broken", "SetParent", "helicopter_prop", 0.0, null);
            EntFire("helicopter_particle_broken", "SetParentAttachment", "Damage0", 0.0, null);

            EntFire("helicopter_prop", "RunScriptcode", "UseSkill()", RandomFloat(0.0, 10.0), null);

            // for (local ent; ent = Entities.FindByClassname(ent, "player"); )
            // {
            //     EntFireByHandle(speedmod, "ModifySpeed", "1.00", 0.0, ent, ent);
            //     SendToConsole("r_screenoverlay /");
            // }
            // EntFireByHandle(point_viewcontrol_multiplayer, "Disable", "", 0.0, null, null);
            //EntFireByHandle(point_viewcontrol_multiplayer, "kill", "", 0.02, null, null);
            EntFire("helicopter_animation", "kill", "", 0.1, null);

            //EntFire("boss_animation", "kill", "", 0.02, null, null);
            //EntFire("camera_tracktrain*", "kill", "", 0.1, null, null);

            //EntFire("logic_script", "RunScriptcode", "play_music(2)", 0.0, null);
            break;
    }
}
pvm <- null;

function intro_start_v2() {
    EntFire("template_boss_intro", "ForceSpawn", "", 0.0, null);
    pvm <- Entities.CreateByClassname("point_viewcontrol_multiplayer");
    pvm.SetOrigin(Vector(-8298, -8369, 5487));
    pvm.SetAngles(7.5, 205.5, 0);
    pvm.__KeyValueFromString("targetname", "boss_pvm");
    pvm.__KeyValueFromInt("pov", 100);
    EntFireByHandle(pvm, "Enable", "", 0.1, null, null);
    EntFireByHandle(pvm, "SetParent", "camera_tracktrain", 0.12, null, null);
    EntFire("boss_camera", "StartForward", "", 0.15, null);
    EntFire("boss_animation", "StartForward", "", 0.15, null);
    EntFire("camera_tracktrain", "StartForward", "", 0.15, null);
}