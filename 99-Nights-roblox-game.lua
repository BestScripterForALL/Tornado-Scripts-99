--// SERVICES
local Players = game:GetService("Players")
local UIS     = game:GetService("UserInputService")
local RS      = game:GetService("RunService")
local VIM     = game:GetService("VirtualInputManager")

local plr = Players.LocalPlayer
local daysOld = plr.AccountAge

--// GUI BASE
local gui = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))
gui.Name, gui.ResetOnSpawn = "TornadoGui", false

-- FLOATING T BUTTON
local floatBtn = Instance.new("TextButton", gui)
floatBtn.Size = UDim2.new(0,60,0,60)
floatBtn.Position = UDim2.new(0,20,1,-80)
floatBtn.BackgroundColor3 = Color3.new(0,0,0)
floatBtn.Text, floatBtn.TextColor3 = "T", Color3.new(1,1,1)
floatBtn.TextScaled, floatBtn.Font = true, Enum.Font.GothamBold
floatBtn.AutoButtonColor = false
Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(1,0)
local stroke = Instance.new("UIStroke", floatBtn)
stroke.Thickness = 2; stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
RS.RenderStepped:Connect(function() stroke.Color = Color3.fromHSV((tick()%5)/5,1,1) end)

-- Drag T
local dragging, dragInput, dragStart, startPos
local function beginDrag(b,i)
	dragging = true
	dragStart = i.Position
	startPos = b.Position
	i.Changed:Connect(function()
		if i.UserInputState == Enum.UserInputState.End then
			dragging = false
		end
	end)
end
floatBtn.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
		beginDrag(floatBtn,i)
	end
end)
floatBtn.InputChanged:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = i
	end
end)
UIS.InputChanged:Connect(function(i)
	if dragging and i == dragInput then
		local d = i.Position - dragStart
		floatBtn.Position = UDim2.new(0,startPos.X.Offset + d.X,0,startPos.Y.Offset + d.Y)
	end
end)

-- MAIN MENU
local menu = Instance.new("Frame", gui)
menu.Size, menu.Position = UDim2.new(0.8,0,0.8,0), UDim2.new(0.1,0,0.1,0)
menu.BackgroundColor3 = Color3.fromRGB(30,30,30); menu.Visible=false
Instance.new("UICorner", menu).CornerRadius = UDim.new(0,10)
local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1,0,0,40); title.BackgroundColor3 = Color3.fromRGB(40,40,40)
title.TextScaled, title.Font, title.TextColor3, title.Text = true, Enum.Font.GothamBold, Color3.new(1,1,1), "Tornado Scripts"
Instance.new("UICorner", title).CornerRadius = UDim.new(0,8)
title.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
		beginDrag(menu,i)
	end
end)
title.InputChanged:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = i
	end
end)
UIS.InputChanged:Connect(function(i)
	if dragging and i == dragInput then
		local d = i.Position - dragStart
		menu.Position = UDim2.new(0,startPos.X.Offset + d.X,0,startPos.Y.Offset + d.Y)
	end
end)

-- TABS / PAGES
local tabFrame = Instance.new("Frame", menu)
tabFrame.Size, tabFrame.Position = UDim2.new(0,120,1,-40), UDim2.new(0,0,0,40)
tabFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
Instance.new("UICorner", tabFrame).CornerRadius = UDim.new(0,6)
local pages = Instance.new("Frame", menu)
pages.Size, pages.Position = UDim2.new(1,-120,1,-40), UDim2.new(0,120,0,40)
pages.BackgroundColor3 = Color3.fromRGB(35,35,35)
Instance.new("UICorner", pages).CornerRadius = UDim.new(0,6)

local function tab(txt,y)
	local b = Instance.new("TextButton",tabFrame)
	b.Size = UDim2.new(1,0,0,40)
	b.Position = UDim2.new(0,0,0,y)
	b.BackgroundColor3 = Color3.fromRGB(80,80,80)
	b.TextScaled = true
	b.Font = Enum.Font.Gotham
	b.TextColor3 = Color3.new(1,1,1)
	b.Text = txt
	return b
end
local infoBtn  = tab("Info",0)
local mainBtn  = tab("Main",45)
local extraBtn = tab("Extra",90)

local function page(scroll)
	if scroll then
		local s = Instance.new("ScrollingFrame",pages)
		s.Size = UDim2.new(1,0,1,0)
		s.CanvasSize = UDim2.new(0,0,0,1200)
		s.ScrollBarThickness = 8
		s.BackgroundTransparency = 1
		s.Visible = false
		return s
	else
		local f = Instance.new("Frame",pages)
		f.Size = UDim2.new(1,0,1,0)
		f.BackgroundTransparency = 1
		f.Visible = false
		return f
	end
end
local infoPage  = page(false)
local mainPage  = page(true)
local extraPage = page(true)
infoPage.Visible = true
local function switch(p)
	infoPage.Visible = false
	mainPage.Visible = false
	extraPage.Visible = false
	p.Visible = true
end
infoBtn.MouseButton1Click:Connect(function() switch(infoPage) end)
mainBtn.MouseButton1Click:Connect(function() switch(mainPage) end)
extraBtn.MouseButton1Click:Connect(function() switch(extraPage) end)

-- INFO
local info = Instance.new("TextLabel",infoPage)
info.Size = UDim2.new(1,-20,1,-20)
info.Position = UDim2.new(0,10,0,10)
info.BackgroundTransparency = 1
info.TextWrapped = true
info.TextScaled = true
info.Font = Enum.Font.Gotham
info.TextColor3 = Color3.new(1,1,1)
info.Text = "📜 Script by: BestScripterForAll\n👤 "..plr.Name.."\n📅 Account Age: "..daysOld.." days"

-- UTILS (Bring)
local function bring(list)
	local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
	local items = workspace:FindFirstChild("Items")
	if not hrp or not items then return end
	for _,o in ipairs(items:GetDescendants()) do
		if list[o.Name] then
			local m = o:IsA("Model") and o or o:FindFirstAncestorOfClass("Model")
			if m and m.PrimaryPart then
				pcall(function()
					m:SetPrimaryPartCFrame(hrp.CFrame + Vector3.new(0,3,0))
				end)
			end
		end
	end
end

local function button(parent,y,text,list)
	local b = Instance.new("TextButton",parent)
	b.Size = UDim2.new(1,-20,0,50)
	b.Position = UDim2.new(0,10,0,y)
	b.BackgroundColor3 = Color3.fromRGB(60,60,60)
	b.Font = Enum.Font.GothamBold
	b.TextColor3 = Color3.new(1,1,1)
	b.TextScaled = true
	b.Text = text
	b.MouseButton1Click:Connect(function() bring(list) end)
end

-- Lists
local fuel  = {["Coal"]=true,["Fuel canister"]=true,["Biofuel"]=true,["Oil Barrel"]=true}
local scrap = {["Scrap"]=true,["Metal Scrap"]=true,["Wire Spool"]=true,["Bolt"]=true,["Sheet Metal"]=true,["Broken Fan"]=true,["Broken Radio"]=true,["Broken Microwave"]=true,["Tyre"]=true,["Old Car Engine"]=true,["Washing Machine"]=true}
local food  = {["Carrot"]=true,["Berry"]=true,["Morsel"]=true,["Steak"]=true,["Cooked Morsel"]=true,["Cooked Steak"]=true,["Apple"]=true,["Stew"]=true,["Cake"]=true,["Pepper"]=true,["Hearty stew"]=true}
local med   = {["Bandage"]=true,["Medkit"]=true}
local wood  = {["Log"]=true}
local ammo  = {["Revolver Ammo"]=true,["Rifle Ammo"]=true,["Shotgun Ammo"]=true}
local gun   = {["Revolver"]=true,["Rifle"]=true,["Tactical Shotgun"]=true,["Kunai"]=true}
local pelt  = {["Wolf Pelt"]=true,["Alpha Wolf pelt"]=true,["Bear Pelt"]=true}
local all   = setmetatable({}, {__index=function() return true end})

-- MAIN buttons
button(mainPage,10 ,"Bring All Items",all)
button(mainPage,70 ,"Bring Fuel",fuel)
button(mainPage,130,"Bring Scrap",scrap)
button(mainPage,190,"Bring Food",food)
button(mainPage,250,"Bring Medical",med)
button(mainPage,310,"Bring Wood",wood)
button(mainPage,370,"Bring Ammo",ammo)
button(mainPage,430,"Bring Gun",gun)
button(mainPage,490,"Bring Pelts",pelt)

-- ========= EXTRA: ESP =========
local espOn = false
local espBtn = Instance.new("TextButton",extraPage)
espBtn.Size = UDim2.new(1,-20,0,50)
espBtn.Position = UDim2.new(0,10,0,10)
espBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
espBtn.Font = Enum.Font.GothamBold
espBtn.TextColor3 = Color3.new(1,1,1)
espBtn.TextScaled = true
espBtn.Text = "ESP: OFF"

local color = {
	Fuel   = Color3.fromRGB(255,136,0),
	Scrap  = Color3.fromRGB(128,128,128),
	Wood   = Color3.fromRGB(102,51,0),
	Medical= Color3.fromRGB(255,255,255),
	Ammo   = Color3.fromRGB(255,0,0),
	Gun    = Color3.fromRGB(0,180,255),
	Pelt   = Color3.fromRGB(255,100,180)
}
local cat = setmetatable({
	["Coal"]="Fuel",["Fuel canister"]="Fuel",["Biofuel"]="Fuel",["Oil Barrel"]="Fuel",
	["Scrap"]="Scrap",["Metal Scrap"]="Scrap",["Wire Spool"]="Scrap",["Bolt"]="Scrap",["Sheet Metal"]="Scrap",["Broken Fan"]="Scrap",["Broken Radio"]="Scrap",["Broken Microwave"]="Scrap",["Tyre"]="Scrap",["Old Car Engine"]="Scrap",["Washing Machine"]="Scrap",
	["Log"]="Wood",["Bandage"]="Medical",["Medkit"]="Medical",
	["Revolver Ammo"]="Ammo",["Rifle Ammo"]="Ammo",["Shotgun Ammo"]="Ammo",
	["Revolver"]="Gun",["Rifle"]="Gun",["Tactical Shotgun"]="Gun",["Kunai"]="Gun",
	["Wolf Pelt"]="Pelt",["Alpha Wolf pelt"]="Pelt",["Bear Pelt"]="Pelt"
},{__index=function() return nil end})

local hi = {}
local function clearESP()
	for o,h in pairs(hi) do
		if h then h:Destroy() end
		hi[o] = nil
	end
end
local function mark(m,c)
	if hi[m] then return end
	local h = Instance.new("Highlight",gui)
	h.Adornee = m
	h.FillColor = c
	h.FillTransparency = 0.5
	h.OutlineTransparency = 1
	hi[m] = h

	local bg = Instance.new("BillboardGui",h)
	bg.Adornee = m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
	bg.Size = UDim2.new(0,200,0,50)
	bg.AlwaysOnTop = true
	bg.StudsOffset = Vector3.new(0,3,0)
	local tl = Instance.new("TextLabel",bg)
	tl.Size = UDim2.new(1,0,1,0)
	tl.BackgroundTransparency = 1
	tl.TextScaled = true
	tl.Font = Enum.Font.GothamBold
	tl.TextColor3 = Color3.new(1,1,1)
	tl.Text = m.Name
end

espBtn.MouseButton1Click:Connect(function()
	espOn = not espOn
	espBtn.Text = "ESP: "..(espOn and "ON" or "OFF")
	if not espOn then clearESP() end
end)
RS.RenderStepped:Connect(function()
	if not espOn then return end
	local items = workspace:FindFirstChild("Items")
	if not items then return end
	for _,obj in ipairs(items:GetDescendants()) do
		if obj:IsA("Model") and obj.PrimaryPart then
			local c = cat[obj.Name]
			if c then
				mark(obj,color[c])
			end
		end
	end
	for o,h in pairs(hi) do
		if not o or not o.Parent then
			h:Destroy()
			hi[o] = nil
		end
	end
end)

-- ========= EXTRA: AUTO-FARM WOOD =========
local farmWood = false
local woodBtn  = espBtn:Clone()
woodBtn.Parent   = extraPage
woodBtn.Position = espBtn.Position + UDim2.new(0,0,0,60)
woodBtn.Text     = "AutoFarm Wood: OFF"

local treeHL
local function highlightTree(t)
	if treeHL then treeHL:Destroy() end
	treeHL = Instance.new("Highlight",gui)
	treeHL.FillColor = Color3.fromRGB(255,0,0)
	treeHL.FillTransparency = 0.5
	treeHL.OutlineTransparency = 1
	treeHL.Adornee = t
end

woodBtn.MouseButton1Click:Connect(function()
	farmWood = not farmWood
	woodBtn.Text = "AutoFarm Wood: "..(farmWood and "ON" or "OFF")
	if not farmWood and treeHL then
		treeHL:Destroy()
		treeHL = nil
	end
end)

task.spawn(function()
	while true do
		if farmWood then
			local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
			local landmarks = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Landmarks")
			if hrp and landmarks then
				local nearest
				local dist = 150
				for _,t in ipairs(landmarks:GetChildren()) do
					if t.Name == "Small Tree" and t:FindFirstChild("Trunk") then
						local d = (hrp.Position - t.Trunk.Position).Magnitude
						if d < dist then
							dist,nearest = d,t
						end
					end
				end
				if nearest then
					highlightTree(nearest)
					hrp.CFrame = CFrame.new(nearest.Trunk.Position + Vector3.new(0,2,0))
					while farmWood and nearest and nearest.Parent do
						VIM:SendMouseButtonEvent(0,0,0,true,game,0)
						task.wait(0.05)
						VIM:SendMouseButtonEvent(0,0,0,false,game,0)
						task.wait(0.25)
					end
				end
			end
		end
		task.wait(0.2)
	end
end)

local tpCampBtn = espBtn:Clone()
tpCampBtn.Parent = extraPage
tpCampBtn.Position = woodBtn.Position + UDim2.new(0, 0, 0, 60)
tpCampBtn.Text = "TP to Campfire"

local autoCampBtn = espBtn:Clone()
autoCampBtn.Parent = extraPage
autoCampBtn.Position = tpCampBtn.Position + UDim2.new(0, 0, 0, 60)
autoCampBtn.Text = "AutoCampfire: OFF"

local campfire = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Campground") and workspace.Map.Campground:FindFirstChild("MainFire")

tpCampBtn.MouseButton1Click:Connect(function()
	local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
	if hrp and campfire and campfire:IsA("BasePart") then
		hrp.CFrame = campfire.CFrame + Vector3.new(0, 2, 0)
	end
end)

local autoCamp = false
autoCampBtn.MouseButton1Click:Connect(function()
	autoCamp = not autoCamp
	autoCampBtn.Text = "AutoCampfire: " .. (autoCamp and "ON" or "OFF")
end)

task.spawn(function()
	while true do
		if autoCamp and campfire then
			local items = workspace:FindFirstChild("Items")
			if items then
				for _, obj in ipairs(items:GetDescendants()) do
					if obj:IsA("Model") and obj.PrimaryPart and fuel[obj.Name] then
						pcall(function()
							obj:SetPrimaryPartCFrame(campfire.CFrame + Vector3.new(0, 3, 0))
						end)
					end
				end
			end
		end
		task.wait(0.2)
	end
end)
-- Toggle menu
floatBtn.MouseButton1Click:Connect(function()
	menu.Visible = not menu.Visible
end)
