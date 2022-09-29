//////////////////////////
///////puzzle_lamp////////
//////////////////////////
j <- 0;k <- 0;num1 <-0;
puzzle_lamp <- [];
for(j=0;j<5;j++){
    puzzle_lamp.push([]);
    for(k=0;k<5;k++){
        puzzle_lamp[j].push(false);
    }
}

function Press_puzzle_lamp1()
{
    j = 1;k = 1;Calc_puzzle_lamp(j,k);
}
function Press_puzzle_lamp2()
{
    j = 1;k = 2;Calc_puzzle_lamp(j,k);
}
function Press_puzzle_lamp3()
{
    j = 1;k = 3;Calc_puzzle_lamp(j,k);
}
function Press_puzzle_lamp4()
{
    j = 2;k = 1;Calc_puzzle_lamp(j,k);
}
function Press_puzzle_lamp5()
{
    j = 2;k = 2;Calc_puzzle_lamp(j,k);
}
function Press_puzzle_lamp6()
{
    j = 2;k = 3;Calc_puzzle_lamp(j,k);
}
function Press_puzzle_lamp7()
{
    j = 3;k = 1;Calc_puzzle_lamp(j,k);
}
function Press_puzzle_lamp8()
{
    j = 3;k = 2;Calc_puzzle_lamp(j,k);
}
function Press_puzzle_lamp9()
{
    j = 3;k = 3;Calc_puzzle_lamp(j,k);
}
function Calc_puzzle_lamp(j,k) {
    puzzle_lamp[j][k]=!puzzle_lamp[j][k];
    puzzle_lamp[j-1][k]=!puzzle_lamp[j-1][k];
    puzzle_lamp[j+1][k]=!puzzle_lamp[j+1][k];
    puzzle_lamp[j][k-1]=!puzzle_lamp[j][k-1];
    puzzle_lamp[j][k+1]=!puzzle_lamp[j][k+1];
    num1++;
}
function Confirm_puzzle_lamp()
{
    if(puzzle_lamp[1][1]&&puzzle_lamp[1][2]&&puzzle_lamp[1][3]&&puzzle_lamp[2][1]&&puzzle_lamp[2][2]&&puzzle_lamp[2][3]&&puzzle_lamp[3][1]&&puzzle_lamp[3][2]&&puzzle_lamp[3][3])
    {
        ScriptPrintMessageChatAll("**哇！你按了"+num1+"次，终于完成了谜题！**");
    }
    else
    {
        ScriptPrintMessageChatAll("**你确定全部的灯都亮了吗？**");
    }
}


//////////////////////////
///////puzzle_calc////////
//////////////////////////
// self.PrecacheScriptSound("hichatu/gol.mp3"); //Precache gol sound without using an ambient_generic
//Check chat data from logic_eventlistener
//Format: <output name> <targetname>,<inputname>,<parameter>,<delay>,<max times to fire (-1 == infinite)>
calc_a <- 0;
calc_b <- 0;
calc_c <- 0;
calc_answer <- 0;
function checkMessage(data)
{
	if(data.text.tolower() == calc_answer.tostring())
	{
		ScriptPrintMessageChatAll("**BINGO**");
	}
}
function generate_puzzle_math() {
    calc_a <- (RandomInt(1, 999));
    calc_b <- (RandomInt(1, 999));
    calc_c <- (RandomInt(1, 99));
    EntFire("puzzle_calc_1", "AddOutput", "Message +"+calc_a.tostring()+"+"+calc_b.tostring()+"*"+calc_c.tostring(), 0, 0);
    calc_answer <- calc_c*calc_b+calc_a;
}

//////////////////////////
/////puzzle_sequence//////
//////////////////////////







//////////////////////////
///////puzzle_tube////////
//////////////////////////
puzzle_tube <- [];
function generate_puzzle_tube(){
    ScriptPrintMessageChatAll("**puzzle_tube will come......**");
    u <- 0;i <- 0;num2 <-0;
    x <- 0;y <- 0;
    local spawner = Entities.CreateByClassname("env_entity_maker");
    u=752;
    for(x=0;x<11;x++){
        puzzle_tube.push([]);
        for(y=0;y<6;y++){
            puzzle_tube[x].push(0);
        }
    }
    for(x=1;x<11;x++){
        puzzle_tube.push([]);//puzzle_lamp.push([]);
        i=112;
        for(y=1;y<6;y++){
            random <- RandomInt(0, 6);
            spawner.__KeyValueFromString("EntityTemplate", "puzzle_tube_"+random);
            spawner.SpawnEntityAtLocation(Vector(u, 1247.5, i), Vector(0, 0, 0));
            puzzle_tube[x][y]=random;//puzzle_lamp[j].push(false);
            i+=32;
        }
        u+=32;
    }
}
function confirm_puzzle_tube(){
    ScriptPrintMessageChatAll("**正在确认谜题，请不要对谜题进行操作......**");
    num3 <- 1;
    for(x=752;x<1072;x+=32){
        for(y=112;y<272;y+=32){
            local tube = Entities.FindByClassnameNearest("func_button", Vector(x, 1247.5, y),8);
            local tubenumber = "puzzle_tube_button"+num3;
            num3++;
            tube.__KeyValueFromString("targetname", tubenumber);
        }
    }
    ScriptPrintMessageChatAll("**谜题已确认生成，无法再重置谜题，请开始作答！**");
}
function rotate_puzzle_tube(){
    local tubenumber = self.GetName();
    printl(tubenumber);
    if(tubenumber == "puzzle_tube_button1"){
        puzzle_tube[1][1]++;
        if(puzzle_tube[1][1]==5) puzzle_tube[1][1]=1;
        if(puzzle_tube[1][1]==7) puzzle_tube[1][1]=5;
        local spawner = Entities.CreateByClassname("env_entity_maker");
        spawner.__KeyValueFromString("EntityTemplate", "puzzle_tube_"+puzzle_tube[1][1]);
        spawner.SpawnEntityAtLocation(Vector(752, 1247.5, 112), Vector(0, 0, 0));

    }
}
function select_puzzle_tube(){

}


//////////////////////////
/////////end_time/////////
//////////////////////////
function enter_showdown(activator){
    activator.__KeyValueFromString("targetname", "winner");
    EntFire("trigger_showdown_door", "Toggle", " ", 0, 0);
    EntFire("logic_script", "RunScriptCode", "SayGoodBye()", 5, 0);
}
function out_showdown(activator){
    activator.__KeyValueFromString("targetname", " ");
}
function SayGoodBye() {
    local h = null;
    while(null!=(h=Entities.FindByClassname(h,"player")))//如果要测试bot请把player换成cs_bot
	{
		if(h.GetName() != "winner" && h.GetHealth()>0)
		{
            EntFireByHandle(h, "SetHealth", "-1", 0.0, null, null);
            //h.SetHealth(0);//这玩意儿弄不死人？怪事
			//h.SetTeam(2);//不知道为啥没屌用，但是能直接把人干死，可以在服务器里试试
		}
	}
    local command = Entities.CreateByClassname("point_servercommand");
    EntFireByHandle(command, "Command", "mp_restartgame 5", 0, null, null);
}