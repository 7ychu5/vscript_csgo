self.PrecacheScriptSound("player/pl_respawn.wav");

VS.ListenToGameEvent( "player_say", function( event )
{

    if(event.text == "111"){
        foreach (k,v in VS.GetAllPlayers()) {
            printl(k+"="+v);
        }
        VS.SetName(VS.GetAllPlayers()[1],"bot")
        // local temp_ambient = Entities.CreateByClassname("ambient_generic");
        // temp_ambient.__KeyValueFromString("SourceEntityName", "bot");
        // temp_ambient.__KeyValueFromString("targetname", "temp_ambient");
        // temp_ambient.__KeyValueFromString("message", "player/pl_respawn.wav");
        EntFire("temp_ambient", "PlaySound", "", 0.0, null);
    }
}, "listen_player_chat" );