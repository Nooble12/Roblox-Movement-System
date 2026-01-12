--[[
- WarBlox Movement System
- author Nooble12 (Github) or Noble536 (Roblox)
- since 12/28/25
- version 1.1.0
- github https://github.com/Nooble12/Roblox-Movement-System
- This server script handles the physics-related parts of the WarBlox movement system.
]]

--Includes
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerTweenFunctions = require(ReplicatedStorage.ModuleScripts.PlayerPositionTween)
local TweenPlayerAppeance = require(ReplicatedStorage.ModuleScripts.TweenPlayerAppearance)

game.ReplicatedStorage.BulletSling.OnServerEvent:Connect(function(player, hrp, hrpRotation, slingResult, cameraLookVector, isHitWall)
	
	if (player.IsSlinging.Value == true) then
		return
	end
	
	player.IsSlinging.Value = true
	
	local hrp = player.Character:WaitForChild("HumanoidRootPart")
	local originalHrpPosition = hrp.Position
	
	ApplySlingEffects(player, hrp)
	TweenPlayerAppeance.HidePlayer(player)
	
	local tweenTime = 0.5 -- seconds
	
	PlayerTweenFunctions.TweenPlayer(hrp, hrp.CFrame.Rotation, slingResult, tweenTime, Enum.EasingStyle.Linear)
	
	-- Only carry the velocity over if not hit wall
	if (not isHitWall) then
		-- speed = distance / time
		local velocity = (originalHrpPosition - slingResult) / tweenTime
		local linearVelocity = Instance.new("LinearVelocity", hrp)
		linearVelocity.Attachment0 = hrp.RootAttachment
		linearVelocity.VectorVelocity = (slingResult - originalHrpPosition).Unit * velocity.Magnitude
		linearVelocity.MaxForce = math.huge
		Debris:AddItem(linearVelocity, 0.01)
	end
	
	player.IsSlinging.Value = false
	TweenPlayerAppeance.ShowPlayer(player)
end)

game.ReplicatedStorage.Run.OnServerEvent:Connect(function(player, isRunning)
	local character = player.Character
	local humanoid = character:WaitForChild("Humanoid")
	local defaultWalkSpeed = 16 -- studs per second
	
	if(isRunning) then
		print(player.Name .. " stopped running.")
		humanoid.WalkSpeed = defaultWalkSpeed
		else
		print(player.Name .. " is now running.")
		humanoid.WalkSpeed = defaultWalkSpeed * 2
	end
end)

function ApplySlingEffects(player, hrp)
	TweenPlayerAppeance.ApplySlingEffect(player, hrp)
end

--Keeps track if the player is slinging
game:GetService("Players").PlayerAdded:Connect(function(player)
	local isSlingTag = Instance.new("BoolValue", player)
	isSlingTag.Name = "IsSlinging"
	isSlingTag.Value = false
end)


