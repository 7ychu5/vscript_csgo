IncludeScript("7ychu5/utils.nut")
health <- 30;
health_max <- health;

health_bar <- null;

function HealthUpdate() {
    if(health_bar == null){
        maker.__KeyValueFromString("EntityTemplate", "template_health_bar");
        maker.SpawnEntityAtEntityOrigin(self);
        health_bar = Entities.FindByClassnameNearest("prop_money_crate", self.GetOrigin(), 64);
        health_bar.SetMaxHealth(health_max);
        health_bar.SetHealth(health_max);
    }
    health += -1;

    hurter.__KeyValueFromString("Damage", "1");
    hurter.__KeyValueFromString("DamageType", "32");
    hurter.__KeyValueFromString("DamageTarget", health_bar.GetName());
    EntFire("hurter", "hurt", "", 0.0, activator)

    if(health <= 0){
        health_bar.Destroy();
        EntFireByHandle(self, "break", "", 0.0, null, null);
    }
}