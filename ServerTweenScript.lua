local TweenService = game:GetService("TweenService")

game.ReplicatedStorage.TweenClimb.OnServerEvent:Connect(function(player, hrp, hrpRaycastResultPosition, climbTime)
	TweenPlayer(hrp, hrpRaycastResultPosition, climbTime)
end)

function TweenPlayer(hrp, hrpRaycastResultPosition, climbTime)
	local info = TweenInfo.new( 
		climbTime, 
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.InOut,
		0,
		false 
	) 
	local goal = {
		CFrame = CFrame.new(hrpRaycastResultPosition + Vector3.new(hrp.CFrame.LookVector, 8,hrp.CFrame.LookVector)) 
	}

	local tween = TweenService:Create(hrp, info, goal)
	hrp.Anchored = true
	tween:Play()
	tween.Completed:Wait()
	hrp.Anchored = false
end