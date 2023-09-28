SCRIPT_OWNER <- "7ychu5";
SCRIPT_TIME <- "2023年8月5日18:26:15";
SCRIPT_MAP <- "ze_obj_rampage";
SCRIPT_VERISON <- "0.1";

IncludeScript("7ychu5/utils.nut");

//////////user_variable///////////

prop_missile_model <- "models/props/de_inferno/hr_i/missile/missile_02.mdl"//导弹模型
sound_explode_1 <- "weapons/hegrenade/explode3.wav"
sound_explode_2 <- "weapons/hegrenade/explode4.wav"
sound_explode_3 <- "weapons/hegrenade/explode5.wav"

cooldown <- 6;                         //冷却时间
//这个冷却写的有点问题，意味着这个冷却是恒冷却，CD一到无论什么条件都会施放一次技能。但能不能找到有效目标另说。反正总是要用一次，然后等10秒CD。
flush_times <- 10;
zombie_be_flushed_damage <- 10000;
human_be_flushed_damage <- 20;
zombie_warehouse_origin <- Vector(-13536, -10080, 4116);

move_origin_center_2 <- Vector(-9396, -9070, 4329)              //直升机冲水的运行位置（记得把movement.nut里的也改了）

self.PrecacheModel(prop_missile_model);
self.PrecacheScriptSound(sound_explode_1);
self.PrecacheScriptSound(sound_explode_2);
self.PrecacheScriptSound(sound_explode_3);
//////////sys_variable////////////

//prop_helikopter <- self;
skill_rocket_use_toggle <- true;

//////////////////////////////////


function UseSkill() {//普攻
    if(skill_rocket_use_toggle == true && self.IsValid())
    {
        skill_rocket_use_toggle = false;
        EntFireByHandle(self, "RunScriptCode", "skill_rocket_use_toggle = true", cooldown, null, null);
        EntFireByHandle(self, "RunScriptCode", "UseSkill();", cooldown + 0.02, null, null);

        local spawn_origin = self.GetOrigin();
        // switch (RandomInt(1, 2)) {
        //     case 1:
        //         spawn_origin = self.GetAttachmentOrigin(self.LookupAttachment("starboard_light"));
        //         break;
        //     case 2:
        //         spawn_origin = self.GetAttachmentOrigin(self.LookupAttachment("port_light"));
        //         break;
        // }

        maker.__KeyValueFromString("EntityTemplate", "template_missile");
        maker.SpawnEntityAtLocation(spawn_origin, Vector(0, 0, 0));

        local ent = Entities.FindByNameNearest("missile_physbox*", self.GetOrigin(), 10000);
        EntFireByHandle(ent, "RunScriptCode", "Tick()", 0.40, ent, ent);
    }
}

function flush_water() {
    if(flush_times == 10)
    {
        local cliff_indoor_delay = RandomFloat(3, 8);

        EntFire("cliff_warehouse_prop_breakable", "break", "", cliff_indoor_delay, null);
        EntFire("cliff_warehouse_particle_fire", "start", "", cliff_indoor_delay, null);
        EntFireByHandle(self, "RunScriptcode", "DispatchParticleEffect(\"gas_cannister_impact\", Vector(-13240, -10104, 4064), Vector(0, 0, 0))", cliff_indoor_delay, null, null);
        EntFireByHandle(self, "RunScriptcode", "shake_plr_screen();", cliff_indoor_delay, null, null);

        local cliff_outdoor_delay = RandomFloat(3, 8);

        EntFire("cliff_outside_prop_breakable", "break", "", cliff_outdoor_delay, null);
        EntFireByHandle(self, "RunScriptcode", "DispatchParticleEffect(\"explosion_molotov_air_down\", Vector(-12480, -9952, 4115), Vector(0, 0, 0))", cliff_outdoor_delay, null, null);
        EntFireByHandle(self, "RunScriptcode", "shake_plr_screen();", cliff_outdoor_delay, null, null);

    }

    if(flush_times > 1) {
        flush_times--;
        EntFireByHandle(self, "RunScriptcode", "flush_water()", 1.0, null, null);
        if(flush_times == 2){
            EntFire("helicopter_physbox", "RunScriptcode", "stage_2_end()", 0.0, null);
            EntFire("helicopter_particle_minigun", "kill", "", 0.0, null);
            EntFire("cliff_outside_rock_breakable", "break", "", 0.2, null);
            EntFireByHandle(self, "RunScriptcode", "DispatchParticleEffect(\"explosion_c4_500\", Vector(-11872, -9888, 4128), Vector(0, 0, 0))", 0.01, null, null);
            self.EmitSound("weapons/hegrenade/explode" + RandomInt(3, 5) + ".wav");
            EntFire("cliff_outdoor_particle_flek", "start", "", 2.0, null);
        }
    }
    local particle = Entities.FindByName(null, "helicopter_particle_minigun");
    EntFireByHandle(particle, "SetParent", "helicopter_prop", 0.00, null, null);
    EntFireByHandle(particle, "SetParentAttachment", "engSmokeA", 0.02, null, null);
    EntFireByHandle(particle, "start", "", 1.0, null, null);
    for(local ent; ent = Entities.FindByClassname(ent, "player"); )
    {
        if(ent == null || !ent.IsValid() || ent.GetHealth() <= 0) continue;
        switch (ent.GetTeam()) {
            case 3:
                ScriptPrintMessageChatAll(TraceLine(self.GetOrigin(),ent.EyePosition(),self).tostring());
                if(TraceLine(self.GetOrigin(),ent.EyePosition(),self) <= 0.94) continue
                local hp = ent.GetHealth();
                if(hp > human_be_flushed_damage) EntFireByHandle(ent, "SetHealth", (hp - human_be_flushed_damage).tostring(), 0.0, null, null);
                else EntFireByHandle(ent, "SetHealth", "-1", 0.0, null, null);
                break;
            default:
                break;
        }
    }
}

function shake_plr_screen() {
    for (local ent; ent = Entities.FindByClassname(ent, "player"); )
        {
            for(local j = 0 ; j < 20 ;j++)
            {
                SendToConsole("shake");
            }
        }
}