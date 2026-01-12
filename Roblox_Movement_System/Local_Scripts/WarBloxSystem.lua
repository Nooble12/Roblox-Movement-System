--[[
- WarBlox Movement System
- author Nooble12 (Github) or Noble536 (Roblox)
- since 12/29/25
- version 1.0.0
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
local Debris = game:GetService("Debris")
local RaycastFunctions = require(ReplicatedStorage.ModuleScripts.RaycastFunctions)

local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local TweenPlayerAppeance = require(ReplicatedStorage.ModuleScripts.TweenPlayerAppearance)


--Global Vars
local isDebugEnabled = false
local isRunning = false
local isCastingRay = false
local isSlinging = false
local maxSlingDistance = 100 -- studs

UserInputService.InputBegan:Connect(function(inputObject, processedEvent)
	
	if(inputObject.KeyCode == Enum.KeyCode.F3 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)) then
		isDebugEnabled = not isDebugEnabled
		print("Debug Toggled: ", isDebugEnabled)
	end
	
	--Running
	if(inputObject.KeyCode == Enum.KeyCode.LeftShift and UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and not isSlinging) then
		ReplicatedStorage.Run:FireServer(isRunning)
		isRunning = true
	end
	
	--Bullet Sling
	if (inputObject.KeyCode == Enum.KeyCode.Space and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and not isSlinging) then
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
		isCastingRay = true
		isSlinging = true
		
		--Creates a single part that will move to the raycastResult to save resources. better than creating and destroying parts to represent the cast result.
		local cameraLookVector = workspace.CurrentCamera.CFrame.LookVector
		local raycastResult = RaycastFunctions.RaycastBlock(player, hrp, cameraLookVector, maxSlingDistance, 0.001,3,0.001, 0)
		local resultPart = CreateResultPart()
		
		local beam = CreateBeam(hrp,resultPart) -- A beam between the result part and hrp
		
		local raycastResultPosition = nil
		local isHitWall = false
		
		while (isCastingRay) do
			cameraLookVector = workspace.CurrentCamera.CFrame.LookVector
			task.wait(0.001)
			raycastResult = RaycastFunctions.RaycastBlock(player, hrp, cameraLookVector, maxSlingDistance, 0.001,3,0.001, 0)
			
			-- Case: when you hit a block
			if (raycastResult) then
				resultPart.Position = Vector3.new(raycastResult.Position.X, raycastResult.Position.Y, raycastResult.Position.Z)
				raycastResultPosition = Vector3.new(raycastResult.Position.X, raycastResult.Position.Y, raycastResult.Position.Z)
				isHitWall = true
			-- Case: When the raycast runs out of distance (looking into the sky)
			else
				local displacementVector = cameraLookVector * maxSlingDistance
				local sourcePosition = hrp.Position
				local targetPosition = displacementVector + sourcePosition
				
				resultPart.Position = Vector3.new(targetPosition.X, targetPosition.Y, targetPosition.Z) -- sets the visualizer block to this spot
				raycastResultPosition = Vector3.new(targetPosition.X, targetPosition.Y, targetPosition.Z)
				isHitWall = false
			end
		end
		
		ReplicatedStorage.BulletSling:FireServer(hrp, hrp.CFrame.Rotation, raycastResultPosition, cameraLookVector, isHitWall)
		
		DelayedObjectDestroy(resultPart)
		--Clears the beam data
		for _, object in pairs(beam) do
			DelayedObjectDestroy(object)
		end
		
		task.wait(0.5)
		isSlinging = false
	end
	
end)

--Used to see where the ray hits
function CreateResultPart()
	local part = Instance.new("Part")
	part.Parent = Workspace
	part.Anchored = true
	part.CanCollide = false
	part.Size = Vector3.new(1,1,1)
	part.Position = Vector3.new(0,0,0)
	part.Transparency = 0
	part.Material = Enum.Material.ForceField
	part.CastShadow = false
	
	local specialMesh = Instance.new("SpecialMesh", part)
	specialMesh.TextureId = "rbxassetid://5101923607"
	specialMesh.MeshId = "rbxassetid://114635266684018"
	specialMesh.VertexColor = Vector3.new(0,1,0)
	ApplySinusoidalTransform(specialMesh)
	
	return part
end

function CreateBeam(hrp, resultPart)
	local beam = Instance.new("Beam", hrp)
	local attachment0 = Instance.new("Attachment", hrp)
	local attachment1 = Instance.new("Attachment", resultPart)
	beam.Attachment0 = attachment0
	beam.Attachment1 = attachment1
	beam.Color = ColorSequence.new(Color3.new(0,1,0))
	beam.FaceCamera = true
	beam.Segments = 1
	
	local beamTable = {beam, attachment0, attachment1}
	
	return beamTable
end

function DelayedObjectDestroy(object)
	Debris:AddItem(object, 0.5)
end

function ApplySinusoidalTransform(specialMesh)
	specialMesh.Scale = Vector3.new(0.02,0.02,0.02) -- Smallest 
	local info = TweenInfo.new( 
		0.5, 
		Enum.EasingStyle.Sine,
		Enum.EasingDirection.InOut,
		-1,
		true 
	) 
	
	local tween = TweenService:Create(specialMesh, info, {Scale = Vector3.new(0.03,0.03,0.03)})
	
	tween:Play()
	
end
	

UserInputService.InputEnded:Connect(function(inputObject, processedEvent)
	
	--Running
	if(inputObject.KeyCode == Enum.KeyCode.LeftShift and not UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)) then
		ReplicatedStorage.Run:FireServer(isRunning)
		isRunning = false
	end
	
	if((inputObject.KeyCode == Enum.KeyCode.LeftControl and not UserInputService:IsKeyDown(Enum.KeyCode.Space)) or inputObject.KeyCode == Enum.KeyCode.Space) then
		isCastingRay = false
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
	end
	
end)
