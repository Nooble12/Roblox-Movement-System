--[[
- Roblox Movement System
- author Nooble12 (Github) or Noble536 (Roblox)
- since 12/28/25
- version 1.1.1
- github https://github.com/Nooble12/Roblox-Movement-System
]]

local TweenPlayerAppeance = {}

--Includes
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

function TweenPlayerAppeance.TweenTransparency(player)
	local tweenInfo = TweenInfo.new(
		0.5, --Time
		Enum.EasingStyle.Bounce, --EasingStyle
		Enum.EasingDirection.Out, --EasingDirection
		0, --Repeat count
		true, --Reverses if true
		0 --Delay time
	)
	

	--If player is already cloaked, uncloak them.
	if(player.Character:WaitForChild("Head").Transparency > 0) then
		for _, part in pairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") and not (part.Name == "HumanoidRootPart") then
				part.Transparency = 0
				print("yes")
			end
		end
	end
	
	for _, part in pairs(player.Character:GetDescendants()) do
		if part:IsA("BasePart") and not (part.Name == "HumanoidRootPart") then
			local tween = TweenService:Create(part, tweenInfo, {Transparency = 0.7})
			tween:Play()
		end
	end
end

function TweenPlayerAppeance.ApplySlingEffect(player, hrp)
	
	local part = Instance.new("Part", hrp)
	part.Size = Vector3.new(1,1,1)
	part.Position = Vector3.new(0,0,0)
	part.Transparency = 0
	part.Material = Enum.Material.ForceField
	part.CastShadow = false
	part.Anchored = false
	part.CanCollide = false
	part.Massless = true
	part.Name = "EffectPart"
	
	local weld = Instance.new("Weld", hrp) 
	weld.C0 = CFrame.new()
	weld.C1 = CFrame.new()
	weld.Part0 = hrp
	weld.Part1 = part
	
	Debris:AddItem(part, 0.5)

	local specialMesh = Instance.new("SpecialMesh", part)
	specialMesh.TextureId = "rbxassetid://5101923607"
	specialMesh.MeshId = "rbxassetid://114635266684018"
	specialMesh.VertexColor = Vector3.new(0,1,0)
	
	specialMesh.Scale = Vector3.new(0.03,0.03,0.03) -- Smallest 
	local info = TweenInfo.new( 
		0.1, 
		Enum.EasingStyle.Sine,
		Enum.EasingDirection.InOut,
		-1,
		true 
	) 

	local tween = TweenService:Create(specialMesh, info, {Scale = Vector3.new(0.05,0.05,0.05)})
	tween:Play()
end

function TweenPlayerAppeance.HidePlayer(player)
	ApplyTransparency(player, 1)
end

function TweenPlayerAppeance.ShowPlayer(player)
	ApplyTransparency(player, 0)
end

function ApplyTransparency(player, transparencyValue)
	for _, part in pairs(player.Character:GetDescendants()) do
		if part:IsA("BasePart") and not (part.Name == "HumanoidRootPart" or part.Name == "EffectPart") then
			part.Transparency = transparencyValue
		end
	end
end
return TweenPlayerAppeance
