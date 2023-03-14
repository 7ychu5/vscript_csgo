IncludeScript("vs_library")
IncludeScript("glow")

ScriptPrintMessageChatAll("seward脚本已载入")
//===================================================================
//              SCRIPT BY SEWARD
//              VERSION: 0.0.1
//              TIME:2023/2/24  01:26
//===================================================================

// Collect and register game event callbacks prefixed with "OnGameEvent_" in the root
function OnPostSpawn()
{
	foreach( k,v in getroottable() )
	{
		if ( typeof v != "function" )
			continue;

		if ( k.find("OnGameEvent_") == null )
			continue;

		local event = k.slice(12);
		VS.ListenToGameEvent( event, v, "GameEventCallbacks" );
	}

    ScriptPrintMessageChatAll("地图默认事件已加载,该方法在游戏开始时运行")
}



//=============================================
//  EVENT: bullet_impact
//
//
//=============================================

VS.ListenToGameEvent( "bullet_impact", function( event )
{
	local position = Vector( event.x, event.y, event.z );
	local player = VS.GetPlayerByUserid( event.userid );

    

    
   
}.bindenv(this), "" );


//=============================================
//  EVENT: player_say
//
//
//=============================================

VS.ListenToGameEvent( "player_say", function( event )
{
     ScriptPrintMessageChatAll("==============分割线============")
    foreach ( k,v in VS.GetAllPlayers() ){
        
        ScriptPrintMessageChatAll(k+ ":" + v)
        
    }
    ScriptPrintMessageChatAll("==========================")
    

    local player = ToExtendedPlayer( VS.GetPlayerByIndex(1) );

    EntFireByHandle( player.self, "SetHealth", 1 );

    local tr = TraceLine( v1, v2, player.self, MASK_SOLID );

}, "" );

//=============================================
//
//  EVENT: player_connect
//
//=============================================

VS.ListenToGameEvent( "player_connect", function( event )
{
    
}, "" );

//=============================================
//
//  EVENT: grenade_bounce  投掷物弹起
//
//=============================================

VS.ListenToGameEvent( "grenade_bounce", function( event )
{
    local owner =  VS.GetPlayerByUserid( event.userid );
    local pos;
    local ent;
    while( ent = Entities.FindByClassname(ent,"flashbang_projectile") ){
        if (ent.GetOwner() == owner){
            pos = ent.GetOrigin();

            foreach ( ply in VS.GetAllPlayers() ){
                local dist = (ply.GetCenter() - pos).Length();
                if( dist < 256.0 ){
                    Glow.Set( ply,"255 0 0",0,2048.0 );
                    VS.EventQueue.AddEvent( Glow.Disable, 5.0 , [null,ply] )
                }
            }

            ent.Destroy();
            break;
        }
    }
    if(pos){
        VS.DrawSphere( pos,256.0,16,16,255,255,255,false,5.0 );
    }

}, "" );

//=============================================
//
//  EVENT: player_ping  鼠标中间标记
//
//=============================================

VS.ListenToGameEvent( "player_ping", function( event )
{
    local position = Vector( event.x, event.y, event.z );
	local player = VS.GetPlayerByUserid( event.userid );

    if(position){
        VS.DrawSphere( position,32,16,16,255,0,0,false,5 );
    }


    player.SetHealth(1000)
    

}, "" );








const PLAYER_INPUT_CONTEXT = "";
VS.ListenToGameEvent( "player_spawn", function(ev)
{
    local player = ToExtendedPlayer( VS.GetPlayerByUserid( ev.userid ) );
	if ( !player )
		return;

    //如果玩家不是BOT
	if ( !player.IsBot() )
	{
		VS.SetInputCallback( player, "+forward",  OnForwardPressed, PLAYER_INPUT_CONTEXT );
		VS.SetInputCallback( player, "-forward",  OnForwardReleased, PLAYER_INPUT_CONTEXT );

        VS.SetInputCallback( player, "+back",  OnBackPressed, PLAYER_INPUT_CONTEXT );
		VS.SetInputCallback( player, "-back",  OnBackReleased, PLAYER_INPUT_CONTEXT );

        VS.SetInputCallback( player, "+moveleft",  OnLeftPressed, PLAYER_INPUT_CONTEXT );
		VS.SetInputCallback( player, "-moveleft",  OnLeftReleased, PLAYER_INPUT_CONTEXT );

        VS.SetInputCallback( player, "+moveright",  OnRightPressed, PLAYER_INPUT_CONTEXT );
		VS.SetInputCallback( player, "-moveright",  OnRightReleased, PLAYER_INPUT_CONTEXT );

        VS.SetInputCallback( player, "+attack", OnAttack, PLAYER_INPUT_CONTEXT );
        VS.SetInputCallback( player, "-attack", OnAttackReleased, PLAYER_INPUT_CONTEXT );

        VS.SetInputCallback( player, "+attack2", OnAttack2, PLAYER_INPUT_CONTEXT );
        VS.SetInputCallback( player, "-attack2", OnAttack2Released, PLAYER_INPUT_CONTEXT );

        VS.SetInputCallback( player, "+use",  OnUsePressed, PLAYER_INPUT_CONTEXT );
	}

	



}.bindenv(this), "" );




//======================= 分割线 ==========================
// 脚本中这种监听方法是使用game_ui 来实现的,暂时不清楚有什么奇怪的情况
// 下面的代码是用来监听玩家的基础操作:


//第一开火按键
function OnAttack( player )
{
    
}

function OnAttackReleased( player )
{

}

//辅助攻击按键
function OnAttack2( player )
{

}

function OnAttack2Released( player )
{

}

//按下/松开直线前进

function OnForwardPressed( player )
{

}

function OnForwardReleased( player )
{

}

//按下/松开后退

function OnBackPressed( player )
{

}

function OnBackReleased( player )
{

}

//按下/松开左右按键

function OnLeftPressed( player )
{

}

function OnLeftReleased( player )
{

}



function OnRightPressed(player)
{

}

function OnRightReleased(player)
{

}

function OnUsePressed(player)
{

}


//========================== 分割线 =====================================

	


function Think()
{
    local player = ToExtendedPlayer( VS.GetPlayerByIndex(1) );
	local tr = VS.TraceDir( player.EyePosition(), player.EyeForward(), MAX_COORD_FLOAT, player.self, MASK_SOLID );
	local normal = tr.GetNormal();
	local hitpos = tr.GetPos();

    // DebugDrawLine(Vector start, Vector end, int red, int green, int blue', bool zTest, float time)
	// DebugDrawBoxAngles( Vector start, Vector偏移, Vector MAX, VS.VectorAngles(normal), 0,0,255,255, 0.1 );
    DebugDrawBoxAngles( hitpos, Vector(0,-1,-1), Vector(16,1,1), VS.VectorAngles(normal), 0, 255, 0,255, 0.1 );
    DebugDrawBoxAngles( hitpos, Vector(0,-1,-1), Vector(1,16,1), VS.VectorAngles(normal), 0, 255, 0,255, 0.1 );
    DebugDrawBoxAngles( hitpos, Vector(0,-1,-1), Vector(1,1,16), VS.VectorAngles(normal), 0, 255, 0,255, 0.1 );
    DebugDrawBoxAngles( hitpos, Vector(0,-1,-1), Vector(1,-16,1), VS.VectorAngles(normal), 0, 255, 0,255, 0.1 );
    DebugDrawBoxAngles( hitpos, Vector(0,-1,-1), Vector(1,1,-16), VS.VectorAngles(normal), 0, 255, 0,255, 0.1 );
    DebugDrawLine( player.GetOrigin(),hitpos,0,255,0,false,0.1 )
}



//------------------------------
//
// Custom gun viewmodel
//
//------------------------------
VS.ListenToGameEvent( "item_equip", function(ev)
{
	local ply = VS.GetPlayerByUserid( ev.userid );
	if ( !ply ) return;

    ViewmodelChanger(ply);
}.bindenv(this), "" );

function ViewmodelChanger(ply){
    local model = null;

    //换第一人称
    while (model = Entities.FindByModel(model, "models/weapons/v_smg_bizon.mdl")) { // Original Weapon Model
        SetViewmodel( ply, model, "models/weapons/v_smg_mac10.mdl", 2);           // Custom Weapon Model
    }
    
    

    while (model = Entities.FindByModel(model, "models/weapons/w_smg_bizon_dropped.mdl")) { // WORLD MODEL DROPPED
        model.PrecacheModel("models/weapons/w_smg_mac10.mdl");                       // REGULAR WORLD MODEL DOES NOT WORK (w_smg_mp7.mdl)
        model.SetModel("models/weapons/w_smg_mac10.mdl");
    }

}

function SetViewmodel( ply, model, mdlPath, drawIndex ) {
    local viewmodel = Entities.FindByClassnameWithin(null, "predicted_viewmodel", ply.GetOrigin(), 4);
	local mdlName = viewmodel.GetModelName();

    model.PrecacheModel(mdlPath);
    model.SetModel(mdlPath);

	if(viewmodel.GetModelName() == mdlPath)
	{
		viewmodel.__KeyValueFromInt("sequence", drawIndex); // drawSeq represents the sequence index within the qc file, default is 3
	}

}
