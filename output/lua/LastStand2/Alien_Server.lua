function Alien:OnProcessMove(input)

    if self.empBlasted then
    
        self:DeductAbilityEnergy(kEMPBlastEnergyDamage)  
        self.empBlasted = false  
        
    end
    
    if Server then    
        self.hasAdrenalineUpgrade = GetHasAdrenalineUpgrade(self)
    end
    
    Player.OnProcessMove(self, input)
    
    // In rare cases, Player.OnProcessMove() above may cause this entity to be destroyed.
    // The below code assumes the player is not destroyed.
    if not self:GetIsDestroyed() then
    
        // Calculate two and three hives so abilities for abilities        
        UpdateAbilityAvailability(self, self:GetTierTwoTechId(), self:GetTierThreeTechId())
        
        self.enzymed = self.timeWhenEnzymeExpires > Shared.GetTime()
        self.primalScreamBoost = self.timeWhenPrimalScreamExpires > Shared.GetTime()
        
        self:UpdateAutoHeal()
        
    end
    
end