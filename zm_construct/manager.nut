SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "zm_construct";
SCRIPT_TIME <- "2023年1月27日10:27:00";
SCRIPT_VERSION <- "v0.1";

::Manager <- this;
IncludeScript("vs_library");

::MAPPER_NetID <- [
    "STEAM_1:0:92422507",//7ychu5
];
::MAPPER_skin <- "models/player/custom_player/legacy/ctm_heavy.mdl";self.PrecacheModel(::MAPPER_skin);

class ::weapon_list
{
    weapon =
    [
        "weapon_ak47"
        "weapon_aug"
        "weapon_awp"
        "weapon_bizon"
        "weapon_cz75a"
        "weapon_deagle"
        "weapon_elite"
        "weapon_famas"
        "weapon_fiveseven"
        "weapon_g3sg1"
        "weapon_galilar"
        "weapon_glock"
        "weapon_hkp2000"
        "weapon_m249"
        "weapon_m4a1"
        "weapon_m4a1_silencer"
        "weapon_mac10"
        "weapon_mag7"
        "weapon_mp5sd"
        "weapon_mp7"
        "weapon_mp9"
        "weapon_negev"
        "weapon_p250"
        "weapon_p90"
        "weapon_revolver"
        "weapon_scar20"
        "weapon_sg556"
        "weapon_ssg08"
        "weapon_tec9"
        "weapon_ump45"
        "weapon_usp_silencer"
    ]
    delay =
    [
        "2.43"
        "3.77"
        "3.67"
        "2.43"
        "2.83"
        "2.20"
        "3.77"
        "3.30"
        "2.27"
        "4.67"
        "3.03"
        "2.27"
        "2.27"
        "5.70"
        "3.07"
        "3.07"
        "2.57"
        "2.47"
        "2.94"
        "3.13"
        "2.13"
        "5.70"
        "2.27"
        "3.37"
        "2.27"
        "3.07"
        "2.77"
        "3.70"
        "2.57"
        "3.43"
        "2.17"
    ]
}

class ::broadcast_list
{
    one =
    [
        TextColor.Uncommon+"[MAP] "+ TextColor.Location + " 还有五分钟传送门即将激活！记得在天台等着！",
        TextColor.Uncommon+"[MAP] "+ TextColor.Location + " 五分钟！五分钟后不出意外传送门会再次开启！"
    ]
    two =
    [
        TextColor.Uncommon+"[MAP] "+ TextColor.Location + " 还有四分钟！我们的补给在持续投放！多拿一些增加胜算！",
        TextColor.Uncommon+"[MAP] "+ TextColor.Location + " 四分钟！补给在持续投放！从感染者手中抢过来！"
    ]
    three =
    [
        TextColor.Uncommon+"[MAP] "+ TextColor.Location + " 最后三分钟！怎么外面也出现了感染者？坚持住！",
        TextColor.Uncommon+"[MAP] "+ TextColor.Location + " 三分钟！见鬼！我们腹背受敌！哪里来的敌人？"
    ]
    four =
    [
        TextColor.Uncommon+"[MAP] "+ TextColor.Location + " 两分钟！两分钟！两分钟！",
        TextColor.Uncommon+"[MAP] "+ TextColor.Location + " 再撑两分钟！我们损失了30%的战力，我们还能打！"
    ]
    five =
    [
        TextColor.Uncommon+"[MAP] "+ TextColor.Location + " 倒计时60秒！我们损失超过半数了，碎剑者行动已开启！拜托你们了！",
        TextColor.Uncommon+"[MAP] "+ TextColor.Location + " 倒计时一分钟！天啊，这么多感染者......我们要执行核爆了！"
    ]
    six =
    [
        TextColor.Uncommon+"[MAP] "+ TextColor.Location + " 快上天台！传送门要开了，快走！这里全完了！",
        TextColor.Uncommon+"[MAP] "+ TextColor.Location + " 去天台！快走！代号碎剑者已执行！"
    ]
    escape =
    [
        TextColor.Uncommon+"[MAP] "+ TextColor.Location + " 跳！跳！跳！跳！跳！",
        TextColor.Uncommon+"[MAP] "+ TextColor.Location + " 快走，他们来了！"
    ]
}

::PLAYERS<-[];
class ::PlayerInfo
{
	name = null;
	userid = null;
	networkid = null;
    handle = null;
	constructor(p_name,p_userid,p_networkid)
	{
        name = p_name;
		userid = p_userid;
		networkid = p_networkid;
	}

	job = 0;
    build = 2;
    function check_build(){return this.build;}
    function build_add(){this.build++;}
    function build_sub(){this.build--;}
    function set_build_none(){this.build = 0;}
    function set_build_done(){this.build = 999;}
	function check_job(){return this.job;}
	function clear_job(){this.job = 0;}
	function set_job1(){this.job = 1;}
	function set_job2(){this.job = 2;}
	function set_job3(){this.job = 3;}
    function set_job4(){this.job = 4;}
}

first_time <- true;
function map_start() {
	//::PLAYERS.clear();
	if(first_time == true)
	{
		foreach(p in VS.GetAllPlayers())
		{
			local userid = p.GetScriptScope().userid;
			local name = p.GetScriptScope().name;
			local networkid = p.GetScriptScope().networkid;

			local pp = ::PlayerInfo(name,userid,networkid);
			::PLAYERS.push(pp);
			mapper_info(userid);
            job_info();
            EntFireByHandle(VS.GetPlayerByUserid(userid), "AddOutput", "rendermode 0", 0.0, null, null);
            VS.GetPlayerByUserid(userid).__KeyValueFromString("targetname", "");
		}
        EntFire("center_tree_dirt", "open", "", 0.0, null);//startup the floating island
        random_item_drop();//startup the dropping
        game_show();
		first_time = false;
	}
	else check_players_array();
}

function check_players_array() {
	local Temp_Player_Arr = [];
	for(local i = 0; i < ::PLAYERS.len(); i++)
	{
		if(VS.GetPlayerByUserid(::PLAYERS[i].userid) != null && VS.GetPlayerByUserid(PLAYERS[i].userid).IsValid())
		{
			Temp_Player_Arr.push(::PLAYERS[i]);
		}
	}
	::PLAYERS.clear();
	for(local a = 0; a < Temp_Player_Arr.len(); a++)
	{
		::PLAYERS.push(Temp_Player_Arr[a]);
	}
}

function mapper_info(userid) {
	local handle = VS.GetPlayerByUserid(userid);
	local scope = handle.GetScriptScope();
	local name = scope.name;
	local networkid = scope.networkid;
	for(local a = 0; a < MAPPER_NetID.len(); a++)
	{
		if(networkid.tostring() == MAPPER_NetID[a].tostring())
		{
            foreach(p in ::PLAYERS)
                {
                    if(p.userid == userid)
                    {
                        p.set_build_done();
                    }
                }
			Chat(TextColor.Uncommon+"[MAP] "+ TextColor.Location + " 您好！我是 "+TextColor.Immortal + name + TextColor.Location +"！希望您游玩愉快！\n ");
			handle.SetModel(MAPPER_skin);
		}
		break;
	}
	//ScriptPrintMessageCenterAll("<html><img src=\"https://steamuserimages-a.akamaihd.net/ugc/2001321225474498283/2FB6FA65DC8ED3A6224DF943A18F64326C88D1E2/\"/></html>\n");
}

function job_info() {
    local hint1 = CreateHint();
    hint1.__KeyValueFromString("targetname", "hint1");
    hint1.__KeyValueFromString("hint_target", "btn_job_supply");
    hint1.__KeyValueFromString("hint_caption", "支援兵：被动：手动换弹极小弹夹，爆炸子弹。主动：无");
    local hint2 = CreateHint();
    hint2.__KeyValueFromString("targetname", "hint2");
    hint2.__KeyValueFromString("hint_target", "btn_job_engineer");
    hint2.__KeyValueFromString("hint_caption", "工兵：被动：无。主动：拾取空投进行建筑");
    local hint3 = CreateHint();
    hint3.__KeyValueFromString("targetname", "hint3");
    hint3.__KeyValueFromString("hint_target", "btn_job_assault");
    hint3.__KeyValueFromString("hint_caption", "突击手：被动：制造烟幕。主动：你的治疗包好像发生了某些变化......");
    local b=1;
    for(local a = 0.0 ; a < 30; a += 5)
    {
        EntFireByHandle(hint1, "ShowHint", "", a, null, null);
        a+=5;
        EntFireByHandle(hint2, "ShowHint", "", a, null, null);
        a+=5;
        EntFireByHandle(hint3, "ShowHint", "", a, null, null);
    }
    EntFireByHandle(hint3, "kill", "", 30.0, null, null);
    EntFireByHandle(hint2, "kill", "", 30.0, null, null);
    EntFireByHandle(hint1, "kill", "", 30.0, null, null);
}
VS.ListenToGameEvent( "player_connect", function( event )
{
	local userid = event.userid;
    local name = event.name;
	local networkid = event.networkid;
    local p = ::PlayerInfo(name,userid,networkid);
	::PLAYERS.push(p);
},"");

::toggle <- false;
VS.ListenToGameEvent( "player_say", function( event ) {
    local userid = event.userid;
	//local networkid = Get32IDByUserid(userid);
    local player = VS.GetPlayerByUserid(userid);
    local networkid = player.GetScriptScope().networkid;
    local msg = event.text;
    if ( msg[0] != '!' ) return;
	for(local a = 0; a < MAPPER_NetID.len(); a++)
    {
        if(networkid.tostring() == ::MAPPER_NetID[a].tostring())
        {
            if(msg == "!map_noclip")
            {
                ::toggle = !::toggle;
                if(::toggle) EntFireByHandle(VS.GetPlayerByUserid(userid), "AddOutput", "MoveType 8", 0.0, null, null);
                else EntFireByHandle(VS.GetPlayerByUserid(userid), "AddOutput", "MoveType 2", 0.0, null, null);
            }
            if(msg == "!map_enginner_done")
            {
                foreach(p in ::PLAYERS)
                {
                    Chat(TextColor.Uncommon+"[MAP]  "+ TextColor.Location +" 无限建筑时刻！谨慎使用，小心炸服！\n ");
                    if(p.userid == activator.GetScriptScope().userid)
                    {
                        if(p.job==2)
                        {
                            p.set_build_done();
                        }
                    }
                }
            }
            if(msg == "!map_enginner_none")
            {
                foreach(p in ::PLAYERS)
                {
                    if(p.userid == activator.GetScriptScope().userid)
                    {
                        if(p.job==2)
                        {
                            p.set_build_none();
                        }
                    }
                }
            }
            if(msg == "!map_slay @ct")
            {
                local target_candidates = [];
                for(local h;h=Entities.FindByClassname(h,"player");)
                {
                    if(h==null||!h.IsValid()||h.GetHealth()<=0||h.GetTeam()!=3) continue;
                    target_candidates.push(h);
                }
                if(target_candidates.len()<=0) return;
                for(local a = 0; a < target_candidates.len(); a++)
                {
                    EntFireByHandle(target_candidates[a], "SetHealth", "-1", 0.0, null, null);
                }
            }
            if(msg == "!map_slay @t")
            {
                local target_candidates = [];
                for(local h;h=Entities.FindByClassname(h,"player");)
                {
                    if(h==null||!h.IsValid()||h.GetHealth()<=0||h.GetTeam()!=2) continue;
                    target_candidates.push(h);
                }
                if(target_candidates.len()<=0) return;
                for(local a = 0; a < target_candidates.len(); a++)
                {
                    EntFireByHandle(target_candidates[a], "SetHealth", "-1", 0.0, null, null);
                }
            }
            if(msg == "!map_slay @all")
            {
                local target_candidates = [];
                for(local h;h=Entities.FindByClassname(h,"player");)
                {
                    if(h==null||!h.IsValid()||h.GetHealth()<=0) continue;
                    target_candidates.push(h);
                }
                if(target_candidates.len()<=0) return;
                for(local a = 0; a < target_candidates.len(); a++)
                {
                    EntFireByHandle(target_candidates[a], "SetHealth", "-1", 0.0, null, null);
                }
            }
        }
    }
    // if(::hero_toggle == true && player.GetName() == "hero")
    // {
    //     if(msg == "!bs")
    //     {
    //         ::player_set_job4(player);
    //     }
    // }
}, "mapper_say" );

function CreateHint() {
    local hint = Entities.CreateByClassname("Env_instructor_hint");
    hint.__KeyValueFromString("hint_static", "0");
    hint.__KeyValueFromString("hint_color", "255 255 255");
    hint.__KeyValueFromString("hint_nooffscreen", "0");
    hint.__KeyValueFromString("hint_icon_onscreen", "icon_tip");
    hint.__KeyValueFromString("hint_timeout", "5");
    hint.__KeyValueFromString("hint_forcecaption", "1");
    return hint;
}

::CreateText <- function() {
    local text = Entities.CreateByClassname("game_text");
	text.__KeyValueFromString("message","game_text");
	text.__KeyValueFromString("color","255 255 255");
	text.__KeyValueFromString("color2","255 255 255");
	text.__KeyValueFromString("effect","2");
	text.__KeyValueFromString("x","0");
	text.__KeyValueFromString("y","0.41");
	text.__KeyValueFromString("channel","1");
	text.__KeyValueFromString("spawnflags","0");
	text.__KeyValueFromString("holdtime","5");
	text.__KeyValueFromString("fadein","0");
	text.__KeyValueFromString("fadeout","0");
	text.__KeyValueFromString("fxtime","0");
	return text;
}
////////////////////////////////////////
///////NutEnt prefab by Luffaren////////
////////////////////////////////////////

::GVO<-function(vec,_x,_y,_z){return Vector(vec.x+_x,vec.y+_y,vec.z+_z);}
::InSight<-function(start,target){if(TraceLine(start,target,self)<1.00)return true;return true;}//false
::GetDistance<-function(v1,v2){return sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y)+(v1.z-v2.z)*(v1.z-v2.z));}
::GetDistanceZ<-function(v1,v2){return sqrt((v1.z-v2.z)*(v1.z-v2.z));}
::Ent<-function(pos=Vector(),rot=Vector(),classname="",keyvalues=null,script=null){
	local template_not_found = true;
	local template = null;
	local maker = null;
	if(classname==null||classname==""){}else
	{
		template = Entities.FindByName(null,"nutent_template_"+classname);
		if(template==null||!template.IsValid()){}else
		{
			template.ValidateScriptScope();
			maker = Entities.FindByName(null,"nutent_maker_"+classname);
			if(maker==null||!maker.IsValid())
			{
				maker = Entities.CreateByClassname("env_entity_maker");
				maker.__KeyValueFromString("targetname","nutent_maker_"+classname);
				maker.__KeyValueFromString("EntityTemplate","nutent_template_"+classname);
				template.GetScriptScope().spawnqueue <- [];
				template.GetScriptScope().PreSpawnInstance <- function(entityClass,entityName)
				{
					if(spawnqueue.len()<=0)return false;
					return spawnqueue[0].keyvalues;
				}
				template.GetScriptScope().PostSpawn <- function(entities)
				{
					local borked = false;
					local q = null;
					if(spawnqueue.len()<=0)borked = true;
					else
					{
						q = spawnqueue[0];
						spawnqueue.remove(0);
					}
					foreach(targetname,handle in entities)
					{
						if(borked){
							printl("[::Ent() PostSpawn ERROR]: killing: "+handle);
							EntFireByHandle(handle,"Kill","",0.00,null,null);
							break;}
						if(q.script!=null&&(typeof q.script)=="table")
						{
							handle.ValidateScriptScope();
							local sc = handle.GetScriptScope();
							foreach(v,i in q.script){sc[v] <- i;}
							if("_Run" in sc)sc._Run();
							if("Run" in sc)sc.Run();
						}
						break;
					}
				}
			}
			template_not_found = false;
		}
	}
	if(template_not_found)
	{
		printl("---------------------------------------------------------------------------------------------------------------------------------------------------------");
		printl("  [::Ent ERROR]: ::Ent-supported classname '"+classname+"' does not exist in the map");
		printl("        These ::Ent-supported entities exist in the map:");
		for(local h;h=Entities.FindByName(h,"nutent_template_*");)
		{
			local ename = h.GetName().slice(16);
			if(ename=="XXXXX")continue;
			printl("              -    "+ename);
		}
		printl("        To add more ::Ent-supported classes to the map (should also be possible via stripper for most of it):");
		printl("                (XXXXX = classname of the entity you want to add, for example:	logic_relay / point_tesla / trigger_hurt / ...)");
		printl("            -    make sure the entity doesn't already exist in the map/nutent.vmf (run ::Ent() with classname=null to print all existing classes)");
		printl("            -    create a point_template, uncheck the flag 'Preserve entity names', add the below entity as Template01 name it:		nutent_template_XXXXX");
		printl("            -    create the entity of the desired class, place its origin at the center of the ^template, name it:					nutent_XXXXX");
		printl("            -    set the default values for the entity (should be as default/generic/general-purpose as possible)");
		printl("            -    that's it, just recompile the .bsp with the new ents from nutent.vmf and it'll be ready for in-game usage (or do it by stripper if possible/desired)");
		printl("---------------------------------------------------------------------------------------------------------------------------------------------------------");
		return;
	}
	template.GetScriptScope().spawnqueue.push({keyvalues=keyvalues,script=script});
	if(pos.LengthSqr() < 0.05)pos.z = 0.05;
	maker.SpawnEntityAtLocation(pos,rot);
}

////////////////////////////////////////
/////////////工兵（已完工）//////////////
////////////////////////////////////////

function player_set_job1() {
	//local handle = VS.GetPlayerByUserid(activator.GetScriptScope().userid);
	foreach(p in ::PLAYERS)
	{
		if(p.userid == activator.GetScriptScope().userid && activator.GetTeam() == 3 && p.check_job() == 0)
		{
			p.set_job1();
            local text = CreateText();
            EntFireByHandle(text, "SetText", "您好，工兵！", 0.0, activator, null);
            EntFireByHandle(text, "Display", "", 0.01, activator, null);
            EntFireByHandle(text, "kill", "", 0.01, activator, null);
            local maker = Entities.CreateByClassname("env_entity_maker");
            local stripper = Entities.CreateByClassname("player_weaponstrip");
            maker.__KeyValueFromString("EntityTemplate","engineer_template");
            EntFireByHandle(stripper, "Strip", " ", 0.0, activator, null);
            maker.SpawnEntityAtLocation(activator.GetOrigin(), Vector(0, 0, 0));
            EntFireByHandle(maker, "kill", "", 0.01, null, null);
            EntFireByHandle(stripper, "kill", "", 0.01, null, null);
        }
	}
}

function barrier_build() {
    foreach(p in ::PLAYERS)
    {
        if(p.userid == activator.GetScriptScope().userid && p.check_job() == 1)
        {
            if(p.check_build()>0)
            {
                p.build_sub();
                local player = ToExtendedPlayer( VS.GetPlayerByUserid( activator.GetScriptScope().userid ) );
                local eyePos = player.EyePosition();
                local eyeAngle = player.EyeAngles();
                local pos = VS.TraceDir( eyePos, player.EyeForward(), 128.0 ).GetPos();

                ::Ent(pos,Vector(0, 0, 0),"func_breakable",{
                    health = 999999,
                    material = 8,
                },{
                count = 30,
                function barrier_break(){
                    count--;
                    if(count<=0)
                    {
                        EntFireByHandle(self, "break", "", 0.0, null, null);
                    }
                    local text = CreateText();
                    local counttemp = count;
                    local value = "耐久度：";
                    for(local j=1;j<=10;j++)
                    {
                        if(counttemp-3>=0)
                        {
                            counttemp -= 3;
                            value = value + "■";
                        }
                        else
                        {
                            value = value + "□";
                        }
                    }
                    EntFireByHandle(text, "SetText", value, 0.0, activator, null);
                    EntFireByHandle(text, "Display", "", 0.01, activator, null);
                    EntFireByHandle(text, "kill", "", 1, activator, null);
                },
                function Run(){
                    EntFireByHandle(self,"AddOutput","OnHealthChanged !self:RunScriptCode:barrier_break();:0:-1",0.00,null,null);
                }});
            }
            else
            {
                local text = CreateText();
                EntFireByHandle(text, "SetText", "可建筑数："+p.check_build(), 0.0, activator, null);
                EntFireByHandle(text, "Display", "", 0.01, activator, null);
                EntFireByHandle(text, "kill", "", 1, activator, null);
            }
        }
    }
}

////////////////////////////////////////
/////////////支援兵（已完工）/////////////
////////////////////////////////////////

function player_set_job2() {
	foreach(p in ::PLAYERS)
	{
		if(p.userid == activator.GetScriptScope().userid && activator.GetTeam() == 3 && p.check_job() == 0)
		{
			p.set_job2();
            for(local n = 0;n < ::weapon_list.weapon.len();n++)
            {
                for (local ent; ent = Entities.FindByClassname(ent, ::weapon_list.weapon[n]);){
                    if(ent.GetMoveParent() == activator){EntFireByHandle(ent,"SetAmmoAmount","5",0,null,null);break;}
                }
            }
			local text = CreateText();
            EntFireByHandle(text, "SetText", "您好，支援兵！", 0.0, activator, null);
            EntFireByHandle(text, "Display", "", 0.01, activator, null);
            EntFireByHandle(text, "kill", "", 0.01, activator, null);
		}
	}
}

VS.ListenToGameEvent( "weapon_reload", function( event )
{
	local player = VS.GetPlayerByUserid( event.userid );
	foreach(p in ::PLAYERS)
	{
		if(p.userid == player.GetScriptScope().userid)
		{
			if(p.job==2)
			{
                for(local n = 0;n < ::weapon_list.weapon.len();n++)
                {
                    for (local ent; ent = Entities.FindByClassname(ent, ::weapon_list.weapon[n]);){
                        if(ent.GetMoveParent() == player){EntFireByHandle(ent,"SetAmmoAmount","5",weapon_list.delay[n].tofloat(),null,null);break;}
                    }
                }
			}
		}
	}
}, " " );

VS.ListenToGameEvent( "bullet_impact", function( event )
{
	local player = VS.GetPlayerByUserid( event.userid );
	foreach(p in ::PLAYERS)
	{
		if(p.userid == player.GetScriptScope().userid)
		{
			if(p.job==2)
			{
				local position = Vector( event.x, event.y, event.z );
                local DISTANCE = 128;
                local FORCE_MOD = 1.00;
                local UP_SPEED = 150;
                local humans = [];
                local h = null;
                while(null!=(h=Entities.FindInSphere(h,position,DISTANCE)))
                {
                    if(h.GetClassname() == "player" && h.GetHealth()>0)
                    {
                        if(InSight(position,GVO(h.GetOrigin(),0,0,48))) humans.push(h);
                    }
                }
                foreach(target in humans)
                {
                    local position = position;
                    local tpos = target.GetOrigin();
                    local vec = position-tpos;
                    local dist = GetDistance(position,GVO(target.GetOrigin(),0,0,40));
                    vec.Norm();
                    EntFireByHandle(target,"AddOutput","basevelocity "+
                        (vec.x*(((dist)-DISTANCE)*FORCE_MOD)).tostring()+" "+
                        (vec.y*(((dist)-DISTANCE)*FORCE_MOD)).tostring()+" "+
                        (UP_SPEED).tostring(),0.00,null,null);
                }

				DispatchParticleEffect("explosion_hegrenade_brief", position, Vector(0,0,0));
			}
		}
	}
}, "DrawImpact" );

////////////////////////////////////////
/////////////突击兵（已完工）////////////
////////////////////////////////////////

//sry...... I made everything fucked up......

////////////////////////////////////////
////////////////////////////////////////
////////////////////////////////////////

function random_item_drop() {
    //Vector(2600,7408,2112),Vector(6616,3624,2112)
    local maker = Entities.CreateByClassname("env_entity_maker");
    maker.__KeyValueFromString("EntityTemplate","item_get_template");

    local count = 3;
    if(::PLAYERS.len()>8){count += 4};
    if(::PLAYERS.len()>16){count += 4};
    if(::PLAYERS.len()>24){count += 3};
    if(::PLAYERS.len()>32){count += 2};
    if(::PLAYERS.len()>40){count += 1};
    for (local ent; ent = Entities.FindByName(ent, "item_get_prop*"); )
    {
        count--;
    }
    for(;count>0;count--)
    {
        local x = RandomInt(2600, 6616);
        local y = RandomInt(3624, 7408);
        local z = 2112;
        maker.SpawnEntityAtLocation(Vector(x, y, z), Vector(0, 0, 0));
    }
    EntFire("logic_script", "RunScriptCode", "random_item_drop()", 45.0, null);
}

function random_item_get() {
    if(activator.GetTeam() == 2 && activator.GetName() != "user")
    {
        foreach(p in ::PLAYERS)
	    {
		    if(p.userid == activator.GetScriptScope().userid)
		    {
			    if(p.job==2)
			    {
                    p.set_build_none();
                }
            }
        }
        activator.__KeyValueFromString("targetname", "user");
        local stripper = Entities.CreateByClassname("player_weaponstrip");
        local maker = Entities.CreateByClassname("env_entity_maker");
        EntFireByHandle(stripper, "Strip", " ", 0.0, activator, null);
        switch (RandomInt(1, 5)) {
            case 1:
                maker.__KeyValueFromString("EntityTemplate","item_blade_template");
                break;
            case 2:
                maker.__KeyValueFromString("EntityTemplate","item_vanish_template");
                break;
            case 3:
                maker.__KeyValueFromString("EntityTemplate","gas_template");
                break;
            case 4:
                maker.__KeyValueFromString("EntityTemplate","item_horn_template");
                break;
            case 5:
                maker.__KeyValueFromString("EntityTemplate","item_portal_template");
                break;
            default:break;
        }
        maker.SpawnEntityAtLocation(activator.GetOrigin(), Vector(0, 0, 0));
        EntFireByHandle(stripper, "kill", " ", 0.01, null, null);
        EntFireByHandle(maker, "kill", "", 0.01, null, null);
    }
    if(activator.GetTeam() == 3)
    {
        local ct = 0;local t = 0;
        local target_candidates = [];
        foreach(p in ::PLAYERS)
        {
            local player = VS.GetPlayerByUserid( p.userid );
            if(player.GetTeam() == 3 && player.GetHealth()>0)
            {
                ct++;
                target_candidates.push(player);
            }
            if(player.GetTeam() == 2 && player.GetHealth()>0) t++;
        }
        if(ct == 1 && activator.GetName()!="user")
        {
            local stripper = Entities.CreateByClassname("player_weaponstrip");
            EntFireByHandle(stripper, "Strip", " ", 0.0, activator, null);
            local maker = Entities.CreateByClassname("env_entity_maker");
            maker.__KeyValueFromString("EntityTemplate","alpha_template");
            maker.SpawnEntityAtLocation(activator.GetOrigin(), Vector(0, 0, 0));
            EntFireByHandle(stripper, "kill", " ", 0.01, null, null);
            EntFireByHandle(maker, "kill", "", 0.01, null, null);
            activator.__KeyValueFromString("targetname", "user");
            return;
        }
        else
        {
            target_candidates.clear();
        }
        foreach(p in ::PLAYERS)
        {
            if(p.userid == activator.GetScriptScope().userid)
            {
                if(p.check_job() == 1)
                {
                    p.build_add();
                    local text = CreateText();
                    text.__KeyValueFromFloat("channel", 5);
                    text.__KeyValueFromFloat("y", 0.8);
                    EntFireByHandle(text, "SetText", "可建筑数："+p.check_build(), 0.0, activator, null);
                    EntFireByHandle(text, "Display", "", 0.01, activator, null);
                    EntFireByHandle(text, "kill", "", 0.01, activator, null);
                }
                else
                {
                    switch (RandomInt(1, 2)) {
                        case 1:
                            local text = CreateText();
                            EntFireByHandle(text, "SetText", "轻盈！", 0.0, activator, null);
                            EntFireByHandle(text, "Display", "", 0.01, activator, null);
                            EntFireByHandle(text, "kill", "", 0.01, activator, null);
                            EntFireByHandle(activator, "AddOutput", "gravity 0.2", 0.0, activator, null);
                            EntFireByHandle(activator, "AddOutput", "gravity 1", 15.0, activator, null);
                            break;
                        case 2:
                            local text = CreateText();
                            EntFireByHandle(text, "SetText", "迅捷！", 0.0, activator, null);
                            EntFireByHandle(text, "Display", "", 0.01, activator, null);
                            EntFireByHandle(text, "kill", "", 0.01, activator, null);
                            local speedmod = Entities.CreateByClassname("player_speedmod");
                            EntFireByHandle(speedmod, "ModifySpeed", "3", 0.0, activator, null);
                            EntFireByHandle(speedmod, "ModifySpeed", "1", 15.0, activator, null);
                            EntFireByHandle(speedmod, "kill", "", 15.01, null, null);
                            break;
                        case 3:
                            local stripper = Entities.CreateByClassname("player_weaponstrip");
                            EntFireByHandle(stripper, "Strip", " ", 0.0, activator, null);
                            local maker = Entities.CreateByClassname("env_entity_maker");
                            maker.__KeyValueFromString("EntityTemplate","item_vanish_template");
                            maker.SpawnEntityAtLocation(activator.GetOrigin(), Vector(0, 0, 0));
                            EntFireByHandle(stripper, "kill", " ", 0.01, null, null);
                            EntFireByHandle(maker, "kill", "", 0.01, null, null);
                            break;
                        default:break;
                    }
                }
            }
        }
    }
}

self.PrecacheScriptSound("7ychu5/ambient/streetwar/city_battle2.wav");
self.PrecacheScriptSound("7ychu5/ambient/streetwar/city_battle3.wav");
self.PrecacheScriptSound("7ychu5/ambient/streetwar/city_battle4.wav");
self.PrecacheScriptSound("7ychu5/ambient/streetwar/city_battle5.wav");
self.PrecacheScriptSound("7ychu5/ambient/streetwar/city_battle6.wav");
self.PrecacheScriptSound("7ychu5/ambient/streetwar/city_battle7.wav");
self.PrecacheScriptSound("7ychu5/ambient/streetwar/city_battle8.wav");
self.PrecacheScriptSound("7ychu5/ambient/streetwar/city_battle9.wav");

function game_show() {
    EntFire("logic_script", "RunScriptCode", "Chat(::broadcast_list.one[RandomInt(0,1)])", 0, null);
    EntFire("logic_script", "RunScriptCode", "Chat(::broadcast_list.two[RandomInt(0,1)])", 60, null);
    EntFire("logic_script", "RunScriptCode", "Chat(::broadcast_list.three[RandomInt(0,1)])", 120, null);
    EntFire("logic_script", "RunScriptCode", "Chat(::broadcast_list.four[RandomInt(0,1)])", 180, null);
    EntFire("logic_script", "RunScriptCode", "Chat(::broadcast_list.five[RandomInt(0,1)])", 240, null);
    EntFire("logic_script", "RunScriptCode", "Chat(::broadcast_list.six[RandomInt(0,1)])", 300, null);
    EntFire("logic_script", "RunScriptCode", "Chat(::broadcast_list.escape[RandomInt(0,1)])", 330, null);
    EntFire("particle_portal_shock", "start", "", 300, null);
    EntFire("particle_portal_shock", "stop", "", 329, null);
    EntFire("particle_portal_shock", "start", "", 330, null);
    EntFire("trigger_gravity", "Enable", "", 330, null);
    EntFire("trigger_push", "Enable", "", 325, null);
    EntFire("logic_script", "RunScriptCode", "SayGoodBye()", 340, null);

    local a = RandomInt(33, 64);local d = 0;
    while(a>0)
    {
        if(a/2*2 == a) EntFire("skybox_uh60_template", "ForceSpawn", "", d, null);
        d+=60;
        a/=2;
    }

    for (local a = 1; a < 330; a+=2) {
        switch (RandomInt(1, 2)) {
            case 1:
                local b = RandomInt(2, 9).tostring();
                local ambient = "7ychu5/ambient/streetwar/city_battle"+b+".wav";
                EntFire("ambient_generic", "AddOutput", "message "+ambient, a, null);
                EntFire("ambient_generic", "PlaySound", "", a, null);
                break;
            default:
                break;
        }
    }
}

function SayGoodBye() {
    for (local p; p = Entities.FindByClassname(p, "player"); )
	{
		local ent_origin_z = p.GetOrigin().z;
        if(ent_origin_z < 2086){
        EntFireByHandle(p, "SetHealth", "-1", 0.0, null, null);
        }
	}
    local target_candidates = [];
	for(local h;h=Entities.FindByClassname(h,"player");)
	{
		if(h==null||!h.IsValid()||h.GetHealth()<=0||h.GetTeam()==3) continue;
		target_candidates.push(h);
	}
	if(target_candidates.len()<=0) return;
	for(local a = 0; a < target_candidates.len(); a++)
    {
        EntFireByHandle(target_candidates[a], "SetHealth", "-1", 0.0, null, null);
    }
}
