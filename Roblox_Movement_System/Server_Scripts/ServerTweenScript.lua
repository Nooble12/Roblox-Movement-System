--[[
- Wall Mantle Movement System
- author Nooble12 (Github) or Noble536 (Roblox)
- since 12/28/25
- version 1.1.0
- github https://github.com/Nooble12/Roblox-Movement-System
]]

local TweenService = game:GetService("TweenService")

game.ReplicatedStorage.TweenClimb.OnServerEvent:Connect(function(player, hrp, hrpRaycastResultPosition, climbTime)
	TweenPlayer(hrp, hrpRaycastResultPosition, climbTime)
end)

function TweenPlayer(hrp, hrpRaycastResultPosition, climbTime)
	local info = TweenInfo.new( 
		climbTime, 
		Enum.EasingStyle.Sine,
		Enum.EasingDirection.InOut,
		0,
		false 
	) 
	local goal = {
		CFrame = CFrame.new(hrpRaycastResultPosition.X, hrpRaycastResultPosition.Y + 2.5, hrpRaycastResultPosition.Z) 
	}

	local tween = TweenService:Create(hrp, info, goal)
	hrp.Anchored = true
	tween:Play()
	tween.Completed:Wait()
	hrp.Anchored = false
end