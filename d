local Version = "1.6.63"
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. Version .. "/main.lua"))()

-- Initialize safeguard variables to prevent automatic activation
getgenv().ManualConstructionToggle = true
getgenv().ConstructionManuallyActivated = false

local Window = WindUI:CreateWindow({
    Title = "Kori Script", 
    Icon = "rbxassetid://94290650012089",
    IconSize = 45,
    Author = "THA BRONX 3",
    Folder = "MySuperHub",
    
    Size = UDim2.fromOffset(550, 400),
    Transparent = false,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 180,
    BackgroundImageTransparency = 0.2,
    HideSearchBar = false,
    ScrollBarEnabled = true,
    
    Background = "rbxassetid://94290650012089",
    
    User = {
        Enabled = false,
        Anonymous = false,
        Callback = function()
            print("User clicked")
        end,
    },

    Thumbnail = {
        Image = "rbxassetid://94290650012089", 
        Title = "Thumbnail",
    },
})
Window:EditOpenButton({
    Title = "Kori Script",
    Icon = "rbxassetid://94290650012089",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(255, 0, 0)), -- dark blue
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
    Position = UDim2.new(0.5, -75, 0, 50), -- Top middle of screen
    Size = UDim2.new(0, 150, 0, 50), -- Button size
})

-- Simple and reliable drag system
local UserInputService = game:GetService("UserInputService")
local buttonGui = nil
local isDragging = false
local dragStart = nil
local startPos = nil



local SenseESPInterface =
    loadstring(game:HttpGet("https://raw.githubusercontent.com/boshyxd/rayfield/refs/heads/main/SenseSource.luau"))()

if SenseESPInterface then
    WindUI:Notify({
        Title = "Sense ESP",
        Content = "Loading Sense ESP...\nSense ESP library loaded successfully!\nSense ESP Initialized!",
        Duration = 3,
        Icon = "bird",
    })
    SenseESPInterface.Load()
else
    WindUI:Notify({
        Title = "Error",
        Content = "Failed to load Sense ESP Library.",
        Duration = 3,
        Icon = "bird",
    })
end




local MainTab = Window:Tab({
    Title = "Main",
    Icon = "percent", 
    Locked = false,
})
local ExploitsTab = Window:Tab({
    Title = "Exploits",
    Icon = "shield-ban", 
    Locked = false,
})
local VisualsTab = Window:Tab({
    Title = "Visuals",
    Icon = "eye", 
    Locked = false,
})
local FunTab = Window:Tab({
    Title = "Fun",
    Icon = "smile", 
    Locked = false,
})
local UtilitiesTab = Window:Tab({
    Title = "Utilities",
    Icon = "circle-ellipsis", 
    Locked = false,
})
local AutoFarmTab = Window:Tab({
    Title = "Auto Farm",
    Icon = "circle-dollar-sign",
    Locked = false,
})
local UserTab = Window:Tab({
    Title = "User",
    Icon = "user", 
    Locked = false,
})
Window:SelectTab(1)

local LocalPlayer = cloneref(game:GetService("Players").LocalPlayer)

local outfits = {
    ["Blue Spider"] = {
        Hats = {"MRHoodieBRR"},
        Shirts = {"Blue Sp5der Hoodie"},
        Pants = {"Blue Sp5der Sweats"},
        Shiestys = {"Shiesty"}
    },
    ["Spider Man"] = {
        Hats = nil,
        Shirts = {"Spiderman"},
        Pants = {"Spiderman"},
        Shiestys = {"RedShiesty"}
    },
    ["Red Spider"] = {
        Hats = {"MRHoodieBRR"},
        Shirts = {"Red Sp5der Sweats"},
        Pants = {"Red Sp5der Sweats"},
        Shiestys = {"Shiesty"}
    }
}

local function equipOutfitItem(category, itemName)
    if not LocalPlayer[category]:FindFirstChild(itemName) then
        game.ReplicatedStorage.ClothShopRemote:FireServer("Buy", category, itemName)
        task.wait(0.1) -- Small delay to ensure purchase completes
    end
    game.ReplicatedStorage.ClothShopRemote:FireServer("Wear", category, itemName)
end

local function equipOutfit(outfitName)
    local outfit = outfits[outfitName]
    if not outfit then
        WindUI:Notify({
            Title = "Outfit Error",
            Content = "Outfit '" .. outfitName .. "' not found!",
            Duration = 3,
            Icon = "x",
        })
        return
    end

    game.ReplicatedStorage.ClothShopRemote:FireServer("Reset Data")
    task.wait(0.2) 

    WindUI:Notify({
        Title = "Equipping Outfit",
        Content = "Changing to " .. outfitName .. " outfit...",
        Duration = 2,
        Icon = "user",
    })

    for category, items in pairs(outfit) do
        for _, item in ipairs(items) do
            pcall(function()
                equipOutfitItem(category, item)
                task.wait(0.2) 
            end)
        end
    end

    WindUI:Notify({
        Title = "Outfit Changed",
        Content = "Successfully equipped " .. outfitName .. " outfit!",
        Duration = 3,
        Icon = "check",
    })
end

local outfitNames = {}
for name, _ in pairs(outfits) do
    table.insert(outfitNames, name)
end

local OutfitSection = UserTab:Section({ 
    Title = "Quick Outfit Change",
    TextXAlignment = "Left",
    TextSize = 17, 
})

local selectedOutfit = "Default"
local OutfitDropdown = UserTab:Dropdown({
    Title = "Select Outfit",
    Desc = "Choose an outfit to wear",
    Values = outfitNames,
    Callback = function(option)
        selectedOutfit = option
    end
})

UserTab:Button({
    Title = "Equip Selected Outfit",
    Desc = "Wear the selected outfit",
    Color = Color3.fromRGB(255, 0, 0),
    Callback = function()
        equipOutfit(selectedOutfit)
    end
})
Window:SelectTab(1)
local Section = MainTab:Section({ 
    Title = "Movement",
    TextXAlignment = "Left",
    TextSize = 17, 
})



local player = game.Players.LocalPlayer
local humanoidRootPart
player.CharacterAdded:Connect(function(char)
    humanoidRootPart = char:WaitForChild("HumanoidRootPart", 10)
end)
if player.Character then
    humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
end
local function updateCharacterReferences()
    local character = player.Character or player.CharacterAdded:Wait()
    humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
end
updateCharacterReferences()
local locations = {
    ["Bank"] = Vector3.new(-226.22584533691406, 283.8095703125, -1217.7509765625),
    ["Money Wash"] = Vector3.new(-376.1771 - 601, 197.6838 + 56, -1975.5855 + 1035 + 248),
    ["Safe Items"] = Vector3.new(48917.8984 + 19597, 53680.5 - 396 - 343, -796.09),
    ["Pawn Shop"] = Vector3.new(-23.6431 - 1026, 391.5367 - 138, -1118.2697 + 300 + 4),
    ["Bank Vault"] = Vector3.new(-217.568359375, 373.7984924316406, -1216.20947265625),
    ["Mr Money Man"] = Vector3.new(-1008.6871337890625, 262.3301086425781, 54.565277099609375),
    ["GunShop 1"] = Vector3.new(92959.8671875, 122098.5, 17244.462890625),
    ["GunShop 1 Lobby"] = Vector3.new(-1002.4224, 563.6382 - 310, -1685.9125 + 244 + 638),
    ["GunShop 2"] = Vector3.new(66195.4453125, 123615.7109375, 5750.28271484375),
    ["GunShop 2 Lobby"] = Vector3.new(-224.3818359375, 283.8034362792969, -794.7174072265625),
    ["GunShop 3"] = Vector3.new(61041.3086 - 55 - 166, 16979.1484 + 70630, -36.4746 - 315),
    ["GunShop 4"] = Vector3.new(72421.9140625, 128855.8203125, -1080.611083984375),
    ["Pent House"] = Vector3.new(-178.27471923828125, 397.1383056640625, -573.0322265625),
    ["Pent House2"] = Vector3.new(-618.0346069335938, 356.5451354980469, -681.4015502929688),
    ["Mini Mansion"] = Vector3.new(-791.5180053710938, 256.7944641113281, 1414.4248046875),
    ["Backpack Shop"] = Vector3.new(-692.4142456054688, 253.78091430664062, -681.0672607421875),
    ["Frozen Shop"] = Vector3.new(-216.31436157226562, 284.031494140625, -1169.032470703125),
    ["Drip Shop"] = Vector3.new(7378.6953 + 60084, 18630.0352 - 8141, 205.5895 + 344),
    ["Chicken Wings"] = Vector3.new(-1559.9142 + 512 + 90, 253.5367, -815.9442),
    ["Deli"] = Vector3.new(-755.8114013671875, 254.6927490234375, -687.1181640625),
    ["Car Dealer"] = Vector3.new(-401.99371337890625, 253.4141082763672, -1248.8380126953125),
    ["Drip Store"] = Vector3.new(67462, 10489.21484375, 546.1941528320312),
    ["Soda Warehouse"] = Vector3.new(-187.85504150390625, 284.6252136230469, -291.3419189453125),
    ["Soda Supplies"] = Vector3.new(51372.82421875, 21680.416015625, 5840.85546875),
    ["Soda Seller"] = Vector3.new(-1292.2200927734375, 253.30044555664062, -3003.04833984375),
    ["Exotic Dealer"] = Vector3.new(-1523.5654296875, 273.9729919433594, -990.6575317382812),
    ["Switch Seller"] = Vector3.new(-1446.2166748046875, 256.059814453125, 2189.876220703125),
    ["Bank Tools"] = Vector3.new(-397.4308776855469, 334.3142395019531, -555.7023315429688),
    ["Construction Site"] = Vector3.new(-3120.8307 + 135 + 1254, 1393.8123 - 1023, -5490.8387 + 4314),
    ["Prison"] = Vector3.new(-1135.0464, 254.7160, -3330.9954),
    ["McDonalds"] = Vector3.new(-1012.13, 253.71, -1148.07),
    ["Ice Box"] = Vector3.new(-120.1407 - 95, 283.5154, -1173.691 - 85),
    ["Hospital"] = Vector3.new(-1589.504150390625, 254.27223205566406, 17.6555233001709),
    ["MarGreens"] = Vector3.new(-381.20751953125, 254.45382690429688, -385.66546630859375),
    ["Feds Room"] = Vector3.new(-1441.7904052734375, 255.03651428222656, -3132.597412109375),
    ["ATM 1"] = Vector3.new(-1011.9066162109375, 253.7509002685547, -1153.7340087890625),
    ["ATM 2"] = Vector3.new(-739.9456176757812, 287.12518310546875, -793.5716552734375),
    ["ATM 3"] = Vector3.new(-96.72356414794922, 283.6329345703125, -766.3309326171875),
    ["House Rob Door 1"] = Vector3.new(-714.2440185546875, 287.1214294433594, -779.2329711914062),
    ["House Rob Door 2"] = Vector3.new(-606.2669067382812, 253.8867645263672, -679.8844604492188),
    ["Studio Robbery"] = Vector3.new(93427.515625, 14484.9052734375, 566.6701049804688),
    ["TrailerPark"] = Vector3.new(-1522.76904296875, 253.16094970703125, 2344.95947265625),
    ["Woodys Hotel"] = Vector3.new(-1022.61962890625, 325.8400573730469, -908.9157104492188),
}
local function teleportToLocation(locVec, locName)
    humanoidRootPart.Parent:FindFirstChild("Humanoid"):ChangeState(0)
    repeat task.wait(0.0001) until not player:GetAttribute("LastACPos")

    humanoidRootPart.CFrame = CFrame.new(locVec)

    task.wait()
    humanoidRootPart.Parent:FindFirstChild("Humanoid"):ChangeState(2)

    WindUI:Notify({
        Title = "Teleported",
        Content = "Teleported to " .. tostring(locName),
        Duration = 2,
        Icon = "bird",
    })
end
local hasPickedLocation = false
local Dropdown = MainTab:Dropdown({
    Title = "Teleport to Location",
    Desc = "Select a location to teleport to",
    Values = (function()
        local vals = {}
        for _, key in ipairs({
            "Bank", "Money Wash", "Safe Items", "Pawn Shop", "Bank Vault", "Mr Money Man",
            "GunShop 1", "GunShop 1 Lobby", "GunShop 2", "GunShop 2 Lobby", "GunShop 3", "GunShop 4",
            "Pent House", "Pent House2", "Mini Mansion", 
            "Backpack Shop", "Frozen Shop", "Drip Shop", "Chicken Wings", "Deli", "Car Dealer", "Drip Store",
            "Soda Warehouse", "Soda Supplies", "Soda Seller", "Exotic Dealer", "Switch Seller",
            "Bank Tools", "Construction Site", "Prison", "McDonalds", "Ice Box", "Hospital", "MarGreens", "Feds Room",
            "ATM 1", "ATM 2", "ATM 3",
            "House Rob Door 1", "House Rob Door 2", "Studio Robbery",
            "TrailerPark", "Woodys Hotel",
        }) do
            table.insert(vals, key)
        end
        return vals
    end)(),
    Callback = function(option)
        if not hasPickedLocation then
            hasPickedLocation = true
        end

        if option and locations[option] then
            teleportToLocation(locations[option], option)
        end
    end,
})

MainTab:Divider()

local Paragraph = MainTab:Paragraph({
    Title = "Car Fly Instructions",
    Desc = "1. Click 'Bring Nearest Car' to summon a car\n2. Get in the car\n3. Enable 'Car Fly' toggle\n4. Use WASD to fly, Right Click to look around",
    Color = Color3.fromRGB(255, 0, 0),
    Image = "helicopter",
    ImageSize = 40,
    Thumbnail = "",
    ThumbnailSize = 0
})
Config = Config or {}
Config.TheBronx = {
    carfly = false,
    carflyspeed = 120,
}
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local hum, seat, car, root
local bv, bg
local lastCar
local function Cleanup()
    if bv then bv:Destroy() bv = nil end
    if bg then bg:Destroy() bg = nil end
end
local function Setup()
    Cleanup()
    if not Config.TheBronx.carfly then return end
    local char = LP.Character
    if not char then return end
    hum = char:FindFirstChildWhichIsA("Humanoid")
    if not hum then return end
    seat = hum.SeatPart
    if not seat or not seat:IsA("VehicleSeat") then return end
    car = seat.Parent
    if not car then return end
    root = car.PrimaryPart
    if not root then return end
    lastCar = car
    for _, v in ipairs(car:GetChildren()) do
        if v:IsA("BasePart") and not v.Name:lower():find("wheel") then
            v.CanCollide = false
        end
    end
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bv.Velocity = Vector3.zero
    bv.Parent = root
    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    bg.P = 25000
    bg.D = 1500
    bg.CFrame = root.CFrame
    bg.Parent = root
end
task.spawn(function()
    while true do
        task.wait(0.2)

        local char = LP.Character
        if not char then continue end

        local h = char:FindFirstChildWhichIsA("Humanoid")
        if not h then continue end

        local currentSeat = h.SeatPart

        if currentSeat and currentSeat:IsA("VehicleSeat") then
            if currentSeat.Parent ~= lastCar then
                Setup()
            end
        else
            if lastCar then
                Cleanup()
                lastCar = nil
            end
        end
    end
end)
RunService.RenderStepped:Connect(function()
    if not Config.TheBronx.carfly then
        Cleanup()
        return
    end

    if not hum or hum.SeatPart ~= seat then return end
    if not root or not bv or not bg then Setup() return end

    local speed = Config.TheBronx.carflyspeed or 120
    local cam = workspace.CurrentCamera
    local camCF = cam.CFrame
    local camLook = camCF.LookVector
    local camRight = camCF.RightVector

    if not UIS.TouchEnabled then
        if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            bg.CFrame = CFrame.lookAt(root.Position, root.Position + camLook)
        end

        local move = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then move += camLook end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move -= camLook end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move -= camRight end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move += camRight end
        if move.Magnitude > 0 then
            bv.Velocity = move.Unit * speed
        else
            bv.Velocity = Vector3.zero
        end

    else

        bg.CFrame = CFrame.lookAt(root.Position, root.Position + camLook)

        local move = hum.MoveDirection
        local vertical = camLook.Y 

        local velocity =
            (move * speed) +
            (Vector3.new(0, vertical, 0) * speed)

        if velocity.Magnitude > 0 then
            bv.Velocity = velocity
        else
            bv.Velocity = Vector3.zero
        end
    end
end)
local function GetNearestCar(hrp)
    local CivCars = workspace:FindFirstChild("CivCars")
    if not CivCars then return nil end

    local nearestCar = nil
    local nearestDist = math.huge

    for _, car in ipairs(CivCars:GetChildren()) do
        if not car:IsA("Model") then continue end

        local seat = car:FindFirstChild("DriveSeat")
        if not seat then continue end

        if seat.Occupant then continue end

        if not car.PrimaryPart then
            local body = car:FindFirstChild("Body")
            if body and body:FindFirstChild("#Weight") then
                car.PrimaryPart = body["#Weight"]
            else
                car.PrimaryPart = seat
            end
        end

        if not car.PrimaryPart then continue end

        local dist = (car.PrimaryPart.Position - hrp.Position).Magnitude
        if dist < nearestDist then
            nearestDist = dist
            nearestCar = car
        end
    end

    return nearestCar
end
local Button = MainTab:Button({
    Title = "Bring Nearest Car",
    Desc = "Summons the closest civilian car to your position",
    Color = Color3.fromRGB(255, 0, 0),
    Locked = false,
    Callback = function()
        local Players = game:GetService("Players")
        local Player = Players.LocalPlayer
        if not Player then return end

        local char = Player.Character or Player.CharacterAdded:Wait()

        local hrp = char:WaitForChild("HumanoidRootPart", 3)
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if not hrp or not hum then return end

        local car = GetNearestCar(hrp)
        if not car then
            WindUI:Notify({
                Title = "Car Summon",
                Content = "No cars found nearby",
                Duration = 2,
                Icon = "car",
            })
            return
        end

        local seat = car:FindFirstChild("DriveSeat") or car:FindFirstChildWhichIsA("VehicleSeat")
        if not seat then return end

        if not car.PrimaryPart then
            car.PrimaryPart = car:FindFirstChildWhichIsA("BasePart")
            if not car.PrimaryPart then return end
        end

        car:SetPrimaryPartCFrame(
            hrp.CFrame * CFrame.new(0, 0, -6) * CFrame.Angles(0, math.rad(180), 0)
        )

        seat:Sit(hum)
        
        WindUI:Notify({
            Title = "Car Summoned",
            Content = "Car brought to your location",
            Duration = 2,
            Icon = "car",
        })
    end
})
local Toggle = MainTab:Toggle({
    Title = "Car Fly",
    Desc = "Enable flying while in vehicles",
    Icon = "helicopter",
    Type = "Checkbox",
    Value = Config.TheBronx.carfly,
    Callback = function(state)
        Config.TheBronx.carfly = state
        if state then
            WindUI:Notify({
                Title = "Car Fly",
                Content = "Car fly enabled - Get in a vehicle!",
                Duration = 2,
                Icon = "helicopter",
            })
        else
            WindUI:Notify({
                Title = "Car Fly", 
                Content = "Car fly disabled",
                Duration = 2,
                Icon = "helicopter",
            })
        end
    end
})
local Slider = MainTab:Slider({
    Title = "Car Fly Speed",
    Desc = "Control how fast you fly in vehicles",
    Step = 1,
    Value = {
        Min = 20,
        Max = 300,
        Default = Config.TheBronx.carflyspeed,
    },
    Callback = function(value)
        Config.TheBronx.carflyspeed = value
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local speed = 16
local boostMultiplier = 2
local enhancedWalk = false
local character, humanoid, humanoidRootPart
local bodyGyro
local movementConnection
local freezeConnection
local animationTrack
local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://88680730602344" 
getgenv().SwimMethod = false
task.spawn(function()
	while task.wait() do
		
		if enhancedWalk then
			if not getgenv().SwimMethod then
				getgenv().SwimMethod = true
			end
			if humanoid then
				humanoid:ChangeState(Enum.HumanoidStateType.FallingDown)
			end
		end
	end
end)
local function updateCharacterRefs()
	character = player.Character or player.CharacterAdded:Wait()
	humanoidRootPart = character:WaitForChild("HumanoidRootPart")
	humanoid = character:WaitForChild("Humanoid")
end
local function cleanup()
	if movementConnection then movementConnection:Disconnect() movementConnection = nil end
	if freezeConnection then freezeConnection:Disconnect() freezeConnection = nil end
	if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
	if animationTrack then animationTrack:Stop() animationTrack = nil end
end
local function setupMovement()
	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	bodyGyro.P = 50000
	bodyGyro.D = 1000
	bodyGyro.CFrame = humanoidRootPart.CFrame
	bodyGyro.Parent = humanoidRootPart

	movementConnection = RunService.RenderStepped:Connect(function()
		if not enhancedWalk then return end

		local camera = workspace.CurrentCamera
		local dir = Vector3.zero
		local usingKeys = false

		if UserInputService:IsKeyDown(Enum.KeyCode.W) then
			dir += Vector3.new(camera.CFrame.LookVector.X, 0, camera.CFrame.LookVector.Z)
			usingKeys = true
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then
			dir -= Vector3.new(camera.CFrame.LookVector.X, 0, camera.CFrame.LookVector.Z)
			usingKeys = true
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then
			dir -= camera.CFrame.RightVector
			usingKeys = true
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then
			dir += camera.CFrame.RightVector
			usingKeys = true
		end

		if not usingKeys then
			local md = humanoid.MoveDirection
			dir = Vector3.new(md.X, 0, md.Z)
		end

		local moveSpeed = speed
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
			moveSpeed = moveSpeed * boostMultiplier
		end

		if dir.Magnitude > 0 then
			dir = dir.Unit * moveSpeed
		end

		local currentY = humanoidRootPart.AssemblyLinearVelocity.Y
		local groundedY = math.clamp(currentY, -100, -2)
		humanoidRootPart.AssemblyLinearVelocity = Vector3.new(dir.X, groundedY, dir.Z)

		if dir.Magnitude > 0 then
			local look = dir.Unit
			bodyGyro.CFrame = CFrame.new(humanoidRootPart.Position, humanoidRootPart.Position + Vector3.new(look.X, 0, look.Z))
		end

		humanoidRootPart.RotVelocity = Vector3.zero
		humanoidRootPart.AssemblyAngularVelocity = Vector3.zero

		if dir.Magnitude > 0 then
			if not animationTrack.IsPlaying then animationTrack:Play() end
		else
			if animationTrack.IsPlaying then animationTrack:Stop() end
		end
	end)
end
local function startEnhancedWalk()
	enhancedWalk = true
	updateCharacterRefs()
	cleanup()
	humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
	getgenv().SwimMethod = true
	freezeConnection = RunService.RenderStepped:Connect(function()
		if enhancedWalk then
			
			if not getgenv().SwimMethod then
				getgenv().SwimMethod = true
			end
			humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
		end
	end)
	local animator = humanoid:FindFirstChildWhichIsA("Animator") or Instance.new("Animator", humanoid)
	animationTrack = animator:LoadAnimation(animation)
	animationTrack.Looped = true

	task.delay(3, function()
		if freezeConnection then freezeConnection:Disconnect() freezeConnection = nil end
		if enhancedWalk then
			setupMovement()
		end
	end)
end
local function stopEnhancedWalk()
	enhancedWalk = false
	cleanup()
	getgenv().SwimMethod = false
end
player.CharacterAdded:Connect(function()
	task.wait(1)
	updateCharacterRefs()
	if enhancedWalk then
		startEnhancedWalk()
	end
end)
local Toggle = MainTab:Toggle({
    Title = "Enable WalkSpeed",
    Desc = "Toggle enhanced walk mode",
    Icon = "footprints",
    Type = "Checkbox",
    Default = false,
    Callback = function(state) 
        if state then
            startEnhancedWalk()
        else
            stopEnhancedWalk()
        end
    end
})
local Slider = MainTab:Slider({
    Title = "‍Change Walk Speed",
    Step = 1,
    Value = {
        Min = 16,
        Max = 200,
        Default = speed,
    },
    Callback = function(value)
        speed = value
    end
})





local Section = MainTab:Section({ 
    Title = "Shop",
    TextXAlignment = "Left",
    TextSize = 17, 
})
local toggledGUIs = {}
local shopGUIs = {
    ["Bronx Market"] = "Bronx Market 2",
    ["Tattoo Shop"] = "Bronx TATTOOS",
    ["Open Trunk"] = "TRUNK STORAGE",
    ["BRONX PAWNING"] = "Bronx PAWNING",
    ["BRONX CLOTHING"] = "Bronx CLOTHING",
    ["Gas Station"] = "ShopGUI",
    ["EXOTIC DEALER"] = "ThaShop"
}
local function getKeys(tbl)
    local keys = {}
    for k, _ in pairs(tbl) do
        table.insert(keys, k)
    end
    return keys
end
local shopList = getKeys(shopGUIs)
local currentSelection = nil 
local Dropdown = MainTab:Dropdown({
    Title = "Select Shop",
    Values = shopList,
    Value = nil, 
    Multi = false,
    AllowNone = true,
    Callback = function(option)
        currentSelection = option 
    end
})
local Button = MainTab:Button({
    Title = "Open/Close Selected Shop",
    Desc = "Toggle the selected shop's GUI",
    Color = Color3.fromRGB(255, 0, 0),
    Justify = "Center",
    IconAlign = "Left",
    Icon = "",
    Locked = false,
    Callback = function()
        if not currentSelection then
            return
        end

        local guiName = shopGUIs[currentSelection]
        if not guiName then
            return
        end

        local gui = game.Players.LocalPlayer.PlayerGui:FindFirstChild(guiName)
        if not gui then
            return
        end

        gui.Enabled = not gui.Enabled
    end
})





local Section = MainTab:Section({ 
    Title = "Bank",
    TextXAlignment = "Left",
    TextSize = 17, 
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local atmbankamount = 0
local autoDropEnabled = false
local Button = MainTab:Button({
    Title = "Show Bank Balance",
    Desc = "Displays your bank balance",
    Color = Color3.fromRGB(255, 0, 0),

    Justify = "Center",
    IconAlign = "Left",
    Icon = "dollar-sign",
    Locked = false,
    Callback = function()
        local bankAmount = "N/A"
        if player and player:FindFirstChild("stored") and player.stored:FindFirstChild("Bank") then
            bankAmount = tostring(player.stored.Bank.Value)
        end

        WindUI:Notify({
            Title = "Bank Balance",
            Content = "You have $" .. bankAmount .. " in your bank.",
            Duration = 6.5,
            Icon = "dollar-sign",
        })
    end
})
MainTab:Input({
    Title = "Cash Amount",
    Desc = "Enter cash amount",
    Value = "",
    InputIcon = "dollar-sign",
    Type = "Input",
    Placeholder = "Enter cash amount",
    Callback = function(text)
        if text == "" then
            
            return
        end

        local amt = tonumber(text)
        if not amt then
            WindUI:Notify({
                Title = "ATM",
                Content = "Invalid amount",
                Duration = 1,
                Icon = "dollar-sign",
            })
            atmbankamount = 0
            return
        end
        atmbankamount = amt
    end
})
MainTab:Button({
    Title = "Deposit",
    Desc = "Deposit cash to bank",
    Color = Color3.fromRGB(255, 0, 0),

    Justify = "Center",
    IconAlign = "Left",
    Icon = "arrow-down-circle",
    Locked = false,
    Callback = function()
        if atmbankamount > 0 then
            ReplicatedStorage:WaitForChild("BankAction"):FireServer("depo", atmbankamount)
        end
    end
})
MainTab:Button({
    Title = "Withdraw",
    Desc = "Withdraw cash from bank",
    Color = Color3.fromRGB(255, 0, 0),

    Justify = "Center",
    IconAlign = "Left",
    Icon = "arrow-up-circle",
    Locked = false,
    Callback = function()
        if atmbankamount > 0 then
            ReplicatedStorage:WaitForChild("BankAction"):FireServer("with", atmbankamount)
        end
    end
})
MainTab:Button({
    Title = "Drop",
    Desc = "Drop cash",
    Color = Color3.fromRGB(255, 0, 0),
 
    Justify = "Center",
    IconAlign = "Left",
    Icon = "dollar-sign",
    Locked = false,
    Callback = function()
        if atmbankamount > 0 then
            ReplicatedStorage:WaitForChild("BankProcessRemote"):InvokeServer("Drop", atmbankamount)
        end
    end
})
MainTab:Toggle({
    Title = "Auto Drop ($10k)",
    Desc = "Automatically drop $10,000 repeatedly",
    Icon = "dollar-sign",
    Type = "Checkbox",
    Default = false,
    Callback = function(value)
        autoDropEnabled = value
        if value then
            spawn(function()
                while autoDropEnabled do
                    ReplicatedStorage:WaitForChild("BankProcessRemote"):InvokeServer("Drop", 10000)
                    local giveMoney = ReplicatedStorage:FindFirstChild("GiveMoney")
                    if giveMoney then
                        giveMoney:FireServer("drop", 10000)
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})


local Paragraph = ExploitsTab:Paragraph({
    Title = [[
1. "Equip whatever tool or item you want to duplicate into your hands"
2. "Press "Market Dupe"
3. "If it doesn't duplicate, run it again"
]],
    Desc = "",
    Color = Color3.fromRGB(255, 0, 0),

    Image = "",
    ImageSize = 1,
    Thumbnail = "",
    ThumbnailSize = 1,
    Locked = false,
    Buttons = {} 
})
local Button = ExploitsTab:Button({
    Title = "Market Dupe",
    Desc = "Duplicate your market item",
    Color = Color3.fromRGB(255, 0, 0),

    Justify = "Center",
    IconAlign = "Left",
    Icon = "book-copy",
    Locked = false,
    Callback = function()
        local Players = cloneref(game:GetService("Players"))
        local Player = Players.LocalPlayer
        local Character = Player.Character or Player.CharacterAdded:Wait()

        local Tool = Character:FindFirstChildOfClass("Tool")
        if not Tool then
            WindUI:Notify({
                Title = "Market Dupe",
                Content = "You need to equip a tool or item first!",
                Duration = 3,
                Icon = "book-copy",
            })
            return
        end

        WindUI:Notify({
            Title = "Market Dupe",
            Content = "Attempting to dupe your item...",
            Duration = 3,
            Icon = "check",
        })

        local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
        local Backpack = Player:WaitForChild("Backpack")

        Tool.Parent = Backpack
        task.wait(0.5)

        local ToolName = Tool.Name
        local ToolId = nil

        local function getPing()
            if typeof(Player.GetNetworkPing) == "function" then
                local success, result = pcall(function()
                    return tonumber(string.match(Player:GetNetworkPing(), "%d+"))
                end)
                if success and result then
                    return result
                end
            end

            local success2, pingStat = pcall(function()
                return Players.LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("Ping") or
                       Players.LocalPlayer:FindFirstChild("PlayerScripts"):FindFirstChild("Ping")
            end)
            if success2 and pingStat and pingStat:IsA("TextLabel") then
                local num = tonumber(string.match(pingStat.Text, "%d+"))
                if num then
                    return num
                end
            end

            local t0 = tick()
            local temp = Instance.new("BoolValue", ReplicatedStorage)
            temp.Name = "PingTest_" .. tostring(math.random(10000,99999))
            task.wait(0.1)
            local t1 = tick()
            temp:Destroy()

            return math.clamp((t1 - t0) * 1000, 50, 300)
        end

        local ping = getPing()
        local delay = 0.25 + ((math.clamp(ping, 0, 300) / 300) * 0.03)

        local marketconnection = ReplicatedStorage.MarketItems.ChildAdded:Connect(function(item)
            if item.Name == ToolName then
                local owner = item:WaitForChild("owner", 2)
                if owner and owner.Value == Player.Name then
                    ToolId = item:GetAttribute("SpecialId")
                end
            end
        end)

        task.spawn(function()
            ReplicatedStorage.ListWeaponRemote:FireServer(ToolName, 99999)
        end)

        task.wait(delay)

        task.spawn(function()
            ReplicatedStorage.BackpackRemote:InvokeServer("Store", ToolName)
        end)

        task.wait(3)

        if ToolId then
            task.spawn(function()
                ReplicatedStorage.BuyItemRemote:FireServer(ToolName, "Remove", ToolId)
            end)
        end

        task.spawn(function()
            ReplicatedStorage.BackpackRemote:InvokeServer("Grab", ToolName)
        end)

        marketconnection:Disconnect()
        task.wait(1)
    end
})


ExploitsTab:Divider()



local Paragraph = ExploitsTab:Paragraph({
    Title = [[
1. Go to the cooking spot
2. Cook one Ice Fruit Cup
3. Make sure it's in your
   inventory and not holding in hand!!
4. Click "Generate Dirty
   Money"
]],
    Desc = "Cooking Instructions ",
    Color = Color3.fromRGB(255, 0, 0),

    Image = "cooking-pot",
    ImageSize = 1,
    Thumbnail = "",
    ThumbnailSize = 4,
    Locked = true,
    Buttons = {} 
})



getgenv().SwimMethod = false
local function enableSwimMethod()
    getgenv().SwimMethod = true
    task.wait(1)
end
local function disableSwimMethod()
    getgenv().SwimMethod = false
end
local Button = ExploitsTab:Button({
    Title = "Cookin House",
    Desc = "Teleports to where you gotta cook the stuff",
    Color = Color3.fromRGB(255, 0, 0),

    Justify = "Center",
    IconAlign = "Left",
    Icon = "map-pin",
    Locked = false,
    Callback = function()
        local cookingPos = Vector3.new(-1605.9183349609375, 254.04150390625, -488.43804931640625)
        local character = game.Players.LocalPlayer.Character

        if character and character:FindFirstChild("HumanoidRootPart") then
            enableSwimMethod()
            character.HumanoidRootPart.CFrame = CFrame.new(cookingPos)
            disableSwimMethod()
        end
    end
})
local ButtonBuyAll = ExploitsTab:Button({
    Title = "Buy All Items",
    Desc = "Purchase all items at once",
    Color = Color3.fromRGB(255, 0, 0),

    Justify = "Center",
    IconAlign = "Left",
    Icon = "shopping-cart",
    Locked = false,
    Callback = function()
        local items = {"FijiWater", "FreshWater", "Ice-Fruit Cupz", "Ice-Fruit Bag"}
        for _, item in ipairs(items) do
            game:GetService("ReplicatedStorage").ExoticShopRemote:InvokeServer(item)
            task.wait(0.1) -- Small delay between purchases
        end
        
        WindUI:Notify({
            Title = "Purchase Complete",
            Content = "✅ All items purchased successfully",
            Duration = 3,
            Icon = "check",
        })
    end
})
local Button = ExploitsTab:Button({
    Title = "Generate Dirty Money",
    Desc = "Teleport and auto-sell Ice-Fruit Cupz",
    Color = Color3.fromRGB(255, 0, 0),

    Locked = false,
    Callback = function()
        local player = game.Players.LocalPlayer
        local StarterGui = game:GetService("StarterGui")
        local camera = game.Workspace.CurrentCamera
        local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

        local originalCameraType = camera.CameraType
        local originalFieldOfView = camera.FieldOfView
        local originalCameraShake = camera:FindFirstChild("CameraShake")
        local cameraShakeBackup = originalCameraShake and originalCameraShake.Value or nil

        local function GetCharacter()
            return player and player.Character
        end

        getgenv().SwimMethod = false

        local function enableSwimMethod()
            getgenv().SwimMethod = true
            task.wait(1)
        end

        local function disableSwimMethod()
            getgenv().SwimMethod = false
        end

        local function SwimBypassTeleport(destinationCFrame)
            local character = GetCharacter()
            if not character or not character:FindFirstChild("HumanoidRootPart") then return end

            local HRP = character.HumanoidRootPart

            enableSwimMethod()
            task.wait(0.25)

            HRP.CFrame = destinationCFrame + Vector3.new(2, 0, 0)

            task.delay(0.25, function()
                disableSwimMethod()
            end)
        end

        local tool = player.Backpack:FindFirstChild("Ice-Fruit Cupz")
        if tool then
            player.Character.Humanoid:EquipTool(tool)
        else
            WindUI:Notify({
                Title = "No Ice-Fruit Cupz",
                Content = "❌ Tool 'Ice-Fruit Cupz' not found in backpack",
                Duration = 3,
                Icon = "x",
            })
            return
        end

local blackScreen = Instance.new("ScreenGui")
blackScreen.IgnoreGuiInset = true
blackScreen.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame", blackScreen)
frame.BackgroundTransparency = 0
frame.BackgroundColor3 = Color3.new(0, 0, 0)

frame.Size = UDim2.new(1, 0, 1, 0)
frame.Position = UDim2.new(0, 0, 0, 0)
frame.BorderSizePixel = 0
frame.Visible = true

-- Add background image using the same asset ID as the main window
local backgroundImage = Instance.new("ImageLabel", frame)
backgroundImage.Size = UDim2.new(1, 0, 1, 0)
backgroundImage.Position = UDim2.new(0, 0, 0, 0)
backgroundImage.BackgroundTransparency = 1
backgroundImage.Image = "rbxassetid://94290650012089"
backgroundImage.ImageTransparency = 0
backgroundImage.ScaleType = Enum.ScaleType.Stretch
backgroundImage.BorderSizePixel = 0

        local textLabel = Instance.new("TextLabel", frame)
textLabel.Size = UDim2.new(0.8, 0, 0.8, 0)
textLabel.Position = UDim2.new(0.1, 0, 0.1, 0)
textLabel.BackgroundTransparency = 1
textLabel.Text = ""
textLabel.TextScaled = true 
textLabel.TextColor3 = Color3.new(1, 1, 1) 
textLabel.TextStrokeTransparency = 0.5 
textLabel.TextWrapped = true
textLabel.TextXAlignment = Enum.TextXAlignment.Center
textLabel.TextYAlignment = Enum.TextYAlignment.Center


        if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
        local originalCFrame = player.Character.HumanoidRootPart.CFrame

        task.wait(0.5)

        local targetCFrame = CFrame.new(-69.82200622558594, 287.0635986328125, -319.79437255859375)
        SwimBypassTeleport(targetCFrame)

        task.wait(0.5)

        local cameraOffset = Vector3.new(0, 5, 5)
        local angleOffset = Vector3.new(0, -1, 0)

        camera.CameraType = Enum.CameraType.Scriptable

        getgenv().cameraFollowConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if humanoidRootPart then
                local characterPos = humanoidRootPart.Position
                camera.CFrame = CFrame.new(characterPos + cameraOffset + angleOffset, characterPos + Vector3.new(0, 3, 0))
            end
        end)

        getgenv().instantPrompts = true

        local iceFruitSellPrompt = workspace:WaitForChild("IceFruit Sell"):FindFirstChildOfClass("ProximityPrompt")
        if iceFruitSellPrompt then
            iceFruitSellPrompt.HoldDuration = 0
            iceFruitSellPrompt.MaxActivationDistance = 6

            getgenv().updateConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if getgenv().instantPrompts and iceFruitSellPrompt.Enabled then
                    for _ = 1, 79 do
                        iceFruitSellPrompt:InputHoldBegin()
                        iceFruitSellPrompt:InputHoldEnd()
                    end
                end
            end)
        end

        task.spawn(function()
            task.wait(1)

            getgenv().instantPrompts = false

            if getgenv().updateConnection then
                getgenv().updateConnection:Disconnect()
                getgenv().updateConnection = nil
            end

            if iceFruitSellPrompt then
                iceFruitSellPrompt.HoldDuration = 1
                iceFruitSellPrompt.MaxActivationDistance = 4
            end

            enableSwimMethod()
            task.wait(0.5)
            SwimBypassTeleport(originalCFrame)
            task.wait(0.5)
            disableSwimMethod()

            if getgenv().cameraFollowConnection then
                getgenv().cameraFollowConnection:Disconnect()
                getgenv().cameraFollowConnection = nil
            end

            camera.CameraType = originalCameraType
            camera.FieldOfView = originalFieldOfView

            if originalCameraShake then
                originalCameraShake.Value = cameraShakeBackup
            end

            blackScreen:Destroy()

            WindUI:Notify({
                Title = "Money vulnerability",
                Content = "You Know have Max Money",
                Duration = 2,
                Icon = "dollar-sign",
            })
        end)
    end
})

local Section = VisualsTab:Section({ 
    Title = "ESP",
    TextXAlignment = "Left",
    TextSize = 17, 
})

local EnableESP = VisualsTab:Toggle({
    Title = "Enable ESP",
    Desc = "Toggles ESP for enemies and friends",
    Icon = "sun",
    Type = "Checkbox",
    Default = false,
    Callback = function(Value)
        if SenseESPInterface then
            SenseESPInterface.teamSettings.enemy.enabled = Value
            SenseESPInterface.teamSettings.friendly.enabled = Value
            if Value then
                WindUI:Notify({
                    Title = "ESP",
                    Content = "Enabled",
                    Duration = 2,
                    Icon = "spotlight",
                })
            end
        else
            WindUI:Notify({
                Title = "ESP Error",
                Content = "Sense ESP not loaded",
                Duration = 2,
                Icon = "spotlight",
            })
        end
    end,
})
local EnableBoxESP = VisualsTab:Toggle({
    Title = "Enable Box ESP",
    Desc = "Draws a box around players",
    Icon = "sun",
    Type = "Checkbox",
    Default = false,
    Callback = function(Value)
        if SenseESPInterface then
            SenseESPInterface.teamSettings.enemy.box = Value
            SenseESPInterface.teamSettings.friendly.box = Value
            if Value then
                WindUI:Notify({
                    Title = "Box ESP",
                    Content = "Enabled",
                    Duration = 2,
                    Icon = "spotlight",
                })
            end
        else
            WindUI:Notify({
                Title = "ESP Error",
                Content = "Sense ESP not loaded",
                Duration = 2,
                Icon = "spotlight",
            })
        end
    end,
})
local EnableNameESP = VisualsTab:Toggle({
    Title = "Enable Name ESP",
    Desc = "Shows player names",
    Icon = "sun",
    Type = "Checkbox",
    Default = false,
    Callback = function(Value)
        if SenseESPInterface then
            SenseESPInterface.teamSettings.enemy.name = Value
            SenseESPInterface.teamSettings.friendly.name = Value
            if Value then
                WindUI:Notify({
                    Title = "Name ESP",
                    Content = "Enabled",
                    Duration = 2,
                    Icon = "spotlight",
                })
            end
        else
            WindUI:Notify({
                Title = "ESP Error",
                Content = "Sense ESP not loaded",
                Duration = 2,
                Icon = "spotlight",
            })
        end
    end,
})
local EnableHealthESP = VisualsTab:Toggle({
    Title = "Enable Health ESP",
    Desc = "Shows health bars and text",
    Icon = "sun",
    Type = "Checkbox",
    Default = false,
    Callback = function(Value)
        if SenseESPInterface then
            SenseESPInterface.teamSettings.enemy.healthBar = Value
            SenseESPInterface.teamSettings.friendly.healthBar = Value
            SenseESPInterface.teamSettings.enemy.healthText = Value
            SenseESPInterface.teamSettings.friendly.healthText = Value
            if Value then
                WindUI:Notify({
                    Title = "Health ESP",
                    Content = "Enabled",
                    Duration = 2,
                    Icon = "spotlight",
                })
            end
        else
            WindUI:Notify({
                Title = "ESP Error",
                Content = "Sense ESP not loaded",
                Duration = 2,
                Icon = "spotlight",
            })
        end
    end,
})
local EnableLineESP = VisualsTab:Toggle({
    Title = "Enable Line ESP",
    Desc = "Draws tracers to players",
    Icon = "sun",
    Type = "Checkbox",
    Default = false,
    Callback = function(Value)
        if SenseESPInterface then
            SenseESPInterface.teamSettings.enemy.tracer = Value
            SenseESPInterface.teamSettings.friendly.tracer = Value
            if Value then
                WindUI:Notify({
                    Title = "Line ESP",
                    Content = "Enabled",
                    Duration = 2,
                    Icon = "spotlight",
                })
            end
        else
            WindUI:Notify({
                Title = "ESP Error",
                Content = "Sense ESP not loaded",
                Duration = 2,
                Icon = "spotlight",
            })
        end
    end,
})
local RainbowGunsToggle = VisualsTab:Toggle({
    Title = "Admin Guns",
    Desc = "",
    Icon = "rocket",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        local gunsFolder = workspace:FindFirstChild("GUNS")
        if not gunsFolder then
            warn("GUNS folder not found in workspace!")
            return
        end

        local validGunNames = {}
        for _, gun in ipairs(gunsFolder:GetChildren()) do
            validGunNames[gun.Name] = true
        end

        getgenv().activeRainbowThreads = getgenv().activeRainbowThreads or {}
        getgenv().rainbowConnections = getgenv().rainbowConnections or {}
        getgenv().originalStates = getgenv().originalStates or {}

        local function storeOriginalState(part)
            if not getgenv().originalStates[part] then
                getgenv().originalStates[part] = {
                    Color = part.Color,
                    Material = part.Material,
                    Transparency = part.Transparency
                }
            end
        end

        local function startRainbow(tool)
            if getgenv().activeRainbowThreads[tool] then return end
            local parts = {}
            for _, part in ipairs(tool:GetDescendants()) do
                if part:IsA("BasePart") then
                    storeOriginalState(part)
                    table.insert(parts, part)
                end
            end
            if #parts > 0 then
                local stopped = false
                getgenv().activeRainbowThreads[tool] = function() stopped = true end
                task.spawn(function()
                    for _, part in ipairs(parts) do
                        part.Material = Enum.Material.Glass
                        part.Transparency = 0.3
                    end
                    while not stopped do
                        local now = tick()
                        local step = math.floor(now / 1)
                        local hue = (step % 12) / 12
                        local color = Color3.fromHSV(hue, 1, 1)
                        for _, part in ipairs(parts) do
                            part.Color = color
                        end
                        task.wait(0.05)
                    end
                end)
            end
        end

        local function restoreOriginal(tool)
            for _, part in ipairs(tool:GetDescendants()) do
                if part:IsA("BasePart") and getgenv().originalStates[part] then
                    local state = getgenv().originalStates[part]
                    part.Color = state.Color
                    part.Material = state.Material
                    part.Transparency = state.Transparency
                    getgenv().originalStates[part] = nil
                end
            end
        end

        local function stopRainbow(tool)
            if getgenv().activeRainbowThreads[tool] then
                getgenv().activeRainbowThreads[tool]()
                getgenv().activeRainbowThreads[tool] = nil
                restoreOriginal(tool)
            end
        end

        local function stopAllRainbows()
            for tool, stopper in pairs(getgenv().activeRainbowThreads) do
                stopper()
            end

            for part, state in pairs(getgenv().originalStates) do
                if part and part.Parent then
                    part.Color = state.Color
                    part.Material = state.Material
                    part.Transparency = state.Transparency
                end
            end
            getgenv().originalStates = {}
            getgenv().activeRainbowThreads = {}
        end

        local function applyToInventoryAndEquipped()
            for _, tool in ipairs(player.Backpack:GetChildren()) do
                if tool:IsA("Tool") and validGunNames[tool.Name] then
                    startRainbow(tool)
                end
            end
            if player.Character then
                for _, tool in ipairs(player.Character:GetChildren()) do
                    if tool:IsA("Tool") and validGunNames[tool.Name] then
                        startRainbow(tool)
                    end
                end
            end
        end

        local function onToolAdded(tool)
            if tool:IsA("Tool") and validGunNames[tool.Name] then
                startRainbow(tool)
            end
        end

        local function connectCharacter(char)
            table.insert(getgenv().rainbowConnections, char.ChildAdded:Connect(onToolAdded))
        end

        if state then

            applyToInventoryAndEquipped()
            table.insert(getgenv().rainbowConnections, player.Backpack.ChildAdded:Connect(onToolAdded))
            table.insert(getgenv().rainbowConnections, player.CharacterAdded:Connect(connectCharacter))
            if player.Character then
                connectCharacter(player.Character)
            end
        else

            stopAllRainbows()
            for _, conn in ipairs(getgenv().rainbowConnections) do
                conn:Disconnect()
            end
            getgenv().rainbowConnections = {}
        end
    end
})
local Slider = VisualsTab:Slider({
    Title = "Time of Day",
    Step = 1, 
    Value = {
        Min = 0,
        Max = 24,
        Default = 12,
    },
    Callback = function(value)
 
        local hour = math.floor(value)
        local minutes = math.floor((value - hour) * 60)
        local timeString = string.format("%02d:%02d:00", hour, minutes)


        game.Lighting.TimeOfDay = timeString
    end
})



function getcp()
    local mouse = game.Players.LocalPlayer:GetMouse()
    local hit = mouse.Hit.Position
    local maxdis = math.huge
    local target = nil
    for i, v in next, game.Players:GetChildren() do
        if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v ~= game.Players.LocalPlayer then
            local mag = (hit - v.Character.HumanoidRootPart.Position).Magnitude
            if mag < maxdis then
                maxdis = mag
                target = v
            end
        end
    end
    return target
end


getgenv().highlight = false
getgenv().wallbang = false
getgenv().randomredire = false
getgenv().killaurahigh = false
getgenv().cooldown = 0
getgenv().damage = 100
getgenv().hitpart = "Head"
getgenv().auraenabled = false
getgenv().beam = true 
getgenv().rainbowbeam = false
getgenv().beamcolor = Color3.fromRGB(255, 0, 0)

local target1 = getcp()
spawn(function()
    game:GetService("RunService").RenderStepped:Connect(function()
        local currentTarget = getcp()
        if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart") then
            target1 = currentTarget
            if getgenv().highlight or getgenv().killaurahigh then
                task.wait()
                local hi = Instance.new("Highlight", target1.Character)
                hi.FillColor = Color3.fromRGB(255, 0, 0) -- red only
                hi.OutlineColor = Color3.new(1, 1, 1)
                hi.FillTransparency = 0.25
                game.Debris:AddItem(hi, 0.1)
            end
        end
    end)
end)
local lad = {
    "Head", "UpperTorso", "HumanoidRootPart", "RightUpperLeg", "RightUpperArm", "RightLowerLeg", "RightLowerArm",
    "RightHand", "RightFoot", "LowerTorso", "LeftUpperLeg", "LeftUpperArm", "LeftLowerLeg", "LeftLowerArm", "LeftHand"
}
spawn(function()
    if hookmetamethod then
        local saimh
        saimh = hookmetamethod(game, "__namecall", function(Self, ...)
            local method = getnamecallmethod():lower()
            local args = { ... }
            if tostring(method) == "findpartonray" and getgenv().saim and target1.Character and target1 and
                tostring(getfenv(0).script) == "GunScript_Local" then
                local targetPosition = target1.Character["Head"].Position
                if getgenv().randomredire then
                    targetPosition = target1.Character[lad[math.random(1, #lad)]].Position
                end
                local origin = args[1].Origin
                local direction = (targetPosition - origin).Unit
                args[1] = Ray.new(origin, direction * 1000)
                return saimh(Self, table.unpack(args))
            end
            return saimh(Self, ...)
        end)
    end
end)
local function randomRGB()
    return Color3.fromRGB(
        Random.new():NextInteger(0, 255),
        Random.new():NextInteger(0, 255),
        Random.new():NextInteger(0, 255)
    )
end
local function visualizeMuzzle()
    local plr = game.Players.LocalPlayer
    local tool = plr.Character and plr.Character:FindFirstChildWhichIsA("Tool")
    if tool then
        local handle = tool:FindFirstChild("Handle")
        local muzzleEffect = tool:FindFirstChild("GunScript_Local") and tool.GunScript_Local:FindFirstChild("MuzzleEffect")
        if handle and muzzleEffect and game.ReplicatedStorage:FindFirstChild("VisualizeMuzzle") then
            local color = getgenv().rainbowbeam and Color3.fromHSV(tick() % 5 / 5, 1, 1) or getgenv().beamcolor
            game.ReplicatedStorage.VisualizeMuzzle:FireServer(
                handle,
                true,
                {false, 7, color, 15, true, 0.02},
                muzzleEffect
            )
        end
    end
end
local KillauraToggle = FunTab:Toggle({
    Title = "SuperMan",
    Desc = "",
    Icon = "rocket",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        getgenv().auraenabled = state
        if state then
            spawn(function()
                while getgenv().auraenabled and task.wait(getgenv().cooldown) do
                    task.wait()
                    pcall(function()
                        local plr = game.Players.LocalPlayer
                        if plr.Character:FindFirstChildWhichIsA("Tool") and
                           plr.Character:FindFirstChildOfClass("Tool"):FindFirstChild("GunScript_Local") then
                            -- Beam
                            local part = Instance.new("Part", workspace)
                            part.Size = Vector3.new(0.2, 0.2,
                                (plr.Character.HumanoidRootPart.Position - target1.Character.Head.Position).Magnitude)
                            part.Anchored = true
                            part.CanCollide = false
                            local color = getgenv().rainbowbeam and Color3.fromHSV(tick() % 5 / 5, 1, 1) or getgenv().beamcolor
                            part.Color = color
                            part.Material = Enum.Material.Neon
                            local toolHandle = plr.Character:FindFirstChildWhichIsA("Tool"):FindFirstChild("Handle")
                            if toolHandle then
                                local midpoint = (toolHandle.Position + target1.Character[getgenv().hitpart].Position) / 2
                                part.Position = midpoint
                                part.CFrame = CFrame.new(midpoint, target1.Character[getgenv().hitpart].Position)
                            end
                            task.wait(0.1)
                            part:Destroy()
                        end
                        visualizeMuzzle()
                        dmg(target1, getgenv().hitpart, getgenv().damage)
                    end)
                end
            end)
        end
    end
})
local BeamColorPicker = FunTab:Colorpicker({
    Title = "Beam Color",
    Desc = "Change Killaura beam color",
    Color = Color3.fromRGB(255, 0, 0),
    Transparency = 0,
    Locked = false,
    Callback = function(color)
        getgenv().beamcolor = color
    end
})
local HighlightToggle = FunTab:Toggle({
    Title = "Highlight Target",
    Desc = "Highlight the current target for Killaura",
    Icon = "rocket",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        getgenv().killaurahigh = state
    end
})
local RainbowToggle = FunTab:Toggle({
    Title = "Simulate Rainbow (Beam)",
    Desc = "Make the beam cycle colors",
    Icon = "rocket",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        getgenv().rainbowbeam = state
    end
})

function dmg(target, hpart, damage)
    game:GetService("ReplicatedStorage").InflictTarget:FireServer(
        game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Tool"),
        game.Players.LocalPlayer,
        target.Character.Humanoid,
        target.Character[hpart],
        damage,
        {0, 0, false, false,
            game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Tool").GunScript_Server.IgniteScript,
            game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Tool").GunScript_Server.IcifyScript,
            100, 100},
        {false, 5, 3},
        target.Character[hpart],
        {false, {1930359546}, 1, 1.5, 1},
        nil,
        nil,
        true
    )
end

function checkgun()
    local player = game.Players.LocalPlayer
    local gunTool = nil

    for _, v in pairs(player.Backpack:GetDescendants()) do
        if v:IsA("LocalScript") and v.Name == "GunScript_Local" then
            gunTool = v.Parent
            break
        end
    end

    if not gunTool and player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("LocalScript") and v.Name == "GunScript_Local" then
                gunTool = v.Parent
                break
            end
        end
    end

    if gunTool and gunTool:IsA("Tool") then
        player.Character:WaitForChild("Humanoid"):EquipTool(gunTool)
    end

    return gunTool
end


local Button = FunTab:Button({
    Title = "KillAll",
    Desc = "Kills every loaded player except you for 5 seconds.",
    Color = Color3.fromRGB(255, 0, 0),

    Locked = false,
    Callback = function()
        local gun = checkgun()
        if not gun then
            WindUI:Notify({
                Title = "Killing All",
                Content = "Gun not found.",
                Duration = 3,
                Icon = "x",
            })
            return
        end

        local duration = 5
        local startTime = tick()

        while tick() - startTime < duration do
            local fireRemote = gun:FindFirstChild("Fire") or gun:FindFirstChild("Shoot") or gun:FindFirstChild("Remote")
            if fireRemote and fireRemote:IsA("RemoteEvent") then
                fireRemote:FireServer()
            elseif fireRemote and fireRemote:IsA("RemoteFunction") then
                fireRemote:InvokeServer()
            elseif gun.Activate then
                gun:Activate()
            end

            local handle = gun:FindFirstChild("Handle")
            local muzzleEffect = gun:FindFirstChild("GunScript_Local") and gun.GunScript_Local:FindFirstChild("MuzzleEffect")
            if handle and muzzleEffect and game.ReplicatedStorage:FindFirstChild("VisualizeMuzzle") then
                game.ReplicatedStorage.VisualizeMuzzle:FireServer(
                    handle,
                    true,
                    {false, 7, Color3.new(1, 1.1098, 0), 15, true, 0.02},
                    muzzleEffect
                )
            end

            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= game.Players.LocalPlayer then
                    local char = v.Character
                    if char and char:FindFirstChild("Head") and char:FindFirstChild("Humanoid") then
                        dmg(v, "Head", 1000)
                    end
                end
            end
            wait(0.1)
        end

        WindUI:Notify({
            Title = "Killing All",
            Content = "Kill command sent to all loaded players (except you) for 5 seconds.",
            Duration = 3,
            Icon = "check",
        })
    end
})


local BreakGlassToggle = FunTab:Toggle({
    Title = "Break All Glass (Loop)",
    Desc = "Continuously breaks all glass in the workspace",
    Icon = "",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        if state then
            getgenv()._breakGlassLoop = true
            task.spawn(function()
                while getgenv()._breakGlassLoop do
                    for _, v in ipairs(workspace:GetDescendants()) do
                        if (v:IsA("BasePart") or v:IsA("MeshPart")) and v.Name == "Glass" then
                            game:GetService("ReplicatedStorage").BreakGlass:InvokeServer(v)
                        end
                    end
                    task.wait(0.01)
                end
            end)
        else
            getgenv()._breakGlassLoop = false
        end
    end
})


local SpamPoliceButton = FunTab:Button({
    Title = "Spam Call Police",
    Color = Color3.fromRGB(255, 0, 0),

    Justify = "Center",
    IconAlign = "Left",
    Icon = "",
    Callback = function()
        for i = 1, getgenv().intsdp or 10 do
            task.wait(0.05)
            game:GetService("ReplicatedStorage").CallPolice:FireServer()
        end
        
        WindUI:Notify({
            Title = "Police Called",
            Content = "Spammed police call " .. tostring(getgenv().intsdp or 10) .. " times!",
            Duration = 3,
            Icon = "phone",
        })
    end
})



local Section = FunTab:Section({ 
    Title = "Target",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local SelectedPlayer = nil


local function getPlayerByName(name)
	for _, p in pairs(Players:GetPlayers()) do
		if p.Name == name then
			return p
		end
	end
	return nil
end


local function updatePlayerList()
	local pl = {"None"}
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			table.insert(pl, p.Name)
		end
	end
	return pl
end


local playerDropdown = FunTab:Dropdown({
	Title = "Select Player",
	Values = updatePlayerList(),
	Value = "",
	Callback = function(selectedOption)
		local selNameStr
		if type(selectedOption) == "table" then
			selNameStr = selectedOption.Value or selectedOption[1] or tostring(selectedOption)
		else
			selNameStr = tostring(selectedOption)
		end

		if selNameStr ~= "" and selNameStr ~= nil then
			if selNameStr == "None" then
				SelectedPlayer = nil
				WindUI:Notify({
					Title = "Player Selection",
					Content = "No player selected",
					Duration = 2,
					Icon = "x"
				})
			else
				SelectedPlayer = getPlayerByName(selNameStr)
				if SelectedPlayer then
					WindUI:Notify({
						Title = "Player Selected",
						Content = selNameStr .. " selected",
						Duration = 2,
						Icon = "check"
					})
				else
					WindUI:Notify({
						Title = "Error",
						Content = "Player '" .. selNameStr .. "' not found",
						Duration = 2,
						Icon = "message-circle-warning"
					})
				end
			end
		end
	end,
})


if not playerDropdown.Frame and playerDropdown._Container then
	local fixFrame = Instance.new("Frame")
	fixFrame.Size = UDim2.new(1, 0, 1, 0)
	fixFrame.BackgroundTransparency = 1
	fixFrame.Parent = playerDropdown._Container
	playerDropdown.Frame = fixFrame
end


local function refreshDropdownOptions()
	if not playerDropdown then return end

	local newOptions = updatePlayerList()
	local currentSelection = playerDropdown.Value


	playerDropdown:Refresh(newOptions)


	if currentSelection and currentSelection ~= "" then
		for _, name in ipairs(newOptions) do
			if name == currentSelection then
				playerDropdown.Value = currentSelection
				SelectedPlayer = getPlayerByName(currentSelection)
				return
			end
		end
	end


	playerDropdown.Value = ""
	SelectedPlayer = nil
end


Players.PlayerAdded:Connect(refreshDropdownOptions)
Players.PlayerRemoving:Connect(refreshDropdownOptions)



local gotoPlayerToggle
gotoPlayerToggle = FunTab:Toggle({
    Title = "TP to Player",
    Desc = "Teleport to the selected player",
    Icon = "map",
    Type = "Checkbox",
    Default = false,
    Callback = function(Value)
        if Value then
            if SelectedPlayer then
                -- Ensure target exists
                local targetChar = SelectedPlayer.Character or SelectedPlayer.CharacterAdded:Wait()
                local targetHRP = targetChar:WaitForChild("HumanoidRootPart")

                local myHRP = humanoidRootPart or LocalPlayer.Character:WaitForChild("HumanoidRootPart")

                -- Teleport
                getgenv().SwimMethod = true
                task.wait(1)
                myHRP.CFrame = targetHRP.CFrame
                getgenv().SwimMethod = false

                WindUI:Notify({
                    Title = "Goto",
                    Content = "Teleported to " .. SelectedPlayer.Name,
                    Duration = 2,
                    Icon = "map"
                })
            end

            -- Reset toggle
            if gotoPlayerToggle then
                gotoPlayerToggle:Set(false)
            end
        end
    end,
})




FunTab:Button({
	Title = "Ruin Player Movement - Need Gun",
	Desc = "",
    Color = Color3.fromRGB(255, 0, 0),

	Locked = false,
	Callback = function()
		if not SelectedPlayer
			or not SelectedPlayer.Character
			or not SelectedPlayer.Character:FindFirstChild("LeftLowerLeg") then

			WindUI:Notify({
				Title = "Ruin Player Movement",
				Content = "Invalid target selected",
				Duration = 2,
				Icon = "message-circle-warning"
			})
			return
		end

		local player = LocalPlayer

		local function dmg(target, hpart, damage)
			local tool = player.Character and player.Character:FindFirstChildWhichIsA("Tool")
			if not tool then
				return
			end

			game:GetService("ReplicatedStorage").InflictTarget:FireServer(
				tool,
				player,
				target.Character.Humanoid,
				target.Character[hpart],
				damage,
				{ 0, 0, false, false, tool.GunScript_Server.IgniteScript, tool.GunScript_Server.IcifyScript, 100, 100 },
				{ false, 5, 3 },
				target.Character[hpart],
				{ false, { 1930359546 }, 1, 1.5, 1 },
				nil,
				nil,
				true
			)
		end

		local function checkgun()
			local gunTool = nil
			for _, v in pairs(player.Backpack:GetDescendants()) do
				if v:IsA("LocalScript") and v.Name == "GunScript_Local" then
					gunTool = v.Parent
					break
				end
			end
			if not gunTool and player.Character then
				for _, v in pairs(player.Character:GetDescendants()) do
					if v:IsA("LocalScript") and v.Name == "GunScript_Local" then
						gunTool = v.Parent
						break
					end
				end
			end
			if gunTool and gunTool:IsA("Tool") then
				player.Character:WaitForChild("Humanoid"):EquipTool(gunTool)
			end
			return gunTool
		end

		local gun = checkgun()
		if not gun then
			WindUI:Notify({
				Title = "Ruin Player Movement",
				Content = "No gun found",
				Duration = 2,
				Icon = "message-circle-warning"
			})
			return
		end

		local handle = gun:FindFirstChild("Handle")
		local muzzleEffect = gun:FindFirstChild("GunScript_Local")
			and gun.GunScript_Local:FindFirstChild("MuzzleEffect")
		if handle and muzzleEffect and game.ReplicatedStorage:FindFirstChild("VisualizeMuzzle") then
			game.ReplicatedStorage.VisualizeMuzzle:FireServer(
				handle,
				true,
				{ false, 7, Color3.new(1, 1.1098, 0), 15, true, 0.02 },
				muzzleEffect
			)
		end

		task.spawn(function()
			local startTime = os.clock()
			while os.clock() - startTime < 5 do
				if not SelectedPlayer
					or not SelectedPlayer.Character
					or not SelectedPlayer.Character:FindFirstChild("Humanoid")
					or SelectedPlayer.Character.Humanoid.Health <= 0 then
					break
				end

				local part = SelectedPlayer.Character:FindFirstChild("LeftLowerLeg") 
					or SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
				if part then
					dmg(SelectedPlayer, part.Name, .5)
				end

				task.wait(3)
			end
		end)

		WindUI:Notify({
			Title = "Ruin Player Movement",
			Content = "Attacking " .. SelectedPlayer.Name,
			Duration = 3,
			Icon = "circle-plus"
		})
	end,
})


FunTab:Button({
    Title = "Kill Player - Need Gun",
    Color = Color3.fromRGB(255, 0, 0),

    Callback = function()
        if not SelectedPlayer
            or not SelectedPlayer.Character
            or not SelectedPlayer.Character:FindFirstChild("Head")
        then
            WindUI:Notify({ Title = "Kill Player", Content = "Invalid target selected", Duration = 2, Icon = "bird" })
            return
        end

        local player = game.Players.LocalPlayer

        local function dmg(target, hpart, damage)
            local tool = player.Character and player.Character:FindFirstChildWhichIsA("Tool")
            if not tool then return end

            game:GetService("ReplicatedStorage").InflictTarget:FireServer(
                tool,
                player,
                target.Character.Humanoid,
                target.Character[hpart],
                damage,
                { 0, 0, false, false, tool.GunScript_Server.IgniteScript, tool.GunScript_Server.IcifyScript, 100, 100 },
                { false, 5, 3 },
                target.Character[hpart],
                { false, { 1930359546 }, 1, 1.5, 1 },
                nil,
                nil,
                true
            )
        end

        local function checkgun()
            local gunTool = nil
            for _, v in pairs(player.Backpack:GetDescendants()) do
                if v:IsA("LocalScript") and v.Name == "GunScript_Local" then
                    gunTool = v.Parent
                    break
                end
            end
            if not gunTool and player.Character then
                for _, v in pairs(player.Character:GetDescendants()) do
                    if v:IsA("LocalScript") and v.Name == "GunScript_Local" then
                        gunTool = v.Parent
                        break
                    end
                end
            end
            if gunTool and gunTool:IsA("Tool") then
                player.Character:WaitForChild("Humanoid"):EquipTool(gunTool)
            end
            return gunTool
        end

        local gun = checkgun()
        if not gun then
            WindUI:Notify({ Title = "Kill Player", Content = "No gun found", Duration = 2, Icon = "bird" })
            return
        end

        local handle = gun:FindFirstChild("Handle")
        local muzzleEffect = gun:FindFirstChild("GunScript_Local") and gun.GunScript_Local:FindFirstChild("MuzzleEffect")
        if handle and muzzleEffect and game.ReplicatedStorage:FindFirstChild("VisualizeMuzzle") then
            game.ReplicatedStorage.VisualizeMuzzle:FireServer(
                handle,
                true,
                { false, 7, Color3.new(1, 1.1098, 0), 15, true, 0.02 },
                muzzleEffect
            )
        end

        task.spawn(function()
            local startTime = os.clock()
            while os.clock() - startTime < 5 do
                if not SelectedPlayer.Character
                    or not SelectedPlayer.Character:FindFirstChild("Humanoid")
                    or SelectedPlayer.Character.Humanoid.Health <= 0
                then
                    break
                end
                dmg(SelectedPlayer, "Head", 1000)
                task.wait(0.1)
            end
        end)

        WindUI:Notify({ Title = "Kill Player", Content = "Attacking " .. SelectedPlayer.Name, Duration = 2, Icon = "bird" })
    end,
}) 

local spectateToggleEnabled = false

local spectateToggle = FunTab:Toggle({
    Title = "Spectate Player",
    Desc = "Spectate the selected player",
    Icon = "circle-plus",
    Type = "Checkbox",
    Default = false,
    Callback = function(Value)
        if Value == spectateToggleEnabled then
            return 
        end
        spectateToggleEnabled = Value  

        if Value then

            if SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("Humanoid") then
                workspace.CurrentCamera.CameraSubject = SelectedPlayer.Character.Humanoid
                WindUI:Notify({
                    Title = "Spectate",
                    Content = "On: " .. SelectedPlayer.Name,
                    Duration = 2,
                    Icon = "eye"
                })
            else
                WindUI:Notify({
                    Title = "Spectate",
                    Content = "No target selected",
                    Duration = 2,
                    Icon = "alert"
                })
                spectateToggle.Value = false
            end
        else

            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
            end
            WindUI:Notify({
                Title = "Spectate",
                Content = "Off",
                Duration = 2,
                Icon = "circle-plus"
            })
        end
    end,
})



local killBringActive = false
local bringClone
bringClone = FunTab:Toggle({
    Title = "BringClone",
    Desc = "Bring the selected player near you",
    Icon = "circle-plus",
    Type = "Checkbox",
    Default = false,
    Callback = function(Value)
        if Value then
            if not SelectedPlayer then
                WindUI:Notify({ Title = "KB", Content = "No target selected", Duration = 2, Icon = "alert" })
                if bringClone then
                    bringClone:Set(false)
                end
                return
            end
            if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                WindUI:Notify({ Title = "KB", Content = "Your character not ready", Duration = 2, Icon = "alert" })
                if bringClone then
                    bringClone:Set(false)
                end
                return
            end
        end

        killBringActive = Value
        if killBringActive then
            local targetPlayer = SelectedPlayer
            task.spawn(function()
                while killBringActive do
                    local tCharacter = targetPlayer and targetPlayer.Character
                    local tRoot = tCharacter and tCharacter:FindFirstChild("HumanoidRootPart")
                    local humanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

                    if not tRoot or not humanoidRootPart then
                        WindUI:Notify({ Title = "KB", Content = "No target/self", Duration = 2, Icon = "alert" })
                        killBringActive = false
                        if bringClone then
                            bringClone:Set(false)
                        end
                        break
                    end

                    local tHumanoid = tCharacter:FindFirstChildOfClass("Humanoid")
                    if tHumanoid then
                        tHumanoid.Sit = false
                    end

                    task.wait()
                    tRoot.CFrame = humanoidRootPart.CFrame + Vector3.new(3, 1, 0)
                    task.wait(0.1)
                end
            end)
        end
    end,
})


local viewInventory
viewInventory = FunTab:Toggle({
    Title = "View Inventory",
    Desc = "View selected player's backpack items",
    Icon = "circle-plus",
    Type = "Checkbox",
    Default = false,
    Callback = function(Value)
        if Value then
            if SelectedPlayer and SelectedPlayer:FindFirstChild("Backpack") then
                local items = {}
                for _, i in ipairs(SelectedPlayer.Backpack:GetChildren()) do
                    table.insert(items, i.Name)
                end
                WindUI:Notify({
                    Title = SelectedPlayer.Name .. "'s Inv",
                    Content = (#items > 0 and table.concat(items, ", ") or "Empty"),
                    Duration = 5,
                    Icon = "circle-plus"
                })
            else
                WindUI:Notify({ Title = "Inv", Content = "No target/backpack", Duration = 2, Icon = "alert" })
            end
            if viewInventory then
                viewInventory:Set(false)
            end
        end
    end,
})

-- Fly Function
local flyEnabled = false
local flyConnections = {}
local flyVelocity = nil
local flyGyro = nil
local flySeat = nil
local lastPosition = nil

local function cleanupFly()
    -- Disconnect all connections
    for _, conn in ipairs(flyConnections) do
        if conn and conn.Disconnect then
            conn:Disconnect()
        end
    end
    flyConnections = {}
    
    -- Remove fly objects
    if flyVelocity and flyVelocity.Parent then
        flyVelocity:Destroy()
        flyVelocity = nil
    end
    
    if flyGyro and flyGyro.Parent then
        flyGyro:Destroy()
        flyGyro = nil
    end
    
    if flySeat and flySeat.Parent then
        flySeat:Destroy()
        flySeat = nil
    end
    
    -- Disable swim method
    getgenv().SwimMethod = false
    
    -- Restore character with anti-teleport bypass
    local player = game.Players.LocalPlayer
    local char = player.Character
    if char then
        local humanoid = char:FindFirstChildWhichIsA("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        
        if humanoid and hrp then
            -- Use the same bypass as teleportToLocation
            humanoid:ChangeState(0) -- Reset state
            repeat task.wait(0.0001) until not player:GetAttribute("LastACPos")
            
            -- Wait a moment to ensure position is locked
            task.wait(0.1)
            
            -- Restore normal state
            humanoid:ChangeState(2) -- Running state
            humanoid.PlatformStand = false
            humanoid.Jump = false
            
            -- Clear velocity
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
    end
end

local function setupFly()
    cleanupFly()
    
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildWhichIsA("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return end
    
    -- Store current position
    lastPosition = hrp.CFrame
    
    -- Enable swim method for anti-teleport protection
    getgenv().SwimMethod = true
    
    -- Create invisible seat for flying (safer method)
    local seat = Instance.new("VehicleSeat")
    seat.Name = "FlySeat"
    seat.Anchored = false
    seat.CanCollide = false
    seat.Transparency = 1
    seat.TopSurface = Enum.SurfaceType.Smooth
    seat.BottomSurface = Enum.SurfaceType.Smooth
    seat.Parent = workspace
    seat.CFrame = hrp.CFrame * CFrame.new(0, -3, 0)
    
    -- Create weld to attach seat to player
    local weld = Instance.new("Weld")
    weld.Part0 = seat
    weld.Part1 = hrp
    weld.C0 = CFrame.new(0, 3, 0)
    weld.Parent = seat
    
    -- Sit in seat
    seat:Sit(humanoid)
    
    -- Create fly objects
    flyVelocity = Instance.new("BodyVelocity")
    flyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    flyVelocity.Velocity = Vector3.zero
    flyVelocity.Parent = hrp
    
    flyGyro = Instance.new("BodyGyro")
    flyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    flyGyro.P = 50000
    flyGyro.D = 1000
    flyGyro.CFrame = hrp.CFrame
    flyGyro.Parent = hrp
    
    -- Store seat for cleanup
    flySeat = seat
    
    -- Movement variables
    local speed = 80
    local minSpeed = 20
    local maxSpeed = 300
    local move = {W=false,A=false,S=false,D=false,Space=false,Shift=false}
    
    -- Input connections
    local inputBegan = game:GetService("UserInputService").InputBegan:Connect(function(i,g)
        if g then return end
        if i.KeyCode == Enum.KeyCode.W then move.W = true end
        if i.KeyCode == Enum.KeyCode.A then move.A = true end
        if i.KeyCode == Enum.KeyCode.S then move.S = true end
        if i.KeyCode == Enum.KeyCode.D then move.D = true end
        if i.KeyCode == Enum.KeyCode.Space then move.Space = true end
        if i.KeyCode == Enum.KeyCode.LeftShift then move.Shift = true end
        if i.KeyCode == Enum.KeyCode.E then speed = math.clamp(speed + 10, minSpeed, maxSpeed) end
        if i.KeyCode == Enum.KeyCode.Q then speed = math.clamp(speed - 10, minSpeed, maxSpeed) end
    end)
    table.insert(flyConnections, inputBegan)
    
    local inputEnded = game:GetService("UserInputService").InputEnded:Connect(function(i)
        if i.KeyCode == Enum.KeyCode.W then move.W = false end
        if i.KeyCode == Enum.KeyCode.A then move.A = false end
        if i.KeyCode == Enum.KeyCode.S then move.S = false end
        if i.KeyCode == Enum.KeyCode.D then move.D = false end
        if i.KeyCode == Enum.KeyCode.Space then move.Space = false end
        if i.KeyCode == Enum.KeyCode.LeftShift then move.Shift = false end
    end)
    table.insert(flyConnections, inputEnded)
    
    -- RenderStepped connection
    local renderStepped = game:GetService("RunService").RenderStepped:Connect(function()
        if not flyEnabled or not flyVelocity or not flyGyro then return end
        
        -- Maintain swim method
        if not getgenv().SwimMethod then
            getgenv().SwimMethod = true
        end
        
        local cam = workspace.CurrentCamera
        flyGyro.CFrame = cam.CFrame
        
        local dir = Vector3.zero
        if move.W then dir += cam.CFrame.LookVector end
        if move.S then dir -= cam.CFrame.LookVector end
        if move.A then dir -= cam.CFrame.RightVector end
        if move.D then dir += cam.CFrame.RightVector end
        if move.Space then dir += Vector3.new(0,1,0) end
        if move.Shift then dir -= Vector3.new(0,1,0) end
        
        if dir.Magnitude > 0 then
            flyVelocity.Velocity = dir.Unit * speed
        else
            flyVelocity.Velocity = Vector3.zero
        end
    end)
    table.insert(flyConnections, renderStepped)
end

FunTab:Toggle({
    Title = "Fly",
    Desc = "Enable flight mode (WASD to move, Space/Shift to go up/down, Q/E to change speed)",
    Icon = "feather",
    Type = "Checkbox",
    Default = false,
    Callback = function(Value)
        flyEnabled = Value
        if Value then
            setupFly()
            WindUI:Notify({
                Title = "Fly",
                Content = "Fly enabled! Use WASD to move, Space/Shift for up/down, Q/E for speed",
                Duration = 3,
                Icon = "feather"
            })
        else
            cleanupFly()
            WindUI:Notify({
                Title = "Fly",
                Content = "Fly disabled",
                Duration = 2,
                Icon = "feather"
            })
        end
    end
})



local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local LocalPlayer = player



local staminaEnabled = false
local hungerEnabled = false
local sleepEnabled = false
local AntiRentPayEnabled = false
local AntiLoseEnabled = false
local Noclipping = nil
local isNoclipInitialized = false
local _G = _G or {}
_G.respawn = false
local lastDeathPosition = nil

local function applyEffectsToCharacter(character)
    if staminaEnabled then
        local staminaScript = player.PlayerGui:FindFirstChild("Run", true)
        if staminaScript then
            local scriptObj = staminaScript:FindFirstChild("StaminaBarScript", true)
            if scriptObj then scriptObj:Destroy() end
        end
    end
    if hungerEnabled then
        local hungerScript = player.PlayerGui:FindFirstChild("Hunger", true)
        if hungerScript then
            local scriptObj = hungerScript:FindFirstChild("HungerBarScript", true)
            if scriptObj then scriptObj:Destroy() end
        end
    end
    if sleepEnabled then
        local success, s = pcall(function()
            return player.PlayerGui.SleepGui.Frame.sleep.SleepBar.sleepScript
        end)
        if success and s then
            s.Disabled = true
            s.Disabled = false
            s.Disabled = true
        end
    end
end
player.CharacterAdded:Connect(function(character)
    character:WaitForChild("HumanoidRootPart", 5)
    applyEffectsToCharacter(character)
end)
local function setCollide(state)
    local char = player.Character
    if char then
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = state
            end
        end
    end
end


UtilitiesTab:Toggle({
    Title = "Anti Fall Damage",
    Desc = "Prevents fall damage",
    Icon = "",
    Type = "Checkbox",
    Value = false,
    Callback = function(Value)
        if Value then
            WindUI:Notify({
                Title = "Kori Script",
                Content = "Anti Fall Damage enabled",
                Duration = 3,
                Icon = "",
            })
        end
        local character = player.Character or player.CharacterAdded:Wait()
        local fallDamage = character:FindFirstChild("FallDamageRagdoll")
        if fallDamage and Value then
            fallDamage:Destroy()
        end
    end
})
UtilitiesTab:Toggle({
    Title = "Infinite Stamina",
    Desc = "Never run out of stamina",
    Icon = "",
    Type = "Checkbox",
    Value = false,
    Callback = function(Value)
        staminaEnabled = Value
        if Value then
            WindUI:Notify({
                Title = "Kori Script",
                Content = "Infinite Stamina enabled",
                Duration = 3,
                Icon = "",
            })
            applyEffectsToCharacter(player.Character or player.CharacterAdded:Wait())
        end
    end
})
UtilitiesTab:Toggle({
    Title = "Infinite Hunger",
    Desc = "Never get hungry",
    Icon = "",
    Type = "Checkbox",
    Value = false,
    Callback = function(Value)
        hungerEnabled = Value
        if Value then
            WindUI:Notify({
                Title = "Kori Script",
                Content = "Infinite Hunger enabled",
                Duration = 3,
                Icon = "",
            })
            applyEffectsToCharacter(player.Character or player.CharacterAdded:Wait())
        end
    end
})
UtilitiesTab:Toggle({
    Title = "Infinite Sleep",
    Desc = "Never need to sleep",
    Icon = "",
    Type = "Checkbox",
    Value = false,
    Callback = function(Value)
        sleepEnabled = Value
        if Value then
            WindUI:Notify({
                Title = "Kori Script",
                Content = "Infinite Sleep enabled",
                Duration = 3,
                Icon = "",
            })
            applyEffectsToCharacter(player.Character or player.CharacterAdded:Wait())
        end
    end
})
UtilitiesTab:Toggle({
    Title = "Anti Lose Items",
    Desc = "Prevent losing items on death",
    Icon = "",
    Type = "Checkbox",
    Value = false,
    Callback = function(Value)
        AntiLoseEnabled = Value
        if Value then
            WindUI:Notify({
                Title = "Kori Script",
                Content = "Anti Lose enabled",
                Duration = 3,
                Icon = "",
            })
        end
    end
})
UtilitiesTab:Toggle({
    Title = "No Rent Pay",
    Desc = "Disable rent payments",
    Icon = "",
    Type = "Checkbox",
    Value = false,
    Callback = function(Value)
        AntiRentPayEnabled = Value
        if Value then
            WindUI:Notify({
                Title = "Kori Script",
                Content = "No Rent Pay enabled",
                Duration = 3,
                Icon = "",
            })
            task.spawn(function()
                while AntiRentPayEnabled do
                    task.wait(1)
                    local rentGui = player.PlayerGui:FindFirstChild("RentGui")
                    if rentGui then
                        local rentScript = rentGui:FindFirstChild("LocalScript")
                        if rentScript then
                            rentScript.Disabled = true
                            rentScript:Destroy()
                        end
                    end
                end
            end)
        end
    end
})
UtilitiesTab:Toggle({
    Title = "Anti-Knockback",
    Desc = "Prevents knockback effects",
    Icon = "",
    Type = "Checkbox",
    Value = false,
    Callback = function(Value)
        if Value then
            WindUI:Notify({
                Title = "Kori Script",
                Content = "Anti-Knockback enabled",
                Duration = 3,
                Icon = "",
            })
            local character = player.Character or player.CharacterAdded:Wait()
            for _, v in ipairs(character:GetDescendants()) do
                if v:IsA("BodyVelocity") or v:IsA("LinearVelocity") or v:IsA("VectorForce") then
                    v:Destroy()
                end
            end
            local ae = ReplicatedStorage:FindFirstChild("AE")
            if ae then ae:Destroy() end
            local root = character:WaitForChild("HumanoidRootPart")
            root.ChildAdded:Connect(function(v)
                if v:IsA("BodyVelocity") or v:IsA("LinearVelocity") or v:IsA("VectorForce") then
                    v:Destroy()
                end
            end)
        end
    end
})
UtilitiesTab:Toggle({
    Title = "Noclip",
    Desc = "Walk through walls",
    Icon = "",
    Type = "Checkbox",
    Value = false,
    Callback = function(Value)
        if not isNoclipInitialized then
            isNoclipInitialized = true
            return
        end

        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildWhichIsA("Humanoid")
        local root = character:FindFirstChild("HumanoidRootPart")

        if Value then
            WindUI:Notify({
                Title = "Kori Script",
                Content = "Noclip enabled",
                Duration = 3,
                Icon = "",
            })
            Noclipping = game:GetService("RunService").Stepped:Connect(function()
                setCollide(false)
            end)
        else
            if Noclipping then
                Noclipping:Disconnect()
                Noclipping = nil
            end
            setCollide(true)
            if root then
                local cf = root.CFrame
                root.CFrame = cf + Vector3.new(0, 0.1, 0)
                task.wait()
                root.CFrame = cf
            end
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
            WindUI:Notify({
                Title = "Kori Script",
                Content = "Noclip disabled",
                Duration = 3,
                Icon = "",
            })
        end
    end
})
UtilitiesTab:Toggle({
    Title = "Anti-CameraShake",
    Desc = "Disables camera shake",
    Icon = "",
    Type = "Checkbox",
    Value = false,
    Callback = function(Value)
        if Value then
            WindUI:Notify({
                Title = "Kori Script",
                Content = "Camera shake disabled",
                Duration = 3,
                Icon = "",
            })
            local character = player.Character or player.CharacterAdded:Wait()
            local camBobbing = character:FindFirstChild("CameraBobbing")
            if camBobbing then camBobbing:Destroy() end
            character.ChildAdded:Connect(function(v)
                if v.Name == "CameraBobbing" then v:Destroy() end
            end)
        end
    end
})
UtilitiesTab:Toggle({
    Title = "Instant Prompts",
    Desc = "Makes all prompts instant",
    Icon = "",
    Type = "Checkbox",
    Value = false,
    Callback = function(Value)
        getgenv().instantPrompts = Value
        local connection

        local function modifyPrompts()
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    v.HoldDuration = 0
                    v.MaxActivationDistance = 6
                end
            end
        end

        local function resetPrompts()
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    v.HoldDuration = 1
                    v.MaxActivationDistance = 4
                end
            end
        end

        if Value then
            WindUI:Notify({
                Title = "Kori Script",
                Content = "Applying instant interact settings...",
                Duration = 3,
                Icon = "",
            })
            task.wait(2)
            modifyPrompts()
            connection = workspace.DescendantAdded:Connect(function(obj)
                if obj:IsA("ProximityPrompt") then
                    obj.HoldDuration = 0
                    obj.MaxActivationDistance = 6
                end
            end)
        else
            resetPrompts()
            if connection then connection:Disconnect() end
        end
    end
})
UtilitiesTab:Button({
    Title = "Respawn Where Died",
    Color = Color3.fromRGB(255, 0, 0),

    Justify = "Center",
    IconAlign = "Left",
    Icon = "",
    Callback = function()
        WindUI:Notify({
            Title = "Kori Script",
            Content = "You will now respawn where you died.",
            Duration = 3,
            Icon = "",
        })

        local function onCharacterAdded(character)
            local humanoid = character:WaitForChild("Humanoid")

            if lastDeathPosition then
                local root = character:WaitForChild("HumanoidRootPart")
                root.CFrame = CFrame.new(lastDeathPosition + Vector3.new(0,3,0))
            end

            humanoid.Died:Connect(function()
                local root = character:FindFirstChild("HumanoidRootPart")
                if root then
                    lastDeathPosition = root.Position
                end
            end)
        end

        if player.Character then
            onCharacterAdded(player.Character)
        end
        player.CharacterAdded:Connect(onCharacterAdded)
    end
})
UtilitiesTab:Button({
    Title = "Enable Faster Respawn",
    Color = Color3.fromRGB(255, 0, 0),

    Justify = "Center",
    IconAlign = "Left",
    Icon = "",
    Callback = function()
        _G.respawn = true
        WindUI:Notify({
            Title = "Kori Script",
            Content = "Faster respawn has been enabled!",
            Duration = 3,
            Icon = "",
        })
    end
})
UtilitiesTab:Button({
    Title = "NO Close GunShop",
   Color = Color3.fromRGB(255, 0, 0),

    Justify = "Center",
    IconAlign = "Left",
    Icon = "",
    Callback = function()
        local gunShopClosed = workspace:FindFirstChild("GunShopClosed")
        if gunShopClosed then gunShopClosed:Destroy() end

        local secondGun = workspace:FindFirstChild("SecondGun4886")
        if secondGun and secondGun:FindFirstChild("ProximityPrompt") then
            secondGun.ProximityPrompt.Enabled = true
        end

        WindUI:Notify({
            Title = "Kori Script",
            Content = "GunShop Is Now Open!",
            Duration = 3,
            Icon = "",
        })
    end
})
UtilitiesTab:Button({
    Title = "No Camera Arrest",
    Color = Color3.fromRGB(255, 0, 0),

    Justify = "Center",
    IconAlign = "Left",
    Icon = "",
    Callback = function()
        local cameras = game:GetService("ReplicatedFirst"):FindFirstChild("Dakotas")
        if cameras and cameras:FindFirstChild("Cameras") then
            cameras.Cameras:Destroy()
            WindUI:Notify({
                Title = "Kori Script",
                Content = "Dakotas.Cameras has been deleted!",
                Duration = 1,
                Icon = "",
            })
        else
            WindUI:Notify({
                Title = "Kori Script",
                Content = "Dakotas.Cameras not found!",
                Duration = 1,
                Icon = "",
            })
        end
    end
})

task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.respawn then
            local character = player.Character
            if character and character:FindFirstChild("Humanoid") and character.Humanoid.Health <= 0 then
                ReplicatedStorage.RespawnRE:FireServer()
                task.wait(0.1)
            end
        end
    end
end)
local ExemptItems = {"Phone", "Fist", "Shiesty", "Bandage", "Lemonade", "Car keys"}

local function MarketHasItem(toolName)
    local market = ReplicatedStorage:FindFirstChild("MarketItems")
    if not market then return false end
    for _, item in ipairs(market:GetChildren()) do
        if item.Name == toolName and item:FindFirstChild("owner") and item.owner.Value == LocalPlayer.Name then
            return true
        end
    end
    return false
end
local function BackpackHasItem(toolName)
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name == toolName then
            return true
        end
    end
    return false
end
local function ForcePutToMarket(toolName)
    local endTime = os.clock() + 12
    while os.clock() < endTime do
        if MarketHasItem(toolName) then return true end
        pcall(function()
            ReplicatedStorage.ListWeaponRemote:FireServer(toolName, 999999)
        end)
        task.wait(0.15)
    end
    return false
end
local function ForceRetrieveFromMarket(toolName)
    local market = ReplicatedStorage:WaitForChild("MarketItems", 10)
    if not market then return false end

    local endTime = os.clock() + 12
    while os.clock() < endTime do
        for _, item in ipairs(market:GetChildren()) do
            if item.Name == toolName
                and item:FindFirstChild("owner")
                and item.owner.Value == LocalPlayer.Name
                and item:GetAttribute("SpecialId") then

                local special = item:GetAttribute("SpecialId")

                pcall(function()
                    ReplicatedStorage.BuyItemRemote:FireServer(toolName, "Remove", special)
                end)

                task.wait(0.2)

                pcall(function()
                    ReplicatedStorage.BackpackRemote:InvokeServer("Grab", toolName)
                end)

                task.wait(0.2)

                if BackpackHasItem(toolName) then
                    return true
                end
            end
        end
        task.wait(0.2)
    end
    return false
end

local function SaveOnDeath(char)
    local hum = char:WaitForChild("Humanoid")
    hum.Died:Connect(function()
        if not AntiLoseEnabled then return end
        task.wait(0.25)
        for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") and not table.find(ExemptItems, tool.Name) then
                ForcePutToMarket(tool.Name)
            end
        end
    end)
end

local function RetrieveAfterSpawn()
    task.delay(2.2, function()
        if not AntiLoseEnabled then return end
        local market = ReplicatedStorage:FindFirstChild("MarketItems")
        if not market then return end
        for _, item in ipairs(market:GetChildren()) do
            if item:FindFirstChild("owner") and item.owner.Value == LocalPlayer.Name then
                ForceRetrieveFromMarket(item.Name)
            end
        end
    end)
end

local function SetupCharacter(char)
    SaveOnDeath(char)
    RetrieveAfterSpawn()
end

LocalPlayer.CharacterAdded:Connect(SetupCharacter)
if LocalPlayer.Character then
    SetupCharacter(LocalPlayer.Character)
end

UtilitiesTab:Divider()


local function GetGunSettings()
    local player = game.Players.LocalPlayer
    local char = player.Character
    local tool = char and char:FindFirstChildOfClass("Tool")

    if not tool or not tool:FindFirstChild("Setting") then
        WindUI:Notify({
            Title = "Kori Script",
            Content = "Equip a gun first",
            Duration = 2,
            Icon = "",
        })
        return nil
    end

    return require(tool.Setting), tool
end
UtilitiesTab:Button({
    Title = "🔫 Infinite Ammo",
    Color = Color3.fromRGB(255, 0, 0),

    Justify = "Center",
    IconAlign = "Left",
    Icon = "",
    Callback = function()
        local settings, tool = GetGunSettings()
        if not settings then return end
        settings.LimitedAmmoEnabled = false
        settings.MaxAmmo = 80000
        settings.AmmoPerMag = 80000
        settings.Ammo = 80000
        settings.StoredAmmo = 80000
        settings.MagCount = 80000
        local gunScript = tool:FindFirstChild("GunScript_Local")
        if gunScript then
            local success1 = pcall(function()
                debug.setupvalue(getsenv(gunScript).Reload, 3, 80000)
            end)
            
            local success2 = pcall(function()
                debug.setupvalue(getsenv(gunScript).Reload, 5, 80000)
            end)
            
            if success1 and success2 then
                WindUI:Notify({
                    Title = "Kori Script",
                    Content = "Infinite Ammo & Mags (80000) Enabled",
                    Duration = 2,
                    Icon = "",
                })
            else
                WindUI:Notify({
                    Title = "Kori Script",
                    Content = "Infinite Ammo (80000) Enabled",
                    Duration = 2,
                    Icon = "",
                })
            end
        else
            WindUI:Notify({
                Title = "Kori Script",
                Content = "Infinite Ammo (80000) Enabled",
                Duration = 2,
                Icon = "",
            })
        end
    end
})
UtilitiesTab:Button({
    Title = "🔫 No Recoil",
   Color = Color3.fromRGB(255, 0, 0),

    Justify = "Center",
    IconAlign = "Left",
    Icon = "",
    Callback = function()
        local settings = GetGunSettings()
        if not settings then return end

        settings.Recoil = 0

        WindUI:Notify({
            Title = "Kori Script",
            Content = "No Recoil Enabled",
            Duration = 2,
            Icon = "",
        })
    end
})
UtilitiesTab:Button({
    Title = "🔫 Automatic Gun",
   Color = Color3.fromRGB(255, 0, 0),

    Justify = "Center",
    IconAlign = "Left",
    Icon = "",
    Callback = function()
        local settings = GetGunSettings()
        if not settings then return end

        settings.Auto = true
        
        WindUI:Notify({
            Title = "Kori Script",
            Content = "Automatic Gun Enabled",
            Duration = 2,
            Icon = "",
        })
    end
})
UtilitiesTab:Button({
    Title = "🔫 No Fire Rate",
   Color = Color3.fromRGB(255, 0, 0),

    Justify = "Center",
    IconAlign = "Left",
    Icon = "",
    Callback = function()
        local settings = GetGunSettings()
        if not settings then return end

        settings.FireRate = 0.1
        
        WindUI:Notify({
            Title = "Kori Script",
            Content = "Fire Rate Modified",
            Duration = 2,
            Icon = "",
        })
    end
})
UtilitiesTab:Button({
    Title = "🔫 Inf Damage",
    Color = Color3.fromRGB(255, 0, 0),

    Justify = "Center",
    IconAlign = "Left",
    Icon = "",
    Callback = function()
        local settings = GetGunSettings()
        if not settings then return end

        settings.BaseDamage = 9e9
        
        WindUI:Notify({
            Title = "Kori Script",
            Content = "Infinite Damage Enabled",
            Duration = 2,
            Icon = "",
        })
    end
})
UtilitiesTab:Button({
    Title = "🔫 No Spread",
   Color = Color3.fromRGB(255, 0, 0),

    Justify = "Center",
    IconAlign = "Left",
    Icon = "",
    Callback = function()
        local settings = GetGunSettings()
        if not settings then return end

        if settings.SpreadXY then settings.SpreadXY = 0 end
        if settings.SpreadYX then settings.SpreadYX = 0 end
        if settings.Spread then settings.Spread = 0 end
        settings.SpreadX = 0
        settings.SpreadY = 0
        
        WindUI:Notify({
            Title = "Kori Script",
            Content = "No Spread Enabled",
            Duration = 2,
            Icon = "",
        })
    end
})
UtilitiesTab:Button({
    Title = "🔫 No Jam",
    Color = Color3.fromRGB(255, 0, 0),

    Justify = "Center",
    IconAlign = "Left",
    Icon = "",
    Callback = function()
        local settings = GetGunSettings()
        if not settings then return end

        settings.JamChance = 0
        
        WindUI:Notify({
            Title = "Kori Script",
            Content = "No Jam Enabled",
            Duration = 2,
            Icon = "",
        })
    end
})


local player = game.Players.LocalPlayer
local originalPosition = nil

local function teleport(x, y, z)
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    local root = char:WaitForChild("HumanoidRootPart")

    humanoid:ChangeState(0)
    repeat task.wait() until not player:GetAttribute("LastACPos")
    root.CFrame = CFrame.new(x, y, z)
end
task.spawn(function()
	while task.wait() do
		if getgenv().SwimMethod then
			local p = game:GetService("Players").LocalPlayer
			if p and p.Character and p.Character:FindFirstChild("Humanoid") then
				p.Character.Humanoid:ChangeState(Enum.HumanoidStateType.FallingDown)
			end
		end
	end
end)
AutoFarmTab:Toggle({
    Title = "🗑️ Search Trashbags",
    Desc = "Automatically loot trashbags and sell items",
    Icon = "bird",
    Type = "Checkbox",
    Default = false,
    Callback = function(Value)
        getgenv().loottrash = Value
        getgenv().SwimMethod = Value 

        if Value then

            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                originalPosition = hrp.Position
            end


            task.spawn(function()
                while getgenv().loottrash do
                    pcall(function()
                        local gui = player:WaitForChild("PlayerGui")
                        local pawnGui = gui:FindFirstChild("Bronx PAWNING")
                        if pawnGui then
                            local list = pawnGui.Frame:FindFirstChild("Holder") and pawnGui.Frame.Holder:FindFirstChild("List")
                            if list then
                                for _, frame in ipairs(list:GetChildren()) do
                                    if frame:IsA("Frame") and frame:FindFirstChild("Item") then
                                        local itemName = frame.Item.Text
                                        while player.Backpack:FindFirstChild(itemName) do
                                            game.ReplicatedStorage.PawnRemote:FireServer(itemName)
                                            task.wait(0.05)
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(1)
                end
            end)


            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") and v.Name == "ProximityPrompt" and v.Parent.Name == "DumpsterPromt" then
                    v.HoldDuration = 0
                    v.RequiresLineOfSight = false
                end
            end


            task.spawn(function()
                while getgenv().loottrash do
                    task.wait()
                    for _, v in pairs(workspace:GetDescendants()) do
                        if not getgenv().loottrash then break end
                        if v:IsA("ProximityPrompt") and v.Name == "ProximityPrompt" and v.Parent.Name == "DumpsterPromt" then
                            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                teleport(v.Parent.Position.X, v.Parent.Position.Y, v.Parent.Position.Z + 3)
                            end
                            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, v.Parent.Position)
                            task.wait(0.3)
                            for _ = 1, 10 do fireproximityprompt(v) end
                            task.wait(0.1)
                        end
                    end
                end


                if originalPosition then
                    teleport(originalPosition.X, originalPosition.Y, originalPosition.Z)
                    originalPosition = nil
                end
            end)

        else

            getgenv().loottrash = false
            getgenv().SwimMethod = false
        end
    end
})
local camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

local function RootPart()
    local player = game.Players.LocalPlayer
    if player and player.Character then
        return player.Character:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

local function enableSwimMethod()
    getgenv().SwimMethod = true
    task.wait(1)
end

local function disableSwimMethod()
    getgenv().SwimMethod = false
end

local function fireproximityprompt(prompt)
    if prompt and prompt:IsA("ProximityPrompt") then
        prompt:InputHoldBegin()
        task.wait(prompt.HoldDuration or 0)
        prompt:InputHoldEnd()
    end
end

local function stuidoprompt()
    for _, v in pairs(workspace.StudioPay.Money:GetDescendants()) do
        if v:IsA("ProximityPrompt") and v.Name == "Prompt" then
            v.HoldDuration = 0
            v.RequiresLineOfSight = false
        end
    end
end

local function getOffsetPosition(basePos, distance)
    local angle = math.rad(math.random(0, 359))
    local offsetX = math.cos(angle) * distance
    local offsetZ = math.sin(angle) * distance
    return CFrame.new(basePos.X + offsetX, basePos.Y + 2, basePos.Z + offsetZ)
end

local function TeleportTo(cf)
    local root = RootPart()
    if root then
        root.CFrame = cf
    end
end

local function RobStudioAuto()
    local root = RootPart()
    if not root then return end

    stuidoprompt()
    local prompts = {}
    for _, v in pairs(workspace.StudioPay.Money:GetDescendants()) do
        if v:IsA("ProximityPrompt") and v.Name == "Prompt" and v.Enabled then
            table.insert(prompts, v)
        end
    end

    if #prompts == 0 then
        WindUI:Notify({
            Title = "Studio Robbery",
            Content = "Studio already robbed!",
            Duration = 6.5,
            Icon = "bird", 
        })
        return
    end

    local oldCFrameStudio = root.CFrame

    for _, v in ipairs(prompts) do
        enableSwimMethod()

        local teleportPos = getOffsetPosition(v.Parent.Position, 1)
        TeleportTo(teleportPos)

        local oldCameraType = camera.CameraType
        camera.CameraType = Enum.CameraType.Scriptable

        local promptPos = v.Parent.Position
        local conn
        conn = RunService.RenderStepped:Connect(function()
            camera.CFrame = CFrame.lookAt(camera.CFrame.Position, promptPos)
        end)

        task.wait(0.3)

        repeat
            fireproximityprompt(v)
            task.wait(0.1)
        until not v.Enabled

        conn:Disconnect()
        camera.CameraType = oldCameraType

        disableSwimMethod()
    end

    if oldCFrameStudio then
        TeleportTo(oldCFrameStudio)
    end

    WindUI:Notify({
        Title = "Studio Robbery",
        Content = "No money left.",
        Duration = 6.5,
        Icon = "bird",
    })
end
local Button = AutoFarmTab:Button({
    Title = "StudioRob",
    Desc = "",
    Color = Color3.fromRGB(255, 0, 0),

    Locked = false,
    Callback = function()
        RobStudioAuto()
    end
})

UtilitiesTab:Button({
    Title = " Open FreeCam UI",
    Desc = "Open FreeCam interface",
    Color = Color3.fromRGB(255, 0, 0),
    Justify = "Center",
    IconAlign = "Left",
    Icon = "camera",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/xGw7HSQ8"))()
        WindUI:Notify({
            Title = "FreeCam",
            Content = "FreeCam UI opened",
            Duration = 2,
            Icon = "camera",
        })
    end
})

local function OpenCustomAutoDupeMenu()
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local TweenService = game:GetService("TweenService")
    local LocalPlayer = Players.LocalPlayer

    local AutoDupe = false
    local Cooldown = false
    local dupeTask = nil

    local function StartLoop()
        AutoDupe = true

        local FirstTool = nil
        repeat
            task.wait(0.5)
            FirstTool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
        until FirstTool or not AutoDupe

        if not AutoDupe or not FirstTool then
            AutoDupe = false
            return
        end

        local ToolName = FirstTool.Name

        if dupeTask == nil then
            dupeTask = task.spawn(function()
                while AutoDupe do
                    if not Cooldown then
                        Cooldown = true
                        local ToolId = nil

                        local Connection
                        Connection = ReplicatedStorage.MarketItems.ChildAdded:Connect(function(item)
                            if item.Name == ToolName then
                                local owner = item:WaitForChild("owner", 2)
                                if owner and owner.Value == LocalPlayer.Name then
                                    ToolId = item:GetAttribute("SpecialId")
                                end
                            end
                        end)

                        task.defer(function()
                            pcall(function()
                                ReplicatedStorage.ListWeaponRemote:FireServer(ToolName, 999999)
                            end)
                        end)

                        task.wait(0.23)

                        task.defer(function()
                            pcall(function()
                                ReplicatedStorage.BackpackRemote:InvokeServer("Store", ToolName)
                            end)
                        end)

                        task.wait(2.7)

                        task.defer(function()
                            pcall(function()
                                if ToolId then
                                    ReplicatedStorage.BuyItemRemote:FireServer(ToolName, "Remove", ToolId)
                                end
                            end)
                        end)

                        task.defer(function()
                            pcall(function()
                                ReplicatedStorage.BackpackRemote:InvokeServer("Grab", ToolName)
                            end)
                        end)

                        if Connection then
                            Connection:Disconnect()
                        end

                        Cooldown = false
                    end

                    task.wait(3.5)
                end
            end)
        end
    end

    local function StopLoop()
        AutoDupe = false
        if dupeTask then
            task.cancel(dupeTask)
            dupeTask = nil
        end
        Cooldown = false
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = LocalPlayer.PlayerGui

    local Main = Instance.new("Frame")
    Main.Size = UDim2.fromOffset(315, 195)
    Main.Position = UDim2.fromScale(0.5, 0.5)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundTransparency = 0.2
    Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)

    local BackgroundImage = Instance.new("ImageLabel")
    BackgroundImage.Size = UDim2.new(1, -10, 1, -10)
    BackgroundImage.Position = UDim2.new(0, 5, 0, 5)
    BackgroundImage.BackgroundTransparency = 1
    BackgroundImage.Image = "rbxassetid://94290650012089"
    BackgroundImage.ImageTransparency = 0.3
    BackgroundImage.ScaleType = Enum.ScaleType.Stretch
    BackgroundImage.ZIndex = 1
    Instance.new("UICorner", BackgroundImage).CornerRadius = UDim.new(0, 255)
    BackgroundImage.Parent = Main

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(255, 0, 0)
    Stroke.Thickness = 4
    Stroke.Parent = Main

    local Glow = Instance.new("Frame")
    Glow.Size = UDim2.new(1, 10, 1, 10)
    Glow.Position = UDim2.new(0, -5, 0, -5)
    Glow.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    Glow.BackgroundTransparency = 0.8
    Glow.BorderSizePixel = 0
    Glow.ZIndex = 0
    Instance.new("UICorner", Glow).CornerRadius = UDim.new(0, 23)
    Glow.Parent = Main

    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, -15, 0, 45)
    Header.Position = UDim2.new(0, 8, 0, 8)
    Header.BackgroundTransparency = 1
    Header.ZIndex = 2
    Header.Parent = Main

    local Title = Instance.new("TextLabel")
    Title.Text = "Tets"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextColor3 = Color3.fromRGB(255, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 0, 0, 3)
    Title.Size = UDim2.new(1, 0, 0, 18)
    Title.TextXAlignment = Enum.TextXAlignment.Center
    Title.ZIndex = 2
    Title.Parent = Header

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Text = "THA BRONX 3 • AUTO DUPE"
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.TextSize = 13
    Subtitle.TextColor3 = Color3.fromRGB(255, 0, 0)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Position = UDim2.new(0, 0, 0, 21)
    Subtitle.Size = UDim2.new(1, 0, 0, 15)
    Subtitle.TextXAlignment = Enum.TextXAlignment.Center
    Subtitle.ZIndex = 2
    Subtitle.Parent = Header

    local StatusBox = Instance.new("Frame")
    StatusBox.Size = UDim2.new(1, -15, 0, 41)
    StatusBox.Position = UDim2.new(0, 8, 0, 60)
    StatusBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    StatusBox.ZIndex = 2
    StatusBox.Parent = Main
    Instance.new("UICorner", StatusBox).CornerRadius = UDim.new(0, 14)

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.fromOffset(8, 8)
    Dot.Position = UDim2.new(0, 11, 0.5, -4)
    Dot.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Dot.ZIndex = 2
    Dot.Parent = StatusBox
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

    local StatusText = Instance.new("TextLabel")
    StatusText.Text = "Duplicate"
    StatusText.Font = Enum.Font.Gotham
    StatusText.TextSize = 11
    StatusText.TextColor3 = Color3.fromRGB(255, 0, 0)
    StatusText.BackgroundTransparency = 1
    StatusText.Position = UDim2.new(0, 26, 0, 0)
    StatusText.Size = UDim2.new(1, -68, 1, 0)
    StatusText.TextXAlignment = Enum.TextXAlignment.Left
    StatusText.TextYAlignment = Enum.TextYAlignment.Center
    StatusText.ZIndex = 2
    StatusText.Parent = StatusBox

    local Cash = Instance.new("TextLabel")
    Cash.Text = "‼"
    Cash.Font = Enum.Font.GothamBold
    Cash.TextSize = 18
    Cash.TextColor3 = Color3.fromRGB(255, 0, 0)
    Cash.BackgroundTransparency = 1
    Cash.Size = UDim2.fromOffset(27, 27)
    Cash.Position = UDim2.new(1, -33, 0.5, -14)
    Cash.ZIndex = 2
    Cash.Parent = StatusBox

    local Instructions = Instance.new("TextLabel")
    Instructions.Text = "Hold a tool In your hands, then enable"
    Instructions.Font = Enum.Font.Gotham
    Instructions.TextSize = 13
    Instructions.TextColor3 = Color3.fromRGB(255, 0, 0)
    Instructions.BackgroundTransparency = 1
    Instructions.Position = UDim2.new(0, 8, 0, 109)
    Instructions.Size = UDim2.new(1, -15, 0, 23)
    Instructions.TextXAlignment = Enum.TextXAlignment.Center
    Instructions.TextYAlignment = Enum.TextYAlignment.Center
    Instructions.ZIndex = 2
    Instructions.Parent = Main

    local Generate = Instance.new("TextButton")
    Generate.Size = UDim2.new(1, -15, 0, 42)
    Generate.Position = UDim2.new(0, 8, 1, -51)
    Generate.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Generate.Text = "ON/OFF"
    Generate.Font = Enum.Font.GothamBold
    Generate.TextSize = 15
    Generate.TextColor3 = Color3.fromRGB(255, 0, 0)
    Generate.ZIndex = 2
    Generate.Parent = Main
    Instance.new("UICorner", Generate).CornerRadius = UDim.new(0, 16)

    local GenStroke = Instance.new("UIStroke")
    GenStroke.Color = Color3.fromRGB(0, 0, 0)
    GenStroke.Thickness = 2
    GenStroke.Parent = Generate

    Generate.MouseButton1Click:Connect(function()
        if not AutoDupe then
            Dot.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            StatusText.Text = "STATUS\nDuplicating..."
            Generate.Text = "ON"
            Generate.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            Generate.TextColor3 = Color3.fromRGB(255, 0, 0)
            GenStroke.Enabled = false
            StartLoop()
        else
            Dot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            StatusText.Text = "STATUS\nReady to Run"
            Generate.Text = "OFF"
            Generate.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            Generate.TextColor3 = Color3.fromRGB(255, 0, 0)
            GenStroke.Enabled = true
            StopLoop()
        end
    end)

    local dragging, dragStart, startPos

    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    local BackgroundColor = Color3.fromRGB(0, 0, 0)
    local GlowColor = Color3.fromRGB(255, 0, 0)

    local function makeDraggable(guiElement)
        local dragging2 = false
        local dragStart2, startPos2

        guiElement.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging2 = true
                dragStart2 = input.Position
                startPos2 = guiElement.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging2 = false
                    end
                end)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging2 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart2
                guiElement.Position = UDim2.new(
                    startPos2.X.Scale,
                    startPos2.X.Offset + delta.X,
                    startPos2.Y.Scale,
                    startPos2.Y.Offset + delta.Y
                )
            end
        end)
    end

    local toggleScreenGui = Instance.new("ScreenGui")
    toggleScreenGui.Name = "DupeMenu"
    toggleScreenGui.ResetOnSpawn = false
    toggleScreenGui.Parent = LocalPlayer.PlayerGui

    local toggleButton = Instance.new("ImageButton")
    toggleButton.Size = UDim2.new(0, 70, 0, 70)
    toggleButton.Position = UDim2.new(0, 10, 0, 50)
    toggleButton.Image = "rbxassetid://94290650012089"
    toggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    toggleButton.BackgroundTransparency = 0.2
    toggleButton.ScaleType = Enum.ScaleType.Stretch
    Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 10)

    local toggleStroke = Instance.new("UIStroke", toggleButton)
    toggleStroke.Color = Color3.fromRGB(0, 0, 0)
    toggleStroke.Thickness = 3
    toggleStroke.Transparency = 0.2
    toggleStroke.LineJoinMode = Enum.LineJoinMode.Round

    local toggleGlow = Instance.new("Frame")
    toggleGlow.Size = UDim2.new(1, 8, 1, 8)
    toggleGlow.Position = UDim2.new(0, -4, 0, -4)
    toggleGlow.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    toggleGlow.BackgroundTransparency = 0.7
    toggleGlow.BorderSizePixel = 0
    toggleGlow.ZIndex = -1
    Instance.new("UICorner", toggleGlow).CornerRadius = UDim.new(0, 14)
    toggleGlow.Parent = toggleButton

    toggleButton.Parent = toggleScreenGui
    makeDraggable(toggleButton)

    local tweenInfo = TweenInfo.new(
        1,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut,
        -1,
        true
    )

    local goal = { Transparency = 0.8 }

    local heartbeatTweenToggle = TweenService:Create(toggleStroke, tweenInfo, goal)
    heartbeatTweenToggle:Play()

    toggleButton.MouseButton1Click:Connect(function()
        Main.Visible = not Main.Visible
    end)

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")

    local Player = Players.LocalPlayer
    local Mouse = Player:GetMouse()

    local DEFAULT_ICON = Mouse.Icon

    local function HasTool()
        local char = Player.Character
        return char and char:FindFirstChildOfClass("Tool") ~= nil
    end

    RunService.RenderStepped:Connect(function()
        if HasTool() then
            UserInputService.MouseIconEnabled = true
            Mouse.Icon = DEFAULT_ICON
        end
    end)
end

UtilitiesTab:Button({
    Title = "Auto Dupe Menu",
    Desc = "Open Auto Dupe Interface",
    Color = Color3.fromRGB(255, 0, 0),
    Justify = "Center",
    IconAlign = "Left",
    Icon = "zap",
    Locked = false,
    Callback = function()
        OpenCustomAutoDupeMenu()
        WindUI:Notify({
            Title = "Auto Dupe Menu",
            Content = "Auto Dupe UI opened",
            Duration = 2,
            Icon = "camera",
        })
    end
})

local player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local collecting = false
local function StealMoneyPrompt()
    for _, v in pairs(workspace.Dollas:GetDescendants()) do
        if v:IsA("ProximityPrompt") and v.Name == "ProximityPrompt" then
            v.HoldDuration = 0
            v.RequiresLineOfSight = false
        end
    end
end
local function fireproximityprompt(prompt)
    if prompt and prompt:IsA("ProximityPrompt") then
        prompt:InputHoldBegin()
        task.wait(prompt.HoldDuration or 0)
        prompt:InputHoldEnd()
    end
end
local function collectAndReturn()
    if collecting then return end
    collecting = true

    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then collecting = false return end

    local originalCFrame = hrp.CFrame

    StealMoneyPrompt()

    task.spawn(function()
        local foundAny = false

        for _, v in pairs(workspace.Dollas:GetDescendants()) do
            if v:IsA("ProximityPrompt") and v.Name == "ProximityPrompt" then
                foundAny = true
                StealMoneyPrompt()

                Camera.CFrame = CFrame.new(Camera.CFrame.Position, v.Parent.CFrame.Position)

                local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                if humanoid and hrp then
                    humanoid:ChangeState(0)
                    repeat task.wait() until not player:GetAttribute("LastACPos")
                    hrp.CFrame = v.Parent.CFrame
                end

                task.wait(0.25)
                fireproximityprompt(v)
                task.wait(0.25)
            end
        end

        if not foundAny then
            pcall(function()
                WindUI:Notify({
                    Title = "Pickup Dropped Bread",
                    Content = "No Dropped Money Has Been found!",
                    Duration = 4,
                    Icon = "rocket", 
                })
            end)
        end
        task.wait(0.5)
        if hrp then
            hrp.CFrame = originalCFrame
        end

        collecting = false
    end)
end
local Button = AutoFarmTab:Button({
    Title = "Collect Dropped Cash",
    Desc = "",
    Color = Color3.fromRGB(255, 0, 0),

    Locked = false,
    Callback = function()
        collectAndReturn()
    end
})
