//////////////////////////////
////////////shenle////////////
//////////////////////////////

//Format: <output name> <targetname>,<inputname>,<parameter>,<delay>,<max times to fire (-1 == infinite)>
//void EntFireByHandle(handle target, string action, string 'value, float delay, handle activator, handle caller)
shenle_Owner <- null;
function Pickup_shenle()
{
	shenle_Owner = activator;
    EntFireByHandle(shenle_Owner, "AddOutput", "rendermode 10", 0.0, null, null);
}
function attack1_shenle()
{

}
function attack2_shenle()
{

}
function Slay_shenle()
{
	EntFireByHandle(shenle_Owner, "SetHealth", "-99999", 0.0, null, null);
	EntFireByHandle(shenle_Owner, "SetDamageFilter", "", 0.0, null, null);
	EntFireByHandle(shenle_Owner, "AddOutput", "max_health 20000", 0.0, null, null);
	EntFireByHandle(shenle_Owner, "AddOutput", "rendermode 0", 0.0, null, null);
	EntFireByHandle(shenle_Owner, "AddOutput", "targetname  ", 0.0, null, null);
}