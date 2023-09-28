SCRIPT_OWNER <- "7ychu5";
SCRIPT_TIME <- "2023年7月11日09点38分";
SCRIPT_MAP <- "playmaster";
SCRIPT_VERISON <- "0.1";

//////////////////////////////////////////////

File_name <- "PlayMaster"

//////////////////////////////////////////////



function save() {
    SendToConsole("developer 0;con_timestamp 0;con_logfile cfg/" + File_name + ".log");                                             //打开读写文件指令
    SendToConsole("echo "+File_name);                                                                                               //开始记录
    SendToConsole("con_logfile \"\";");                                                                                             //将读写记录转移到另一个根目录去
    ScriptPrintMessageChatAll(File_name + ".log已保存至cfg文件夹");
    //SendToConsole("echo \"saved cfg/" + name + ".log\";echo Aprox. size is " + savedArrayLen + " | sar_str is " + sar_str,false);
}