local Players = game:GetService("Players")
local player = Players.LocalPlayer
local offset = Vector3.new(0,3,0)
local cycleDelay = 1.15
local antiAFKDistance = 0.1
local antiAFKInterval = 60
local function getHRP()
	local char = player.Character or player.CharacterAdded:Wait()
	return char:WaitForChild("HumanoidRootPart")
end
local function getModelCFrame(model)
	if not model then return nil end
	local primary = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
	if primary then
		return primary.CFrame + offset
	end
	return nil
end
local function antiAFK(hrp)
	task.spawn(function()
		while true do
			if hrp then
				hrp.CFrame = hrp.CFrame + Vector3.new(antiAFKDistance,0,0)
				task.wait(0.1)
				hrp.CFrame = hrp.CFrame - Vector3.new(antiAFKDistance,0,0)
			end
			task.wait(antiAFKInterval)
		end
	end)
end
task.spawn(function()
	local hrp = getHRP()
	antiAFK(hrp)
	while true do
		local visited = {} 
		local finished = false
		while not finished do
			local folder = workspace.Interiors:FindFirstChild("MainMap!Christmas")
			local rigs = {}
			if folder then
				for _, obj in pairs(folder:GetChildren()) do
					if obj:IsA("Model") and obj.Name == "GingerbreadRig" then
						if not visited[obj] then
							table.insert(rigs, obj)
						end
					end
				end
			end
			if #rigs == 0 then
				finished = true
			else
				for _, rig in ipairs(rigs) do
					local cframe = getModelCFrame(rig)
					if cframe then
						hrp.CFrame = cframe
						visited[rig] = true
						task.wait(cycleDelay)
					end
				end
			end
		end
		local collection = workspace:FindFirstChild("Collection")
		if collection then
			local cframe = getModelCFrame(collection)
			if cframe then
				hrp.CFrame = cframe
			end
		end
		task.wait(0.1) -- 
	end
end)