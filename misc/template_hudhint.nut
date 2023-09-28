IncludeScript("7ychu5/utils.nut")

function PreSpawnInstance( entityClass, entityName )
{
	local keyvalues =
	{
   		targetname = "hudhint_"+RandomInt(100000, 999999)
        message = "#SFUI_Notice_Escaping_Terrorists_Neutralized"
	}
	return keyvalues
}

function PostSpawn( entities )
{
	foreach( name, handle in entities )
	{
        EntFireByHandle(handle, "showhudhint", "", 0.00, null, null);
	}
}