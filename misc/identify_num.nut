function identify_num() {
    local drone_num = 0;
    for (local ent; ent = Entities.FindByName(ent, "drone_user_*"); )
    {
        drone_num++;
    }
    if(drone_num >= 3) return;
    local name = "drone_user_" + RandomInt(1000, 9999).tostring();
    while(Entities.FindByName(null, name) != null){
        name = "drone_user_" + RandomInt(1000, 9999).tostring();
    }
    EntFireByHandle(activator, "AddOutput", "targetname "+name, 0.0, null, null);
}