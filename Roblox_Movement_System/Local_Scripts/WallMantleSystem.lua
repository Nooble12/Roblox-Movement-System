--[[
- Wall Mantle Movement System
- author Nooble12 (Github) or Noble536 (Roblox)
- since 12/28/25
- version 1.1.1
- github https://github.com/Nooble12/Roblox-Movement-System
]]

--Includes
local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local TweenService = game:GetService("TweenService")
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remoteEvent = ReplicatedStorage:FindFirstChild("TweenClimb")

--Module Includes
local RaycastFunctions = require(ReplicatedStorage.ModuleScripts.RaycastFunctions)

--On respawn, update character and humanoid references
local Player = game.Players.LocalPlayer
Player.CharacterAdded:Connect(function(Character)
	hrp = Character:WaitForChild("HumanoidRootPart")
	humanoid = Character:WaitForChild("Humanoid")
	animator = humanoid:WaitForChild("Animator")
end)

--Config
local MaxMantleDistance = 4 -- studs
local climbTime = 0.5 -- seconds
local feetRaycastOffset = -2.5
local headRaycastOffset = 2
local offsetDifference = math.abs(feetRaycastOffset - headRaycastOffset)

--Global States (Runtime)
local isClimbing = false
local isDebugEnabled = false

local function onInputBegin(inputObject, processedEvent)

	if(inputObject.KeyCode == Enum.KeyCode.F3 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)) then
		isDebugEnabled = not isDebugEnabled
		print("Debug Toggled: ", isDebugEnabled)
		print("Wall Mantle Configs: ")
		print("Max Mantle Distance: ", 4)
		print("Mantle Time: ", climbTime)
		print("Head Raycast Offset: ", headRaycastOffset)
		print("Feet Raycast Offset: ", feetRaycastOffset)
		print("Offset Difference: ", offsetDifference)
	end
	
	--[[
	Mantle System
	]]
	if (inputObject.KeyCode == Enum.KeyCode.Space and not isClimbing) then
		local hrpRaycastResult = RaycastFunctions.RaycastBlock(player, hrp, hrp.CFrame.LookVector, MaxMantleDistance, 0.001,3,0.001, -2)
		local headRaycastResult = RaycastFunctions.Raycast(player, hrp, hrp.CFrame.LookVector, MaxMantleDistance, headRaycastOffset)
		
		if (isDebugEnabled) then
			if (hrpRaycastResult) then
				CreateHitPart(hrpRaycastResult, Color3.new(0,1,0),0.1,3,0.1)
				print("Result Block Ray: ", hrpRaycastResult)
			end
			
			if(headRaycastResult) then
				CreateHitPart(headRaycastResult, Color3.new(0,1,0),0.5,0.5,0.5)
				print("Head Ray: ", headRaycastResult)
			end
			
		end
		
		if(hrpRaycastResult and not headRaycastResult) then
			ClimbWall(hrpRaycastResult)
			
		else if (hrpRaycastResult and headRaycastResult) then
				local headRaycastDistance = GetRayDistance(headRaycastResult, hrp.Position)
				local hrpRaycastDistance = GetRayDistance(hrpRaycastResult, hrp.Position)
				
				if (not CheckIfWithinRange(hrpRaycastDistance, headRaycastDistance, 1)) then
					ClimbWall(hrpRaycastResult)
				end
			end
		end
	end
end

function GetRayDistance(resultRay, origin)
	local horizontalResultRay = Vector3.new(resultRay.Position.X, 0, resultRay.Position.Z)
	local horizontalOrgin = Vector3.new(origin.X, 0, origin.Z)
	return (horizontalResultRay - horizontalOrgin).Magnitude
end

--Sends a signal to the server to tween the player
function TweenPlayer(hrp, hrpRotation, hrpRaycastResult, climbTime)
	ReplicatedStorage.TweenClimb:FireServer(hrp, hrpRotation, hrpRaycastResult.Position, climbTime)
end

--Helper function that runs the animation and tweens the player
function ClimbWall(hrpRaycastResult)
	isClimbing = true
	
	--Creates additional rays to find max climb height.
	local raycastSpacing = 0.3
	local closestRaycastResult = nil

	local raycastTable = {}
	for count = 0, 16, 1 do
		local raycastResult = RaycastFunctions.Raycast(player, hrp, hrp.CFrame.LookVector, MaxMantleDistance, (count * raycastSpacing) + feetRaycastOffset)
		if(raycastResult) then
			table.insert(raycastTable, raycastResult)
		end
	end

	if(isDebugEnabled) then
		for _, raycastResult in pairs(raycastTable) do
			print(raycastResult)
			CreateHitPart(raycastResult, Color3.new(1,0,0), 0.1, 0.1, 0.1)
		end
	end
	
	local lastRaycastResult = raycastTable[#raycastTable] -- Will tween the player to the last raycast result to find the edge of the wall
	
	if (lastRaycastResult) then
		TweenPlayer(hrp, hrp.CFrame.Rotation, lastRaycastResult, climbTime)
		PlayClimbAnimation()
	end
	
	isClimbing = false
end

function CheckIfWithinRange(expectedValue, actualValue, rangePercent)
	local difference = expectedValue - actualValue
	local range = math.abs(difference / expectedValue)
	return range <= rangePercent
end

function PlayClimbAnimation()
	local climbAnimation = Instance.new("Animation")
	climbAnimation.AnimationId = "rbxassetid://507765644"
	
	local climbAnimationTrack = animator:LoadAnimation(climbAnimation)
	climbAnimationTrack:Play()
	climbAnimationTrack:AdjustSpeed(1 / climbTime)
	task.wait(climbTime)
	climbAnimationTrack:Stop()
end

-- Used in debug mode to visualize the raycasts.
function CreateHitPart(inRaycastResult, color, blockLength, blockWidth, blockHeight)
	local hitPart = inRaycastResult.Instance

	if hitPart then
		print("Ray hit:", hitPart.Name)
		local part = Instance.new("Part")
		part.Anchored = true
		part.CanCollide = false	
		part.Size = Vector3.new(blockLength,blockWidth,blockHeight)
		part.Color = color
		part.Transparency = 0.5
		part.Position = Vector3.new(inRaycastResult.Position.X, inRaycastResult.Position.Y, inRaycastResult.Position.Z)
		part.Parent = Workspace
		part.Material = Enum.Material.Neon
		part.Name = "HitBlock"
		local lifetime = 5
		local Debris = game:GetService("Debris")
		Debris:AddItem(part, lifetime)
	end
end

UserInputService.InputBegan:Connect(onInputBegin)
