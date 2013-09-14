if Server then

    function AlienCommander:CreateCyst(position, normal, orientation, pickVec)

        if not self.cystAllowed then
            return false
        end

        // check for energy
        local hive = self:GetClassHasEnergy("Hive", LookupTechData(kTechId.Cyst, kTechDataCostKey) )
        local success = false

        if hive then
        
            success = self:AttemptToBuild(kTechId.Cyst, position, normal, orientation, pickVec, false, hive)
            
            if success then
            
                Shared.PlayPrivateSound(self, self:GetSpendTeamResourcesSoundName(), nil, 1.0, self:GetOrigin())            
                hive:SetEnergy(hive:GetEnergy() - LookupTechData(kTechId.Cyst, kTechDataCostKey))
                
            end
            
        end

        return success
    
    end
    
    // check if a notification should be send for successful actions
    function AlienCommander:ProcessTechTreeActionForEntity(techNode, position, normal, pickVec, orientation, entity, trace, targetId)
    
        local techId = techNode:GetTechId()
        local success = false
        local keepProcessing = false
        
        if GetIsPheromone(techId) then
        
            success = CreatePheromone(techId, position, self:GetTeamNumber()) ~= nil
            keepProcessing = false
        
        else
            success, keepProcessing = Commander.ProcessTechTreeActionForEntity(self, techNode, position, normal, pickVec, orientation, entity, trace, targetId)
        end
        
        if success then
        
            local location = GetLocationForPoint(position)
            local locationName = location and location:GetName() or ""
            self:TriggerNotification(Shared.GetStringIndex(locationName), techId)
            
            if techId == kTechId.BoneWall then
                Shared.PlayPrivateSound(self, AlienCommander.kBoneWallSpawnSound, nil, 1.0, self:GetOrigin())
            end
            
        end
        
        return success, keepProcessing
        
    end
	
end

