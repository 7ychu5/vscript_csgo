//请将此文本放到csgo\scripts\vscripts\7ychu5文件夹下
SCRIPT_OWNER <- "7ychu5";
SCRIPT_MAP <- "UNKNOWN";
SCRIPT_TIME <- "2022年8月27日20:47:25";
///////////////////////////变量//////////////////////////////
SKIN_LOCATION <- "models/zombieden/xmas/xmastree_mini.mdl";//更改为你需要的模型的位置。
SKIN_NUM_MIN <- 0;//不轻易更改，除非你确定你需要使用某样材质组编号
SKIN_NUM_MAX <- 3;//一般填为材质组编号的最大数，不要无脑填16，会导致随机不公平。
//////////////////////////主程式//////////////////////////////
function transform() {
    local transformer = activator;
    transformer.__KeyValueFromString("targetname", "transformer");
    transformer.SetModel(SKIN_LOCATION);
    transformer.__KeyValueFromInt("skin", RandomInt(SKIN_NUM_MIN, SKIN_NUM_MAX));
    transformer.__KeyValueFromString("targetname", " ");
}