--Includes
local Workspace = game:GetService("Workspace")
--[[
- Wall Mantle Movement System
- author Nooble12 (Github) or Noble536 (Roblox)
- since 12/28/25
- version 1.1.0
- github https://github.com/Nooble12/Roblox-Movement-System
]]

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
	
	local raycastResult = Workspace:Blockcast(originCFrame, size, rayDirection * inRayDistance, raycastParams)
	return raycastResult
end

return RaycastFunctions
