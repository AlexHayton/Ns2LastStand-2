if Client then

	function Babbler:OnGetIsVisible(visibleTable, viewerTeamNumber)
        
        local parent = self:GetParent()
        if parent and (parent == Client.GetLocalPlayer() or (HasMixin(parent, "Cloakable") and parent:GetIsCloaked()) ) then
            visibleTable.Visible = false
        end
    
    end

end

// Clear this one - we don't need it now.	
function Babbler:OnUpdateRender()


end