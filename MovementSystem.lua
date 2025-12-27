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

--On respawn, update character and humanoid references
local Player = game.Players.LocalPlayer
Player.CharacterAdded:Connect(function(Character)
	hrp = Character:WaitForChild("HumanoidRootPart")
	humanoid = Character:WaitForChild("Humanoid")
	animator = humanoid:WaitForChild("Animator")
end)

--Config
local MaxMantleDistance = 3 -- studs
local climbTime = 0.5 -- seconds
local hrpRaycastOffset = -2.5
local headRaycastOffset = 2
local offsetDifference = math.abs(hrpRaycastOffset - headRaycastOffset)

local function onInputBegin(inputObject, processedEvent)

	--[[
	Mantle System
	]]
	
	if inputObject.KeyCode == Enum.KeyCode.Space then
		local hrpRaycastResult = CastRay(hrp, hrp.CFrame.LookVector, MaxMantleDistance, hrpRaycastOffset)
		if(hrpRaycastResult) then
			CreateHitPart(hrpRaycastResult)
		end
		
		local headRaycastResult = CastRay(hrp, hrp.CFrame.LookVector, MaxMantleDistance, headRaycastOffset)
		if(headRaycastResult) then
			CreateHitPart(headRaycastResult)
		end
		
		if (hrpRaycastResult and not headRaycastResult) then	
			print("Can Climb")
			--character:PivotTo(CFrame.new(hrpRaycastResult.Position.X, hrpRaycastResult.Position.Y + 5, hrpRaycastResult.Position.Z))
			ClimbWall(hrpRaycastResult)
		else if (hrpRaycastResult and headRaycastResult) then
				
				--Distance between the head and hrp raycast result
				local raycastDifference = (hrpRaycastResult.Position - headRaycastResult.Position).Magnitude
				
				--Checks the edge case where the head cast also hits a wall that is behind where the hrpcast hits.
				if (raycastDifference * 0.995 > offsetDifference) then
					print("Difference Result: " .. raycastDifference * 0.995)
					print("Default Result: " .. offsetDifference)
					ClimbWall(hrpRaycastResult)
				end
			else
				print("Cant Climb")
			end
		end
	end
end

--Sends a signal to the server to tween the player
function TweenPlayer(hrp, hrpRaycastResult, climbTime)
	print(hrpRaycastResult)
	ReplicatedStorage.TweenClimb:FireServer(hrp, hrpRaycastResult.Position, climbTime)
end

--Helper function that runs the animation and tweens the player
function ClimbWall(hrpRaycastResult)
	TweenPlayer(hrp, hrpRaycastResult, climbTime)
	PlayClimbAnimation()
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

function CastRay(inRayOrigin, inRayDirection, inRayLength, inRayOffset)
	local rayOrigin =  Vector3.new(inRayOrigin.Position.X, (inRayOrigin.Position.Y + inRayOffset), inRayOrigin.Position.Z)

	local rayDirection = Vector3.new(inRayDirection.X, (inRayDirection.Y), inRayDirection.Z)

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = {player.Character} -- Ensures the ray doesn't hit the player's own character
	local raycastResult = Workspace:Raycast(rayOrigin, rayDirection * MaxMantleDistance, raycastParams)
	return raycastResult
end

function CreateHitPart(inRaycastResult)
	local hitPart = inRaycastResult.Instance

	if hitPart then
		print("Ray hit:", hitPart.Name)
		local part = Instance.new("Part")
		part.Anchored = true
		part.CanCollide = false	
		part.Size = Vector3.new(0.5,0.5,0.5)
		part.Color = Color3.new(0, 1, 0) 
		part.Transparency = 0
		part.Position = Vector3.new(inRaycastResult.Position.X, inRaycastResult.Position.Y, inRaycastResult.Position.Z)
		part.Parent = Workspace
		part.Material = Enum.Material.Neon
		local lifetime = 5
		local Debris = game:GetService("Debris")
		Debris:AddItem(part, lifetime)
	end
end


UserInputService.InputBegan:Connect(onInputBegin)
