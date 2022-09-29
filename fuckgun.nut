function StartAimBot() {
    sentry <- Entities.FindByName(null,"sentry_main");
    local Target = Entities.FindByClassnameNearest( "player", sentry.GetOrigin(), 512 );
    if(Target != null) {
        local m_targetVector = Target.EyePosition();
        local m_sentryOrigin = sentry.GetOrigin();
        local m_dir = m_targetVector - m_sentryOrigin;

        local UCSX = sqrt(pow(m_dir.x,2)+pow(m_dir.y,2));
        local pitch = asin(m_dir.z / sqrt( pow(UCSX,2) + pow(m_dir.z,2) )) * 180 / PI * -1;
        local yaw = asin(m_dir.y / sqrt( pow(m_dir.x,2) + pow(m_dir.y,2) )) * 180 / PI;

        if(m_dir.x < 0)
            yaw = 180 - yaw;
        
        sentry.SetAngles(pitch,yaw,0);
        }
}
timer <- null

function OnTimer() 
{
	local scr = Entities.FindByName(null,"scr");
	EntFireByHandle( scr, "RunScriptCode", "StartAimBot()", 0, null, null );
}

// Called after the entity is spawned
function OnPostSpawn()
{
	if( timer == null )
	{
		timer = Entities.CreateByClassname( "logic_timer" );

		// set refire time
		timer.__KeyValueFromFloat( "RefireTime", 0.01 );

		timer.ValidateScriptScope();
		local scope = timer.GetScriptScope();
		
		// add a reference to the function;
		scope.OnTimer <- OnTimer;

		// connect the OnTimer output,
		// every time the timer fires the output, the function is executed;
		timer.ConnectOutput( "OnTimer", "OnTimer" );

		// start the timer
		EntFireByHandle( timer, "Enable", "", 0, null, null );
	}
}