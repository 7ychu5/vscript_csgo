//thx for luffaren answer my doubts with search victim
SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "ze_obj_insane_v1";
SCRIPT_TIME <- "2022年8月16日00:08:36";
/*
    //////////////////////////////
    BOSS战形式为追击战，僵尸与BOSS齐头并进。
    BOSS技能有：         破坏障碍物：发射导弹、制造火浪刀......；
            若障碍物提前被人类所破坏：脚踏无差别推力、能量护盾......
    全程80秒左右，boss死亡后终点门才会被激活；若是boss到达终点后触发人类核爆。
    由path_track控制BOSS行进路径、调整BOSS速率。
    预先在路径上制作十数个障碍物，障碍物prop_dynamic，内容待定。
    每次地图生成时随机载入3、4个障碍物。
    随机采用预设的BOSS动作动画，对障碍物进行破坏 ？ 人类打碎障碍物继续奔逃 ？
    //////////////////////////////
*/
//TODO:制作BOSS技能，配合spawner生成一定距离上的动画。

barrier_low_HP <- 5000//泰坦提前死亡后障碍物降到此血量

::counter <- 0;
gargantua_HP <- 256; //泰坦初始血量为128血
gargantua_HP_max <- 0;
gargantua_HP_calc <- 99999999;
gargantua_prop <- Entities.FindByName(null, "gargantua_prop");
gargantua_mover <- Entities.FindByName(null, "gargantua_mover");
gargantua_voice <- Entities.FindByName(null, "gargantua_voice");

function gargantua_HP_add(a) {
    gargantua_HP += a;
}

function gargantua_chase_ready() {//改为强制触发或强行引导触发
    EntFire("gargantua_prop", "SetAnimation", "walk_all", 0, 0);
    EntFire("gargantua_mover", "StartForward", " ", 23.0, 0);
    //EntFire("gargantua_chase_skill_relay", "Enable", " ", 0.0, null);
    //EntFire("gargantua_particles", "start", " ", 0, null);
    //local gargantua_HP_hud = Entities.CreateByClassname("env_hudhint");
    spawn_barrier();
}

function health_confirm() {//门完全关上的时候用这个function
    gargantua_HP_calc = gargantua_HP;
    printl(gargantua_HP_calc);
    gargantua_HP_max = gargantua_HP/15;
}

function HealthChanged(a) {
    if(gargantua_HP_calc > 0)
    {
        gargantua_HP_calc -= a;
        local gargantua_HP_temp = gargantua_HP_calc;

        local value = "泰坦血量：■"
        for(local j=1;j<=15;j++)
        {
            if(gargantua_HP_temp-gargantua_HP_max>=0)
            {
                gargantua_HP_temp-=gargantua_HP_max;
                value = value + "■";
            }
            else
            {
                value = value + "□";
            }
        }
        ScriptPrintMessageCenterAll(value);
    }
    else if(gargantua_HP_calc <= 0)
    {
        ScriptPrintMessageCenterAll("泰坦血量：□□□□□□□□□□□□□□□□");
        local gargantua_explosion_die = Entities.CreateByClassname("env_explosion");
        gargantua_explosion_die.SetOrigin(gargantua_prop.GetOrigin());

        EntFire("gargantua_physbox", "kill", " ", 0.0, null);
        EntFire("gargantua_mover", "stop", " ", 0, null);
        EntFire("gargantua_prop", "SetAnimation", "powerup_electrocute", 0, null);//死亡动作
        EntFire("gargantua_voice", "PlaySound", " ", 0.1, null)
        EntFire("gargantua_prop", "FadeAndKill", " ", 5, null);
        EntFire("gargantua_mover", "kill", " ", 4, null);
        //EntFire("gargantua_chase_skill_relay", "Disable", " ", 0, null);
        //EntFire("gargantua_particles", "stop", " ", 2, null);
        EntFireByHandle(gargantua_explosion_die, "Explode", " ", 4, null, null);//死亡特效
        EntFireByHandle(gargantua_explosion_die, "kill", " ", 5, null, null);
        EntFireByHandle("gargantua_HP_hud", "kill", " ", 0.0, null, null);
        if(null!=Entities.FindByName(null, "gargantua_barrier_template_break_1"))
        {
            local gargantua_barrier_template_break_1 = Entities.FindByName(null, "gargantua_barrier_template_break_1");
            gargantua_barrier_template_break_1.__KeyValueFromInt("health", barrier_low_HP);
        }
        if(null!=Entities.FindByName(null, "gargantua_barrier_template_break_2"))
        {
            local gargantua_barrier_template_break_2 = Entities.FindByName(null, "gargantua_barrier_template_break_2");
            gargantua_barrier_template_break_2.__KeyValueFromInt("health", barrier_low_HP);
        }
    }
    else
    {
        printl("WTF?");
    }
}

function gargantua_chase_skill()
{
	local target_candidates = [];
	for(local h;h=Entities.FindByClassnameWithin(h,"player",gargantua_prop.GetOrigin(),1024);)		//finds all players within 1024 units from gargantua_prop
	{
		if(h==null||!h.IsValid()||h.GetTeam()!=3||h.GetHealth()<=0) continue;						//ignores players that are invalid/not CT/dead
		target_candidates.push(h);																	//add player to target-candidate list
	}
	if(target_candidates.len()<=0) return;															//no target found, abort
	local h = target_candidates[RandomInt(0,target_candidates.len()-1)];							//picking random player from valid target-candidates

		//original code:
            local h_origin = Vector(h.GetOrigin().x, h.GetOrigin().y, h.GetOrigin().z+40);
            local spawner = Entities.CreateByClassname("env_entity_maker");
            if(RandomInt(1, 2)==1)
            {
                spawner.__KeyValueFromString("EntityTemplate", "gargantua_skill_freemissile_template");
                spawner.SpawnEntityAtNamedEntityOrigin("gargantua_mover");
                local gargantua_skill_freemissile_path_1 = Entities.FindByName(null, "gargantua_skill_freemissile_path_1*");
                local gargantua_skill_freemissile_path_2 = Entities.FindByName(null, "gargantua_skill_freemissile_path_2*");
                DebugDrawLine(gargantua_skill_freemissile_path_1.GetOrigin(), h_origin, 255, 80, 80, false, 1.5);
                EntFireByHandle(spawner, "kill", " ", 0.1, null, null);
                local gargantua_skill_freemissile_explosion = Entities.FindByName(null, "gargantua_skill_freemissile_explosion*");
                local gargantua_skill_freemissile_particles = Entities.FindByName(null, "gargantua_skill_freemissile_particles*");
                local gargantua_skill_freemissile_shake = Entities.FindByName(null, "gargantua_skill_freemissile_shake*");
                gargantua_skill_freemissile_path_2.SetOrigin(h_origin);
                gargantua_skill_freemissile_explosion.SetOrigin(h_origin);
                gargantua_skill_freemissile_shake.SetOrigin(h_origin);
                local gargantua_skill_freemissile_mover = Entities.FindByName(null, "gargantua_skill_freemissile_mover*");
                EntFireByHandle(gargantua_skill_freemissile_particles, "start", " ", 0.01, null, null);
                EntFireByHandle(gargantua_skill_freemissile_mover, "StartForward", " ", 0.01, null, null);
                EntFire("gargantua_skill_freemissile_voice", "PlaySound", " ", 0.01, null);
            }
            else
            {
                spawner.__KeyValueFromString("EntityTemplate", "gargantua_skill_freefire_template");
                spawner.SpawnEntityAtNamedEntityOrigin("gargantua_prop");
                EntFireByHandle(spawner, "kill", " ", 0.1, null, null);
                local gargantua_skill_freefire_path_2 = Entities.FindByName(null, "gargantua_skill_freefire_path_2*");
                gargantua_skill_freefire_path_2.SetOrigin(h_origin);
                local gargantua_skill_freefire_mover = Entities.FindByName(null, "gargantua_skill_freefire_mover*");
                local gargantua_skill_freefire_particles = Entities.FindByName(null, "gargantua_skill_freefire_particles*");
                EntFireByHandle(gargantua_skill_freefire_particles, "start", " ", 0.05, null, null)
                EntFireByHandle(gargantua_skill_freefire_mover, "StartForward", " ", 0.05, null, null);
            }
    EntFire("gargantua_chase_skill_relay", "FireUser1", " ", 3.0, null);
}

function spawn_barrier() {
    local spawner = Entities.CreateByClassname("env_entity_maker");
    for(local j=1; j<=2; j++)
    {
        if(RandomInt(1, 10)<10)
        {
            ::counter+=j;
            spawner.__KeyValueFromString("EntityTemplate", "gargantua_barrier_template_"+j);
            spawner.SpawnEntityAtNamedEntityOrigin("gargantua_barrier_template_"+j);
        }
    }
    EntFireByHandle(spawner, "kill", " ", 0.0, null, null);
    printl(::counter);
}
function gargantua_barrier_template_break_1(){
    if(::counter==1||::counter==3)
    {
        if(null!=Entities.FindByName(null, "gargantua_barrier_template_break_1"))
        {
            //释放随机技能
            //local gargantua_entity_maker = Entities.FindByName(null, "gargantua_entity_maker")
            if(RandomInt(1, 2)==1)
            {
                //火箭弹
                EntFire("gargantua_mover", "Stop", " ", 0.0, null);
                EntFire("gargantua_prop", "SetAnimation", "fire1", 0.1, null);

                local spawner = Entities.CreateByClassname("env_entity_maker");
                spawner.__KeyValueFromString("EntityTemplate", "gargantua_skill_missile_1_template");
                spawner.SpawnEntityAtNamedEntityOrigin("gargantua_skill_missile_1_template");
                EntFire("gargantua_skill_missile_1_template", "ForceSpawn", " ", 0.2, null);
                EntFireByHandle(spawner, "kill", " ", 0.2, null, null)
                EntFire("gargantua_skill_missile_1_particles", "start", " ", 0.2, null);
                EntFire("gargantua_skill_missile_1", "open", " ", 0.2, null);

                EntFire("gargantua_prop", "SetAnimation", "walk_all", 1.0, null);
                EntFire("gargantua_mover", "StartForward", " ", 1.0, null);
            }
            else
            {
                //火浪刀
                EntFire("gargantua_mover", "Stop", " ", 0.0, null);
                EntFire("gargantua_prop", "SetAnimation", "melee2", 0.1, null);

                local spawner = Entities.CreateByClassname("env_entity_maker");
                spawner.__KeyValueFromString("EntityTemplate", "gargantua_skill_fire_1_template");
                spawner.SpawnEntityAtNamedEntityOrigin("gargantua_skill_fire_1_template");
                EntFire("gargantua_skill_fire_1_template", "ForceSpawn", " ", 0.2, null);
                EntFireByHandle(spawner, "kill", " ", 0.2, null, null)
                for(local j=1; j<=11; j++)
                {
                    EntFire("gargantua_skill_fire_particles_1_"+j, "start", " ", 0.2, null);
                }
                EntFire("gargantua_skill_fire_1_move", "open", " ", 0.2, null);

                EntFire("gargantua_prop", "SetAnimation", "walk_all", 1, null);
                EntFire("gargantua_mover", "StartForward", " ", 1.1, null);
            }
        }
        else
        {
            //释放强化技能
            if(RandomInt(1, 1)==2)//暴走太IMBA了
            {
                //僵尸暴走
                EntFire("gargantua_mover", "Stop", " ", 0.0, null);
                EntFire("gargantua_prop", "SetAnimation", "roar2", 0.1, null);
                local player_speedmod = null;
                local h = null;
                local player_speedmod = Entities.CreateByClassname("player_speedmod");
                if(null!=(h=Entities.FindInSphere(h,gargantua_prop.GetOrigin(),800)))
	            {
		            if(h.GetClassname()=="player"&&h.GetTeam()==2&&h.GetHealth()>0)
                    {
			            EntFireByHandle(player_speedmod, "ModifySpeed", "1.2", 0.1, h, null);
                        EntFireByHandle(player_speedmod, "ModifySpeed", "1.0", 8.1, h, null);
		            }
                }
                EntFire("gargantua_prop", "SetAnimation", "walk_all", 2, null);
                EntFire("gargantua_mover", "StartForward", " ", 2.1, null);
            }
            else
            {
                //震撼视角
                EntFire("gargantua_mover", "Stop", " ", 0.0, null);
                EntFire("gargantua_prop", "SetAnimation", "roar1", 0.1, null);
                gargantua_voice.__KeyValueFromString("message", "music/insanemusic_garg1.mp3")
                EntFire("gargantua_voice", "PlaySound", " ", 0.3, null)

			    EntFire("gargantua_skill_shock_particles", "FireUser1", " ", 0.2, null);

                EntFire("gargantua_prop", "SetAnimation", "walk_all", 2, null);
                EntFire("gargantua_mover", "StartForward", " ", 2.1, null);
            }
        }
    }
}
function gargantua_barrier_template_break_2(){
    if(::counter==2||::counter==3)
    {
        if(null!=Entities.FindByName(null, "gargantua_barrier_template_break_2"))
        {
            //释放随机技能
            if(RandomInt(1, 2)==2)
            {
                //火箭弹
                EntFire("gargantua_mover", "Stop", " ", 0.0, null);
                EntFire("gargantua_prop", "SetAnimation", "fire1", 0.1, null);

                local spawner = Entities.CreateByClassname("env_entity_maker");
                spawner.__KeyValueFromString("EntityTemplate", "gargantua_skill_missile_2_template");
                spawner.SpawnEntityAtNamedEntityOrigin("gargantua_skill_missile_2_template");
                EntFire("gargantua_skill_missile_2_template", "ForceSpawn", " ", 0.2, null);
                EntFireByHandle(spawner, "kill", " ", 0.21, null, null)
                EntFire("gargantua_skill_missile_2_particles", "start", " ", 0.2, null);
                EntFire("gargantua_skill_missile_2", "open", " ", 0.2, null);

                EntFire("gargantua_prop", "SetAnimation", "walk_all", 2, null);
                EntFire("gargantua_mover", "StartForward", " ", 2.1, null);
            }
            else
            {
                //火浪刀
                EntFire("gargantua_mover", "Stop", " ", 0.0, null);
                EntFire("gargantua_prop", "SetAnimation", "melee2", 0.1, null);

                local spawner = Entities.CreateByClassname("env_entity_maker");
                spawner.__KeyValueFromString("EntityTemplate", "gargantua_skill_fire_2_template");
                spawner.SpawnEntityAtNamedEntityOrigin("gargantua_skill_fire_2_template");
                EntFire("gargantua_skill_fire_2_template", "ForceSpawn", " ", 0.2, null);
                EntFireByHandle(spawner, "kill", " ", 0.21, null, null)
                for(local j=1; j<=11; j++)
                {
                    EntFire("gargantua_skill_fire_particles_2_"+j, "start", " ", 0.2, null);
                }
                EntFire("gargantua_skill_fire_2_move", "open", " ", 0.2, null);

                EntFire("gargantua_prop", "SetAnimation", "walk_all", 2, null);
                EntFire("gargantua_mover", "StartForward", " ", 2.1, null);
            }
        }
        else
        {
            //释放强化技能
            if(RandomInt(1, 1)==2)//暴走太IMBA了
            {
                //僵尸暴走
                EntFire("gargantua_mover", "Stop", " ", 0.0, null);
                EntFire("gargantua_prop", "SetAnimation", "roar2", 0.1, null);
                local player_speedmod = null;
                local h = null;
                local player_speedmod = Entities.CreateByClassname("player_speedmod");
                if(null!=(h=Entities.FindInSphere(h,gargantua_prop.GetOrigin(),800)))
	            {
		            if(h.GetClassname()=="player"&&h.GetTeam()==2&&h.GetHealth()>0)
                    {
			            EntFireByHandle(player_speedmod, "ModifySpeed", "1.2", 0.1, h, null);
                        EntFireByHandle(player_speedmod, "ModifySpeed", "1.0", 8.1, h, null);
		            }
                }

                EntFire("gargantua_prop", "SetAnimation", "walk_all", 2, null);
                EntFire("gargantua_mover", "StartForward", " ", 2.1, null);
            }
            else
            {
                //震撼视角
                EntFire("gargantua_mover", "Stop", " ", 0.0, null);
                EntFire("gargantua_prop", "SetAnimation", "roar1", 0.1, null);
                gargantua_voice.__KeyValueFromString("message", "music/insanemusic_garg1.mp3")
                EntFire("gargantua_voice", "PlaySound", " ", 0.3, null)

			    EntFire("gargantua_skill_shock_particles", "FireUser1", " ", 0.2, null);

                EntFire("gargantua_prop", "SetAnimation", "walk_all", 2, null);
                EntFire("gargantua_mover", "StartForward", " ", 2.1, null);
            }
        }
    }
}

function close_particles_fire_1() {
    for(local j=1; j<=11; j++)
    {
        EntFire("gargantua_skill_fire_particles_1_"+j, "stop", " ", 0.0, null);
    }
}
function close_particles_fire_2() {
    for(local j=1; j<=11; j++)
    {
        EntFire("gargantua_skill_fire_particles_2_"+j, "stop", " ", 0.0, null);
    }
}

function SayGoodbye_ready() {
    ScriptPrintMessageChatAll("太迟了，泰坦即将自爆引爆整条隧道，下次好运吧！");
}
function SayGoodbye() {
    local h = null;
    while(null!=(h=Entities.FindByClassname(h,"player")))
	{
		if(h.GetClassname()=="player"&&h.GetTeam()==3&&h.GetHealth()>0)
		{
            EntFireByHandle(h, "SetHealth", "-1", 0.0, null, null);
		}
	}
}