-- Modern GUI Library v2.0
-- Updated with smooth animations and modern design
-- Compatible with Roblox Lua

local TweenService = game:GetService('TweenService')
local UserInputService = game:GetService('UserInputService')
local TextService = game:GetService('TextService')
local Players = game:GetService('Players')
local CoreGui = (gethui and gethui()) or game:FindFirstChild('CoreGui') or Players.LocalPlayer.PlayerGui

-- Enhanced Blur System
local ElBlurSource = function()
	local GuiSystem = {}
	local RunService = game:GetService('RunService')
	local CurrentCamera = workspace.CurrentCamera

	function GuiSystem:Hash()
		return string.reverse(string.gsub(game:GetService('HttpService'):GenerateGUID(false),'..',function(aa)
			return string.reverse(aa)
		end))
	end

	local function Hiter(planePos, planeNormal, rayOrigin, rayDirection)
		local n = planeNormal
		local d = rayDirection
		local v = rayOrigin - planePos

		local num = (n.x*v.x) + (n.y*v.y) + (n.z*v.z)
		local den = (n.x*d.x) + (n.y*d.y) + (n.z*d.z)
		local a = -num / den

		return rayOrigin + (a * rayDirection), a;
	end;

	function GuiSystem.new(frame)
		local Part = Instance.new('Part',workspace)
		local DepthOfField = Instance.new('DepthOfFieldEffect',game:GetService('Lighting'))
		local SurfaceGui = Instance.new('SurfaceGui',Part)
		local BlockMesh = Instance.new("BlockMesh")

		BlockMesh.Parent = Part

		Part.Material = Enum.Material.Glass
		Part.Transparency = 1
		Part.Reflectance = 0.2
		Part.CastShadow = false
		Part.Anchored = true
		Part.CanCollide = false
		Part.CanQuery = false
		Part.CollisionGroup = GuiSystem:Hash()
		Part.Size = Vector3.new(1, 1, 1) * 0.01
		Part.Color = Color3.fromRGB(15,15,15)

		TweenService:Create(Part,TweenInfo.new(1.2,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
			Transparency = 0.85
		}):Play()

		DepthOfField.Enabled = true
		DepthOfField.FarIntensity = 0.8
		DepthOfField.FocusDistance = 0
		DepthOfField.InFocusRadius = 600
		DepthOfField.NearIntensity = 0.8

		SurfaceGui.AlwaysOnTop = true
		SurfaceGui.Adornee = Part
		SurfaceGui.Active = true
		SurfaceGui.Face = Enum.NormalId.Front
		SurfaceGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
		SurfaceGui.LightInfluence = 0

		DepthOfField.Name = GuiSystem:Hash()
		Part.Name = GuiSystem:Hash()
		SurfaceGui.Name = GuiSystem:Hash()

		local C4 = {
			Update = nil,
			Collection = SurfaceGui,
			Enabled = true,
			Instances = {
				BlockMesh = BlockMesh,
				Part = Part,
				DepthOfField = DepthOfField,
				SurfaceGui = SurfaceGui,
			},
			Signal = nil
		};

		local Update = function()
			if not C4.Enabled then
				TweenService:Create(Part,TweenInfo.new(0.8,Enum.EasingStyle.Quint),{
					Transparency = 1
				}):Play()
				return
			end;

			TweenService:Create(Part,TweenInfo.new(0.8,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
				Transparency = 0.85
			}):Play()

			local corner0 = frame.AbsolutePosition
			local corner1 = corner0 + frame.AbsoluteSize

			local ray0 = CurrentCamera.ScreenPointToRay(CurrentCamera,corner0.X, corner0.Y, 1)
			local ray1 = CurrentCamera.ScreenPointToRay(CurrentCamera,corner1.X, corner1.Y, 1)

			local planeOrigin = CurrentCamera.CFrame.Position + CurrentCamera.CFrame.LookVector * (0.05 - CurrentCamera.NearPlaneZ)
			local planeNormal = CurrentCamera.CFrame.LookVector

			local pos0 = Hiter(planeOrigin, planeNormal, ray0.Origin, ray0.Direction)
			local pos1 = Hiter(planeOrigin, planeNormal, ray1.Origin, ray1.Direction)

			pos0 = CurrentCamera.CFrame:PointToObjectSpace(pos0)
			pos1 = CurrentCamera.CFrame:PointToObjectSpace(pos1)

			local size   = pos1 - pos0
			local center = (pos0 + pos1) / 2

			BlockMesh.Offset = center
			BlockMesh.Scale  = size / 0.0101
			Part.CFrame = CurrentCamera.CFrame
		end

		C4.Update = Update
		C4.Signal = RunService.RenderStepped:Connect(Update)

		pcall(function()
			C4.Signal2 = CurrentCamera:GetPropertyChangedSignal('CFrame'):Connect(function()
				Part.CFrame = CurrentCamera.CFrame
			end)
		end)

		return C4
	end

	return GuiSystem
end

-- Configuration Helper
local Config = function(data,default)
	data = data or {}
	for i,v in next,default do
		data[i] = data[i] or v
	end
	return data
end

-- Modern Color Palette
local ModernColors = {
	Primary = Color3.fromRGB(25, 25, 25),
	Secondary = Color3.fromRGB(35, 35, 35),
	Accent = Color3.fromRGB(45, 45, 45),
	Text = Color3.fromRGB(255, 255, 255),
	TextSecondary = Color3.fromRGB(200, 200, 200),
	Border = Color3.fromRGB(255, 255, 255),
	Shadow = Color3.fromRGB(0, 0, 0)
}

-- Main Library
local Library = {}

Library['.'] = '1'
Library['FetchIcon'] = "https://raw.githubusercontent.com/evoincorp/lucideblox/master/src/modules/util/icons.json"

pcall(function()
	Library['Icons'] = game:GetService('HttpService'):JSONDecode(game:HttpGetAsync(Library.FetchIcon))['icons']
end)

function Library.new(config)
	config = Config(config,{
		Title = "Modern UI Library",
		Description = "discord.gg/BH6pE7jesa",
		Keybind = Enum.KeyCode.LeftControl,
		Logo = "http://www.roblox.com/asset/?id=18810965406",
		Size = UDim2.new(0.1, 500, 0.1, 350)
	})

	local TweenInfo1 = TweenInfo.new(0.6,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
	local TweenInfo2 = TweenInfo.new(0.4,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut)

	local WindowTable = {
		Tabs = {},
		Dropdown = {},
		WindowToggle = true,
		Keybind = config.Keybind,
		ToggleButton = nil
	}

	local ScreenGui = Instance.new("ScreenGui")
	local MainFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local MainDropShadow = Instance.new("ImageLabel")
	local Headers = Instance.new("Frame")
	local Logo = Instance.new("ImageLabel")
	local Title = Instance.new("TextLabel")
	local Description = Instance.new("TextLabel")
	local TabButtonFrame = Instance.new("Frame")
	local TabButtons = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")
	local MainTabFrame = Instance.new("Frame")
	local InputFrame = Instance.new("Frame")

	local function Update()
		if WindowTable.WindowToggle then
			TweenService:Create(MainFrame,TweenInfo.new(0.6,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
				BackgroundTransparency = 0.15,
				Size = config.Size,
				Position = UDim2.fromScale(0.5,0.5)
			}):Play()
			
			TweenService:Create(MainDropShadow,TweenInfo1,{
				ImageTransparency = 0.4
			}):Play()
			
			WindowTable.ElBlurUI.Enabled = true
		else
			TweenService:Create(MainFrame,TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.In),{
				BackgroundTransparency = 1,
				Size = UDim2.new(0.1, 0, 0.05, 0),
				Position = UDim2.fromScale(0.5,-0.2)
			}):Play()
			
			TweenService:Create(MainDropShadow,TweenInfo1,{
				ImageTransparency = 1
			}):Play()
			
			WindowTable.ElBlurUI.Enabled = false
		end

		WindowTable.Dropdown:Close()
		if WindowTable.ToggleButton then
			WindowTable.ToggleButton()
		end

		task.delay(0.3,WindowTable.ElBlurUI.Update)
	end

	-- Modern Toggle Button
	task.spawn(function()
		local Frame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local DropShadow = Instance.new("ImageLabel")
		local TextLabel = Instance.new("TextLabel")
		local Button = Instance.new("TextButton")

		Frame.Parent = ScreenGui
		Frame.AnchorPoint = Vector2.new(0.5, 0.5)
		Frame.BackgroundColor3 = ModernColors.Secondary
		Frame.BackgroundTransparency = 0.3
		Frame.BorderSizePixel = 0
		Frame.Position = UDim2.new(0.5, 0, -0.2, 0)
		Frame.Size = UDim2.new(0.12, 0, 0.06, 0)
		Frame.ZIndex = 150

		TweenService:Create(Frame,TweenInfo.new(0.8,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
			Position = UDim2.new(0.5, 0, 0.05, 0)
		}):Play()

		UICorner.CornerRadius = UDim.new(0.5, 0)
		UICorner.Parent = Frame

		DropShadow.Name = "DropShadow"
		DropShadow.Parent = Frame
		DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
		DropShadow.BackgroundTransparency = 1
		DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
		DropShadow.Size = UDim2.new(1, 30, 1, 30)
		DropShadow.ZIndex = 149
		DropShadow.Image = "rbxassetid://6014261993"
		DropShadow.ImageColor3 = ModernColors.Shadow
		DropShadow.ImageTransparency = 0.4
		DropShadow.ScaleType = Enum.ScaleType.Slice
		DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

		TextLabel.Parent = Frame
		TextLabel.Active = true
		TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Position = UDim2.new(0.5, 0, 0.6, 0)
		TextLabel.Size = UDim2.new(0.9, 0, 0.4, 0)
		TextLabel.ZIndex = 150
		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.Text = config.Title
		TextLabel.TextColor3 = ModernColors.Text
		TextLabel.TextScaled = true
		TextLabel.TextTransparency = 0.1

		Button.Name = "Button"
		Button.Parent = Frame
		Button.BackgroundTransparency = 1
		Button.Size = UDim2.new(1, 0, 1, 0)
		Button.ZIndex = 150
		Button.Font = Enum.Font.SourceSans
		Button.Text = ""
		Button.TextTransparency = 1

		Button.MouseEnter:Connect(function()
			TweenService:Create(Frame,TweenInfo.new(0.2),{
				BackgroundTransparency = 0.2
			}):Play()
		end)

		Button.MouseLeave:Connect(function()
			TweenService:Create(Frame,TweenInfo.new(0.2),{
				BackgroundTransparency = 0.3
			}):Play()
		end)

		Button.MouseButton1Click:Connect(function()
			WindowTable.WindowToggle = not WindowTable.WindowToggle
			Update()
		end)

		WindowTable.ToggleButton = function()
			if not WindowTable.WindowToggle then
				TweenService:Create(Frame,TweenInfo.new(0.6,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
					Position = UDim2.new(0.5, 0, 0.05, 0)
				}):Play()
			else
				TweenService:Create(Frame,TweenInfo.new(0.6,Enum.EasingStyle.Back,Enum.EasingDirection.In),{
					Position = UDim2.new(0.5, 0, -0.2, 0)
				}):Play()
			end
		end

		WindowTable.ToggleButton()
	end)

	-- Main Frame Setup
	ScreenGui.Parent = CoreGui
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.Name = "ModernGameGui"

	MainFrame.Name = "MainFrame"
	MainFrame.Parent = ScreenGui
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.BackgroundColor3 = ModernColors.Primary
	MainFrame.BackgroundTransparency = 1
	MainFrame.BorderSizePixel = 0
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.Size = UDim2.fromOffset(config.Size.X.Offset,config.Size.Y.Offset)
	MainFrame.Active = true

	TweenService:Create(MainFrame,TweenInfo.new(0.8,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
		BackgroundTransparency = 0.15,
		Size = config.Size
	}):Play()

	WindowTable.ElBlurUI = ElBlurSource.new(MainFrame)

	UICorner.CornerRadius = UDim.new(0, 12)
	UICorner.Parent = MainFrame

	MainDropShadow.Name = "MainDropShadow"
	MainDropShadow.Parent = MainFrame
	MainDropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	MainDropShadow.BackgroundTransparency = 1
	MainDropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainDropShadow.Size = UDim2.new(1, 60, 1, 60)
	MainDropShadow.ZIndex = 0
	MainDropShadow.Image = "rbxassetid://6015897843"
	MainDropShadow.ImageColor3 = ModernColors.Shadow
	MainDropShadow.ImageTransparency = 0.5
	MainDropShadow.ScaleType = Enum.ScaleType.Slice
	MainDropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
	TweenService:Create(MainDropShadow,TweenInfo2,{ImageTransparency = 0.4}):Play()

	Headers.Name = "Headers"
	Headers.Parent = MainFrame
	Headers.BackgroundColor3 = ModernColors.Secondary
	Headers.BackgroundTransparency = 0.3
	Headers.BorderSizePixel = 0
	Headers.ClipsDescendants = true
	Headers.Position = UDim2.new(0.01, 0, 0.015, 0)
	Headers.Size = UDim2.new(0.3, 0, 0.178, 0)
	Headers.ZIndex = 3
	TweenService:Create(Headers,TweenInfo2,{BackgroundTransparency = 0.3}):Play()

	Logo.Name = "Logo"
	Logo.Parent = Headers
	Logo.Active = true
	Logo.AnchorPoint = Vector2.new(0.5, 0.5)
	Logo.BackgroundTransparency = 1
	Logo.Position = UDim2.new(0.5, 0, 0.5, 0)
	Logo.Size = UDim2.new(0.95, 0, 0.95, 0)
	Logo.ZIndex = 4
	Logo.Image = config.Logo
	Logo.ScaleType = Enum.ScaleType.Crop
	Logo.ImageTransparency = 1
	TweenService:Create(Logo,TweenInfo2,{ImageTransparency = 0}):Play()

	UICorner_2.CornerRadius = UDim.new(0, 4)
	UICorner_2.Parent = Headers
	TweenService:Create(UICorner_2,TweenInfo2,{CornerRadius = UDim.new(0, 4)}):Play()

	Title.Name = "Title"
	Title.Parent = MainFrame
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0.328, 0, 0.013, 0)
	Title.Size = UDim2.new(0.671, 0, 0.052, 0)
	Title.Font = Enum.Font.GothamBold
	Title.Text = config.Title
	Title.TextColor3 = ModernColors.Text
	Title.TextScaled = true
	Title.TextWrapped = true
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.TextTransparency = 1
	TweenService:Create(Title,TweenInfo2,{TextTransparency = 0}):Play()

	Description.Name = "Description"
	Description.Parent = MainFrame
	Description.BackgroundTransparency = 1
	Description.Position = UDim2.new(0.328, 0, 0.071, 0)
	Description.Size = UDim2.new(0.671, 0, 0.029, 0)
	Description.Font = Enum.Font.GothamBold
	Description.Text = config.Description
	Description.TextColor3 = ModernColors.TextSecondary
	Description.TextScaled = true
	Description.TextTransparency = 1
	Description.TextWrapped = true
	Description.TextXAlignment = Enum.TextXAlignment.Left
	TweenService:Create(Description,TweenInfo2,{TextTransparency = 0.5}):Play()

	TabButtonFrame.Name = "TabButtonFrame"
	TabButtonFrame.Parent = MainFrame
	TabButtonFrame.AnchorPoint = Vector2.new(0.5, 0)
	TabButtonFrame.BackgroundColor3 = ModernColors.Secondary
	TabButtonFrame.BackgroundTransparency = 0.3
	TabButtonFrame.BorderSizePixel = 0
	TabButtonFrame.ClipsDescendants = true
	TabButtonFrame.Position = UDim2.new(0.16, 0, 0.215, 0)
	TabButtonFrame.Size = UDim2.new(0.3, 0, 0.775, 0)
	TweenService:Create(TabButtonFrame,TweenInfo2,{BackgroundTransparency = 0.3}):Play()

	UICorner_6.CornerRadius = UDim.new(0, 6)
	UICorner_6.Parent = TabButtonFrame

	TabButtons.Name = "TabButtons"
	TabButtons.Parent = TabButtonFrame
	TabButtons.Active = true
	TabButtons.AnchorPoint = Vector2.new(0.5, 0.5)
	TabButtons.BackgroundTransparency = 1
	TabButtons.BorderSizePixel = 0
	TabButtons.ClipsDescendants = false
	TabButtons.Position = UDim2.new(0.5, 0, 0.5, 0)
	TabButtons.Size = UDim2.new(0.97, 0, 0.97, 0)
	TabButtons.ScrollBarThickness = 0

	UIListLayout.Parent = TabButtons
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 4)

	MainTabFrame.Name = "MainTabFrame"
	MainTabFrame.Parent = MainFrame
	MainTabFrame.AnchorPoint = Vector2.new(0.5, 0)
	MainTabFrame.BackgroundColor3 = ModernColors.Secondary
	MainTabFrame.BackgroundTransparency = 0.3
	MainTabFrame.BorderSizePixel = 0
	MainTabFrame.ClipsDescendants = true
	MainTabFrame.Position = UDim2.new(0.658, 0, 0.131, 0)
	MainTabFrame.Size = UDim2.new(0.67, 0, 0.86, 0)
	TweenService:Create(MainTabFrame,TweenInfo2,{BackgroundTransparency = 0.3}):Play()

	UICorner_7.CornerRadius = UDim.new(0, 6)
	UICorner_7.Parent = MainTabFrame

	InputFrame.Name = "InputFrame"
	InputFrame.Parent = MainFrame
	InputFrame.BackgroundTransparency = 1
	InputFrame.BorderSizePixel = 0
	InputFrame.Position = UDim2.new(0, 0, 0, 0)
	InputFrame.Size = UDim2.new(1, 0, 0.121, 0)
	InputFrame.ZIndex = 15

	-- Input Handling
	UserInputService.InputBegan:Connect(function(io)
		if io.KeyCode == WindowTable.Keybind then
			WindowTable.WindowToggle = not WindowTable.WindowToggle
			Update()
		end
	end)

	-- Dropdown System
	task.spawn(function()
		local DropdownFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local MiniDropShadow = Instance.new("ImageLabel")
		local UIStroke = Instance.new("UIStroke")
		local ValueId = Instance.new("TextLabel")
		local ScrollingFrame = Instance.new("ScrollingFrame")
		local UIListLayout = Instance.new("UIListLayout")

		DropdownFrame.Name = "DropdownFrame"
		DropdownFrame.Parent = ScreenGui
		DropdownFrame.BackgroundColor3 = ModernColors.Primary
		DropdownFrame.BackgroundTransparency = 1
		DropdownFrame.BorderSizePixel = 0
		DropdownFrame.Position = UDim2.new(0, 289, 0, 213)
		DropdownFrame.Size = UDim2.new(0, 150, 0, 145)
		DropdownFrame.ZIndex = 100
		DropdownFrame.Visible = false

		UICorner.CornerRadius = UDim.new(0, 6)
		UICorner.Parent = DropdownFrame

		MiniDropShadow.Name = "MiniDropShadow"
		MiniDropShadow.Parent = DropdownFrame
		MiniDropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
		MiniDropShadow.BackgroundTransparency = 1
		MiniDropShadow.BorderSizePixel = 0
		MiniDropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
		MiniDropShadow.Size = UDim2.new(1, 30, 1, 30)
		MiniDropShadow.ZIndex = 99
		MiniDropShadow.Image = "rbxassetid://6015897843"
		MiniDropShadow.ImageColor3 = ModernColors.Shadow
		MiniDropShadow.ImageTransparency = 0.6
		MiniDropShadow.ScaleType = Enum.ScaleType.Slice
		MiniDropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

		UIStroke.Transparency = 0.9
		UIStroke.Color = ModernColors.Border
		UIStroke.Parent = DropdownFrame

		ValueId.Name = "ValueId"
		ValueId.Parent = DropdownFrame
		ValueId.AnchorPoint = Vector2.new(0.5, 0)
		ValueId.BackgroundTransparency = 1
		ValueId.Position = UDim2.new(0.5, 0, 0, 0)
		ValueId.Size = UDim2.new(0.97, 0, 0.5, 0)
		ValueId.ZIndex = 101
		ValueId.Font = Enum.Font.GothamBold
		ValueId.Text = "NONE"
		ValueId.TextColor3 = ModernColors.Text
		ValueId.TextScaled = true
		ValueId.TextTransparency = 0.8
		ValueId.TextWrapped = true
		ValueId.TextXAlignment = Enum.TextXAlignment.Right

		ScrollingFrame.Parent = DropdownFrame
		ScrollingFrame.Active = true
		ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		ScrollingFrame.BackgroundTransparency = 1
		ScrollingFrame.BorderSizePixel = 0
		ScrollingFrame.Position = UDim2.new(0.5, 0, 0.556, 0)
		ScrollingFrame.Size = UDim2.new(0.95, 0, 0.888, 0)
		ScrollingFrame.ZIndex = 102
		ScrollingFrame.BottomImage = ""
		ScrollingFrame.ScrollBarThickness = 1
		ScrollingFrame.TopImage = ""

		UIListLayout.Parent = ScrollingFrame
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 4)

		local Locked = nil
		local Looped = false

		local function GetSelector(title,value)
			local Selector = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local TitleLabel = Instance.new("TextLabel")
			local Frame = Instance.new("Frame")
			local UICorner_2 = Instance.new("UICorner")
			local Button = Instance.new("TextButton")
			local UIStroke = Instance.new("UIStroke")

			Selector.Name = "Selector"
			Selector.Parent = ScrollingFrame
			Selector.BackgroundColor3 = ModernColors.Accent
			Selector.BackgroundTransparency = 0.75
			Selector.BorderSizePixel = 0
			Selector.ClipsDescendants = true
			Selector.Size = UDim2.new(0.97, 0, 0.5, 0)
			Selector.ZIndex = 103

			UICorner.CornerRadius = UDim.new(0, 3)
			UICorner.Parent = Selector

			TitleLabel.Name = "Title"
			TitleLabel.Parent = Selector
			TitleLabel.AnchorPoint = Vector2.new(0, 0.5)
			TitleLabel.BackgroundTransparency = 1
			TitleLabel.Position = UDim2.new(0.025, 0, 0.5, 0)
			TitleLabel.Size = UDim2.new(1, 0, 0.5, 0)
			TitleLabel.ZIndex = 104
			TitleLabel.Font = Enum.Font.GothamBold
			TitleLabel.Text = title
			TitleLabel.TextColor3 = ModernColors.Text
			TitleLabel.TextScaled = true
			TitleLabel.TextWrapped = true
			TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

			Frame.Parent = Selector
			Frame.AnchorPoint = Vector2.new(1, 0.5)
			Frame.BackgroundColor3 = ModernColors.Text
			Frame.BackgroundTransparency = 0.6
			Frame.BorderSizePixel = 0
			Frame.Position = UDim2.new(1.025, 0, 0.5, 0)
			Frame.Size = UDim2.new(0.055, 0, 0.7, 0)
			Frame.ZIndex = 104

			UICorner_2.CornerRadius = UDim.new(0, 3)
			UICorner_2.Parent = Frame

			Button.Name = "Button"
			Button.Parent = Selector
			Button.BackgroundTransparency = 1
			Button.Size = UDim2.new(1, 0, 1, 0)
			Button.ZIndex = 105
			Button.Font = Enum.Font.SourceSans
			Button.Text = ""
			Button.TextTransparency = 1

			UIStroke.Transparency = 0.9
			UIStroke.Color = ModernColors.Border
			UIStroke.Parent = Selector

			local function SetActive(active)
				if active then
					TweenService:Create(Frame,TweenInfo.new(0.1),{
						Position = UDim2.new(1.025, 0, 0.5, 0)
					}):Play()
					TweenService:Create(TitleLabel,TweenInfo.new(0.1),{
						TextTransparency = 0
					}):Play()
				else
					TweenService:Create(Frame,TweenInfo.new(0.1),{
						Position = UDim2.new(1.125, 0, 0.5, 0)
					}):Play()
					TweenService:Create(TitleLabel,TweenInfo.new(0.1),{
						TextTransparency = 0.25
					}):Play()
				end
			end

			SetActive(value)

			return {
				SetActive = SetActive,
				Button = Button,
				Destroy = function()
					Selector:Destroy()
				end
			}
		end

		local MouseInFrame = false
		local MouseInMyFrame = false

		function WindowTable.Dropdown:Setup(target_frame)
			Locked = target_frame
		end

		function WindowTable.Dropdown:Open(args,default,callback)
			Looped = true
			ValueId.Text = tostring(default)

			TweenService:Create(DropdownFrame,TweenInfo.new(0.3),{
				BackgroundTransparency = 0.1
			}):Play()

			TweenService:Create(MiniDropShadow,TweenInfo.new(0.3),{
				ImageTransparency = 0.4
			}):Play()

			TweenService:Create(ValueId,TweenInfo.new(0.3),{
				TextTransparency = 0.8
			}):Play()

			TweenService:Create(UIStroke,TweenInfo.new(0.3),{
				Transparency = 0.8
			}):Play()

			for i,v in pairs(ScrollingFrame:GetChildren()) do
				if v:IsA('Frame') then
					v:Destroy()
				end
			end

			local list = {}

			for i,v in pairs(args) do
				local selector = GetSelector(tostring(v),v == default)

				selector.Button.MouseButton1Click:Connect(function()
					for i,s in ipairs(list) do
						if s[1] == v then
							s[2].SetActive(true)
						else
							s[2].SetActive(false)
						end
					end
					ValueId.Text = tostring(v)
					callback(v)
				end)

				table.insert(list,{v,selector})
			end
		end

		function WindowTable.Dropdown:Close()
			Looped = false
			
			TweenService:Create(UIStroke,TweenInfo.new(0.3),{
				Transparency = 1
			}):Play()
			
			TweenService:Create(DropdownFrame,TweenInfo.new(0.3),{
				BackgroundTransparency = 1
			}):Play()

			TweenService:Create(MiniDropShadow,TweenInfo.new(0.3),{
				ImageTransparency = 1
			}):Play()

			TweenService:Create(ValueId,TweenInfo.new(0.3),{
				TextTransparency = 1
			}):Play()

			for i,v in pairs(ScrollingFrame:GetChildren()) do
				if v:IsA('Frame') then
					v:Destroy()
				end
			end
		end

		MainFrame.MouseEnter:Connect(function()
			MouseInFrame = true
		end)
		
		MainFrame.MouseLeave:Connect(function()
			MouseInFrame = false
		end)

		DropdownFrame.MouseEnter:Connect(function()
			MouseInMyFrame = true
		end)
		
		DropdownFrame.MouseLeave:Connect(function()
			MouseInMyFrame = false
		end)

		UserInputService.InputBegan:Connect(function(keycode)
			if keycode.UserInputType == Enum.UserInputType.MouseButton1 or keycode.UserInputType == Enum.UserInputType.Touch then
				if not MouseInFrame and not MouseInMyFrame then
					WindowTable.Dropdown:Close()
				end
			end
		end)

		game:GetService('RunService'):BindToRenderStep('__MODERN_UI__',20,function()
			WindowTable.Dropdown.Value = Looped
			if Looped then
				DropdownFrame.Visible = true
				
				TweenService:Create(DropdownFrame,TweenInfo.new(0.15),{
					Position = UDim2.fromOffset(Locked.AbsolutePosition.X + 5,Locked.AbsolutePosition.Y + (DropdownFrame.AbsoluteSize.Y / 1.5)),
					Size = UDim2.fromOffset(Locked.AbsoluteSize.X,150)
				}):Play()
			else
				if Locked then
					DropdownFrame.Size = DropdownFrame.Size:Lerp(UDim2.fromOffset(Locked.AbsoluteSize.X,0),.2)
					DropdownFrame.Position = DropdownFrame.Position:Lerp(UDim2.fromOffset(Locked.AbsolutePosition.X,Locked.AbsolutePosition.Y+DropdownFrame.AbsoluteSize.Y),.1)
				else
					DropdownFrame.Size = DropdownFrame.Size:Lerp(UDim2.fromOffset(0,0),.1)
					DropdownFrame.Position = DropdownFrame.Position:Lerp(UDim2.fromOffset(0,0),.1)
				end

				if DropdownFrame.Size.Y.Offset == 0 then
					DropdownFrame.Visible = false
				end
			end
		end)
	end)

	-- Tab Creation
	function WindowTable:NewTab(cfg)
		cfg = Config(cfg,{
			Title = "Example",
			Description = "Tab: "..tostring(#WindowTable.Tabs + 1),
			Icon = "rbxassetid://7733964640"
		})

		local TabTable = {}
		
		local TabButton = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local Icon = Instance.new("ImageLabel")
		local Title = Instance.new("TextLabel")
		local Description = Instance.new("TextLabel")
		local Frame = Instance.new("Frame")
		local Button = Instance.new("TextButton")

		TabButton.Name = "TabButton"
		TabButton.Parent = TabButtons
		TabButton.BackgroundColor3 = ModernColors.Accent
		TabButton.BackgroundTransparency = 0.75
		TabButton.BorderSizePixel = 0
		TabButton.ClipsDescendants = true
		TabButton.Size = UDim2.new(0.97, 0, 0.5, 0)
		TabButton.ZIndex = 5
		TweenService:Create(TabButton,TweenInfo2,{BackgroundTransparency = 0.75}):Play()

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = TabButton

		Icon.Name = "Icon"
		Icon.Parent = TabButton
		Icon.AnchorPoint = Vector2.new(0.5, 0.5)
		Icon.BackgroundTransparency = 1
		Icon.Position = UDim2.new(0.1, 0, 0.5, 0)
		Icon.Size = UDim2.new(0.6, 0, 0.6, 0)
		Icon.SizeConstraint = Enum.SizeConstraint.RelativeYY
		Icon.ZIndex = 6
		Icon.Image = cfg.Icon
		Icon.ImageTransparency = 1
		TweenService:Create(Icon,TweenInfo2,{ImageTransparency = 0.1}):Play()

		Title.Name = "Title"
		Title.Parent = TabButton
		Title.AnchorPoint = Vector2.new(0, 0.5)
		Title.BackgroundTransparency = 1
		Title.Position = UDim2.new(0.2, 0, 0.375, 0)
		Title.Size = UDim2.new(1, 0, 0.4, 0)
		Title.Font = Enum.Font.GothamBold
		Title.Text = cfg.Title
		Title.TextColor3 = ModernColors.Text
		Title.TextScaled = true
		Title.TextWrapped = true
		Title.TextXAlignment = Enum.TextXAlignment.Left
		Title.TextTransparency = 1

		Description.Name = "Description"
		Description.Parent = TabButton
		Description.AnchorPoint = Vector2.new(0, 0.5)
		Description.BackgroundTransparency = 1
		Description.Position = UDim2.new(0.2, 0, 0.7, 0)
		Description.Size = UDim2.new(1, 0, 0.3, 0)
		Description.Font = Enum.Font.Gotham
		Description.Text = cfg.Description
		Description.TextColor3 = ModernColors.TextSecondary
		Description.TextScaled = true
		Description.TextTransparency = 1
		Description.TextWrapped = true
		Description.TextXAlignment = Enum.TextXAlignment.Left

		Frame.Parent = TabButton
		Frame.AnchorPoint = Vector2.new(1, 0.5)
		Frame.BackgroundColor3 = ModernColors.Text
		Frame.BackgroundTransparency = 0.6
		Frame.BorderSizePixel = 0
		Frame.Position = UDim2.new(1.025, 0, 0.5, 0)
		Frame.Size = UDim2.new(0.055, 0, 0.7, 0)
		Frame.ZIndex = 6
		TweenService:Create(Frame,TweenInfo2,{BackgroundTransparency = 0.1}):Play()

		local UICorner_3 = Instance.new("UICorner")
		UICorner_3.CornerRadius = UDim.new(0, 3)
		UICorner_3.Parent = Frame

		Button.Name = "Button"
		Button.Parent = TabButton
		Button.BackgroundTransparency = 1
		Button.Size = UDim2.new(1, 0, 1, 0)
		Button.ZIndex = 15
		Button.Font = Enum.Font.SourceSans
		Button.Text = ""
		Button.TextTransparency = 1

		local Init = Instance.new("Frame")
		local LeftFrame = Instance.new("ScrollingFrame")
		local RightFrame = Instance.new("ScrollingFrame")

		Init.Name = "Init"
		Init.Parent = MainTabFrame
		Init.AnchorPoint = Vector2.new(0.5, 0.5)
		Init.BackgroundTransparency = 1
		Init.BorderSizePixel = 0
		Init.Position = UDim2.new(0.5, 0, 0.5, 0)
		Init.Size = UDim2.new(0.98, 0, 0.98, 0)
		Init.ZIndex = 4

		LeftFrame.Name = "LeftFrame"
		LeftFrame.Parent = Init
		LeftFrame.Active = true
		LeftFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		LeftFrame.BackgroundTransparency = 1
		LeftFrame.BorderSizePixel = 0
		LeftFrame.ClipsDescendants = false
		LeftFrame.Position = UDim2.new(0.25, 0, 0.5, 0)
		LeftFrame.Size = UDim2.new(0.5, 0, 1, 0)
		LeftFrame.ScrollBarThickness = 0

		local UIListLayout_Left = Instance.new("UIListLayout")
		UIListLayout_Left.Parent = LeftFrame
		UIListLayout_Left.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout_Left.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_Left.Padding = UDim.new(0, 4)

		RightFrame.Name = "RightFrame"
		RightFrame.Parent = Init
		RightFrame.Active = true
		RightFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		RightFrame.BackgroundTransparency = 1
		RightFrame.BorderSizePixel = 0
		RightFrame.ClipsDescendants = false
		RightFrame.Position = UDim2.new(0.75, 0, 0.5, 0)
		RightFrame.Size = UDim2.new(0.5, 0, 1, 0)
		RightFrame.ScrollBarThickness = 0

		local UIListLayout_Right = Instance.new("UIListLayout")
		UIListLayout_Right.Parent = RightFrame
		UIListLayout_Right.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout_Right.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_Right.Padding = UDim.new(0, 4)

		local function onFunction(value)
			if value then
				Init.Visible = true

				TweenService:Create(Icon,TweenInfo.new(0.55,Enum.EasingStyle.Quint),{
					ImageTransparency = 0.1
				}):Play()

				TweenService:Create(Title,TweenInfo.new(0.5,Enum.EasingStyle.Quint),{
					TextTransparency = 0
				}):Play()

				TweenService:Create(Description,TweenInfo.new(0.4,Enum.EasingStyle.Quint),{
					TextTransparency = 0.5
				}):Play()

				TweenService:Create(Frame,TweenInfo.new(0.55,Enum.EasingStyle.Quint),{
					Position = UDim2.new(1.025, 0, 0.5, 0)
				}):Play()
			else
				Init.Visible = false

				TweenService:Create(Icon,TweenInfo.new(0.55,Enum.EasingStyle.Quint),{
					ImageTransparency = 0.25
				}):Play()

				TweenService:Create(Title,TweenInfo.new(0.4,Enum.EasingStyle.Quint),{
					TextTransparency = 0.25
				}):Play()

				TweenService:Create(Description,TweenInfo.new(0.5,Enum.EasingStyle.Quint),{
					TextTransparency = 0.65
				}):Play()

				TweenService:Create(Frame,TweenInfo.new(0.55,Enum.EasingStyle.Quint),{
					Position = UDim2.new(1.1, 0, 0.4, 0)
				}):Play()
			end
		end

		if WindowTable.Tabs[1] then
			onFunction(false)
		else
			onFunction(true)
		end

		table.insert(WindowTable.Tabs,{
			Id = Init,
			onFunction = onFunction,
		})

		Button.MouseButton1Click:Connect(function()
			for i,v in ipairs(WindowTable.Tabs) do
				if v.Id == Init then
					v.onFunction(true)
				else
					v.onFunction(false)
				end
			end
		end)

		-- Section Creation
		function TabTable:NewSection(c_o_n_f_i_g)
			c_o_n_f_i_g = Config(c_o_n_f_i_g,{
				Position = "Left",
				Title = "Section",
				Icon = 'rbxassetid://7733964640'
			})

			local SectionTable = {}
			
			local Section = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local Header = Instance.new("Frame")
			local Icon = Instance.new("ImageLabel")
			local Title = Instance.new("TextLabel")
			local SectionAutoUI = Instance.new("UIListLayout")
			local UIStroke = Instance.new("UIStroke")

			Section.Name = "Section"
			Section.Parent = (c_o_n_f_i_g.Position == "Left" and LeftFrame) or RightFrame
			Section.BackgroundColor3 = ModernColors.Accent
			Section.BackgroundTransparency = 1
			Section.BorderSizePixel = 0
			Section.Size = UDim2.new(0.98, 0, 0, 200)
			Section.ClipsDescendants = true
			TweenService:Create(Section,TweenInfo.new(0.8),{BackgroundTransparency = 0.75}):Play()

			UICorner.CornerRadius = UDim.new(0, 6)
			UICorner.Parent = Section

			Header.Name = "Header"
			Header.Parent = Section
			Header.BackgroundColor3 = ModernColors.Primary
			Header.BackgroundTransparency = 0.9
			Header.BorderSizePixel = 0
			Header.Size = UDim2.new(1, 0, 0.5, 0)
			TweenService:Create(Header,TweenInfo2,{BackgroundTransparency = 0.9}):Play()

			Icon.Name = "Icon"
			Icon.Parent = Header
			Icon.AnchorPoint = Vector2.new(0.5, 0.5)
			Icon.BackgroundTransparency = 1
			Icon.Position = UDim2.new(0.065, 0, 0.5, 0)
			Icon.Size = UDim2.new(0.6, 0, 0.6, 0)
			Icon.SizeConstraint = Enum.SizeConstraint.RelativeYY
			Icon.ZIndex = 6
			Icon.Image = c_o_n_f_i_g.Icon
			Icon.ImageTransparency = 1
			TweenService:Create(Icon,TweenInfo2,{ImageTransparency = 0.1}):Play()

			Title.Name = "Title"
			Title.Parent = Header
			Title.AnchorPoint = Vector2.new(0, 0.5)
			Title.BackgroundTransparency = 1
			Title.Position = UDim2.new(0.125, 0, 0.45, 0)
			Title.Size = UDim2.new(1, 0, 0.5, 0)
			Title.Font = Enum.Font.GothamBold
			Title.Text = c_o_n_f_i_g.Title
			Title.TextColor3 = ModernColors.Text
			Title.TextScaled = true
			Title.TextWrapped = true
			Title.TextXAlignment = Enum.TextXAlignment.Left
			Title.TextTransparency = 1
			TweenService:Create(Title,TweenInfo2,{TextTransparency = 0}):Play()

			SectionAutoUI.Name = "SectionAutoUI"
			SectionAutoUI.Parent = Section
			SectionAutoUI.HorizontalAlignment = Enum.HorizontalAlignment.Center
			SectionAutoUI.SortOrder = Enum.SortOrder.LayoutOrder
			SectionAutoUI.Padding = UDim.new(0, 4)

			SectionAutoUI:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
				TweenService:Create(Section,TweenInfo.new(0.1),{
					Size = UDim2.new(0.98,0,0,math.max(SectionAutoUI.AbsoluteContentSize.Y,50) + (SectionAutoUI.Padding.Offset * 1.12))
				}):Play()
			end)

			UIStroke.Transparency = 1
			UIStroke.Color = ModernColors.Border
			UIStroke.Parent = Section
			TweenService:Create(UIStroke,TweenInfo1,{Transparency = 0.9}):Play()

			-- Toggle Creation
			function SectionTable:NewToggle(toggle)
				toggle = Config(toggle,{
					Title = "Toggle",
					Default = false,
					Callback = function() end
				})

				local FunctionToggle = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local TextInt = Instance.new("TextLabel")
				local Button = Instance.new("TextButton")
				local UIStroke = Instance.new("UIStroke")
				local System = Instance.new("Frame")
				local Icon = Instance.new("Frame")

				FunctionToggle.Name = "FunctionToggle"
				FunctionToggle.Parent = Section
				FunctionToggle.BackgroundColor3 = ModernColors.Primary
				FunctionToggle.BackgroundTransparency = 1
				FunctionToggle.BorderSizePixel = 0
				FunctionToggle.Size = UDim2.new(0.95, 0, 0.5, 0)
				FunctionToggle.ZIndex = 17
				TweenService:Create(FunctionToggle,TweenInfo1,{BackgroundTransparency = 0.8}):Play()

				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = FunctionToggle

				TextInt.Name = "TextInt"
				TextInt.Parent = FunctionToggle
				TextInt.AnchorPoint = Vector2.new(0.5, 0.5)
				TextInt.BackgroundTransparency = 1
				TextInt.Position = UDim2.new(0.5, 0, 0.5, 0)
				TextInt.Size = UDim2.new(0.95, 0, 0.48, 0)
				TextInt.ZIndex = 18
				TextInt.Font = Enum.Font.GothamBold
				TextInt.Text = toggle.Title
				TextInt.TextColor3 = ModernColors.Text
				TextInt.TextScaled = true
				TextInt.TextTransparency = 0.25
				TextInt.TextWrapped = true
				TextInt.TextXAlignment = Enum.TextXAlignment.Left

				Button.Name = "Button"
				Button.Parent = FunctionToggle
				Button.BackgroundTransparency = 1
				Button.Size = UDim2.new(1, 0, 1, 0)
				Button.ZIndex = 15
				Button.Font = Enum.Font.SourceSans
				Button.Text = ""
				Button.TextTransparency = 1

				UIStroke.Transparency = 0.95
				UIStroke.Color = ModernColors.Border
				UIStroke.Parent = FunctionToggle

				System.Name = "System"
				System.Parent = FunctionToggle
				System.AnchorPoint = Vector2.new(1, 0.5)
				System.BackgroundTransparency = 1
				System.Position = UDim2.new(0.975, 0, 0.5, 0)
				System.Size = UDim2.new(0.155, 0, 0.6, 0)
				System.ZIndex = 18

				local UICorner_2 = Instance.new("UICorner")
				UICorner_2.CornerRadius = UDim.new(0.5, 0)
				UICorner_2.Parent = System

				local UIStroke_2 = Instance.new("UIStroke")
				UIStroke_2.Transparency = 0.85
				UIStroke_2.Color = ModernColors.Border
				UIStroke_2.Parent = System

				Icon.Name = "Icon"
				Icon.Parent = System
				Icon.AnchorPoint = Vector2.new(0.5, 0.5)
				Icon.BackgroundColor3 = ModernColors.Text
				Icon.BackgroundTransparency = 0.5
				Icon.BorderSizePixel = 0
				Icon.Position = UDim2.new(0.25, 0, 0.5, 0)
				Icon.Size = UDim2.new(1, 0, 1, 0)
				Icon.SizeConstraint = Enum.SizeConstraint.RelativeYY
				Icon.ZIndex = 17

				local UICorner_3 = Instance.new("UICorner")
				UICorner_3.CornerRadius = UDim.new(1, 0)
				UICorner_3.Parent = Icon

				local function OnChange(value)
					if value then
						TweenService:Create(TextInt,TweenInfo.new(0.15,Enum.EasingStyle.Quint),{
							TextTransparency = 0.02
						}):Play()

						TweenService:Create(Icon,TweenInfo.new(0.15,Enum.EasingStyle.Quint),{
							Position = UDim2.new(0.75, 0, 0.5, 0),
							BackgroundTransparency = 0.4
						}):Play()
					else
						TweenService:Create(Icon,TweenInfo.new(0.15,Enum.EasingStyle.Quint),{
							Position = UDim2.new(0.25, 0, 0.5, 0),
							BackgroundTransparency = 0.5
						}):Play()

						TweenService:Create(TextInt,TweenInfo.new(0.15,Enum.EasingStyle.Quint),{
							TextTransparency = 0.25
						}):Play()
					end
				end

				OnChange(toggle.Default)

				Button.MouseButton1Click:Connect(function()
					toggle.Default = not toggle.Default
					OnChange(toggle.Default)
					task.spawn(toggle.Callback,toggle.Default)
				end)

				return {
					Value = function(newindex)
						toggle.Default = newindex
						OnChange(toggle.Default)
						task.spawn(toggle.Callback,toggle.Default)
					end,
					Visible = function(newindx)
						FunctionToggle.Visible = newindx
					end
				}
			end

			-- Button Creation
			function SectionTable:NewButton(cfg)
				cfg = Config(cfg,{
					Title = "Button",
					Callback = function() end
				})

				local FunctionButton = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local DropShadow = Instance.new("ImageLabel")
				local TextInt = Instance.new("TextLabel")
				local Button = Instance.new("TextButton")
				local UIStroke = Instance.new("UIStroke")

				FunctionButton.Name = "FunctionButton"
				FunctionButton.Parent = Section
				FunctionButton.BackgroundColor3 = Color3.fromRGB(71, 71, 71)
				FunctionButton.BackgroundTransparency = 1
				FunctionButton.BorderSizePixel = 0
				FunctionButton.Size = UDim2.new(0.95, 0, 0.5, 0)
				FunctionButton.ZIndex = 17
				TweenService:Create(FunctionButton,TweenInfo1,{
					BackgroundTransparency = 0.75,
					Size = UDim2.new(0.95, 0, 0.5, 0)
				}):Play()

				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = FunctionButton

				DropShadow.Name = "DropShadow"
				DropShadow.Parent = FunctionButton
				DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
				DropShadow.BackgroundTransparency = 1
				DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
				DropShadow.Size = UDim2.new(1, 20, 1, 20)
				DropShadow.ZIndex = 16
				DropShadow.Image = "rbxassetid://6015897843"
				DropShadow.ImageColor3 = ModernColors.Shadow
				DropShadow.ImageTransparency = 0.6
				DropShadow.ScaleType = Enum.ScaleType.Slice
				DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

				TextInt.Name = "TextInt"
				TextInt.Parent = FunctionButton
				TextInt.AnchorPoint = Vector2.new(0.5, 0.5)
				TextInt.BackgroundTransparency = 1
				TextInt.Position = UDim2.new(0.5, 0, 0.5, 0)
				TextInt.Size = UDim2.new(1, 0, 0.48, 0)
				TextInt.ZIndex = 18
				TextInt.Font = Enum.Font.GothamBold
				TextInt.Text = cfg.Title
				TextInt.TextColor3 = ModernColors.Text
				TextInt.TextScaled = true
				TextInt.TextTransparency = 0.25
				TextInt.TextWrapped = true

				Button.Name = "Button"
				Button.Parent = FunctionButton
				Button.BackgroundTransparency = 1
				Button.Size = UDim2.new(1, 0, 1, 0)
				Button.ZIndex = 15
				Button.Font = Enum.Font.SourceSans
				Button.Text = ""
				Button.TextTransparency = 1

				UIStroke.Transparency = 0.92
				UIStroke.Color = ModernColors.Border
				UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				UIStroke.Parent = FunctionButton

				Button.MouseEnter:Connect(function()
					TweenService:Create(DropShadow,TweenInfo.new(0.2),{
						ImageTransparency = 0.35
					}):Play()

					TweenService:Create(TextInt,TweenInfo.new(0.2),{
						TextTransparency = 0
					}):Play()
				end)

				Button.MouseLeave:Connect(function()
					TweenService:Create(DropShadow,TweenInfo.new(0.2),{
						ImageTransparency = 0.6
					}):Play()

					TweenService:Create(TextInt,TweenInfo.new(0.2),{
						TextTransparency = 0.25
					}):Play()
				end)

				Button.MouseButton1Click:Connect(function()
					task.spawn(cfg.Callback)
				end)

				return {
					Visible = function(newindx)
						FunctionButton.Visible = newindx
					end,
					Fire = cfg.Callback
				}
			end

			-- Slider Creation
			function SectionTable:NewSlider(slider)
				slider = Config(slider,{
					Title = "Slider",
					Min = 0,
					Max = 100,
					Default = 50,
					Callback = function() end
				})

				local FunctionSlider = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local TextInt = Instance.new("TextLabel")
				local UIStroke = Instance.new("UIStroke")
				local ValueText = Instance.new("TextLabel")
				local MFrame = Instance.new("Frame")
				local TFrame = Instance.new("Frame")

				FunctionSlider.Name = "FunctionSlider"
				FunctionSlider.Parent = Section
				FunctionSlider.BackgroundColor3 = ModernColors.Primary
				FunctionSlider.BackgroundTransparency = 0.8
				FunctionSlider.BorderSizePixel = 0
				FunctionSlider.Size = UDim2.new(0.95, 0, 0.5, 0)
				FunctionSlider.ZIndex = 17

				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = FunctionSlider

				TextInt.Name = "TextInt"
				TextInt.Parent = FunctionSlider
				TextInt.AnchorPoint = Vector2.new(0.5, 0.5)
				TextInt.BackgroundTransparency = 1
				TextInt.Position = UDim2.new(0.5, 0, 0.26, 0)
				TextInt.Size = UDim2.new(0.95, 0, 0.38, 0)
				TextInt.ZIndex = 18
				TextInt.Font = Enum.Font.GothamBold
				TextInt.Text = slider.Title
				TextInt.TextColor3 = ModernColors.Text
				TextInt.TextScaled = true
				TextInt.TextTransparency = 0.25
				TextInt.TextWrapped = true
				TextInt.TextXAlignment = Enum.TextXAlignment.Left

				UIStroke.Transparency = 0.95
				UIStroke.Color = ModernColors.Border
				UIStroke.Parent = FunctionSlider

				ValueText.Name = "ValueText"
				ValueText.Parent = FunctionSlider
				ValueText.AnchorPoint = Vector2.new(0.5, 0.5)
				ValueText.BackgroundTransparency = 1
				ValueText.Position = UDim2.new(0.5, 0, 0.26, 0)
				ValueText.Size = UDim2.new(0.95, 0, 0.35, 0)
				ValueText.ZIndex = 18
				ValueText.Font = Enum.Font.GothamBold
				ValueText.Text = tostring(slider.Default)..'/'..tostring(slider.Max)
				ValueText.TextColor3 = ModernColors.Text
				ValueText.TextScaled = true
				ValueText.TextTransparency = 0.5
				ValueText.TextWrapped = true
				ValueText.TextXAlignment = Enum.TextXAlignment.Right

				MFrame.Name = "MFrame"
				MFrame.Parent = FunctionSlider
				MFrame.AnchorPoint = Vector2.new(0.5, 0.5)
				MFrame.BackgroundColor3 = ModernColors.Shadow
				MFrame.BackgroundTransparency = 0.8
				MFrame.BorderSizePixel = 0
				MFrame.ClipsDescendants = true
				MFrame.Position = UDim2.new(0.5, 0, 0.75, 0)
				MFrame.Size = UDim2.new(0.95, 0, 0.29, 0)
				MFrame.ZIndex = 18

				local UICorner_2 = Instance.new("UICorner")
				UICorner_2.CornerRadius = UDim.new(0, 4)
				UICorner_2.Parent = MFrame

				TFrame.Name = "TFrame"
				TFrame.Parent = MFrame
				TFrame.BackgroundColor3 = ModernColors.Text
				TFrame.BackgroundTransparency = 0.5
				TFrame.BorderSizePixel = 0
				TFrame.Size = UDim2.new((slider.Default / slider.Max), 0, 1, 0)
				TFrame.ZIndex = 17

				local UICorner_3 = Instance.new("UICorner")
				UICorner_3.CornerRadius = UDim.new(0, 4)
				UICorner_3.Parent = TFrame

				local UIStroke_2 = Instance.new("UIStroke")
				UIStroke_2.Transparency = 0.975
				UIStroke_2.Color = ModernColors.Border
				UIStroke_2.Parent = MFrame

				local Holding = false

				local function update(Input)
					local SizeScale = math.clamp((((Input.Position.X) - MFrame.AbsolutePosition.X) / MFrame.AbsoluteSize.X), 0, 1)
					local Value = math.floor(((slider.Max - slider.Min) * SizeScale) + slider.Min)
					local Size = UDim2.fromScale(SizeScale, 1)
					ValueText.Text = tostring(Value)..'/'..tostring(slider.Max)
					TweenService:Create(TFrame,TweenInfo.new(0.1),{Size = Size}):Play()
					slider.Callback(Value)
				end

				MFrame.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
						Holding = true
						update(Input)
						TweenService:Create(TextInt,TweenInfo.new(0.1),{
							TextTransparency = 0
						}):Play()
					end
				end)

				MFrame.InputEnded:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
						Holding = false
						TweenService:Create(TextInt,TweenInfo.new(0.1),{
							TextTransparency = 0.3
						}):Play()
					end
				end)

				UserInputService.InputChanged:Connect(function(Input)
					if Holding then
						if (Input.UserInputType==Enum.UserInputType.MouseMovement or Input.UserInputType==Enum.UserInputType.Touch)  then
							update(Input)
						end
					end
				end)

				return {
					Visible = function(newindx)
						FunctionSlider.Visible = newindx
					end,
					Value = function(lrm)
						TFrame.Size = UDim2.new((lrm / slider.Max), 0, 1, 0)
						slider.Callback(lrm)
					end
				}
			end

			-- Dropdown Creation
			function SectionTable:NewDropdown(drop)
				drop = Config(drop,{
					Title = "Dropdown",
					Data = {'One','Two','Three','Four'},
					Default = 'Two',
					Callback = function(a) end
				})

				local FunctionDropdown = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local TextInt = Instance.new("TextLabel")
				local UIStroke = Instance.new("UIStroke")
				local MFrame = Instance.new("Frame")
				local ValueText = Instance.new("TextLabel")
				local Button = Instance.new("TextButton")

				FunctionDropdown.Name = "FunctionDropdown"
				FunctionDropdown.Parent = Section
				FunctionDropdown.BackgroundColor3 = ModernColors.Primary
				FunctionDropdown.BackgroundTransparency = 0.8
				FunctionDropdown.BorderSizePixel = 0
				FunctionDropdown.Size = UDim2.new(0.95, 0, 0.5, 0)
				FunctionDropdown.ZIndex = 17

				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = FunctionDropdown

				TextInt.Name = "TextInt"
				TextInt.Parent = FunctionDropdown
				TextInt.AnchorPoint = Vector2.new(0.5, 0.5)
				TextInt.BackgroundTransparency = 1
				TextInt.Position = UDim2.new(0.5, 0, 0.2, 0)
				TextInt.Size = UDim2.new(0.95, 0, 0.32, 0)
				TextInt.ZIndex = 18
				TextInt.Font = Enum.Font.GothamBold
				TextInt.Text = drop.Title
				TextInt.TextColor3 = ModernColors.Text
				TextInt.TextScaled = true
				TextInt.TextTransparency = 0.25
				TextInt.TextWrapped = true
				TextInt.TextXAlignment = Enum.TextXAlignment.Left

				UIStroke.Transparency = 0.95
				UIStroke.Color = ModernColors.Border
				UIStroke.Parent = FunctionDropdown

				MFrame.Name = "MFrame"
				MFrame.Parent = FunctionDropdown
				MFrame.AnchorPoint = Vector2.new(0.5, 0.5)
				MFrame.BackgroundColor3 = ModernColors.Shadow
				MFrame.BackgroundTransparency = 0.8
				MFrame.BorderSizePixel = 0
				MFrame.ClipsDescendants = true
				MFrame.Position = UDim2.new(0.5, 0, 0.7, 0)
				MFrame.Size = UDim2.new(0.95, 0, 0.375, 0)
				MFrame.ZIndex = 18

				local UICorner_2 = Instance.new("UICorner")
				UICorner_2.CornerRadius = UDim.new(0, 4)
				UICorner_2.Parent = MFrame

				local UIStroke_2 = Instance.new("UIStroke")
				UIStroke_2.Transparency = 0.975
				UIStroke_2.Color = ModernColors.Border
				UIStroke_2.Parent = MFrame

				ValueText.Name = "ValueText"
				ValueText.Parent = MFrame
				ValueText.AnchorPoint = Vector2.new(0.5, 0.5)
				ValueText.BackgroundTransparency = 1
				ValueText.Position = UDim2.new(0.5, 0, 0.5, 0)
				ValueText.Size = UDim2.new(1, 0, 0.8, 0)
				ValueText.ZIndex = 18
				ValueText.Font = Enum.Font.GothamBold
				ValueText.Text = drop.Default or "NONE"
				ValueText.TextColor3 = ModernColors.Text
				ValueText.TextScaled = true
				ValueText.TextTransparency = 0.5
				ValueText.TextWrapped = true

				Button.Name = "Button"
				Button.Parent = FunctionDropdown
				Button.BackgroundTransparency = 1
				Button.Size = UDim2.new(1, 0, 1, 0)
				Button.ZIndex = 25
				Button.Font = Enum.Font.SourceSans
				Button.Text = ""
				Button.TextTransparency = 1

				MFrame.MouseEnter:Connect(function()
					TweenService:Create(ValueText,TweenInfo.new(0.3),{
						TextTransparency = 0.1
					}):Play()
				end)

				MFrame.MouseLeave:Connect(function()
					TweenService:Create(ValueText,TweenInfo.new(0.3),{
						TextTransparency = 0.5
					}):Play()
				end)

				local function UpdateValue(value)
					drop.Default = value
					ValueText.Text = tostring(value)
					drop.Callback(value)
				end

				Button.MouseButton1Click:Connect(function()
					WindowTable.Dropdown:Setup(MFrame)
					WindowTable.Dropdown:Open(drop.Data,drop.Default,UpdateValue)
				end)

				return {
					Visible = function(newindx)
						FunctionDropdown.Visible = newindx
					end,
					Value = function(value)
						ValueText.Text = tostring(value)
						drop.Callback(value)
					end,
					Open = function()
						WindowTable.Dropdown:Setup(MFrame)
						WindowTable.Dropdown:Open(drop.Data,drop.Default,UpdateValue)
					end,
					Close = function()
						WindowTable.Dropdown:Close()
					end
				}
			end

			return SectionTable
		end

		return TabTable
	end

	-- Drag System
	local dragToggle = nil
	local dragSpeed = 0.15
	local dragStart = nil
	local startPos = nil

	local function updateInput(input)
		WindowTable.ElBlurUI.Update()
		local delta = input.Position - dragStart
		local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		game:GetService('TweenService'):Create(MainFrame, TweenInfo.new(dragSpeed), {Position = position}):Play()
	end

	InputFrame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
			dragToggle = true
			dragStart = input.Position
			startPos = MainFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragToggle then
				updateInput(input)
			end
		end
	end)

	return WindowTable
end

-- Modern Notification System
Library.Notification = function()
	local Notification = Instance.new("ScreenGui")
	local Frame = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")
	
	Notification.Name = "ModernNotification"
	Notification.Parent = CoreGui
	Notification.ResetOnSpawn = false
	Notification.ZIndexBehavior = Enum.ZIndexBehavior.Global
	Notification.Name = game:GetService('HttpService'):GenerateGUID(false)
	Notification.IgnoreGuiInset = true
	
	Frame.Parent = Notification
	Frame.AnchorPoint = Vector2.new(1, 0.5)
	Frame.BackgroundTransparency = 1
	Frame.Position = UDim2.new(0.95, 0, 0.5, 0)
	Frame.Size = UDim2.new(0.35, 0, 0.6, 0)
	Frame.SizeConstraint = Enum.SizeConstraint.RelativeYY

	UIListLayout.Parent = Frame
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	UIListLayout.Padding = UDim.new(0, 8)
	
	return {
		new = function(ctfx)
			ctfx = Config(ctfx,{
				Title = "Notification",
				Description = "Description",
				Duration = 5,
				Icon = "rbxassetid://7733993369"
			})
			
			local css_style = TweenInfo.new(0.4,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut)
			local Notifiy = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local icon = Instance.new("ImageLabel")
			local TextLabel = Instance.new("TextLabel")
			local TextLabel_2 = Instance.new("TextLabel")
			local DropShadow = Instance.new('ImageLabel')
			local UIStroke = Instance.new("UIStroke")
			
			-- Warna tema notifikasi
			local NotifColors = {
				Success = Color3.fromRGB(46, 204, 113),
				Error = Color3.fromRGB(231, 76, 60),
				Warning = Color3.fromRGB(241, 196, 15),
				Info = Color3.fromRGB(52, 152, 219)
			}
			
			DropShadow.Name = "DropShadow"
			DropShadow.Parent = Notifiy
			DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
			DropShadow.BackgroundTransparency = 1
			DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
			DropShadow.Size = UDim2.new(1, 25, 1, 25)
			DropShadow.Image = "rbxassetid://6015897843"
			DropShadow.ImageColor3 = ModernColors.Shadow
			DropShadow.ImageTransparency = 0.7
			DropShadow.ScaleType = Enum.ScaleType.Slice
			DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
			
			Notifiy.Name = "Notifiy"
			Notifiy.Parent = Frame
			Notifiy.BackgroundColor3 = ModernColors.Primary
			Notifiy.BackgroundTransparency = 1
			Notifiy.BorderSizePixel = 0
			Notifiy.ClipsDescendants = true
			Notifiy.Size = UDim2.new(0, 0, 0, 0)
			Notifiy.Position = UDim2.new(1, 0, 0, 0)
			
			UICorner.CornerRadius = UDim.new(0, 8)
			UICorner.Parent = Notifiy

			UIStroke.Transparency = 0.8
			UIStroke.Color = ModernColors.Border
			UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			UIStroke.Parent = Notifiy

			icon.Name = "icon"
			icon.Parent = Notifiy
			icon.AnchorPoint = Vector2.new(0.5, 0.5)
			icon.BackgroundTransparency = 1
			icon.Position = UDim2.new(0.15, 0, 0.5, 0)
			icon.Size = UDim2.new(0, 0, 0, 0)
			icon.Image = ctfx.Icon
			icon.ImageTransparency = 0
			
			TextLabel.Parent = Notifiy
			TextLabel.BackgroundTransparency = 1
			TextLabel.Position = UDim2.new(0.3, 0, 0.2, 0)
			TextLabel.Size = UDim2.new(0.65, 0, 0.3, 0)
			TextLabel.Font = Enum.Font.GothamBold
			TextLabel.Text = ctfx.Title
			TextLabel.TextColor3 = ModernColors.Text
			TextLabel.TextScaled = true
			TextLabel.TextWrapped = true
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left

			TextLabel_2.Parent = Notifiy
			TextLabel_2.BackgroundTransparency = 1
			TextLabel_2.Position = UDim2.new(0.3, 0, 0.5, 0)
			TextLabel_2.Size = UDim2.new(0.65, 0, 0.4, 0)
			TextLabel_2.Font = Enum.Font.Gotham
			TextLabel_2.Text = ctfx.Description
			TextLabel_2.TextColor3 = ModernColors.TextSecondary
			TextLabel_2.TextSize = 11
			TextLabel_2.TextWrapped = true
			TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel_2.TextYAlignment = Enum.TextYAlignment.Top
			
			local function showNotification()
				TweenService:Create(Notifiy,css_style,{
					BackgroundTransparency = 0.1,
					Size = UDim2.new(1, 0, 0.15, 0),
					Position = UDim2.new(0, 0, 0, 0)
				}):Play()
				
				TweenService:Create(DropShadow,css_style,{
					ImageTransparency = 0.4
				}):Play()
				
				TweenService:Create(icon,css_style,{
					Size = UDim2.new(0.12, 0, 0.6, 0)
				}):Play()
			end
			
			local function hideNotification()
				TweenService:Create(Notifiy,css_style,{
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 0, 0, 0),
					Position = UDim2.new(1, 0, 0, 0)
				}):Play()
				
				TweenService:Create(DropShadow,css_style,{
					ImageTransparency = 1
				}):Play()
				
				TweenService:Create(icon,css_style,{
					Size = UDim2.new(0, 0, 0, 0)
				}):Play()
			end
			
			showNotification()
			
			task.delay(ctfx.Duration,function()
				hideNotification()
				task.wait(0.5)
				Notifiy:Destroy()
			end)
		end
	}
end

-- Keybind System
Library.NewKeybind = function(ctfx)
	ctfx = Config(ctfx,{
		Title = "Keybind",
		Default = Enum.KeyCode.E,
		Callback = function() end
	})

	local BindEvent = Instance.new('BindableEvent')
	local FunctionKeybind = Instance.new("Frame")
	local TextInt = Instance.new("TextLabel")
	local Button = Instance.new("TextButton")
	local System = Instance.new("Frame")
	local Bindkey = Instance.new("TextLabel")

	BindEvent.Name = tostring(ctfx.Title)
	FunctionKeybind.Name = "FunctionKeybind"
	FunctionKeybind.Parent = ctfx.Parent or CoreGui
	FunctionKeybind.BackgroundColor3 = ModernColors.Primary
	FunctionKeybind.BackgroundTransparency = 0.8
	FunctionKeybind.BorderSizePixel = 0
	FunctionKeybind.Size = UDim2.new(0.95, 0, 0.5, 0)
	FunctionKeybind.ZIndex = 17

	local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
	UIAspectRatioConstraint.Parent = FunctionKeybind
	UIAspectRatioConstraint.AspectRatio = 8

	TextInt.Name = "TextInt"
	TextInt.Parent = FunctionKeybind
	TextInt.AnchorPoint = Vector2.new(0.5, 0.5)
	TextInt.BackgroundTransparency = 1
	TextInt.Position = UDim2.new(0.5, 0, 0.5, 0)
	TextInt.Size = UDim2.new(0.95, 0, 0.48, 0)
	TextInt.ZIndex = 18
	TextInt.Font = Enum.Font.GothamBold
	TextInt.Text = ctfx.Title
	TextInt.TextColor3 = ModernColors.Text
	TextInt.TextScaled = true
	TextInt.TextTransparency = 0.25
	TextInt.TextWrapped = true
	TextInt.TextXAlignment = Enum.TextXAlignment.Left

	Button.Name = "Button"
	Button.Parent = FunctionKeybind
	Button.BackgroundTransparency = 1
	Button.Size = UDim2.new(1, 0, 1, 0)
	Button.ZIndex = 15
	Button.Font = Enum.Font.SourceSans
	Button.Text = ""
	Button.TextTransparency = 1

	local UIStroke = Instance.new("UIStroke")
	UIStroke.Transparency = 0.95
	UIStroke.Color = ModernColors.Border
	UIStroke.Parent = FunctionKeybind

	System.Name = "System"
	System.Parent = FunctionKeybind
	System.AnchorPoint = Vector2.new(1, 0.5)
	System.BackgroundTransparency = 1
	System.Position = UDim2.new(0.975, 0, 0.5, 0)
	System.Size = UDim2.new(0, 50, 0.6, 0)
	System.ZIndex = 18

	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0.35, 0)
	UICorner.Parent = System

	local UIStroke_2 = Instance.new("UIStroke")
	UIStroke_2.Transparency = 0.95
	UIStroke_2.Color = ModernColors.Border
	UIStroke_2.Parent = System

	Bindkey.Name = "Bindkey"
	Bindkey.Parent = System
	Bindkey.AnchorPoint = Vector2.new(0.5, 0.5)
	Bindkey.BackgroundTransparency = 1
	Bindkey.Position = UDim2.new(0.5, 0, 0.5, 0)
	Bindkey.Size = UDim2.new(1, 0, 0.65, 0)
	Bindkey.Font = Enum.Font.GothamBold
	Bindkey.Text = UserInputService:GetStringForKeyCode(ctfx.Default) or ctfx.Default.Name
	Bindkey.TextColor3 = ModernColors.Text
	Bindkey.TextScaled = true
	Bindkey.TextTransparency = 0.5
	Bindkey.TextWrapped = true

	local UICorner_2 = Instance.new("UICorner")
	UICorner_2.CornerRadius = UDim.new(0, 4)
	UICorner_2.Parent = FunctionKeybind

	local IsWIP = false
	local function UpdateUI(new)
		Bindkey.Text = (typeof(new) == 'string' and new) or new.Name

		local size = TextService:GetTextSize(Bindkey.Text,Bindkey.TextSize,Bindkey.Font,Vector2.new(math.huge,math.huge))

		TweenService:Create(System,TweenInfo.new(0.2),{
			Size = UDim2.new(0, size.X + 2, 0.6, 0)
		}):Play()
	end

	UpdateUI(ctfx.Default)

	Button.MouseButton1Click:Connect(function()
		if IsWIP then return end
		IsWIP = true

		TweenService:Create(TextInt,TweenInfo.new(0.1),{
			TextTransparency = 0
		}):Play()

		local Signal = UserInputService.InputBegan:Connect(function(key)
			if key.KeyCode then
				if key.KeyCode ~= Enum.KeyCode.Unknown then
					BindEvent:Fire(key.KeyCode)
				end
			end
		end)

		UpdateUI('...')
		local Bind = BindEvent.Event:Wait()
		TweenService:Create(TextInt,TweenInfo.new(0.1),{
			TextTransparency = 0.25
		}):Play()
		Signal:Disconnect()
		UpdateUI(Bind)

		IsWIP = false
		ctfx.Callback(Bind)
	end)

	return {
		Visible = function(newindx)
			FunctionKeybind.Visible = newindx
		end,
		Value = function(lrm)
			UpdateUI(lrm)
			ctfx.Callback(lrm)
		end
	}
end

return table.freeze(Library)
