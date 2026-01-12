--[[
- Wall Mantle Movement System
- author Nooble12 (Github) or Noble536 (Roblox)
- since 12/28/25
- version 1.1.0
- github https://github.com/Nooble12/Roblox-Movement-System
]]

--Includes
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")

local RaycastFunctions = {}

function RaycastFunctions.Raycast(player, inRayOrigin, inRayDirection, inRayLength, inRayOffset)
	local rayOrigin =  Vector3.new(inRayOrigin.Position.X, (inRayOrigin.Position.Y + inRayOffset), inRayOrigin.Position.Z)

	local rayDirection = Vector3.new(inRayDirection.X, (inRayDirection.Y), inRayDirection.Z)

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = {player.Character} -- Ensures the ray doesn't hit the player's own character
	local raycastResult = Workspace:Raycast(rayOrigin, rayDirection * inRayLength, raycastParams)
	return raycastResult
end

function RaycastFunctions.RaycastBlock(player, inRayOrigin, inRayDirection, inRayDistance, inRayLength, inRayHeight, inRayWidth, inRayOffset)
	local originCFrame = CFrame.new(Vector3.new(inRayOrigin.Position.X, (inRayOrigin.Position.Y + inRayOffset), inRayOrigin.Position.Z))
	local size = Vector3.new(inRayLength, inRayHeight, inRayWidth)
	local rayDirection = Vector3.new(inRayDirection.X, inRayDirection.Y, inRayDirection.Z)
	
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = {player.Character} -- Ensures the ray doesn't hit the player's own character
	raycastParams.RespectCanCollide = true
	
	local raycastResult = Workspace:Blockcast(originCFrame, size, rayDirection * inRayDistance, raycastParams)
	return raycastResult
end

function RaycastFunctions.VisualizeRaycast(inRaycastResult, color, blockLength, blockWidth, blockHeight, lifetime)
	local hitPart = inRaycastResult.Instance
	local part = Instance.new("Part")
	if hitPart then
		print("Ray hit:", hitPart.Name)
		part.Anchored = true
		part.CanCollide = false	
		part.Size = Vector3.new(blockLength,blockWidth,blockHeight)
		part.Color = color
		part.Position = Vector3.new(inRaycastResult.Position.X, inRaycastResult.Position.Y, inRaycastResult.Position.Z)
		part.Parent = Workspace
		part.Material = Enum.Material.Neon
		part.Name = "HitBlock"
		local Debris = game:GetService("Debris")
		Debris:AddItem(part, lifetime)
	end
	
	return part
end

return RaycastFunctions
