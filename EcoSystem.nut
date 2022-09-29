::OnGameEvent_round_end <- function ( event ) {

}
::OnGameEvent_round_start <- function ( event ) {
    economy <- 0;
	economymax <- 0;
}
EcoSystem_maker_toggle <- true;
class EcoSystem_cost_hud_list
{
    title="λ传送支援贩卖机，请在使用完毕后记得销毁，感谢您的使用";
    num=4;
    main_option=
    [
        "购买物品"
		"购买增益"
		"销毁此处贩卖机便于下次投放"
		"退出贩卖机界面"
    ];
	shop_option=
	[
		"2点-护盾"
        "4点-支援"
        "99点-？"
		"返回主界面"
	]
	buff_option=
	[
		"2点-治疗"
        "2点-加速"
        "2点-破坏"
		"返回主界面"
	]
}
posMax <- EcoSystem_cost_hud_list.num;
option_toggle <- 0;//界面toggle，0为main，1为shop，2为buff

EcoSystem_ui <- Entities.FindByName(null, "EcoSystem_ui");
EcoSystem_cost_hud <- Entities.FindByName(null, "EcoSystem_cost_hud");
command <- Entities.FindByName(null, "command");

death <- null;
killer <- null;
::OnGameEvent_player_death <- function ( event ){
    local killer = event.weapon;
    killer=killer.tostring();
    if(killer=="ak47"||killer=="aug"||killer=="awp"||killer=="bizon"||killer=="cz75a"||killer=="deagle"||killer=="elite"||killer=="famas"||killer=="fiveseven"||killer=="g3sg1"||killer=="galilar"||killer=="glock"||killer=="hegrenade"||killer=="hkp2000"||killer=="m249"||killer=="m4a1"||killer=="m4a1_silencer"||killer=="mac10"||killer=="mag7"||killer=="molotov"||killer=="mp5sd"||killer=="mp7"||killer=="mp9"||killer=="negev"||killer=="nova"||killer=="p250"||killer=="p90"||killer=="revolver"||killer=="sawedoff"||killer=="scar20"||killer=="sg556"||killer=="ssg08"||killer=="tec9"||killer=="ump45"||killer=="usp_silencer"||killer=="xm1014"){
        economy++;economymax++;
    }
}

function EconomyCount(){
	local zm_speed;
	if(zm_speed < 1.5) zm_speed=log10(economymax*0.01+1)+1;
	else zm_speed = 1.5;
	EntFire("EcoSystem_hud", "SetText", "经济补给: "+economy.tostring()+"\n僵尸速度倍率："+zm_speed.tostring()+"X", 0.00, self);
	EntFire("EcoSystem_hud", "Display", "", 0.02, self);
	EntFireByHandle(self, "RunScriptCode", " EconomyCount(); ", 0.20, null, null);
	pl <- null;
	while(null != (pl = Entities.FindByClassname(pl, "player"))){
	if(pl.GetMaxHealth() >= 1000){
			EntFire("player_speedmod", "ModifySpeed", zm_speed, 0.0, pl);
			//EntFireByHandle(pl, "AddOutput", "gravity 1", 0.0, null, null);//TOO IMBA
		}
	}
}

EcoSystem_cost_user <- null;
EcoSystem_use_toggle <- false;
controllable <- true;
pos <- 0;

function Tick()
{
	UpdateText();
}

function IsMakerToggle()
{
	if(Entities.FindByName(null, "EcoSystem_cost")==null)
	{
		EntFire("EcoSystem_cost_summon_button","FireUser1"," ",0.0,-1);
		EcoSystem_maker_toggle = false;
	}
	else ScriptPrintMessageChatAll("无法发送新的贩卖机，因为旧的贩卖机没有被回收！");
}
function UseEcoSystem_cost()
{
    EcoSystem_cost_user = activator;
    if(EcoSystem_use_toggle != true && activator.GetTeam()==3)
    {
        EntFire("EcoSystem_cost_hud", "SetText", "买东西不？", 0.00, self);
        EntFire("EcoSystem_cost_hud", "Display", " ", 0.0, EcoSystem_cost_user);
        /*if (activator == EcoSystem_cost_user && EcoSystem_cost_user.IsValid())
	    {
		    controllable = true;
	    }*/
		EcoSystem_ui.ConnectOutput("PlayerOn", "PlayerOn");
		EcoSystem_ui.ConnectOutput("PlayerOff", "PlayerOff");
		EcoSystem_ui.ConnectOutput("PressedForward", "PressedForward");
		EcoSystem_ui.ConnectOutput("PressedBack", "PressedBack");
		EcoSystem_ui.ConnectOutput("PressedAttack", "PressedAttack");
        EntFireByHandle(EcoSystem_ui,"Activate","",0.0,EcoSystem_cost_user,null);
        EcoSystem_cost_hud.__KeyValueFromString("holdtime","30.0");
		EcoSystem_cost_hud.__KeyValueFromString("channel","5");
	    EcoSystem_cost_hud.__KeyValueFromString("color","255 255 255");
	    EcoSystem_cost_hud.__KeyValueFromString("color2","255 255 255");
    }
}

function UpdateText()
{
    local msg = EcoSystem_cost_hud_list.title+"\n\n";
	if(option_toggle==0){
		for (local i=0; i<posMax; i++)
		{
			if (pos == i)
			{
				msg += "-->"+EcoSystem_cost_hud_list.main_option[i]+"\n";
			}
			else
			{
				msg += EcoSystem_cost_hud_list.main_option[i]+"\n";
			}
		}
	}
	else if(option_toggle==1){
		for (local i=0; i<posMax; i++)
		{
			if (pos == i)
			{
				msg += "-->"+EcoSystem_cost_hud_list.shop_option[i]+"\n";
			}
			else
			{
				msg += EcoSystem_cost_hud_list.shop_option[i]+"\n";
			}
		}
	}
	else if(option_toggle==2){
		for (local i=0; i<posMax; i++)
		{
			if (pos == i)
			{
				msg += "-->"+EcoSystem_cost_hud_list.buff_option[i]+"\n";
			}
			else
			{
				msg += EcoSystem_cost_hud_list.buff_option[i]+"\n";
			}
		}
	}
	else printl("你是怎么触发这条提示的？");
	EntFireByHandle(EcoSystem_cost_hud, "AddOutput", "message "+msg, 0.0,null,null);
	EntFireByHandle(EcoSystem_cost_hud, "Display", " ", 0.05,activator,null);
}

function PlayerOn()
{
	UpdateText();
}

function PlayerOff()
{
	EcoSystem_use_toggle = true;
	ScriptPrintMessageChatAll("Say GoodBye");
}

function PressedForward()
{
	if (!controllable) return;
	if (pos > 0) pos--;
	else pos = posMax-1;
	UpdateText();
	EntFireByHandle(command, "Command", "play 7ychu5/flashlight1.wav", 0.0, activator,null);
}

function PressedBack()
{
	if (!controllable) return;
	if (pos < posMax-1) pos++;
	else pos = 0;
	UpdateText();
	EntFireByHandle(command, "Command", "play 7ychu5/flashlight1.wav", 0.0, activator,null);
}

function PressedAttack()
{
	if (!controllable) return;

	UpdateText();
	if(option_toggle==0){
		switch(pos){
			case 0:pos=0;option_toggle=1;EntFireByHandle(command, "Command", "play 7ychu5/flashlight1.wav", 0.0, activator,null);UpdateText();break;
			case 1:pos=0;option_toggle=2;EntFireByHandle(command, "Command", "play 7ychu5/flashlight1.wav", 0.0, activator,null);UpdateText();break;
			case 2:{
				EntFire("EcoSystem_cost_button","kill"," ",0.0,-1);
				EntFire("EcoSystem_cost_particle_jet","kill"," ",0.0,-1);
				EntFire("EcoSystem_cost","kill"," ",1.0,-1);
				HideHud();
				EntFireByHandle(command, "Command", "play 7ychu5/XPshutdown.wav", 0.0, activator,null);
				break;
			}
			case 3:{
				HideHud();
				EntFireByHandle(command, "Command", "play 7ychu5/battery_pickup.wav", 0.0, activator,null);
				break;
			}
			default:break;
		}
	}
	else if(option_toggle==1){
		switch(pos){
		case 0:
			if(economy-2>=0 && activator.IsValid())
			{
				ScriptPrintMessageChatAll("λ实验小组感谢您的购买");
				economy-=2;
				local spawner = Entities.CreateByClassname("env_entity_maker");
				spawner.__KeyValueFromString("EntityTemplate", "barrier_wooden_maker_template");
				spawner.SpawnEntityAtLocation(activator.GetOrigin(), Vector(0, 0, 0));
				EntFireByHandle(command, "Command", "play 7ychu5/battery_pickup.wav", 0.0, activator,null);
			}
			else
			{
				ScriptPrintMessageChatAll("没钱买你妈逼？");
				EntFireByHandle(command, "Command", "play 7ychu5/medshotno1.wav", 0.0, activator,null);
			}
			HideHud();
			break;
		case 1:
			if(economy-4>=0 && activator.IsValid())
			{
				ScriptPrintMessageChatAll("λ实验小组感谢您的购买");
				economy-=4;
				local spawner = Entities.CreateByClassname("env_entity_maker");
				spawner.__KeyValueFromString("EntityTemplate", "item_AirStrikeSummoner_template");
				spawner.SpawnEntityAtLocation(activator.GetOrigin(), Vector(0, 0, 0));
				EntFireByHandle(command, "Command", "play 7ychu5/battery_pickup.wav", 0.0, activator,null);
			}
			else
			{
				ScriptPrintMessageChatAll("没钱买你妈逼？");
				EntFireByHandle(command, "Command", "play 7ychu5/medshotno1.wav", 0.0, activator,null);
			}
			HideHud();
			break;
		case 2:
			if(economy-99>=0 && activator.IsValid())
			{
				ScriptPrintMessageChatAll("λ实验小组感谢您的购买");
				economy-=99;
				local spawner = Entities.CreateByClassname("env_entity_maker");
				spawner.__KeyValueFromString("EntityTemplate", "item_Sacrifice_maker_template");
				spawner.SpawnEntityAtLocation(activator.GetOrigin(), Vector(0, 0, 0));
				EntFireByHandle(command, "Command", "play 7ychu5/battery_pickup.wav", 0.0, activator,null);
			}
			else
			{
				ScriptPrintMessageChatAll("没钱买你妈逼？");
				EntFireByHandle(command, "Command", "play 7ychu5/medshotno1.wav", 0.0, activator,null);
			}
			HideHud();
			break;
		case 3:option_toggle=0;EntFireByHandle(command, "Command", "play 7ychu5/flashlight1.wav", 0.0, activator,null);UpdateText();break;
		default:break;
	}
	//EntFireByHandle(self, "RunScriptCode", "SetCanPressAttack()", 0.02,null,null);
	}
	else if(option_toggle==2){
		switch(pos){
		case 0:
			if(economy-2>=0 && activator.IsValid())
			{
				ScriptPrintMessageChatAll("λ实验小组感谢您的购买");
				economy-=2;
				local spawner = Entities.CreateByClassname("env_entity_maker");
				spawner.__KeyValueFromString("EntityTemplate", "item_heal_template");
				spawner.SpawnEntityAtLocation(activator.GetOrigin(), Vector(0, 0, 0));
				EntFireByHandle(command, "Command", "play 7ychu5/battery_pickup.wav", 0.0, activator,null);
			}
			else
			{
				ScriptPrintMessageChatAll("没钱买你妈逼？");
				EntFireByHandle(command, "Command", "play 7ychu5/medshotno1.wav", 0.0, activator,null);
			}
			HideHud();
			break;
		case 1:
			if(economy-2>=0 && activator.IsValid())
			{
				ScriptPrintMessageChatAll("λ实验小组感谢您的购买");
				economy-=2;
				local spawner = Entities.CreateByClassname("env_entity_maker");
				spawner.__KeyValueFromString("EntityTemplate", "item_speed_template");
				spawner.SpawnEntityAtLocation(activator.GetOrigin(), Vector(0, 0, 0));
				EntFireByHandle(command, "Command", "play 7ychu5/battery_pickup.wav", 0.0, activator,null);
			}
			else
			{
				ScriptPrintMessageChatAll("没钱买你妈逼？");
				EntFireByHandle(command, "Command", "play 7ychu5/medshotno1.wav", 0.0, activator,null);
			}
			HideHud();
			break;
		case 2:
			if(economy-2>=0 && activator.IsValid())
			{
				ScriptPrintMessageChatAll("λ实验小组感谢您的购买");
				economy-=2;
				local spawner = Entities.CreateByClassname("env_entity_maker");
				spawner.__KeyValueFromString("EntityTemplate", "item_hurt_template");
				spawner.SpawnEntityAtLocation(activator.GetOrigin(), Vector(0, 0, 0));
				EntFireByHandle(command, "Command", "play 7ychu5/battery_pickup.wav", 0.0, activator,null);
			}
			else
			{
				ScriptPrintMessageChatAll("没钱买你妈逼？");
				EntFireByHandle(command, "Command", "play 7ychu5/medshotno1.wav", 0.0, activator,null);
			}
			HideHud();
			break;
		case 3:option_toggle=0;EntFireByHandle(command, "Command", "play 7ychu5/flashlight1.wav", 0.0, activator,null);UpdateText();break;
		default:break;
	}
	}
}
function HideHud()
{
	option_toggle=0;pos=0;
	EntFireByHandle(EcoSystem_cost_hud, "AddOutput", "message ", 0.0,null,null);
	EntFireByHandle(EcoSystem_cost_hud, "Display", " ", 0.05,activator,null);
	EntFireByHandle(EcoSystem_ui,"Deactivate"," ",0.0,activator,null);
}
