// ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======    
//    
// lua\GroundMoveMixin.lua
//    
//    Created by:   Brian Cronin (brianc@unknownworlds.com)    
//    
// ========= For more information, visit us at http://www.unknownworlds.com =====================    

Script.Load("lua/FunctionContracts.lua")
Script.Load("lua/Mixins/BaseMoveMixin.lua")

GroundMoveMixin = CreateMixin( GroundMoveMixin )
GroundMoveMixin.type = "GroundMove"

GroundMoveMixin.expectedMixins =
{
    BaseMove = "Give basic method to handle player or entity movement"
}

GroundMoveMixin.expectedCallbacks =
{
    ComputeForwardVelocity = "Should return a forward velocity.",
    GetFrictionForce = "Should return the friction force based on the input and velocity passed in.",
    GetGravityAllowed = "Should return true if gravity should take effect.",
    ModifyVelocity = "Should modify the passed in velocity based on the input and whatever other conditions are needed.",
    UpdatePosition = "Should update the position based on the velocity and time passed in. Should return a velocity."
}

GroundMoveMixin.optionalCallbacks =
{
    PreUpdateMove = "Allows children to update state before the update happens.",
    PostUpdateMove = "Allows children to update state after the update happens.",
    OnClampSpeed = "The passed in velocity is clamped to min or max speeds based on the input passed in."
}

function GroundMoveMixin:__initmixin()
end

// round the new value to network precision, rounding towards the old value
local function RoundToNetwork(v)
    local qMul = 128 // need to get this from the server
    return math.floor(qMul * v + 0.5) / qMul
end

local function RoundToNetworkVec(vec)
    vec.x = RoundToNetwork(vec.x)
    vec.y = RoundToNetwork(vec.y)
    vec.z = RoundToNetwork(vec.z)
    return vec
end

local kNetPrecision = 1/128 // should import from server

// Update origin and velocity from input.
function GroundMoveMixin:UpdateMove(input)
    // use the full precision origin
    if self.fullPrecisionOrigin then
        local orig = self:GetOrigin()
        local delta = orig:GetDistance(self.fullPrecisionOrigin)
        if delta < kNetPrecision then
            // Origin has lost some precision due to network rounding, use full precision
            self:SetOrigin(self.fullPrecisionOrigin);
        //else
            // the change must be due to an external event, so don't use the fullPrecision            
            //Log("%s: external origin change, %s -> %s (%s)", self, netPrec, orig, delta)
        end
    end

    local runningPrediction = Shared.GetIsRunningPrediction()
    
    if self.PreUpdateMove then
        self:PreUpdateMove(input, runningPrediction)
    end
    
    local velocity = self:GetVelocity()
    // Don't factor in forward velocity if stunned.
    if not HasMixin(self, "Stun") or not self:GetIsStunned() then
        // ComputeForwardVelocity is an expected callback.
        velocity = velocity + self:ComputeForwardVelocity(input) * input.time
    end
    
    // Add in the friction force.
    // GetFrictionForce is an expected callback.
    local friction = self:GetFrictionForce(input, velocity) * input.time

    // If the friction force will cancel out the velocity completely, then just
    // zero it out so that the velocity doesn't go "negative".
    if math.abs(friction.x) >= math.abs(velocity.x) then
        velocity.x = 0
    else
        velocity.x = friction.x + velocity.x
    end    
    if math.abs(friction.y) >= math.abs(velocity.y) then
        velocity.y = 0
    else
        velocity.y = friction.y + velocity.y
    end    
    if math.abs(friction.z) >= math.abs(velocity.z) then
        velocity.z = 0
    else
        velocity.z = friction.z + velocity.z
    end    
    
    if self.gravityEnabled and self:GetGravityAllowed() then
        // Update velocity with gravity after we update our position (it accounts for gravity and varying frame rates)
        velocity.y = velocity.y + self:GetGravityForce(input) * input.time
    end
    
    // Add additional velocity according to specials.
    self:ModifyVelocity(input, velocity)
    
    // Clamp speed to max speed
    if self.OnClampSpeed then
        self:OnClampSpeed(input, velocity)
    end
    
    velocity = self:UpdatePosition(velocity, input.time, input.move)
        
    self:SetVelocity(velocity)
    
    if self.PostUpdateMove then
        self:PostUpdateMove(input, runningPrediction)
    end
    
    self.fullPrecisionOrigin = Vector(self:GetOrigin())
    
end
AddFunctionContract(GroundMoveMixin.UpdateMove, { Arguments = { "Entity", "Move" }, Returns = { } })