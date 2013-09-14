Script.Load("lua/FunctionContracts.lua")

AddFunctionContract(AttackOrderMixin.ProcessAttackOrder, { Arguments = { "Entity", "number", "number", "number" }, Returns = { } })

function AttackOrderMixin:GetTimeOfLastAttackOrder()
    return self.timeOfLastAttackOrder
end
AddFunctionContract(AttackOrderMixin.GetTimeOfLastAttackOrder, { Arguments = { "Entity" }, Returns = { "number" } })