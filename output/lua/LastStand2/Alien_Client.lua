function Alien:OnCountDown()

	Player.OnCountDown(self)
	
	local script = ClientUI.GetScript("GUIAlienHUD")
	if script then
		script:SetIsVisible(false)
	end
	
end

function Alien:OnCountDownEnd()

	Player.OnCountDownEnd(self)
	
	local script = ClientUI.GetScript("GUIAlienHUD")
	if script then
		script:SetIsVisible(true)
	end
	
end