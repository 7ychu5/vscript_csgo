hm_laser_who <- null;
function hm_laser_Owner()
{
    hm_laser_who = activator;
    ScriptPrintMessageChatAll("英雄拔出了反抗的刀！");
}
mainlaser <- null;
mainlaser_hurt <- null;
function hm_laser()
{
    if(activator == hm_laser_who && hm_laser_who.IsValid() && hm_laser_who != null )
    {
        local hm_Ownerorigin = hm_laser_who.GetOrigin();
        local findlaser = Entities.FindByClassnameNearest("func_movelinear",hm_Ownerorigin, 4000 );
        local findlaser1 = Entities.FindByNameNearest("laser1",hm_Ownerorigin, 4000 );
        local findlaser2 = Entities.FindByNameNearest("laser2",hm_Ownerorigin, 4000 );
        local findlaser3 = Entities.FindByNameNearest("laser3",hm_Ownerorigin, 4000 );
        local findlaser4 = Entities.FindByNameNearest("laser4",hm_Ownerorigin, 4000 );
        local findlaser5 = Entities.FindByNameNearest("laser5",hm_Ownerorigin, 4000 );
        if(findlaser == findlaser1 && findlaser_hurt == findlaser_hurt1)
        {
            mainlaser = findlaser1;
        }
        else if(findlaser == findlaser2 && findlaser_hurt == findlaser_hurt2)
        {
            mainlaser = findlaser2;
        }
        else if(findlaser == findlaser3 && findlaser_hurt == findlaser_hurt3)
        {
            mainlaser = findlaser3;
        }
        else if(findlaser == findlaser4 && findlaser_hurt == findlaser_hurt4)
        {
            mainlaser = findlaser4;
        }
        else if(findlaser == findlaser5 && findlaser_hurt == findlaser_hurt5)
        {
            mainlaser = findlaser5;
        }
    if( mainlaser != null)
    {
        local mainlaserOrigin = mainlaser.GetOrigin();
        local laser_move = sqrt(pow(hm_Ownerorigin.x-mainlaserOrigin.x,2)+pow(hm_Ownerorigin.y-mainlaserOrigin.y,2)+pow(hm_Ownerorigin.z-mainlaserOrigin.z,2));
        local laser_move_time = laser_move/1000;
        //void EntFire(string target, string action, string value = "", float delay = 0.0, handle activator = null)
        EntFire("hm_laser_maker","ForceSpawn"," ",0.0,null);
        EntFire("hm_laser","open"," ",0.0,null);
        EntFire("hm_laser","kill"," ",laser_move_time,null);
        local killer = Entities.FindByName(null,"laser_killer");
        EntFire("laser_killer","trigger"," ",laser_move_time,null);
    
    }
    }
}