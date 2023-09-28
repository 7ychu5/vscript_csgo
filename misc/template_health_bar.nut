IncludeScript("7ychu5/utils.nut")

function PreSpawnInstance( entityClass, entityName )
{
	local keyvalues =
	{
   		rendermode = 2
		renderamt = 0
   		targetname = "health_bar_"+RandomInt(1000, 9999)
		disableshadows = 1
		disableshadowdepth = 1
		disablereceiveshadows = 1
		damagefilter = "filter_damage_fall"
		solid = 1
	}
	return keyvalues
}

function PostSpawn( entities )
{
	foreach( name, handle in entities )
	{
		//printl( name + ": " + handle )
        EntFireByHandle(handle, "Disablemotion", "", 0.0, null, null)
		//handle.SetSize(Vector(0,0,0), Vector(0,0,0))
	}
}