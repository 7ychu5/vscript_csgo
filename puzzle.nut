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
/////puzzle_naipi//////
//////////////////////////
// ::puzzle_naipi_sum <- null;
// ::puzzle_naipi_sum.resize(4);
toggle <- false;
function puzzle_naipi_change(handle,tog) {
    local tog = toggle;
    if(tog == false){
        tog = !tog;
        EntFire(handle.GetName()+"_1", "Alpha", "0", 0.0, null);
        if(handle.GetName().slice(-1).tofloat()<=3){
            EntFire("puzzle_naipi_calc", "Add", "1", 0.0,null);
        }
        else{
            EntFire("puzzle_naipi_calc", "Subtract", "1", 0.0,null);
        }
    }
    else{
        tog = !tog;
        EntFire(handle.GetName()+"_1", "Alpha", "255", 0.0, null);
        if(handle.GetName().slice(-1).tofloat()<=3){
            EntFire("puzzle_naipi_calc", "Subtract", "1", 0.0,null);
        }
        else{
            EntFire("puzzle_naipi_calc", "Add", "1", 0.0,null);
        }
    }
    toggle = tog;
}


//////////////////////////
///////puzzle_tube(WIP)////////
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