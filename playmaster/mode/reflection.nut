//func_button接取
//2023年7月21日09点48分，今天表演一个function就干完一个一个一个reflection humanbenchmark，开造！

/*
ToDo：DONE!
*/
times <- 10;
present_times <- 1;
reflection_time_min <- 1.0;
reflection_time_max <- 3.0;

reflection_start_time <- 0.0;
reflection_end_time <- 0.0;
reflection_avg_time <- 0.0;
reflection_sum_time <- 0.0;
reflection_timer <- null;
state <- 0;

function reflection_mode_on() {
    if(present_times > times)
    {
        reflection_start_time <- 0.0;
        reflection_end_time <- 0.0;
        reflection_sum_time <- 0.0;
        state <- 0;
        present_times <- 1;
        EntFire("brush_reflection_background", "Color", "0 0 0", 0.0, null);
        EntFire("worldtext_reflection_hint", "AddOutput", "message SHOOT to START", 0.0, null);
        local times_message = present_times+"/"+times;
        EntFire("worldtext_reflection_times", "AddOutput", "message "+times_message, 0.0, null);
        return;
    }
    switch (state) {
        case 0://等待状态
            state <- 1;
            EntFire("brush_reflection_background", "Color", "0 0 0", 0.0, null);
            EntFire("worldtext_reflection_hint", "AddOutput", "message SHOOT to START", 0.0, null);
            local times_message = present_times+"/"+times;
            EntFire("worldtext_reflection_times", "AddOutput", "message "+times_message, 0.0, null);
            reflection_mode_on();
            break;
        case 1://开始计时器
            state <- 3;
            EntFire("brush_reflection_background", "Color", "255 0 0", 0.0, null);
            EntFire("worldtext_reflection_hint", "AddOutput", "message Wait for GREEN", 0.0, null);
            reflection_timer <- Entities.CreateByClassname( "logic_timer" );
            reflection_timer.__KeyValueFromFloat( "refiretime", 0 );
            reflection_timer.__KeyValueFromInt( "UseRandomTime", 1 );
            reflection_timer.__KeyValueFromFloat( "LowerRandomBound", reflection_time_min );
            reflection_timer.__KeyValueFromFloat( "UpperRandomBound", reflection_time_max );
            reflection_timer.__KeyValueFromInt( "spawnflags", 0 );
            VS.AddOutput( reflection_timer, "OnTimer", function() {
                state <- 2;
                EntFire("brush_reflection_background", "Color", "0 255 0", 0.0, null);//红板消失绿板显示
                reflection_start_time <- Time();
                EntFire("worldtext_reflection_hint", "AddOutput", "message SHOOT NOW!", 0.0, null);
            }, this );
            EntFireByHandle( reflection_timer, "Enable" );
            break;
        case 2://正确触发
            state <- 1;
            reflection_end_time <- Time();
            local reflection_time = (format("%d", (reflection_end_time - reflection_start_time)*1000)).tostring()+" ms";
            reflection_sum_time += reflection_end_time - reflection_start_time;
            local reflection_avg_time = reflection_sum_time/present_times;
            present_times++;                                                            //进行次数
            local dis_time = (format("%d", reflection_avg_time*1000)).tostring()+" ms"; //每一次计算
            local times_message = present_times+"/"+times;                              //进行次数/总次数
            EntFire("brush_reflection_background", "Color", "0 128 255", 0.0, null);
            EntFire("worldtext_reflection_times", "AddOutput", "message "+times_message, 0.0, null);
            EntFire("worldtext_reflection_time", "AddOutput", "message "+reflection_time, 0.0, null);
            EntFire("worldtext_reflection_time_avg", "AddOutput", "message Total: "+dis_time, 0.0, null);
            reflection_timer.Destroy();
            //reflection_mode_on();//这个衔接上下，加回来的话变回呃呃
            break;
        case 3://错误触发
            state <- 1;
            EntFire("brush_reflection_background", "Color", "0 0 0", 0.0, null);
            EntFire("worldtext_reflection_hint", "AddOutput", "message Too SOON!NOT GREEN!", 0.0, null);
            reflection_timer.Destroy();
            //reflection_mode_on();
            break;
        default:
            printl("寄");
            break;
    }
}
