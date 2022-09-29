maze_chunk <- [];
maze_check <- [];
spawner <- Entities.FindByName(null,"chunk_maker");
spawner_origin <- spawner.GetOrigin();
j <- 0; i <- 0;
for(j=0;j<15;j++){
    maze_check.push([]);
    for(i=0;i<15;i++){
        maze_check[j].push(0);
    }
}
for(j=0;j<15;j++){
    maze_chunk.push([]);
    for(i=0;i<15;i++){
        maze_chunk[j].push(RandomInt(0,3));
    }
}


function generate_maze()
{
    if(Entities.FindByNameNearest("chunk1_brush", spawner_origin, 1024)!=null) return;
    else{
    j <- 0; i <- 0;
    for(j=0;j<15;j++){
        for(i=0;i<15;i++){
            maze_chunk[j][i]=RandomInt(0,3);
        }
    }
    maze_chunk[0][0]=0;
    maze_chunk[14][14]=0;
    check_maze_start();
    if(maze_check[14][14]!=1) generate_maze();
    }
}

function check_maze_start()
{
    j <- 0; i <- 0;
    for(j=0;j<15;j++){
        for(i=0;i<15;i++){
            maze_check[j][i]=0;
        }
    }
    check_maze(0,0);
}
function check_maze(x,y)
{
    maze_check[x][y]=1;
    if(x==14&&y==14){
        print_maze();
        return;
    }
    else if(x==0){
        if(y==0){
            check_maze_right(x,y);
            check_maze_down(x,y);
        }
        else if(y==14){
            check_maze_up(x,y);
            check_maze_right(x,y);
        }
        else{
            check_maze_up(x,y);
            check_maze_right(x,y);
            check_maze_down(x,y);
        }
    }
    else if(x==14){
        if(y==0){
            check_maze_left(x,y);
            check_maze_down(x,y);
        }
        else{
            check_maze_down(x,y);
            check_maze_up(x,y);
            check_maze_left(x,y);
        }
    }
    else if(y==0){
        if(x==0){
            check_maze_right(x,y);
            check_maze_down(x,y);
        }
        else if(x==14){
            check_maze_down(x,y);
            check_maze_left(x,y);
        }
        else{
            check_maze_right(x,y);
            check_maze_left(x,y);
            check_maze_down(x,y);
        }
    }
    else if(y==14){
        if(x==0){
            check_maze_up(x,y);
            check_maze_right(x,y);
        }
        else{
            check_maze_left(x,y);
            check_maze_up(x,y);
            check_maze_right(x,y);
        }
    }
    else{
        check_maze_up(x,y);
        check_maze_left(x,y);
        check_maze_down(x,y);
        check_maze_right(x,y);
    }
}
function check_maze_left(x,y)
{
    if(maze_chunk[x-1][y]!=1 && maze_chunk[x-1][y]!=2 && maze_check[x-1][y]==0) check_maze(x-1,y);
}
function check_maze_right(x,y)
{
    if(maze_chunk[x+1][y]!=1 && maze_chunk[x+1][y]!=2 && maze_check[x+1][y]==0) check_maze(x+1,y);
}
function check_maze_up(x,y)
{
    if(maze_chunk[x][y-1]!=1 && maze_chunk[x][y-1]!=2 && maze_check[x][y-1]==0) check_maze(x,y-1);
}
function check_maze_down(x,y)
{
    if(maze_chunk[x][y+1]!=1 && maze_chunk[x][y+1]!=2 && maze_check[x][y+1]==0) check_maze(x,y+1);
}
function print_maze()
{
    local spawner = Entities.CreateByClassname("env_entity_maker");
    local j=0;local i=0;
    for(j=0;j<15;j++){
        for(i=0;i<15;i++){
            if(maze_chunk[j][i]==0){
                spawner.__KeyValueFromString("EntityTemplate", "chunk0");
                spawner.SpawnEntityAtLocation(spawner_origin, Vector(0, 0, 0));
            }
            if(maze_chunk[j][i]==1){
                spawner.__KeyValueFromString("EntityTemplate", "chunk1");
                spawner.SpawnEntityAtLocation(spawner_origin, Vector(0, 0, 0));
            }
            if(maze_chunk[j][i]==2){
                spawner.__KeyValueFromString("EntityTemplate", "chunk1");
                spawner.SpawnEntityAtLocation(spawner_origin, Vector(0, 0, 0));
            }
            if(maze_chunk[j][i]==3){
                spawner.__KeyValueFromString("EntityTemplate", "chunk0");
                spawner.SpawnEntityAtLocation(spawner_origin, Vector(0, 0, 0));
            }
            spawner_origin.x-=128;
        }
        spawner_origin.x+=1920;
        spawner_origin.y-=128;
    }
    spawner_origin.y+=1920;
}