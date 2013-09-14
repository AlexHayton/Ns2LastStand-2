local function HasUpgrade(callingEntity, techId)

    if not callingEntity then
        return false
    end

    if callingEntity:GetHasUpgrade(techId) then
        return true
    end

    local techtree = GetTechTree(callingEntity:GetTeamNumber())

    if techtree then
        return callingEntity:GetHasUpgrade(techId) // and techtree:GetIsTechAvailable(techId)
    else
        return false
    end

end

function GetHasCelerityUpgrade(callingEntity)
    return HasUpgrade(callingEntity, kTechId.Celerity)
end

function GetHasHyperMutationUpgrade(callingEntity)
    return HasUpgrade(callingEntity, kTechId.HyperMutation)
end

function GetHasRegenerationUpgrade(callingEntity)
    return HasUpgrade(callingEntity, kTechId.Regeneration)
end

function GetHasFeintUpgrade(callingEntity)
    return HasUpgrade(callingEntity, kTechId.Feint)
end

function GetHasAdrenalineUpgrade(callingEntity)
    return HasUpgrade(callingEntity, kTechId.Adrenaline)
end

function GetHasCarapaceUpgrade(callingEntity)
    return HasUpgrade(callingEntity, kTechId.Carapace)
end

function GetHasAuraUpgrade(callingEntity)
    return HasUpgrade(callingEntity, kTechId.Aura)
end

function GetHasCamouflageUpgrade(callingEntity)
    return HasUpgrade(callingEntity, kTechId.Camouflage)
end

function GetHasSilenceUpgrade(callingEntity)
    return HasUpgrade(callingEntity, kTechId.Silence)
end