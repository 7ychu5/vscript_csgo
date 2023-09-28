IncludeScript("vs_library.nut");
SCRIPT_OWNER <- "7ychu5";
SCRIPT_TIME <- "2023年7月25日10点06分";
SCRIPT_MAP <- "playmaster";
SCRIPT_VERISON <- "0.1";

menu_switch <- "buttons/lightswitch2.wav";
menu_confirm <- "buttons/lightswitch2.wav";
menu_deny <- "buttons/lightswitch2.wav";

tablet_model <- "models/7ychu5/weapons/v_tablet.mdl"

self.PrecacheScriptSound(menu_switch);
self.PrecacheScriptSound(menu_confirm);
self.PrecacheScriptSound(menu_deny);
self.PrecacheModel(tablet_model);

class menu_hud_list
{
    title="PlayMaster";

    main_option=[
        "模式选择"
		"枪械选择"
		"强制退出当前模式"
		"退出菜单"
    ];
	mode_option=[
		"跟枪"
        "KPM"
        "弹道修正"
		"甩狙"
		"听声辩位"
		"瞄准练习"
		"单面AIM场地"
		"返回主界面"
	]
	weapon_option=[
		"步枪"
        "冲锋枪"
        "狙击枪"
		"返回主界面"
	]
	weapon_rifle_option=[
		"AK47"
		"M4A1-Silencer"
		"M4A4"
		"Galil"
		"Famas"
		"Aug"
		"SG553"
		"返回枪械种类"
	]
	weapon_smg_option=[
		"MAC-10"
		"MP9"
		"MP7"
		"UMP45"
		"MP5SD"
		"PP-BIZON"
		"P90"
		"CZ75a"
		"返回枪械种类"
	]
	weapon_sniper_option=[
		"ssg08"
		"AWP"
		"SCAR20"
		"G3GS1"
		"返回枪械种类"
	]
}


option_toggle <- "main_option";
posMax <- 0;
pos <- 0;
menu_ui <- null;
menu_hud <- null;
user <- null;


menu_hud <- Entities.CreateByClassname("game_text");
menu_hud.__KeyValueFromString("targetname", "menu_hud");
menu_hud.__KeyValueFromString("effect", "0");
menu_hud.__KeyValueFromString("fadein", "0");
menu_hud.__KeyValueFromString("fadeout", "0");
menu_hud.__KeyValueFromString("holdtime", "1");
menu_hud.__KeyValueFromString("x", "0.33");
menu_hud.__KeyValueFromString("y", "0.27");
menu_hud.__KeyValueFromString("color", "255 255 255");
menu_hud.__KeyValueFromString("channel", "5");
menu_hud.__KeyValueFromString("spawnflags", "1");

if(user == null || user != null && !user.IsValid()){user = Entities.FindByName(null, "user");}
if(menu_ui == null || menu_ui != null && !menu_ui.IsValid()){menu_ui = Entities.FindByName(null, "menu_ui");}
if(menu_hud == null || menu_hud != null && !menu_hud.IsValid()){menu_hud = Entities.FindByName(null, "menu_hud");}


VS.ListenToGameEvent( "item_equip", function( event )
{
	local player = VS.GetPlayerByUserid(event.userid);
	if(player.IsValid() && player.GetHealth() > 0 && player.GetTeam() == 3)
	{
		if(event.item == "tablet"){
			EntFire("menu_ui", "RunScriptcode", "menu_start();", 0.0, null);
		}
		// else{
		// 	EntFire("menu_ui", "RunScriptcode", "ForceStop();", 0.0, null);
		// }
	}
}, "listen_item_equip" );

function menu_start() {
	menu_ui.ConnectOutput("PlayerOn", "PlayerOn");
	menu_ui.ConnectOutput("PlayerOff", "PlayerOff");
	menu_ui.ConnectOutput("PressedForward", "PressedForward");
	menu_ui.ConnectOutput("PressedBack", "PressedBack");
	menu_ui.ConnectOutput("PressedAttack", "PressedAttack");

	local ent;
	while((ent = Entities.FindByClassname(ent, "*") ) != null)
	{
		if(ent.GetClassname() == "predicted_viewmodel")
		{
			if(ent.GetModelName().find("tablet", 0) != null)
			{
				ent.SetModel(tablet_model);
			}
		}
	}
	EntFireByHandle(menu_ui, "Activate", "", 0.0, user, null);

	menu_hud.__KeyValueFromString("holdtime","30.0");
	menu_hud.__KeyValueFromString("channel","5");
	EntFireByHandle(menu_hud, "SetText", menu_hud_list.title, 0.0, user, null);
	EntFireByHandle(menu_hud, "Display", "", 0.0, user, null);
}

function PlayerOn()
{
	option_toggle <- "main_option";
	posMax <- 0;
	pos <- 0;
	ScriptPrintMessageChatAll("菜单上线");
	UpdateText();
}

function PlayerOff()
{
	//EcoSystem_use_toggle = true;
	ScriptPrintMessageChatAll("菜单下线");
	HideHud();
}

function PressedForward()
{
	//if (!controllable) return;
	if (pos > 0) pos--;
	else pos = posMax-1;
	UpdateText();
	self.EmitSound(menu_switch);
}

function PressedBack()
{
	//if (!controllable) return;
	if (pos < posMax-1) pos++;
	else pos = 0;
	UpdateText();
	self.EmitSound(menu_switch);
}

function PressedAttack()
{
	UpdateText();
	switch (option_toggle) {
		case "main_option":
			switch (pos) {
				case 0:
					option_toggle <- "mode_option";
					pos = 0;UpdateText();
					break;
				case 1:
					option_toggle <- "weapon_option";
					pos = 0;UpdateText();
					break;
				case 2:
					EntFire("logic_script", "RunScriptcode", "::MODE_TYPE <- 1;::SpawnBot();", 0.0, user);
					EntFireByHandle(user, "SetHealth", "-1", 0.0, null);
					ForceStop();
					break;
				case 3:
					ForceStop();
					break;
			}
			break;
		case "mode_option":
			switch (pos) {
				case 0:
					EntFire("logic_script", "RunScriptcode", "track_mode_on();", 0.0, user);
					ForceStop();
					break;
				case 1:
					EntFire("logic_script", "RunScriptcode", "aim_mode_on();", 0.0, user);
					ForceStop();
					break;
				case 2:
					EntFire("logic_script", "RunScriptcode", "spary_mode_on();", 0.0, user);
					ForceStop();
					break;
				case 3:
					EntFire("logic_script", "RunScriptcode", "flick_mode_on();", 0.0, user);
					ForceStop();
					break;
				case 4:
					EntFire("logic_script", "RunScriptcode", "perceive_mode_on();", 0.0, user);
					ForceStop();
					break;
				case 5:
					EntFire("logic_script", "RunScriptcode", "aim_ball_mode_on();", 0.0, user);
					ForceStop();
					break;
				case 6:
					user.SetOrigin(Vector(3700, 2556, 462));
					user.SetAngles(0 90 0);
					ForceStop();
					break;
				case 7:
					option_toggle <- "main_option";
					pos = 0;UpdateText();
					break;
			}
			break;
		case "weapon_option":
			switch (pos) {
				case 0:
					option_toggle <- "weapon_rifle_option";
					pos = 0;UpdateText();
					break;
				case 1:
					option_toggle <- "weapon_smg_option";
					pos = 0;UpdateText();
					break;
				case 2:
					option_toggle <- "weapon_sniper_option";
					pos = 0;UpdateText();
					break;
				case 3:
					option_toggle <- "main_option";
					pos = 0;UpdateText();
					break;
			}
			break;
		case "weapon_rifle_option":
			switch (pos) {
				case 0:
					EntFire("btn_weapon_ak47", "press", "", 0.0, user);
					ForceStop();
					break;
				case 1:
					EntFire("btn_weapon_m4a1_silencer", "press", "", 0.0, user);
					ForceStop();
					break;
				case 2:
					EntFire("btn_weapon_m4a1", "press", "", 0.0, user);
					ForceStop();
					break;
				case 3:
					EntFire("btn_weapon_galilar", "press", "", 0.0, user);
					ForceStop();
					break;
				case 4:
					EntFire("btn_weapon_famas", "press", "", 0.0, user);
					ForceStop();
					break;
				case 5:
					EntFire("btn_weapon_aug", "press", "", 0.0, user);
					ForceStop();
					break;
				case 6:
					EntFire("btn_weapon_sg556", "press", "", 0.0, user);
					ForceStop();
					break;
				case 7:
					option_toggle <- "weapon_option";
					pos = 0;UpdateText();
					break;
			}
			break;
		case "weapon_smg_option":
			switch (pos) {
				case 0:
					EntFire("btn_weapon_mac10", "press", "", 0.0, user);
					ForceStop();
					break;
				case 1:
					EntFire("btn_weapon_mp9", "press", "", 0.0, user);
					ForceStop();
					break;
				case 2:
					EntFire("btn_weapon_mp7", "press", "", 0.0, user);
					ForceStop();
					break;
				case 3:
					EntFire("btn_weapon_ump45", "press", "", 0.0, user);
					ForceStop();
					break;
				case 4:
					EntFire("btn_weapon_mp5sd", "press", "", 0.0, user);
					ForceStop();
					break;
				case 5:
					EntFire("btn_weapon_bizon", "press", "", 0.0, user);
					ForceStop();
					break;
				case 6:
					EntFire("btn_weapon_p90", "press", "", 0.0, user);
					ForceStop();
					break;
				case 7:
					EntFire("btn_weapon_cz75a", "press", "", 0.0, user);
					ForceStop();
					break;
				case 8:
					option_toggle <- "weapon_option";
					pos = 0;UpdateText();
					break;
			}
			break;

		case "weapon_sniper_option":
			switch (pos) {
				case 0:
					EntFire("btn_weapon_ssg08", "press", "", 0.0, user);
					ForceStop();
					break;
				case 1:
					EntFire("btn_weapon_awp", "press", "", 0.0, user);
					ForceStop();
					break;
				case 2:
					EntFire("btn_weapon_scar20", "press", "", 0.0, user);
					ForceStop();
					break;
				case 3:
					EntFire("btn_weapon_g3gs1", "press", "", 0.0, user);
					ForceStop();
					break;
				case 8:
					option_toggle <- "weapon_option";
					pos = 0;UpdateText();
					break;
			}
			break;

		case "example_option":
			switch (pos) {
				case 0:
					break;
				case 1:
					break;
				case 2:
					break;
				case 3:
					break;
				case 4:
					break;
			}
			break;
		default:
			break;
	}
}
function UpdateText()
{
    local msg = menu_hud_list.title+"\n\n";

	switch (option_toggle) {
		case "main_option":
			posMax <- menu_hud_list.main_option.len();
			for (local i=0; i<posMax; i++){
				if (pos == i) msg += menu_hud_list.main_option[i]+"<--"+"\n";
				else msg += menu_hud_list.main_option[i]+"\n";
			}
			break;
		case "mode_option":
			posMax <- menu_hud_list.mode_option.len();
			for (local i=0; i<posMax; i++){
				if (pos == i) msg += menu_hud_list.mode_option[i]+"<--"+"\n";
				else msg += menu_hud_list.mode_option[i]+"\n";
			}
			break;
		case "weapon_option":
			posMax <- menu_hud_list.weapon_option.len();
			for (local i=0; i<posMax; i++){
				if (pos == i) msg += menu_hud_list.weapon_option[i]+"<--"+"\n";
				else msg += menu_hud_list.weapon_option[i]+"\n";
			}
			break;
		case "weapon_rifle_option":
			posMax <- menu_hud_list.weapon_rifle_option.len();
			for (local i=0; i<posMax; i++){
				if (pos == i) msg += menu_hud_list.weapon_rifle_option[i]+"<--"+"\n";
				else msg += menu_hud_list.weapon_rifle_option[i]+"\n";
			}
			break;
		case "weapon_smg_option":
			posMax <- menu_hud_list.weapon_smg_option.len();
			for (local i=0; i<posMax; i++){
				if (pos == i) msg += menu_hud_list.weapon_smg_option[i]+"<--"+"\n";
				else msg += menu_hud_list.weapon_smg_option[i]+"\n";
			}
			break;
		case "weapon_sniper_option":
			posMax <- menu_hud_list.weapon_sniper_option.len();
			for (local i=0; i<posMax; i++){
				if (pos == i) msg += menu_hud_list.weapon_sniper_option[i]+"<--"+"\n";
				else msg += menu_hud_list.weapon_sniper_option[i]+"\n";
			}
			break;
		default:
			printl("又炸了......");
			break;
	}
	EntFireByHandle(menu_hud, "AddOutput", "message "+msg, 0.0,null,null);
	EntFireByHandle(menu_hud, "Display", " ", 0.05,user,null);
}

function HideHud() {
	EntFireByHandle(menu_hud, "SetText", "", 0.0, null, null);
	EntFireByHandle(menu_hud, "Display", "", 0.02, user, null);
}

function ForceStop() {
	EntFireByHandle(menu_ui, "Deactivate", "", 0.0, user, null);
	HideHud();
	//SendToConsole("slot3");
}
