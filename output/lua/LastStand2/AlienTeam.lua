Script.Load("lua/LSGameEntities.lua")
Script.Load("lua/LSAlienDeck.lua")

// Post-Hook: Run the Initialize function then do stuff
local function overrideInitialize = AlienTeam.Initialize
function AlienTeam:Initialize(teamName, teamNumber)
	overrideInitialize(self, teamName, teamNumber)
	
	self.respawnEntity = AlienSpectator.kMapName
end


function AlienTeam:GetSpawnPosition()
    return gAlienSpawn:GetOrigin()
end

function AlienTeam:GetSpawnAngles()
    return gAlienSpawn:GetAngles()
end

function AlienTeam:RollAliens()

    local result = {}
    local weights = {}
    local roundFraction = GetGamerules():GetRoundFraction()
    
    if GetGamerules():GetGameState() ~= kGameState.Started then
        roundFraction = 0
    end
    
    Print('Round fraction: %f', roundFraction)
    
    local totalWeight = 0
    for i = 1, #kAlienDeck do
        if kAlienDeck[i].start <= roundFraction then
            local minWeight = kAlienDeck[i].minWeight
            local maxWeight = kAlienDeck[i].maxWeight
            
            local t = (roundFraction - kAlienDeck[i].start) / (1 - kAlienDeck[i].start)
            local weight = minWeight + t*(maxWeight - minWeight)
            totalWeight = totalWeight + weight
            table.insert(weights, weight)
            Print('%s has weight %f', kAlienDeck[i].name, weight)
        else
            Print('%s is not available, starts at %f',  kAlienDeck[i].name, kAlienDeck[i].start)
            table.insert(weights, 0)
        end
    end
    
    while #result < 3 do
        
        local roll = math.random(1, totalWeight)
        local currentWeight = 0
        local rolledAlien = nil
        for i = 1, #kAlienDeck do
            if weights[i] > 0 then
                currentWeight = currentWeight + weights[i]
                if roll <= currentWeight then
                    rolledAlien = i
                    break
                end
            end
        end
        
        assert(rolledAlien ~= nil)
        
        // Check not already rolled
        for i = 1, #result do
            if result[i] == rolledAlien then
                rolledAlien = nil
                break
            end
        end
        
        if rolledAlien ~= nil then
            Print('Rolled %s', kAlienDeck[rolledAlien].name)
            table.insert(result, rolledAlien)
        end
            
    end

    return result

end