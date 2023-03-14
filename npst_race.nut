SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "ze_npst_v1_final";
SCRIPT_TIME <- "2023年1月10日12:27:48";
SCRIPT_VERSION <- "v1_1";//修复mapper高亮

::MAPPER_NetID <- [
    "STEAM_1:0:214019946",//individual
    "STEAM_1:0:92422507",//7ychu5 STEAM_1:0:92422507
	"STEAM_1:0:243840573",//nino
];
//MAPPER_skin <- "models/player/custom_player/legacy/ctm_heavy.mdl";self.PrecacheModel(MAPPER_skin);
predictmodel <- "models/weapons/v_ied.mdl";self.PrecacheModel(predictmodel);

IncludeScript("7ychu5/glow.nut");

local h = null;
while(null!=(h=Entities.FindByClassname(h,"player")))
{
    Glow.Disable(h);
}

::absolute_time <- 0;
rank <- "";
start_toggle <- false;
end_toggle <- false;

rank_text <- Entities.CreateByClassname("game_text");
rank_text.__KeyValueFromFloat("x", 0.17);
rank_text.__KeyValueFromFloat("y", 0);
rank_text.__KeyValueFromString("channel", "5");
rank_text.__KeyValueFromString("effect","0");
rank_text.__KeyValueFromString("color", "0 255 255");
rank_text.__KeyValueFromString("color2", "0 0 0");
rank_text.__KeyValueFromString("spawnflags","1");
rank_text.__KeyValueFromString("holdtime","30");
rank_text.__KeyValueFromString("fadein","0.1");
rank_text.__KeyValueFromString("fadeout","0.1");
timer_text <- Entities.CreateByClassname("game_text");
timer_text.__KeyValueFromFloat("x", 0);
timer_text.__KeyValueFromFloat("y", 0.38);
timer_text.__KeyValueFromString("channel", "4");
timer_text.__KeyValueFromString("effect","0");
timer_text.__KeyValueFromString("color", "255 255 0");
timer_text.__KeyValueFromString("spawnflags","1");
timer_text.__KeyValueFromString("holdtime","1");
timer_text.__KeyValueFromString("fadein","0");
timer_text.__KeyValueFromString("fadeout","0");

::PlayerConnect <- function (params) {
    local tb = getconsttable();
    tb[params.userid] <- params.name;
    tb[params.userid.tostring()] <- params.networkid;
    setconsttable(tb);
    __DumpScope(3,"ConstTable_Data "+tb[params.userid].tostring());
}

::target <- null;
::Think <- function () {
    user <- null;
    while ((user = Entities.FindByClassname(user, "*")) != null) {
        if (user.GetClassname() == "player" || user.GetClassname() == "cs_bot") {
            if (user.ValidateScriptScope()) {
                if (::target == null) {
                    if (!("userid" in user.GetScriptScope())) {
                        user.GetScriptScope().userid <- 1;
                        ::target = user;
                        EntFire("info_game_event_proxy", "GenerateGameEvent", "", 0.00, user);
                    }
                }
            }
        }
    }
}

::GetPlayerByUserid <- function (uid) {
    user <- null;
    while ((user = Entities.FindByClassname(user, "*")) != null) {
        if (user.GetClassname() == "player" || user.GetClassname() == "cs_bot") {
            if (user.ValidateScriptScope()) {
                if ("userid" in user.GetScriptScope()) {
                    if (user.GetScriptScope().userid == uid) {
                        return user;
                        break;
                    }
                }
            }
        }
    }
}

::GetNameByUserid <- function (uid) {
    user <- null;
    while ((user = Entities.FindByClassname(user, "*")) != null) {
        if (user.GetClassname() == "player" || user.GetClassname() == "cs_bot") {
            if (user.ValidateScriptScope()) {
                if ("userid" in user.GetScriptScope()) {
                    if (user.GetScriptScope().userid == uid) {
                        local tb = getconsttable();
                        return tb[user.GetScriptScope().userid];
                    }
                }
            }
        }
    }
}

::Get32IDByUserid <- function (uid) {
    user <- null;
    while ((user = Entities.FindByClassname(user, "*")) != null) {
        if (user.GetClassname() == "player" || user.GetClassname() == "cs_bot") {
            if (user.ValidateScriptScope()) {
                if ("userid" in user.GetScriptScope()) {
                    if (user.GetScriptScope().userid == uid) {
                        local tb = getconsttable();
                        return tb[user.GetScriptScope().userid.tostring()];
                    }
                }
            }
        }
    }
}

::PlayerUse <- function (params) {
    if (::target != null) {
        local sc = ::target.GetScriptScope();
        sc.userid <- params.userid;
        ::target = null;
        return;
    }
}

::toggle <- false;
::PlayerSay <- function (params) {
    local userid = params.userid;
	local networkid = Get32IDByUserid(userid);
    local msg = params.text;
	for(local a = 0; a < MAPPER_NetID.len(); a++)
    {
        if(networkid.tostring() == ::MAPPER_NetID[a].tostring())
        {
            if(msg == "!map_rr")
            {
                EntFire("game_round_end", "EndRound_Draw", "4", 0.0, null);
            }
            if(msg == "!map_retry")
            {
                EntFire("retry_button", "Press", "", 0.0, null);
            }
            if(msg == "!map_race")
            {
                EntFire("race_button", "Press", "", 0.0, null);
            }
            if(msg == "!map_normal")
            {
                EntFire("normal_button", "Press", "", 0.0, null);
            }
            if(msg == "!map_noclip")
            {
                ::toggle = !::toggle;
                if(::toggle) EntFireByHandle(GetPlayerByUserid(userid), "AddOutput", "MoveType 8", 0.0, null, null);
                else EntFireByHandle(GetPlayerByUserid(userid), "AddOutput", "MoveType 2", 0.0, null, null);
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
}


function warning() {
    for (local a = 0; a < 10; a++) {
        ScriptPrintMessageChatAll("\xB \xB[Npst_Race] \x4 在换图前就在本服务器的玩家retry才能体验正常的race体验！\n ");
    }
}

function MAPPER_USE() {
    local uid = activator.GetScriptScope().userid;
    local sid = Get32IDByUserid(uid);
    for(local a = 0; a < MAPPER_NetID.len(); a++)
    {
        if(sid == MAPPER_NetID[a])
        {
            //printl(MAPPER_NetID[a]);
            activator.SetOrigin(Vector(3780,10732,1429));
            break;
        }
    }
}

function water_up_heal() {
    for (local p; p = Entities.FindByClassname(p, "player"); )
	{
		local ent_origin_x = p.GetOrigin().x;
		local ent_origin_y = p.GetOrigin().y;
		local ent_origin_z = p.GetOrigin().z;
		if(ent_origin_x > -4558 && ent_origin_x < -3502){
			if(ent_origin_y > 2094 && ent_origin_y < 5872){
				if(ent_origin_z > 400 && ent_origin_z < 700){
                    local hp = p.GetHealth();
                    hp+=6;
					EntFireByHandle(p, "SetHealth", hp.tostring(), 0.0, null, null);
				}
			}
		}
	}
    EntFire("logic_script", "RunScriptCode", "water_up_heal()", 1.0, null);
}

function timer_start() {
	local userid = activator.GetScriptScope().userid;
	local name = GetNameByUserid(userid);
	local networkid = Get32IDByUserid(userid);
	for(local a = 0; a < MAPPER_NetID.len(); a++)
    {
        if(networkid.tostring() == MAPPER_NetID[a].tostring())
        {
            //GetPlayerByUserid(userid).__KeyValueFromString("targetname", "mapper");
            ScriptPrintMessageChatAll("\xB \xB[Npst_Race]\x4 您好！我是 \x10" + name + "\x4！希望您游玩愉快！\n ");
            local particles = Entities.CreateByClassname("info_particle_system");
            particles.__KeyValueFromString("effect_name", "burning_character");
            EntFireByHandle(particles, "SetParent", "pipewater_medium", 0.0, activator, null);
            Glow.Set( activator, Vector(255,255,255), 0, 2048 );
            break;
        }
    }
    local ent;
    while((ent = Entities.FindByClassname(ent, "*") ) != null)
    {
        if(ent.GetClassname() == "predicted_viewmodel")
        {
            if(ent.GetModelName().find("weapon", 0) != null)
            {
                ent.SetModel(predictmodel);
            }
        }
    }
    if(!start_toggle)
    {
        start_toggle <- !start_toggle;
        timer_roll();
    }
}

function GetTime() {
    local min = ::absolute_time/600;
	local sec = (::absolute_time/10)%60;
	local ms = ::absolute_time%10;
    if(sec<10) sec = "0"+sec.tostring();
    return [min,sec,ms];
}

function step1_toggle() {
    local userid = activator.GetScriptScope().userid;
	local player_name = GetNameByUserid(userid);
    if(GetPlayerByUserid(userid).GetName() != "escape")
    {
        GetPlayerByUserid(userid).__KeyValueFromString("targetname", "escape");
	    switch (RandomInt(0, 19)) {
		    case 0:
			    ScriptPrintMessageChatAll("\xB \xB[Npst_Race] \x7"+ player_name + "\x4 问你有没有看过《我是谁》？\n ");
			    break;
		    case 1:
			    ScriptPrintMessageChatAll("\xB \xB[Npst_Race] \x7"+ player_name + "\x4 已经准备好了纵身一跃！\n ");
			    break;
		    case 2:
			    ScriptPrintMessageChatAll("\xB \xB[Npst_Race] \x7"+ player_name + "\x4 怎么身上湿漉漉的？\n ");
			    break;
		    case 3:
			    ScriptPrintMessageChatAll("\xB \xB[Npst_Race] \x7"+ player_name + "\x4 说他从来不玩蹦极！但今天除外！\n ");
			    break;
		    case 4:
			    ScriptPrintMessageChatAll("\xB \xB[Npst_Race] \x7"+ player_name + "\x4 闭上了眼睛！\n ");
			    break;
		    case 5:
			    ScriptPrintMessageChatAll("\xB \xB[Npst_Race] \x7"+ player_name + "\x4 想在大坝顶部放水！\n ");
			    break;
		    default:
			    ScriptPrintMessageChatAll("\xB \xB[Npst_Race] \x7"+ player_name + "\x4 用时" + GetTime()[0] +"分"+ GetTime()[1] +"秒"+ GetTime()[2] +"00毫秒"+"通过了检查点！\n ");
			    break;
	    }
    }
    local ent;
    while((ent = Entities.FindByClassname(ent, "*") ) != null)
    {
        if(ent.GetClassname() == "predicted_viewmodel")
        {
            if(ent.GetModelName().find("weapon", 0) != null)
            {
                ent.Destroy();
            }
        }
    }
}

function timer_roll(){
	EntFireByHandle(timer_text, "SetText", "计时器："+ GetTime()[0] +":"+ GetTime()[1] +":"+ GetTime()[2] +"\n", 0.0, null, null);
	EntFireByHandle(timer_text, "Display", " ", 0.0, null, null);
	::absolute_time+=1;
	EntFire("logic_script", "RunScriptCode", "timer_roll()", 0.1, null);
}

function push_escaper()
{
	if(::GetPlayerByUserid(activator.GetScriptScope().userid).GetName()!="escape")
	{
		activator.SetOrigin(Vector(3042,-1020,-686));
		//EntFireByHandle(activator, "AddOutput", "origin(3042,-1020,-686)", 0.0, null, null);
	}
}

function timer_speak() {
    if(GetPlayerByUserid(activator.GetScriptScope().userid).GetName() == "escape")
    {
        local player_name = GetNameByUserid(activator.GetScriptScope().userid);
        ::GetPlayerByUserid(activator.GetScriptScope().userid).__KeyValueFromString("targetname", "escaper");
	    switch (RandomInt(0, 19)) {
		    case 0:
			    ScriptPrintMessageChatAll("\xB \xB[Npst_Race] \x7"+ player_name + "\x4 通过了水与火的考验！\n ");
			    break;
		    case 1:
			    ScriptPrintMessageChatAll("\xB \xB[Npst_Race] \x7"+ player_name + "\x4 想要再来一次！\n ");
			    break;
		    case 2:
			    ScriptPrintMessageChatAll("\xB \xB[Npst_Race] \x7"+ player_name + "\x4 在终点准备好了银趴！\n ");
			    break;
		    case 3:
			    ScriptPrintMessageChatAll("\xB \xB[Npst_Race] \x7"+ player_name + "\x4 觉得这一切太慢了！\n ");
			    break;
		    case 4:
			    ScriptPrintMessageChatAll("\xB \xB[Npst_Race] \x7"+ player_name + "\x4 帮你使劲撑着大门！\n ");
			    break;
		    default:
			    ScriptPrintMessageChatAll("\xB \xB[Npst_Race] \x7"+ player_name + "\x4 用时" + GetTime()[0] +"分"+ GetTime()[1] +"秒"+ GetTime()[2] +"00毫秒"+"完成逃脱！\n ");
			    break;
	    }
	    show_rank_text(player_name,GetTime()[0],GetTime()[1],GetTime()[2]);
	    if(!end_toggle)
        {
            end_toggle <- !end_toggle;
            ScriptPrintMessageChatAll("\xB \xB[Npst_Race]\x4 15秒后大门开始关闭，请加快脚步！大坝即将爆破！\n ");
        }
    }
}

function show_rank_text(player_name,min,sec,ms) {
	if(player_name.tostring().len()>=15) {player_name = player_name.slice(0,12)+"...";}
	rank += min +":"+ sec +":"+ ms + "  " + player_name + "\n";
	EntFireByHandle(rank_text, "SetText", rank, 0.0, null, null);
	EntFireByHandle(rank_text, "Display", " ", 0.0, null, null);
}

//////////////////////////
/////////map_info/////////
//////////////////////////
mapper_info_count <- 1;
function mapper_info() {
    if(mapper_info_count > 0)
    {
        ScriptPrintMessageChatAll("\xB \xB[Npst_Race] \x4Race模式stripper制作：\x10 Individual");
        mapper_info_count--;
        EntFire("logic_script", "RunScriptCode", "mapper_info()", 1.5, null);
    }
    else if(mapper_info_count == 0) ScriptPrintMessageChatAll("\xB \xB[Npst_Race] \x4Race模式vscript制作：\x10 7ychu5");
    else return;
}

class text_input
{
    title="";
    maintain=["任""务""：""在""水""坝""上""方""安""放""炸""弹""\n"
	"以""自""己""最""快""的""速""度""跑""完""整""张""地""图""\n"
    "请""按""照""地""图""的""既""定""路""线""执""行""任""务""！""\n"];
	symbol=["|"];
}

function test_text() {
	local text = Entities.CreateByClassname("game_text");
    text.__KeyValueFromFloat("x", 0.05);
    text.__KeyValueFromFloat("y", 0.05);
    text.__KeyValueFromString("channel", "1");
	text.__KeyValueFromString("effect","0");
    text.__KeyValueFromString("color", "82 196 26");
    text.__KeyValueFromString("spawnflags","1");
    text.__KeyValueFromString("holdtime","5");
	text.__KeyValueFromString("fadein","0");
	text.__KeyValueFromString("fadeout","1");
	//text.__KeyValueFromString("fxtime","1");
	local output = "";
	local num = text_input.maintain.len().tofloat();
	local relay = 0.0;
	for(local j=0.0;j<num;j++)
	{
		if(j==num-1) EntFireByHandle(text, "SetText", output+=text_input.maintain[j], relay, null, null);
		else EntFireByHandle(text, "SetText", output+=text_input.maintain[j]+text_input.symbol[RandomInt(0, 0)], relay, null, null);
    	EntFireByHandle(text, "Display", " ", relay, null, null);
		output = output.slice(0,-1);
		if(text_input.maintain[j] == "\n") relay += 1.5;
        else relay += 0.1;
	}
    EntFireByHandle(text, "kill", " ", relay+2.5, null, null);
}

test_warn_count <- 5;
function test_warn() {
    if(test_warn_count > 0)
    {
        local string = ("\xB \xB[Npst_Race] \x4任务还有\x2 " + test_warn_count + " \x4秒开启！").tostring();
        ScriptPrintMessageCenterAll("<font color='#52c41a'>任务还有</font><font color='#FF0000'>"+test_warn_count+"</font><font color='#52c41a'>秒开启！</font>");
        test_warn_count--;
        ScriptPrintMessageChatAll(string);
        EntFire("logic_script", "RunScriptCode", "test_warn()", 1.0, null);
    }
    else if(test_warn_count == 0)
    {
        ScriptPrintMessageChatAll("\xB \xB[Npst_Race] \x2GO! GO! GO!");
        ScriptPrintMessageCenterAll("<font color='#FF0000'>GO! GO! GO!</font>");
    }
    else return;
}

//////////////////////////
/////////end_time/////////
//////////////////////////
function SayGoodBye() {
    local target_candidates = [];
	for(local h;h=Entities.FindByClassname(h,"player");)
	{
		if(h.GetName()=="escaper"||h==null||!h.IsValid()||h.GetHealth()<=0) continue;
		target_candidates.push(h);
	}
    for(local h;h=Entities.FindByClassname(h,"cs_bot");)
	{
		if(h.GetName()=="escaper"||h==null||!h.IsValid()||h.GetHealth()<=0) continue;
		target_candidates.push(h);
	}
	if(target_candidates.len()<=0) return;
	for(local a = 0; a < target_candidates.len(); a++)
    {
        EntFireByHandle(target_candidates[a], "SetHealth", "-1", 0.0, null, null);
    }
}