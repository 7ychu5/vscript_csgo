function OnPostSpawn() {
    local Text = null;
    if(self.GetName().find("BGM_Text_Dust") == 0){Text = "< Now Playing... > \nPerturbator - Technoir";}
    if(self.GetName().find("BGM_Text_Vengar") == 0){Text = "< Now Playing... > \nPerturbator - Ghost Dancers Slay Together";}
    if(self.GetName().find("BGM_Text_Vengar2") == 0){Text = "< Now Playing... > \nPerturbator - I Am the Night";}
    if(self.GetName().find("BGM_Text_Souls") == 0){Text = "< Now Playing... > \nPerturbator - Vantablack";}
    if(self.GetName().find("BGM_Text_Knife") == 0){Text = "< Now Playing... > \nPerturbator - Death Squad";}
    if(self.GetName().find("BGM_Text_Domination") == 0){Text = "< Now Playing... > \nPerturbator - Reaching Xanadu";}
    if(self.GetName().find("BGM_Text_Death") == 0){Text = "< Now Playing... > \nPerturbator - Sentient";}
    if(self.GetName().find("BGM_Text_Death2") == 0){Text = "< Now Playing... > \nPerturbator - Future Club";}
    if(self.GetName().find("BGM_Text_Tech") == 0){Text = "< Now Playing... > \nPerturbator - Lusful Sacrament";}
    if(self.GetName().find("BGM_Text_Tech2") == 0){Text = "< Now Playing... > \nPerturbator - Excess";}
    if(self.GetName().find("BGM_Text_Tech3") == 0){Text = "< Now Playing... > \nPerturbator - Death of the Soul";}
    if(self.GetName().find("BGM_Text_Gost") == 0){Text = "< Now Playing... > \nPerturbator - GosT Behemoth";}
    if(self.GetName().find("BGM_Text_Gost2") == 0){Text = "< Now Playing... > \nPerturbator - Assault";}
    if(self.GetName().find("BGM_Text_Gost3") == 0){Text = "< Now Playing... > \nPerturbator - Messalina";}
    if(self.GetName().find("BGM_Text_War") == 0){Text = "< Now Playing... > \nPerturbator - The Uncanny Valley";}
    if(self.GetName().find("BGM_Text_War2") == 0){Text = "< Now Playing... > \nCarpenter Brut - Imaginary fire";}
    if(Text != null)self.__KeyValueFromString("message",Text);
}