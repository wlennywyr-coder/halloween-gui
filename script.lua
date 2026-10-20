-- GUI Halloween : visuel uniquement, aucune fonctionnalité réelle
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local ORANGE = Color3.fromRGB(255, 120, 20)
local PURPLE = Color3.fromRGB(110, 50, 160)
local DARK = Color3.fromRGB(15, 10, 22)
local DARK2 = Color3.fromRGB(30, 18, 42)
local OFF = Color3.fromRGB(70, 60, 85)

local gui = Instance.new("ScreenGui")
gui.Name = "MM2HalloweenGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Fenêtre principale
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 290)
frame.Position = UDim2.new(0.5, -140, 0.5, -145)
frame.BackgroundColor3 = DARK
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke")
stroke.Color = ORANGE
stroke.Thickness = 2
stroke.Parent = frame

-- Titre
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 44)
title.BackgroundColor3 = PURPLE
title.BorderSizePixel = 0
title.Text = "🎃 MM2 AUTOFARM 🎃"
title.TextColor3 = ORANGE
title.Font = Enum.Font.GothamBlack
title.TextSize = 18
title.Parent = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 12)

-- Déplacement de la fenêtre via le titre
local dragging, dragStart, startPos
title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

-- Bouton activable (visuel uniquement)
local function createButton(text, yPos)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -30, 0, 42)
	btn.Position = UDim2.new(0, 15, 0, yPos)
	btn.BackgroundColor3 = OFF
	btn.AutoButtonColor = false
	btn.Text = text .. " : OFF"
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 15
	btn.Parent = frame
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

	local s = Instance.new("UIStroke")
	s.Color = PURPLE
	s.Thickness = 1.5
	s.Parent = btn

	local enabled = false
	btn.MouseButton1Click:Connect(function()
		enabled = not enabled
		btn.Text = text .. (enabled and " : ON" or " : OFF")
		btn.BackgroundColor3 = enabled and ORANGE or OFF
		btn.TextColor3 = enabled and DARK or Color3.new(1, 1, 1)
		s.Color = enabled and Color3.fromRGB(255, 200, 80) or PURPLE
		-- Aucune action ici : purement visuel
	end)
end

createButton("🎃 Autofarm", 60)
createButton("👻 Auto Reset", 112)

-- Jauge de vitesse (visuelle)
local MIN_SPEED, MAX_SPEED = 16, 100

local sliderLabel = Instance.new("TextLabel")
sliderLabel.Size = UDim2.new(1, -30, 0, 22)
sliderLabel.Position = UDim2.new(0, 15, 0, 168)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Text = "🦇 Speed Autofarm : " .. MIN_SPEED
sliderLabel.TextColor3 = ORANGE
sliderLabel.Font = Enum.Font.GothamBold
sliderLabel.TextSize = 14
sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
sliderLabel.Parent = frame

local track = Instance.new("Frame")
track.Size = UDim2.new(1, -30, 0, 10)
track.Position = UDim2.new(0, 15, 0, 202)
track.BackgroundColor3 = DARK2
track.BorderSizePixel = 0
track.Parent = frame
Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

local fill = Instance.new("Frame")
fill.Size = UDim2.new(0, 0, 1, 0)
fill.BackgroundColor3 = ORANGE
fill.BorderSizePixel = 0
fill.Parent = track
Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

local knob = Instance.new("Frame")
knob.Size = UDim2.new(0, 20, 0, 20)
knob.AnchorPoint = Vector2.new(0.5, 0.5)
knob.Position = UDim2.new(0, 0, 0.5, 0)
knob.BackgroundColor3 = Color3.fromRGB(255, 200, 80)
knob.BorderSizePixel = 0
knob.Parent = track
Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
local ks = Instance.new("UIStroke", knob)
ks.Color = PURPLE
ks.Thickness = 2

local sliding = false
local function updateSlider(inputX)
	local rel = math.clamp((inputX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
	fill.Size = UDim2.new(rel, 0, 1, 0)
	knob.Position = UDim2.new(rel, 0, 0.5, 0)
	local value = math.floor(MIN_SPEED + rel * (MAX_SPEED - MIN_SPEED))
	sliderLabel.Text = "🦇 Speed Autofarm : " .. value
	-- Aucune action ici : purement visuel
end

track.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		sliding = true
		updateSlider(input.Position.X)
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch) then
		updateSlider(input.Position.X)
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		sliding = false
		dragging = false
	end
end)

-- Crédit
local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, 0, 0, 24)
credit.Position = UDim2.new(0, 0, 1, -32)
credit.BackgroundTransparency = 1
credit.Text = "Autofarm made by yaowa7"
credit.TextColor3 = Color3.fromRGB(170, 130, 210)
credit.Font = Enum.Font.GothamMedium
credit.TextSize = 12
credit.Parent = frame
