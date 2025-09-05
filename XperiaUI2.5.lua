-- Modern GUI Library v2.5 - Enhanced Edition
-- Premium SS++ Class with smooth animations and modern design
-- Compatible with Roblox Lua

local TweenService = game:GetService('TweenService')
local UserInputService = game:GetService('UserInputService')
local TextService = game:GetService('TextService')
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local CoreGui = (gethui and gethui()) or game:FindFirstChild('CoreGui') or Players.LocalPlayer.PlayerGui

-- Enhanced Blur System with performance optimization
local ElBlurSource = function()
	local GuiSystem = {}
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
		local Part = Instance.new('Part')
		local DepthOfField = Instance.new('DepthOfFieldEffect',game:GetService('Lighting'))
		local SurfaceGui = Instance.new('SurfaceGui',Part)
		local BlockMesh = Instance.new("BlockMesh")

		Part.Parent = workspace.Terrain
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

			local ray0 = CurrentCamera:ScreenPointToRay(corner0.X, corner0.Y, 1)
			local ray1 = CurrentCamera:ScreenPointToRay(corner1.X, corner1.Y, 1)

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
		if data[i] == nil then
			data[i] = v
		end
	end
	return data
end

-- Modern Color Palette with gradient support
local ModernColors = {
	Primary = Color3.fromRGB(25, 25, 25),
	Secondary = Color3.fromRGB(35, 35, 35),
	Accent = Color3.fromRGB(45, 45, 45),
	Text = Color3.fromRGB(255, 255, 255),
	TextSecondary = Color3.fromRGB(200, 200, 200),
	Border = Color3.fromRGB(255, 255, 255),
	Shadow = Color3.fromRGB(0, 0, 0),
	Success = Color3.fromRGB(46, 204, 113),
	Error = Color3.fromRGB(231, 76, 60),
	Warning = Color3.fromRGB(241, 196, 15),
	Info = Color3.fromRGB(52, 152, 219)
}

-- Main Library
local Library = {}

Library['.'] = '2.5'
Library['FetchIcon'] = "https://raw.githubusercontent.com/evoincorp/lucideblox/master/src/modules/util/icons.json"

-- Load icons with error handling
pcall(function()
	Library['Icons'] = game:GetService('HttpService'):JSONDecode(game:HttpGetAsync(Library.FetchIcon))['icons']
end)

function Library.new(config)
	config = Config(config,{
		Title = "Modern UI Library",
		Description = "Premium SS++ Class",
		Keybind = Enum.KeyCode.RightShift,
		Logo = "http://www.roblox.com/asset/?id=18810965406",
		Size = UDim2.new(0, 500, 0, 350),
		Theme = "Dark",
		Acrylic = true
	})

	local TweenInfo1 = TweenInfo.new(0.6,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
	local TweenInfo2 = TweenInfo.new(0.4,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut)
	local TweenInfo3 = TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)

	local WindowTable = {
		Tabs = {},
		Dropdown = {},
		WindowToggle = true,
		Keybind = config.Keybind,
		ToggleButton = nil,
		Theme = config.Theme
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
			
			if WindowTable.ElBlurUI then
				WindowTable.ElBlurUI.Enabled = true
			end
		else
			TweenService:Create(MainFrame,TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.In),{
				BackgroundTransparency = 1,
				Size = UDim2.new(0.1, 0, 0.05, 0),
				Position = UDim2.fromScale(0.5,-0.2)
			}):Play()
			
			TweenService:Create(MainDropShadow,TweenInfo1,{
				ImageTransparency = 1
			}):Play()
			
			if WindowTable.ElBlurUI then
				WindowTable.ElBlurUI.Enabled = false
			end
		end

		if WindowTable.Dropdown then
			WindowTable.Dropdown:Close()
		end
		
		if WindowTable.ToggleButton then
			WindowTable.ToggleButton()
		end

		if WindowTable.ElBlurUI then
			task.delay(0.3, WindowTable.ElBlurUI.Update)
		end
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
			TweenService:Create(TextLabel,TweenInfo.new(0.2),{
				TextTransparency = 0
			}):Play()
		end)

		Button.MouseLeave:Connect(function()
			TweenService:Create(Frame,TweenInfo.new(0.2),{
				BackgroundTransparency = 0.3
			}):Play()
			TweenService:Create(TextLabel,TweenInfo.new(0.2),{
				TextTransparency = 0.1
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
	ScreenGui.Name = "ModernGameGui_" .. game:GetService("HttpService"):GenerateGUID(false)

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

	-- Initialize blur effect only if Acrylic is enabled
	if config.Acrylic then
		WindowTable.ElBlurUI = ElBlurSource.new(MainFrame)
	end

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

	local UICorner_2 = Instance.new("UICorner")
	UICorner_2.CornerRadius = UDim.new(0, 4)
	UICorner_2.Parent = Headers

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

	local UICorner_6 = Instance.new("UICorner")
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
	TabButtons.ScrollBarThickness = 3
	TabButtons.ScrollBarImageColor3 = ModernColors.TextSecondary
	TabButtons.ScrollBarImageTransparency = 0.7

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

	local UICorner_7 = Instance.new("UICorner")
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
		if io.KeyCode == WindowTable.Keybind and not UserInputService:GetFocusedTextBox() then
			WindowTable.WindowToggle = not WindowTable.WindowToggle
			Update()
		end
	end)

	-- Tab System
	function WindowTable:Tab(title,icon)
		local Tab = {
			Title = title or "New Tab",
			Icon = icon or "rbxassetid://3926305904",
			Buttons = {},
			Container = nil,
			Button = nil
		}

		local TabButton = Instance.new("TextButton")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local Icon = Instance.new("ImageLabel")
		local TitleLabel = Instance.new("TextLabel")

		TabButton.Name = "TabButton"
		TabButton.Parent = TabButtons
		TabButton.BackgroundColor3 = ModernColors.Accent
		TabButton.BackgroundTransparency = 0.75
		TabButton.BorderSizePixel = 0
		TabButton.Size = UDim2.new(0.97, 0, 0, 40)
		TabButton.AutoButtonColor = false
		TabButton.Font = Enum.Font.SourceSans
		TabButton.Text = ""
		TabButton.TextTransparency = 1

		UICorner.CornerRadius = UDim.new(0, 3)
		UICorner.Parent = TabButton

		UIStroke.Transparency = 0.9
		UIStroke.Color = ModernColors.Border
		UIStroke.Parent = TabButton

		Icon.Name = "Icon"
		Icon.Parent = TabButton
		Icon.AnchorPoint = Vector2.new(0, 0.5)
		Icon.BackgroundTransparency = 1
		Icon.Position = UDim2.new(0.025, 0, 0.5, 0)
		Icon.Size = UDim2.new(0, 25, 0, 25)
		Icon.Image = Tab.Icon
		Icon.ImageColor3 = ModernColors.Text
		Icon.ImageTransparency = 0.25

		TitleLabel.Name = "Title"
		TitleLabel.Parent = TabButton
		TitleLabel.AnchorPoint = Vector2.new(0, 0.5)
		TitleLabel.BackgroundTransparency = 1
		TitleLabel.Position = UDim2.new(0.125, 0, 0.5, 0)
		TitleLabel.Size = UDim2.new(0.875, 0, 0.5, 0)
		TitleLabel.Font = Enum.Font.GothamBold
		TitleLabel.Text = Tab.Title
		TitleLabel.TextColor3 = ModernColors.Text
		TitleLabel.TextScaled = true
		TitleLabel.TextWrapped = true
		TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
		TitleLabel.TextTransparency = 0.25

		local Container = Instance.new("ScrollingFrame")
		local UIListLayout = Instance.new("UIListLayout")

		Container.Name = "Container"
		Container.Parent = MainTabFrame
		Container.Active = true
		Container.BackgroundTransparency = 1
		Container.BorderSizePixel = 0
		Container.Size = UDim2.new(1, 0, 1, 0)
		Container.Visible = false
		Container.ScrollBarThickness = 3
		Container.ScrollBarImageColor3 = ModernColors.TextSecondary
		Container.ScrollBarImageTransparency = 0.7
		Container.CanvasSize = UDim2.new(0, 0, 0, 0)

		UIListLayout.Parent = Container
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 4)

		Tab.Container = Container
		Tab.Button = TabButton

		TabButton.MouseEnter:Connect(function()
			if Container.Visible then return end
			TweenService:Create(TabButton,TweenInfo.new(0.2),{
				BackgroundTransparency = 0.7
			}):Play()
			TweenService:Create(Icon,TweenInfo.new(0.2),{
				ImageTransparency = 0.1
			}):Play()
			TweenService:Create(TitleLabel,TweenInfo.new(0.2),{
				TextTransparency = 0.1
			}):Play()
		end)

		TabButton.MouseLeave:Connect(function()
			if Container.Visible then return end
			TweenService:Create(TabButton,TweenInfo.new(0.2),{
				BackgroundTransparency = 0.75
			}):Play()
			TweenService:Create(Icon,TweenInfo.new(0.2),{
				ImageTransparency = 0.25
			}):Play()
			TweenService:Create(TitleLabel,TweenInfo.new(0.2),{
				TextTransparency = 0.25
			}):Play()
		end)

		TabButton.MouseButton1Click:Connect(function()
			for i,v in pairs(WindowTable.Tabs) do
				if v.Container then
					v.Container.Visible = false
				end
				if v.Button then
					TweenService:Create(v.Button,TweenInfo.new(0.2),{
						BackgroundTransparency = 0.75
					}):Play()
					TweenService:Create(v.Button.Icon,TweenInfo.new(0.2),{
						ImageTransparency = 0.25
					}):Play()
					TweenService:Create(v.Button.Title,TweenInfo.new(0.2),{
						TextTransparency = 0.25
					}):Play()
				end
			end

			TweenService:Create(TabButton,TweenInfo.new(0.2),{
				BackgroundTransparency = 0.65
			}):Play()
			TweenService:Create(Icon,TweenInfo.new(0.2),{
				ImageTransparency = 0
			}):Play()
			TweenService:Create(TitleLabel,TweenInfo.new(0.2),{
				TextTransparency = 0
			}):Play()

			Container.Visible = true
		end)

		-- Auto-resize container
		UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			Container.CanCanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
		end)

		-- Add to tabs
		table.insert(WindowTable.Tabs, Tab)

		-- Select first tab by default
		if #WindowTable.Tabs == 1 then
			TabButton.MouseButton1Click:Fire()
		end

		-- Section System
		function Tab:Section(title)
			local Section = {
				Title = title or "New Section",
				Container = nil
			}

			local SectionFrame = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local UIStroke = Instance.new("UIStroke")
			local TitleLabel = Instance.new("TextLabel")
			local Container = Instance.new("Frame")
			local UIListLayout = Instance.new("UIListLayout")

			SectionFrame.Name = "SectionFrame"
			SectionFrame.Parent = Tab.Container
			SectionFrame.BackgroundColor3 = ModernColors.Accent
			SectionFrame.BackgroundTransparency = 0.8
			SectionFrame.BorderSizePixel = 0
			SectionFrame.ClipsDescendants = true
			SectionFrame.Size = UDim2.new(0.97, 0, 0, 40)
			SectionFrame.LayoutOrder = #Tab.Container:GetChildren()

			UICorner.CornerRadius = UDim.new(0, 3)
			UICorner.Parent = SectionFrame

			UIStroke.Transparency = 0.9
			UIStroke.Color = ModernColors.Border
			UIStroke.Parent = SectionFrame

			TitleLabel.Name = "Title"
			TitleLabel.Parent = SectionFrame
			TitleLabel.AnchorPoint = Vector2.new(0.5, 0.5)
			TitleLabel.BackgroundTransparency = 1
			TitleLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
			TitleLabel.Size = UDim2.new(0.95, 0, 0.5, 0)
			TitleLabel.Font = Enum.Font.GothamBold
			TitleLabel.Text = Section.Title
			TitleLabel.TextColor3 = ModernColors.Text
			TitleLabel.TextScaled = true
			TitleLabel.TextWrapped = true
			TitleLabel.TextTransparency = 0.25

			Container.Name = "Container"
			Container.Parent = SectionFrame
			Container.BackgroundTransparency = 1
			Container.BorderSizePixel = 0
			Container.Position = UDim2.new(0, 0, 0.5, 0)
			Container.Size = UDim2.new(1, 0, 0.5, 0)
			Container.Visible = false

			UIListLayout.Parent = Container
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0, 4)

			Section.Container = Container

			-- Toggle section visibility
			SectionFrame.MouseButton1Click:Connect(function()
				Container.Visible = not Container.Visible
				if Container.Visible then
					TweenService:Create(SectionFrame,TweenInfo.new(0.2),{
						Size = UDim2.new(0.97, 0, 0, 80)
					}):Play()
					TweenService:Create(Container,TweenInfo.new(0.2),{
						Position = UDim2.new(0, 0, 0.5, 0)
					}):Play()
				else
					TweenService:Create(SectionFrame,TweenInfo.new(0.2),{
						Size = UDim2.new(0.97, 0, 0, 40)
					}):Play()
					TweenService:Create(Container,TweenInfo.new(0.2),{
						Position = UDim2.new(0, 0, 0.5, 0)
					}):Play()
				end
			end)

			-- Auto-resize section
			UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
				if Container.Visible then
					SectionFrame.Size = UDim2.new(0.97, 0, 0, 80 + UIListLayout.AbsoluteContentSize.Y)
				end
			end)

			-- Button System
			function Section:Button(title,callback)
				local Button = {
					Title = title or "New Button",
					Callback = callback or function() end
				}

				local ButtonFrame = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local UIStroke = Instance.new("UIStroke")
				local TitleLabel = Instance.new("TextLabel")
				local ButtonButton = Instance.new("TextButton")

				ButtonFrame.Name = "ButtonFrame"
				ButtonFrame.Parent = Section.Container
				ButtonFrame.BackgroundColor3 = ModernColors.Accent
				ButtonFrame.BackgroundTransparency = 0.75
				ButtonFrame.BorderSizePixel = 0
				ButtonFrame.Size = UDim2.new(0.97, 0, 0, 30)
				ButtonFrame.LayoutOrder = #Section.Container:GetChildren()

				UICorner.CornerRadius = UDim.new(0, 3)
				UICorner.Parent = ButtonFrame

				UIStroke.Transparency = 0.9
				UIStroke.Color = ModernColors.Border
				UIStroke.Parent = ButtonFrame

				TitleLabel.Name = "Title"
				TitleLabel.Parent = ButtonFrame
				TitleLabel.AnchorPoint = Vector2.new(0.5, 0.5)
				TitleLabel.BackgroundTransparency = 1
				TitleLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
				TitleLabel.Size = UDim2.new(0.95, 0, 0.5, 0)
				TitleLabel.Font = Enum.Font.GothamBold
				TitleLabel.Text = Button.Title
				TitleLabel.TextColor3 = ModernColors.Text
				TitleLabel.TextScaled = true
				TitleLabel.TextWrapped = true
				TitleLabel.TextTransparency = 0.25

				ButtonButton.Name = "Button"
				ButtonButton.Parent = ButtonFrame
				ButtonButton.BackgroundTransparency = 1
				ButtonButton.Size = UDim2.new(1, 0, 1, 0)
				ButtonButton.Font = Enum.Font.SourceSans
				ButtonButton.Text = ""
				ButtonButton.TextTransparency = 1

				ButtonButton.MouseEnter:Connect(function()
					TweenService:Create(ButtonFrame,TweenInfo.new(0.2),{
						BackgroundTransparency = 0.7
					}):Play()
					TweenService:Create(TitleLabel,TweenInfo.new(0.2),{
						TextTransparency = 0.1
					}):Play()
				end)

				ButtonButton.MouseLeave:Connect(function()
					TweenService:Create(ButtonFrame,TweenInfo.new(0.2),{
						BackgroundTransparency = 0.75
					}):Play()
					TweenService:Create(TitleLabel,TweenInfo.new(0.2),{
						TextTransparency = 0.25
					}):Play()
				end)

				ButtonButton.MouseButton1Click:Connect(function()
					Button.Callback()
					TweenService:Create(ButtonFrame,TweenInfo.new(0.1),{
						BackgroundTransparency = 0.65
					}):Play()
					TweenService:Create(TitleLabel,TweenInfo.new(0.1),{
						TextTransparency = 0
					}):Play()
					task.wait(0.1)
					TweenService:Create(ButtonFrame,TweenInfo.new(0.1),{
						BackgroundTransparency = 0.7
					}):Play()
					TweenService:Create(TitleLabel,TweenInfo.new(0.1),{
						TextTransparency = 0.1
					}):Play()
				end)

				return Button
			end

			-- Toggle System
			function Section:Toggle(title,default,callback)
				local Toggle = {
					Title = title or "New Toggle",
					Value = default or false,
					Callback = callback or function() end
				}

				local ToggleFrame = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local UIStroke = Instance.new("UIStroke")
				local TitleLabel = Instance.new("TextLabel")
				local ToggleButton = Instance.new("TextButton")
				local ToggleIndicator = Instance.new("Frame")
				local UICorner_2 = Instance.new("UICorner")

				ToggleFrame.Name = "ToggleFrame"
				ToggleFrame.Parent = Section.Container
				ToggleFrame.BackgroundColor3 = ModernColors.Accent
				ToggleFrame.BackgroundTransparency = 0.75
				ToggleFrame.BorderSizePixel = 0
				ToggleFrame.Size = UDim2.new(0.97, 0, 0, 30)
				ToggleFrame.LayoutOrder = #Section.Container:GetChildren()

				UICorner.CornerRadius = UDim.new(0, 3)
				UICorner.Parent = ToggleFrame

				UIStroke.Transparency = 0.9
				UIStroke.Color = ModernColors.Border
				UIStroke.Parent = ToggleFrame

				TitleLabel.Name = "Title"
				TitleLabel.Parent = ToggleFrame
				TitleLabel.AnchorPoint = Vector2.new(0, 0.5)
				TitleLabel.BackgroundTransparency = 1
				TitleLabel.Position = UDim2.new(0.025, 0, 0.5, 0)
				TitleLabel.Size = UDim2.new(0.7, 0, 0.5, 0)
				TitleLabel.Font = Enum.Font.GothamBold
				TitleLabel.Text = Toggle.Title
				TitleLabel.TextColor3 = ModernColors.Text
				TitleLabel.TextScaled = true
				TitleLabel.TextWrapped = true
				TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
				TitleLabel.TextTransparency = 0.25

				ToggleButton.Name = "Button"
				ToggleButton.Parent = ToggleFrame
				ToggleButton.BackgroundTransparency = 1
				ToggleButton.Size = UDim2.new(1, 0, 1, 0)
				ToggleButton.Font = Enum.Font.SourceSans
				ToggleButton.Text = ""
				ToggleButton.TextTransparency = 1

				ToggleIndicator.Name = "Indicator"
				ToggleIndicator.Parent = ToggleFrame
				ToggleIndicator.AnchorPoint = Vector2.new(1, 0.5)
				ToggleIndicator.BackgroundColor3 = ModernColors.Text
				ToggleIndicator.BackgroundTransparency = 0.6
				ToggleIndicator.BorderSizePixel = 0
				ToggleIndicator.Position = UDim2.new(0.975, 0, 0.5, 0)
				ToggleIndicator.Size = UDim2.new(0.055, 0, 0.7, 0)

				UICorner_2.CornerRadius = UDim.new(0, 3)
				UICorner_2.Parent = ToggleIndicator

				local function UpdateToggle()
					if Toggle.Value then
						TweenService:Create(ToggleIndicator,TweenInfo.new(0.2),{
							BackgroundTransparency = 0
						}):Play()
						TweenService:Create(TitleLabel,TweenInfo.new(0.2),{
							TextTransparency = 0
						}):Play()
					else
						TweenService:Create(ToggleIndicator,TweenInfo.new(0.2),{
							BackgroundTransparency = 0.6
						}):Play()
						TweenService:Create(TitleLabel,TweenInfo.new(0.2),{
							TextTransparency = 0.25
						}):Play()
					end
				end

				UpdateToggle()

				ToggleButton.MouseEnter:Connect(function()
					TweenService:Create(ToggleFrame,TweenInfo.new(0.2),{
						BackgroundTransparency = 0.7
					}):Play()
				end)

				ToggleButton.MouseLeave:Connect(function()
					TweenService:Create(ToggleFrame,TweenInfo.new(0.2),{
						BackgroundTransparency = 0.75
					}):Play()
				end)

				ToggleButton.MouseButton1Click:Connect(function()
					Toggle.Value = not Toggle.Value
					UpdateToggle()
					Toggle.Callback(Toggle.Value)
				end)

				return Toggle
			end

			-- Slider System
			function Section:Slider(title,min,max,default,callback)
				local Slider = {
					Title = title or "New Slider",
					Min = min or 0,
					Max = max or 100,
					Value = default or min,
					Callback = callback or function() end
				}

				local SliderFrame = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local UIStroke = Instance.new("UIStroke")
				local TitleLabel = Instance.new("TextLabel")
				local ValueLabel = Instance.new("TextLabel")
				local SliderTrack = Instance.new("Frame")
				local UICorner_2 = Instance.new("UICorner")
				local SliderFill = Instance.new("Frame")
				local UICorner_3 = Instance.new("UICorner")
				local SliderButton = Instance.new("TextButton")

				SliderFrame.Name = "SliderFrame"
				SliderFrame.Parent = Section.Container
				SliderFrame.BackgroundColor3 = ModernColors.Accent
				SliderFrame.BackgroundTransparency = 0.75
				SliderFrame.BorderSizePixel = 0
				SliderFrame.Size = UDim2.new(0.97, 0, 0, 40)
				SliderFrame.LayoutOrder = #Section.Container:GetChildren()

				UICorner.CornerRadius = UDim.new(0, 3)
				UICorner.Parent = SliderFrame

				UIStroke.Transparency = 0.9
				UIStroke.Color = ModernColors.Border
				UIStroke.Parent = SliderFrame

				TitleLabel.Name = "Title"
				TitleLabel.Parent = SliderFrame
				TitleLabel.AnchorPoint = Vector2.new(0, 0.5)
				TitleLabel.BackgroundTransparency = 1
				TitleLabel.Position = UDim2.new(0.025, 0, 0.3, 0)
				TitleLabel.Size = UDim2.new(0.7, 0, 0.3, 0)
				TitleLabel.Font = Enum.Font.GothamBold
				TitleLabel.Text = Slider.Title
				TitleLabel.TextColor3 = ModernColors.Text
				TitleLabel.TextScaled = true
				TitleLabel.TextWrapped = true
				TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
				TitleLabel.TextTransparency = 0.25

				ValueLabel.Name = "Value"
				ValueLabel.Parent = SliderFrame
				ValueLabel.AnchorPoint = Vector2.new(1, 0.5)
				ValueLabel.BackgroundTransparency = 1
				ValueLabel.Position = UDim2.new(0.975, 0, 0.3, 0)
				ValueLabel.Size = UDim2.new(0.25, 0, 0.3, 0)
				ValueLabel.Font = Enum.Font.GothamBold
				ValueLabel.Text = tostring(Slider.Value)
				ValueLabel.TextColor3 = ModernColors.Text
				ValueLabel.TextScaled = true
				ValueLabel.TextWrapped = true
				ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
				ValueLabel.TextTransparency = 0.25

				SliderTrack.Name = "Track"
				SliderTrack.Parent = SliderFrame
				SliderTrack.AnchorPoint = Vector2.new(0.5, 0)
				SliderTrack.BackgroundColor3 = ModernColors.Text
				SliderTrack.BackgroundTransparency = 0.8
				SliderTrack.BorderSizePixel = 0
				SliderTrack.Position = UDim2.new(0.5, 0, 0.65, 0)
				SliderTrack.Size = UDim2.new(0.95, 0, 0.15, 0)

				UICorner_2.CornerRadius = UDim.new(1, 0)
				UICorner_2.Parent = SliderTrack

				SliderFill.Name = "Fill"
				SliderFill.Parent = SliderTrack
				SliderFill.BackgroundColor3 = ModernColors.Text
				SliderFill.BackgroundTransparency = 0.4
				SliderFill.BorderSizePixel = 0
				SliderFill.Size = UDim2.new((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)

				UICorner_3.CornerRadius = UDim.new(1, 0)
				UICorner_3.Parent = SliderFill

				SliderButton.Name = "Button"
				SliderButton.Parent = SliderFrame
				SliderButton.BackgroundTransparency = 1
				SliderButton.Size = UDim2.new(1, 0, 1, 0)
				SliderButton.Font = Enum.Font.SourceSans
				SliderButton.Text = ""
				SliderButton.TextTransparency = 1

				local function UpdateSlider(value)
					Slider.Value = math.clamp(value, Slider.Min, Slider.Max)
					local fillSize = (Slider.Value - Slider.Min) / (Slider.Max - Slider.Min)
					TweenService:Create(SliderFill,TweenInfo.new(0.1),{
						Size = UDim2.new(fillSize, 0, 1, 0)
					}):Play()
					ValueLabel.Text = tostring(math.floor(Slider.Value))
					Slider.Callback(Slider.Value)
				end

				UpdateSlider(Slider.Value)

				SliderButton.MouseEnter:Connect(function()
					TweenService:Create(SliderFrame,TweenInfo.new(0.2),{
						BackgroundTransparency = 0.7
					}):Play()
					TweenService:Create(TitleLabel,TweenInfo.new(0.2),{
						TextTransparency = 0.1
					}):Play()
					TweenService:Create(ValueLabel,TweenInfo.new(0.2),{
						TextTransparency = 0.1
					}):Play()
				end)

				SliderButton.MouseLeave:Connect(function()
					TweenService:Create(SliderFrame,TweenInfo.new(0.2),{
						BackgroundTransparency = 0.75
					}):Play()
					TweenService:Create(TitleLabel,TweenInfo.new(0.2),{
						TextTransparency = 0.25
					}):Play()
					TweenService:Create(ValueLabel,TweenInfo.new(0.2),{
						TextTransparency = 0.25
					}):Play()
				end)

				local dragging = false

				SliderButton.MouseButton1Down:Connect(function()
					dragging = true
					local connection
					connection = RunService.RenderStepped:Connect(function()
						if not dragging then
							connection:Disconnect()
							return
						end
						local mouse = UserInputService:GetMouseLocation()
						local trackPos = SliderTrack.AbsolutePosition
						local trackSize = SliderTrack.AbsoluteSize
						local relativeX = math.clamp((mouse.X - trackPos.X) / trackSize.X, 0, 1)
						local value = Slider.Min + relativeX * (Slider.Max - Slider.Min)
						UpdateSlider(value)
					end)
				end)

				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = false
					end
				end)

				return Slider
			end

			-- Dropdown System
			function Section:Dropdown(title,options,default,callback)
				local Dropdown = {
					Title = title or "New Dropdown",
					Options = options or {"Option 1", "Option 2"},
					Value = default or options[1],
					Callback = callback or function() end
				}

				local DropdownFrame = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local UIStroke = Instance.new("UIStroke")
				local TitleLabel = Instance.new("TextLabel")
				local ValueLabel = Instance.new("TextLabel")
				local DropdownButton = Instance.new("TextButton")
				local Icon = Instance.new("ImageLabel")

				DropdownFrame.Name = "DropdownFrame"
				DropdownFrame.Parent = Section.Container
				DropdownFrame.BackgroundColor3 = ModernColors.Accent
				DropdownFrame.BackgroundTransparency = 0.75
				DropdownFrame.BorderSizePixel = 0
				DropdownFrame.Size = UDim2.new(0.97, 0, 0, 30)
				DropdownFrame.LayoutOrder = #Section.Container:GetChildren()

				UICorner.CornerRadius = UDim.new(0, 3)
				UICorner.Parent = DropdownFrame

				UIStroke.Transparency = 0.9
				UIStroke.Color = ModernColors.Border
				UIStroke.Parent = DropdownFrame

				TitleLabel.Name = "Title"
				TitleLabel.Parent = DropdownFrame
				TitleLabel.AnchorPoint = Vector2.new(0, 0.5)
				TitleLabel.BackgroundTransparency = 1
				TitleLabel.Position = UDim2.new(0.025, 0, 0.5, 0)
				TitleLabel.Size = UDim2.new(0.7, 0, 0.5, 0)
				TitleLabel.Font = Enum.Font.GothamBold
				TitleLabel.Text = Dropdown.Title
				TitleLabel.TextColor3 = ModernColors.Text
				TitleLabel.TextScaled = true
				TitleLabel.TextWrapped = true
				TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
				TitleLabel.TextTransparency = 0.25

				ValueLabel.Name = "Value"
				ValueLabel.Parent = DropdownFrame
				ValueLabel.AnchorPoint = Vector2.new(1, 0.5)
				ValueLabel.BackgroundTransparency = 1
				ValueLabel.Position = UDim2.new(0.975, 0, 0.5, 0)
				ValueLabel.Size = UDim2.new(0.25, 0, 0.5, 0)
				ValueLabel.Font = Enum.Font.GothamBold
				ValueLabel.Text = tostring(Dropdown.Value)
				ValueLabel.TextColor3 = ModernColors.Text
				ValueLabel.TextScaled = true
				ValueLabel.TextWrapped = true
				ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
				ValueLabel.TextTransparency = 0.25

				Icon.Name = "Icon"
				Icon.Parent = DropdownFrame
				Icon.AnchorPoint = Vector2.new(1, 0.5)
				Icon.BackgroundTransparency = 1
				Icon.Position = UDim2.new(0.975, 0, 0.5, 0)
				Icon.Size = UDim2.new(0, 15, 0, 15)
				Icon.Image = "rbxassetid://3926305904"
				Icon.ImageColor3 = ModernColors.Text
				Icon.ImageTransparency = 0.25
				Icon.Rotation = 90

				DropdownButton.Name = "Button"
				DropdownButton.Parent = DropdownFrame
				DropdownButton.BackgroundTransparency = 1
				DropdownButton.Size = UDim2.new(1, 0, 1, 0)
				DropdownButton.Font = Enum.Font.SourceSans
				DropdownButton.Text = ""
				DropdownButton.TextTransparency = 1

				DropdownButton.MouseEnter:Connect(function()
					TweenService:Create(DropdownFrame,TweenInfo.new(0.2),{
						BackgroundTransparency = 0.7
					}):Play()
					TweenService:Create(TitleLabel,TweenInfo.new(0.2),{
						TextTransparency = 0.1
					}):Play()
					TweenService:Create(ValueLabel,TweenInfo.new(0.2),{
						TextTransparency = 0.1
					}):Play()
					TweenService:Create(Icon,TweenInfo.new(0.2),{
						ImageTransparency = 0.1
					}):Play()
				end)

				DropdownButton.MouseLeave:Connect(function()
					TweenService:Create(DropdownFrame,TweenInfo.new(0.2),{
						BackgroundTransparency = 0.75
					}):Play()
					TweenService:Create(TitleLabel,TweenInfo.new(0.2),{
						TextTransparency = 0.25
					}):Play()
					TweenService:Create(ValueLabel,TweenInfo.new(0.2),{
						TextTransparency = 0.25
					}):Play()
					TweenService:Create(Icon,TweenInfo.new(0.2),{
						ImageTransparency = 0.25
					}):Play()
				end)

				DropdownButton.MouseButton1Click:Connect(function()
					-- Create dropdown menu
					local DropdownMenu = Instance.new("Frame")
					local UIListLayout = Instance.new("UIListLayout")
					local UICorner = Instance.new("UICorner")
					local UIStroke = Instance.new("UIStroke")

					DropdownMenu.Name = "DropdownMenu"
					DropdownMenu.Parent = DropdownFrame
					DropdownMenu.BackgroundColor3 = ModernColors.Primary
					DropdownMenu.BackgroundTransparency = 0.1
					DropdownMenu.BorderSizePixel = 0
					DropdownMenu.Position = UDim2.new(0, 0, 1, 5)
					DropdownMenu.Size = UDim2.new(1, 0, 0, 0)
					DropdownMenu.ZIndex = 5
					DropdownMenu.ClipsDescendants = true

					UICorner.CornerRadius = UDim.new(0, 3)
					UICorner.Parent = DropdownMenu

					UIStroke.Thickness = 1
					UIStroke.Color = ModernColors.Border
					UIStroke.Transparency = 0.8
					UIStroke.Parent = DropdownMenu

					UIListLayout.Parent = DropdownMenu
					UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

					-- Create options
					for _, option in ipairs(Dropdown.Options) do
						local OptionButton = Instance.new("TextButton")
						local UICorner = Instance.new("UICorner")

						OptionButton.Name = option
						OptionButton.Parent = DropdownMenu
						OptionButton.BackgroundColor3 = ModernColors.Accent
						OptionButton.BackgroundTransparency = 0.8
						OptionButton.BorderSizePixel = 0
						OptionButton.Size = UDim2.new(1, 0, 0, 25)
						OptionButton.Font = Enum.Font.GothamBold
						OptionButton.Text = option
						OptionButton.TextColor3 = ModernColors.Text
						OptionButton.TextSize = 14
						OptionButton.TextTransparency = 0.25
						OptionButton.AutoButtonColor = false
						OptionButton.ZIndex = 6

						UICorner.CornerRadius = UDim.new(0, 3)
						UICorner.Parent = OptionButton

						OptionButton.MouseEnter:Connect(function()
							TweenService:Create(OptionButton, TweenInfo.new(0.2), {
								BackgroundTransparency = 0.7,
								TextTransparency = 0
							}):Play()
						end)

						OptionButton.MouseLeave:Connect(function()
							TweenService:Create(OptionButton, TweenInfo.new(0.2), {
								BackgroundTransparency = 0.8,
								TextTransparency = 0.25
							}):Play()
						end)

						OptionButton.MouseButton1Click:Connect(function()
							Dropdown.Value = option
							ValueLabel.Text = option
							Dropdown.Callback(option)
							
							-- Close dropdown
							TweenService:Create(DropdownMenu, TweenInfo.new(0.2), {
								Size = UDim2.new(1, 0, 0, 0)
							}):Play()
							task.wait(0.2)
							DropdownMenu:Destroy()
						end)
					end

					-- Open dropdown
					local height = #Dropdown.Options * 25
					TweenService:Create(DropdownMenu, TweenInfo.new(0.2), {
						Size = UDim2.new(1, 0, 0, height)
					}):Play()

					-- Close dropdown when clicking elsewhere
					local connection
					connection = UserInputService.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							local mousePos = UserInputService:GetMouseLocation()
							local absPos = DropdownMenu.AbsolutePosition
							local absSize = DropdownMenu.AbsoluteSize
							
							if not (mousePos.X >= absPos.X and mousePos.X <= absPos.X + absSize.X and
									mousePos.Y >= absPos.Y and mousePos.Y <= absPos.Y + absSize.Y) then
								
								TweenService:Create(DropdownMenu, TweenInfo.new(0.2), {
									Size = UDim2.new(1, 0, 0, 0)
								}):Play()
								task.wait(0.2)
								DropdownMenu:Destroy()
								connection:Disconnect()
							end
						end
					end)
				end)

				return Dropdown
			end

			-- Textbox System
			function Section:Textbox(title,placeholder,default,callback)
				local Textbox = {
					Title = title or "New Textbox",
					Placeholder = placeholder or "Type here...",
					Value = default or "",
					Callback = callback or function() end
				}

				local TextboxFrame = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local UIStroke = Instance.new("UIStroke")
				local TitleLabel = Instance.new("TextLabel")
				local TextboxBox = Instance.new("TextBox")
				local UICorner_2 = Instance.new("UICorner")

				TextboxFrame.Name = "TextboxFrame"
				TextboxFrame.Parent = Section.Container
				TextboxFrame.BackgroundColor3 = ModernColors.Accent
				TextboxFrame.BackgroundTransparency = 0.75
				TextboxFrame.BorderSizePixel = 0
				TextboxFrame.Size = UDim2.new(0.97, 0, 0, 40)
				TextboxFrame.LayoutOrder = #Section.Container:GetChildren()

				UICorner.CornerRadius = UDim.new(0, 3)
				UICorner.Parent = TextboxFrame

				UIStroke.Transparency = 0.9
				UIStroke.Color = ModernColors.Border
				UIStroke.Parent = TextboxFrame

				TitleLabel.Name = "Title"
				TitleLabel.Parent = TextboxFrame
				TitleLabel.AnchorPoint = Vector2.new(0, 0.5)
				TitleLabel.BackgroundTransparency = 1
				TitleLabel.Position = UDim2.new(0.025, 0, 0.3, 0)
				TitleLabel.Size = UDim2.new(0.95, 0, 0.3, 0)
				TitleLabel.Font = Enum.Font.GothamBold
				TitleLabel.Text = Textbox.Title
				TitleLabel.TextColor3 = ModernColors.Text
				TitleLabel.TextScaled = true
				TitleLabel.TextWrapped = true
				TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
				TitleLabel.TextTransparency = 0.25

				TextboxBox.Name = "Textbox"
				TextboxBox.Parent = TextboxFrame
				TextboxBox.AnchorPoint = Vector2.new(0.5, 0)
				TextboxBox.BackgroundColor3 = ModernColors.Text
				TextboxBox.BackgroundTransparency = 0.9
				TextboxBox.BorderSizePixel = 0
				TextboxBox.Position = UDim2.new(0.5, 0, 0.65, 0)
				TextboxBox.Size = UDim2.new(0.95, 0, 0.25, 0)
				TextboxBox.Font = Enum.Font.GothamBold
				TextboxBox.Text = Textbox.Value
				TextboxBox.PlaceholderText = Textbox.Placeholder
				TextboxBox.TextColor3 = ModernColors.Text
				TextboxBox.TextScaled = true
				TextboxBox.TextTransparency = 0.25
				TextboxBox.ClearTextOnFocus = false

				UICorner_2.CornerRadius = UDim.new(0, 3)
				UICorner_2.Parent = TextboxBox

				TextboxBox.Focused:Connect(function()
					TweenService:Create(TextboxBox,TweenInfo.new(0.2),{
						BackgroundTransparency = 0.8
					}):Play()
					TweenService:Create(TextboxBox,TweenInfo.new(0.2),{
						TextTransparency = 0
					}):Play()
				end)

				TextboxBox.FocusLost:Connect(function()
					TweenService:Create(TextboxBox,TweenInfo.new(0.2),{
						BackgroundTransparency = 0.9
					}):Play()
					TweenService:Create(TextboxBox,TweenInfo.new(0.2),{
						TextTransparency = 0.25
					}):Play()
					Textbox.Value = TextboxBox.Text
					Textbox.Callback(Textbox.Value)
				end)

				return Textbox
			end

			-- Label System
			function Section:Label(title)
				local Label = {
					Title = title or "New Label"
				}

				local LabelFrame = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local UIStroke = Instance.new("UIStroke")
				local TitleLabel = Instance.new("TextLabel")

				LabelFrame.Name = "LabelFrame"
				LabelFrame.Parent = Section.Container
				LabelFrame.BackgroundColor3 = ModernColors.Accent
				LabelFrame.BackgroundTransparency = 0.75
				LabelFrame.BorderSizePixel = 0
				LabelFrame.Size = UDim2.new(0.97, 0, 0, 25)
				LabelFrame.LayoutOrder = #Section.Container:GetChildren()

				UICorner.CornerRadius = UDim.new(0, 3)
				UICorner.Parent = LabelFrame

				UIStroke.Transparency = 0.9
				UIStroke.Color = ModernColors.Border
				UIStroke.Parent = LabelFrame

				TitleLabel.Name = "Title"
				TitleLabel.Parent = LabelFrame
				TitleLabel.AnchorPoint = Vector2.new(0.5, 0.5)
				TitleLabel.BackgroundTransparency = 1
				TitleLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
				TitleLabel.Size = UDim2.new(0.95, 0, 0.5, 0)
				TitleLabel.Font = Enum.Font.GothamBold
				TitleLabel.Text = Label.Title
				TitleLabel.TextColor3 = ModernColors.Text
				TitleLabel.TextScaled = true
				TitleLabel.TextWrapped = true
				TitleLabel.TextTransparency = 0.25

				return Label
			end

			return Section
		end

		return Tab
	end

	-- Theme System
	function WindowTable:SetTheme(theme)
		if theme == "Light" then
			ModernColors = {
				Primary = Color3.fromRGB(240, 240, 240),
				Secondary = Color3.fromRGB(220, 220, 220),
				Accent = Color3.fromRGB(200, 200, 200),
				Text = Color3.fromRGB(30, 30, 30),
				TextSecondary = Color3.fromRGB(80, 80, 80),
				Border = Color3.fromRGB(50, 50, 50),
				Shadow = Color3.fromRGB(0, 0, 0),
				Success = Color3.fromRGB(46, 204, 113),
				Error = Color3.fromRGB(231, 76, 60),
				Warning = Color3.fromRGB(241, 196, 15),
				Info = Color3.fromRGB(52, 152, 219)
			}
		elseif theme == "Dark" then
			ModernColors = {
				Primary = Color3.fromRGB(25, 25, 25),
				Secondary = Color3.fromRGB(35, 35, 35),
				Accent = Color3.fromRGB(45, 45, 45),
				Text = Color3.fromRGB(255, 255, 255),
				TextSecondary = Color3.fromRGB(200, 200, 200),
				Border = Color3.fromRGB(255, 255, 255),
				Shadow = Color3.fromRGB(0, 0, 0),
				Success = Color3.fromRGB(46, 204, 113),
				Error = Color3.fromRGB(231, 76, 60),
				Warning = Color3.fromRGB(241, 196, 15),
				Info = Color3.fromRGB(52, 152, 219)
			}
		elseif theme == "Blue" then
			ModernColors = {
				Primary = Color3.fromRGB(25, 35, 45),
				Secondary = Color3.fromRGB(35, 45, 55),
				Accent = Color3.fromRGB(45, 55, 65),
				Text = Color3.fromRGB(255, 255, 255),
				TextSecondary = Color3.fromRGB(200, 200, 200),
				Border = Color3.fromRGB(100, 150, 255),
				Shadow = Color3.fromRGB(0, 0, 0),
				Success = Color3.fromRGB(46, 204, 113),
				Error = Color3.fromRGB(231, 76, 60),
				Warning = Color3.fromRGB(241, 196, 15),
				Info = Color3.fromRGB(52, 152, 219)
			}
		end

		-- Update all UI elements with new colors
		MainFrame.BackgroundColor3 = ModernColors.Primary
		Headers.BackgroundColor3 = ModernColors.Secondary
		TabButtonFrame.BackgroundColor3 = ModernColors.Secondary
		MainTabFrame.BackgroundColor3 = ModernColors.Secondary
		Title.TextColor3 = ModernColors.Text
		Description.TextColor3 = ModernColors.TextSecondary
		MainDropShadow.ImageColor3 = ModernColors.Shadow

		-- Update all tabs and elements
		for _, tab in pairs(WindowTable.Tabs) do
			if tab.Button then
				tab.Button.BackgroundColor3 = ModernColors.Accent
				tab.Button.Icon.ImageColor3 = ModernColors.Text
				tab.Button.Title.TextColor3 = ModernColors.Text
				tab.Button.UIStroke.Color = ModernColors.Border
			end

			if tab.Container then
				for _, child in pairs(tab.Container:GetChildren()) do
					if child:IsA("Frame") and child.Name:find("Frame") then
						child.BackgroundColor3 = ModernColors.Accent
						if child:FindFirstChild("UIStroke") then
							child.UIStroke.Color = ModernColors.Border
						end
						if child:FindFirstChild("Title") then
							child.Title.TextColor3 = ModernColors.Text
						end
						if child:FindFirstChild("Value") then
							child.Value.TextColor3 = ModernColors.Text
						end
						if child:FindFirstChild("Indicator") then
							child.Indicator.BackgroundColor3 = ModernColors.Text
						end
						if child:FindFirstChild("Track") then
							child.Track.BackgroundColor3 = ModernColors.Text
							if child.Track:FindFirstChild("Fill") then
								child.Track.Fill.BackgroundColor3 = ModernColors.Text
							end
						end
						if child:FindFirstChild("Textbox") then
							child.Textbox.BackgroundColor3 = ModernColors.Text
							child.Textbox.TextColor3 = ModernColors.Text
						end
						if child:FindFirstChild("Icon") then
							child.Icon.ImageColor3 = ModernColors.Text
						end
					end
				end
			end
		end
	end

	-- Apply initial theme
	WindowTable:SetTheme(config.Theme)

	-- Destroy function
	function WindowTable:Destroy()
		if WindowTable.ElBlurUI then
			WindowTable.ElBlurUI.Enabled = false
			WindowTable.ElBlurUI.Instances.Part:Destroy()
			WindowTable.ElBlurUI.Instances.DepthOfField:Destroy()
			WindowTable.ElBlurUI.Signal:Disconnect()
			if WindowTable.ElBlurUI.Signal2 then
				WindowTable.ElBlurUI.Signal2:Disconnect()
			end
		end
		ScreenGui:Destroy()
	end

	return WindowTable
end

return Library