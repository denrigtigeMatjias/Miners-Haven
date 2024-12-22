if game.PlaceId == 258258996 then
    return
else
    while wait(10000) do end
end

-- https://denrigtigematjias.github.io/
local url = "https://render-mzyi.onrender.com/increment/MinersHaven"

local response = request({
    Url = url,
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/json",
    },
    Body = game:GetService("HttpService"):JSONEncode({
        game = "MinersHaven"
    })
})

if response.Success then
    print("Increment successful! Response:", response.Body)
else
    print("Failed to increment count. Error:", response.StatusCode)
end

-- Script
-- Load Libraries
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/denrigtigeMatjias/FluentBackup/refs/heads/main/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/denrigtigeMatjias/FluentBackup/refs/heads/main/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/denrigtigeMatjias/FluentBackup/refs/heads/main/InterfaceManager.lua"))()

-- Initialize the Window
getgenv().version = "v1.0"

local Window = Fluent:CreateWindow({
    Title = "Miners Haven " .. getgenv().version,
    SubTitle = "by .matjias",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
})

-- Define Tabs
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "align-justify" }),
    LocalPlayer = Window:AddTab({ Title = "LocalPlayer", Icon = "user" }),
    Auto = Window:AddTab({ Title = "Auto", Icon = "refresh-cw" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "map-pin" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "folder-open" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}

do
    -- Main Tab Content
    Tabs.Main:AddParagraph({
        Title = "Welcome to Miners Haven Gui!",
        Content = "Script created by: .matjias.\nVersion: " .. getgenv().version,
    })

    Tabs.Main:AddParagraph({
        Title = "Credits",
        Content = "Script Creator: .matjias\nUI Library: Fluent by dawid",
    })

    Tabs.Main:AddParagraph({
        Title = "Update Logs",
        Content = [[v1.0:
    - Initial release
    - discord.gg/minershavenscript]],
    })

    -- Variables
    getgenv().ServerHop = false
    getgenv().CrateAutofarm = false

    -- Local Player Tab
    -- Variables for toggles and settings
    local walkSpeed = 16 -- Default walk speed
    local jumpPower = 50 -- Default jump power
    local isNoClipEnabled = false

    -- Get the player's humanoid
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    -- WalkSpeed Toggle and Slider
    Tabs.LocalPlayer:AddToggle("WalkSpeedToggle", {
        Title = "Enable Walk Speed",
        Default = false,
        Callback = function(Value)
            walkSpeedEnabled = Value
            if not walkSpeedEnabled then
                humanoid.WalkSpeed = 16 -- Reset to default walk speed
            else
                humanoid.WalkSpeed = walkSpeed -- Apply custom walk speed
            end
        end,
    })

    Tabs.LocalPlayer:AddSlider("WalkSpeedSlider", {
        Title = "Walk Speed",
        Min = 16, -- Default Roblox walk speed
        Max = 100,
        Default = walkSpeed,
        Rounding = 1,
        Callback = function(Value)
            walkSpeed = Value
            if walkSpeedEnabled then
                humanoid.WalkSpeed = walkSpeed
            end
        end,
    })

    -- JumpPower Slider and Toggle
    local jumpPowerEnabled = false
    Tabs.LocalPlayer:AddToggle("JumpPowerToggle", {
        Title = "Enable Jump Power",
        Default = false,
        Callback = function(Value)
            jumpPowerEnabled = Value
            if not jumpPowerEnabled then
                humanoid.JumpPower = 50 -- Reset to default jump power
            else
                humanoid.JumpPower = jumpPower -- Apply custom jump power
            end
        end,
    })

    Tabs.LocalPlayer:AddSlider("JumpPowerSlider", {
        Title = "Jump Power",
        Min = 50, -- Default Roblox jump power
        Max = 300,
        Default = jumpPower,
        Rounding = 1,
        Callback = function(Value)
            jumpPower = Value
            if jumpPowerEnabled then
                humanoid.JumpPower = jumpPower
            end
        end,
    })

    -- Variables for fly
    local flying = false
    local flySpeed = 50 -- Default flight speed
    local bodyGyro, bodyVelocity
    local flyConnection

    -- Flight Toggle
    Tabs.LocalPlayer:AddToggle("FlyToggle", {
        Title = "Enable Fly",
        Default = false,
        Callback = function(Value)
            flying = Value

            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            if flying then
                -- Create BodyGyro and BodyVelocity
                bodyGyro = Instance.new("BodyGyro")
                bodyGyro.P = 9e4
                bodyGyro.MaxTorque = Vector3.new(9e4, 9e4, 9e4)
                bodyGyro.CFrame = humanoidRootPart.CFrame
                bodyGyro.Parent = humanoidRootPart

                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(1e4, 1e4, 1e4)
                bodyVelocity.Velocity = Vector3.zero
                bodyVelocity.Parent = humanoidRootPart

                -- Control flying with user input
                local userInputService = game:GetService("UserInputService")
                local camera = workspace.CurrentCamera

                flyConnection = game:GetService("RunService").RenderStepped:Connect(function()
                    local direction = Vector3.zero
                    if userInputService:IsKeyDown(Enum.KeyCode.W) then
                        direction += camera.CFrame.LookVector
                    end
                    if userInputService:IsKeyDown(Enum.KeyCode.S) then
                        direction -= camera.CFrame.LookVector
                    end
                    if userInputService:IsKeyDown(Enum.KeyCode.A) then
                        direction -= camera.CFrame.RightVector
                    end
                    if userInputService:IsKeyDown(Enum.KeyCode.D) then
                        direction += camera.CFrame.RightVector
                    end
                    if userInputService:IsKeyDown(Enum.KeyCode.Space) then
                        direction += Vector3.new(0, 1, 0)
                    end
                    if userInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        direction -= Vector3.new(0, 1, 0)
                    end
                    if userInputService:IsKeyDown(Enum.KeyCode.E) then
                        direction += Vector3.new(0, 1, 0)
                    end
                    if userInputService:IsKeyDown(Enum.KeyCode.Q) then
                        direction -= Vector3.new(0, 1, 0)
                    end

                    -- Normalize the direction and apply speed
                    if direction.Magnitude > 0 then
                        direction = direction.Unit * flySpeed
                    end
                    bodyVelocity.Velocity = direction
                    bodyGyro.CFrame = camera.CFrame
                end)
            else
                -- Cleanup when fly is disabled
                if bodyGyro then
                    bodyGyro:Destroy()
                    bodyGyro = nil
                end
                if bodyVelocity then
                    bodyVelocity:Destroy()
                    bodyVelocity = nil
                end
                if flyConnection then
                    flyConnection:Disconnect()
                    flyConnection = nil
                end
            end
        end,
    })

    -- Flight Speed Slider
    Tabs.LocalPlayer:AddSlider("FlightSpeedSlider", {
        Title = "Flight Speed",
        Description = "Adjust the flight speed",
        Default = 50, -- Default speed
        Min = 10, -- Minimum speed
        Max = 200, -- Maximum speed
        Rounding = 0, -- No rounding
        Callback = function(Value)
            flySpeed = Value -- Update fly speed dynamically
        end,
    })

    -- NoClip Toggle
    Tabs.LocalPlayer:AddToggle("NoClipToggle", {
        Title = "Enable NoClip",
        Default = false,
        Callback = function(Value)
            isNoClipEnabled = Value
            local connection
            connection = game:GetService("RunService").Stepped:Connect(function()
                if not isNoClipEnabled then
                    connection:Disconnect()
                else
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end,
    })

    -- Auto Tab: Crate Autofarm Section
    local AutofarmSettingsSection = Tabs.Auto:AddSection("Autofarm Settings")

    -- Conveyor Speed Slider
    local conveyorSpeed = nil -- Default conveyor speed
    local player = game:GetService("Players").LocalPlayer

    local function findPlayerFactory()
        for _, tycoon in pairs(game:GetService("Workspace").Tycoons:GetChildren()) do
            local playerNameValue = tycoon:FindFirstChildOfClass("StringValue")
            if playerNameValue and playerNameValue.Value == player.Name then
                return tycoon
            end
        end
        return nil
    end

    if findPlayerFactory() then
        conveyorSpeed = findPlayerFactory().AdjustSpeed.Value
    else
        conveyorSpeed = 1
    end

    AutofarmSettingsSection:AddSlider("ConveyorSpeedSlider", {
        Title = "Conveyor Speed",
        Description = "Adjust the speed of the conveyor",
        Default = conveyorSpeed, -- Default speed
        Min = 0.1, -- Minimum speed
        Max = 100, -- Maximum speed
        Rounding = 1, -- Rounding for 1 decimal
        Callback = function(Value)
            conveyorSpeed = Value -- Update conveyor speed
            -- Assuming `Workspace.Tycoons.Factory.AdjustSpeed` is the conveyor speed setting
            local factory = findPlayerFactory()
            if factory then
                local adjustSpeed = factory:FindFirstChild("AdjustSpeed")
                if adjustSpeed and adjustSpeed:IsA("NumberValue") then
                    adjustSpeed.Value = conveyorSpeed
                else
                    Fluent:Notify({
                        Title = "Error",
                        Content = "Could not find AdjustSpeed in factory!",
                        Duration = 3,
                    })
                end
            else
                Fluent:Notify({
                    Title = "Error",
                    Content = "Factory not found!",
                    Duration = 3,
                })
            end
        end,
    })

    -- Initialize variables
    local furnaces = {}  -- This will store the furnace data

    -- Function to get furnaces
    local function getFurnaces()
        local factory = findPlayerFactory()  -- Find the player's factory
        if factory then
            for _, child in pairs(factory:GetDescendants()) do
                if child:IsA("Model") and child.Model:FindFirstChild("Lava") then
                    print(child:GetFullName())
                    table.insert(furnaces, {
                        Name = child.Name,
                        FurnaceModel = child,
                        LavaPosition = child.Model:FindFirstChild("Lava").Position
                    })
                end
            end
        else
            print("Factory not found for the player.")
        end
    end

    -- Fetch the furnaces initially
    getFurnaces()

    -- Create the dropdown for furnaces
    local dropdownValuesFurnace = {}
    for _, furnace in ipairs(furnaces) do
        table.insert(dropdownValuesFurnace, furnace.Name)
    end

    local selectedFurnace = nil

    local FurnaceDropdown = AutofarmSettingsSection:AddDropdown("FurnaceDropdown", {
        Title = "Furnace To Teleport Ores To",
        Values = dropdownValuesFurnace,
        Multi = false,
        Default = 1,
    })

    FurnaceDropdown:OnChanged(function(Value)
        -- When the dropdown selection changes, find the selected furnace
        for _, furnace in ipairs(furnaces) do
            if furnace.Name == Value then
                selectedFurnace = furnace
                break
            end
        end
    end)

    -- Initialize the teleportation toggle and a variable to track the teleport status
    local teleportingEnabled = false

    -- Create the toggle button for enabling/disabling teleportation
    AutofarmSettingsSection:AddToggle("TeleportToFurnaceToggle", {
        Title = "Toggle Ore Teleportation",
        Default = false,  -- Initially set to false (disabled)
        Callback = function(Value)
            teleportingEnabled = Value  -- Update the teleport status based on toggle
        end
    })

    -- Function to teleport dropped parts to the selected furnace's lava position with a Y offset of 5
    local function teleportDroppedPartsToFurnace()
        local droppedParts = game:GetService("Workspace").DroppedParts:FindFirstChild(findPlayerFactory().Name)
        if droppedParts then
            -- Iterate over each child (dropped part) in the factory's dropped parts folder
            for _, part in ipairs(droppedParts:GetChildren()) do
                -- Check if the part is a valid model to teleport
                if part:IsA("Part") then
                    -- Check if a furnace is selected
                    if selectedFurnace then
                        local furnaceLavaPosition = selectedFurnace.LavaPosition
                        -- Teleport the part to the furnace's lava position with a Y offset of 5
                        part.CFrame = CFrame.new(furnaceLavaPosition.X, furnaceLavaPosition.Y + 5, furnaceLavaPosition.Z)
                    end
                end
            end
        end
    end

    -- Continuously monitor for dropped parts and teleport if needed
    task.spawn(function()
        while true do
            -- Only teleport if the toggle is enabled
            if teleportingEnabled then
                teleportDroppedPartsToFurnace()  -- Teleport dropped parts to the furnace
            end
            task.wait(0.1)  -- Wait for 1 second before checking again (adjust as needed)
        end
    end)

    -- Auto Tab: Crate Autofarm Section
    local AutofarmSection = Tabs.Auto:AddSection("Autofarm")

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    local proximityRadius = 14 -- Radius within which to fire the proximity prompt
    local fireInterval = 0.5 -- Default wait time between firing proximity prompt
    local radiusVisualization = nil

    -- Store proximity items with ItemType 1
    local proximityItems = {}

    local function getProximityItems()
        local factory = findPlayerFactory()
        if factory then
            for _, child in pairs(factory:GetDescendants()) do
                if child:IsA("ProximityPrompt") then
                    local itemTypeParent = child.Parent.Parent.Parent
                    if itemTypeParent and itemTypeParent:FindFirstChild("ItemType") then
                        local itemType = itemTypeParent.ItemType.Value
                        if itemType == 1 then
                            table.insert(proximityItems, {
                                Name = itemTypeParent.Name,
                                Position = child.Parent.Position,
                                ProximityPrompt = child
                            })
                        end
                    end
                end
            end
        else
            print("Factory not found for the player.")
        end
    end

    getProximityItems()
    
    -- Create the dropdown for proximity items
    local dropdownValues = {}
    for _, item in ipairs(proximityItems) do
        table.insert(dropdownValues, item.Name)
    end

    local selectedItem = nil

    local isTeleporting = false

    -- Function to create a static circle visualization at the proximity item's position
    local function createRadiusVisualization()
        if radiusVisualization then
            radiusVisualization:Destroy()
        end
        if selectedItem then
            radiusVisualization = Instance.new("Part")
            radiusVisualization.Size = Vector3.new(proximityRadius * 2, proximityRadius * 2, proximityRadius * 2) -- Corrected size
            radiusVisualization.Anchored = true
            radiusVisualization.CanCollide = false
            radiusVisualization.Material = Enum.Material.ForceField
            radiusVisualization.Shape = Enum.PartType.Cylinder
            radiusVisualization.CFrame = CFrame.new(selectedItem.Position) * CFrame.Angles(0, 0, math.rad(90)) -- Corrected rotation
            radiusVisualization.Color = Color3.new(1, 0, 0)
            radiusVisualization.Transparency = 0.5
            radiusVisualization.Parent = game:GetService("Workspace")
        end
    end

    -- Function to remove the visualization
    local function removeRadiusVisualization()
        if radiusVisualization then
            radiusVisualization:Destroy()
            radiusVisualization = nil
        end
    end

    local ProximityDropdown = AutofarmSection:AddDropdown("ProximityItemDropdown", {
        Title = "Select Proximity Mine",
        Values = dropdownValues,
        Multi = false,
        Default = 1,
    })

    ProximityDropdown:OnChanged(function(Value)
        for _, item in ipairs(proximityItems) do
            if item.Name == Value then
                selectedItem = item
                break
            end
        end
        if radiusVisualization then
            createRadiusVisualization()
        end
    end)

    AutofarmSection:AddToggle("TeleportToggle", {
        Title = "Fire Proximity Mine",
        Default = false,
        Callback = function(Value)
            isTeleporting = Value
            if isTeleporting then
                createRadiusVisualization()
            else
                removeRadiusVisualization()
            end
        end,
    })

    -- Slider to adjust fire delay
    AutofarmSection:AddSlider("FireDelaySlider", {
        Title = "Fire Delay",
        Description = "Set delay between firing prompts",
        Default = 0.5,
        Min = 0.1,
        Max = 5,
        Rounding = 2,
        Callback = function(Value)
            fireInterval = Value
        end,
    })

    -- Continuously check distance and fire proximity prompt
    task.spawn(function()
        while true do
            if selectedItem and isTeleporting then
                local playerPosition = character:WaitForChild("HumanoidRootPart").Position
                local distance = (playerPosition - selectedItem.Position).Magnitude

                -- Check if player is outside radius and teleport if necessary
                if distance > (proximityRadius - 1.5) then
                    character.HumanoidRootPart.CFrame = CFrame.new(selectedItem.Position)
                end

                -- Fire the proximity prompt if within the radius
                if distance <= (proximityRadius - 1.5) then
                    fireproximityprompt(selectedItem.ProximityPrompt)
                    task.wait(fireInterval) -- Wait the specified time before firing again
                end
            end
            wait(0.01)
        end
    end)

    local teleportEnabled = false
    local upgradeParts = {}

    -- Function to check for upgrades and store their positions
    local function checkForUpgrades(factory)
        upgradeParts = {}
        for _, child in ipairs(factory:GetChildren()) do
            if child:IsA("Model") and child.Model:FindFirstChild("Upgrade") then
                table.insert(upgradeParts, child.Model.Upgrade.Position) -- Store position of Upgrade parts
            end
        end
        print("Upgrade parts found: " .. #upgradeParts)
    end

    -- Function to teleport parts through upgrades
    local function processDroppedPart(part)
        if not teleportEnabled or not part:IsA("Part") then return end

        -- Iterate through all upgrader positions
        for _, upgradePos in ipairs(upgradeParts) do
            if not teleportEnabled then return end -- Stop processing if toggled off
            part.CFrame = CFrame.new(upgradePos) + Vector3.new(0, 0, 0) -- Teleport slightly above upgrader
            task.wait(0.01) -- Shorter delay for smoother transitions
        end

        -- Teleport to the furnace
        if selectedFurnace and selectedFurnace:IsA("Model") and selectedFurnace.Model:FindFirstChild("Lava") then
            local dropPoint = selectedFurnace.DropInPoint.Position
            part.CFrame = CFrame.new(dropPoint)
            print(part.Name .. " sent to furnace: " .. selectedFurnace.Name)
        end
    end

    -- Monitor dropped parts
    task.spawn(function()
        local playerFactory = findPlayerFactory()
        if playerFactory then
            local droppedParts = game:GetService("Workspace").DroppedParts[playerFactory.Name]
            droppedParts.ChildAdded:Connect(function(child)
                if child:IsA("Part") then
                    print("Dropped part detected: " .. child.Name)
                    processDroppedPart(child)
                end
            end)
        else
            print("Player factory not found.")
        end
    end)

    -- Add toggle to your UI
    AutofarmSection:AddToggle("OreBoost", { 
        Title = "Oreboost", 
        Default = false,
        Callback = function(Value)
            teleportEnabled = Value
            if teleportEnabled then
                print("Oreboost enabled.")
                local factory = findPlayerFactory()
                if factory then
                    checkForUpgrades(factory) -- Refresh upgrade positions
                    selectedFurnace = factory:FindFirstChild("SelectedFurnace") -- Replace with your furnace name
                    if not selectedFurnace then
                        print("Selected furnace not found!")
                    end
                else
                    print("Factory not found!")
                end
            else
                print("Oreboost disabled.")
            end
        end,
    })

    -- Auto Tab: Crate Autofarm Section
    local CrateSection = Tabs.Auto:AddSection("Crate Autofarm")

    -- Server Hop Toggle
    CrateSection:AddToggle("ServerHopToggle", {
        Title = "Enable Server Hop",
        Default = getgenv().ServerHop,
        Callback = function(Value)
            getgenv().ServerHop = Value
            Fluent:Notify({
                Title = "Server Hop Updated",
                Content = Value and "Server Hop Enabled" or "Server Hop Disabled",
                Duration = 5,
            })
        end,
    })

    -- Crate Autofarm Toggle
    CrateSection:AddToggle("CrateAutofarmToggle", {
        Title = "Crate Autofarm",
        Default = false,
        Callback = function(Value)
            getgenv().CrateAutofarm = Value
            if Value then
                Fluent:Notify({
                    Title = "Crate Autofarm Started",
                    Content = "Autofarming process has begun.",
                    Duration = 5,
                })

                -- Start the autofarming loop
                task.spawn(function()
                    while getgenv().CrateAutofarm do
                        local player = game:GetService("Players").LocalPlayer
                        local ReplicatedStorage = game:GetService("ReplicatedStorage")
                        local TeleportService = game:GetService("TeleportService")
                        local Workspace = game:GetService("Workspace")
                        local gameId = 258258996 -- Replace with your game ID

                        -- Load Player Data
                        pcall(function()
                            ReplicatedStorage.QuickLoad:InvokeServer(2)
                            task.wait(0.5)
                            ReplicatedStorage.LoadPlayerData:InvokeServer(2)
                        end)

                        -- Teleport to Crates
                        local targetFolder = Workspace:FindFirstChild("Boxes")
                        if targetFolder then
                            for _, crate in ipairs(targetFolder:GetChildren()) do
                                if not getgenv().CrateAutofarm then break end
                                if crate:IsA("BasePart") then
                                    -- Temporarily disable collision for the local player
                                    local originalCanCollide = crate.CanCollide
                                    crate.CanCollide = false

                                    player.Character:MoveTo(crate.Position)
                                    task.wait(1)

                                    -- Restore original CanCollide state
                                    crate.CanCollide = originalCanCollide
                                end
                            end
                        end

                        -- Server Hop if Enabled
                        if getgenv().ServerHop then
                            pcall(function()
                                TeleportService:Teleport(gameId, player)
                            end)
                        end

                        -- Break autofarming if the toggle is turned off
                        if not getgenv().CrateAutofarm then break end
                    end
                end)
            else
                Fluent:Notify({
                    Title = "Crate Autofarm Stopped",
                    Content = "Autofarming process has been stopped.",
                    Duration = 5,
                })
            end
        end,
    })

    -- Teleport Tab
    local teleportAreaLocations = {
        ["Plot 1"] = game:GetService("Workspace").Tycoons.Factory1.Base.Position,
        ["Plot 2"] = game:GetService("Workspace").Tycoons.Factory2.Base.Position,
        ["Plot 3"] = game:GetService("Workspace").Tycoons.Factory3.Base.Position,
        ["Plot 4"] = game:GetService("Workspace").Tycoons.Factory4.Base.Position,
        ["Plot 5"] = game:GetService("Workspace").Tycoons.Factory5.Base.Position,
        ["Plot 6"] = game:GetService("Workspace").Tycoons.Factory6.Base.Position,
    }
    
    local PlotTeleport = Tabs.Teleport:AddDropdown("Plot Teleport", {
        Title = "Teleport to Plots",
        Values = {"Plot 1", "Plot 2", "Plot 3", "Plot 4", "Plot 5", "Plot 6"},
        Multi = false,
        Default = 1,
    })

    local previousSelection = "Plot 1"  -- Variable to store the previous selection

    PlotTeleport:OnChanged(function(Value)
        -- Only trigger teleport if the selection has actually changed
        if Value ~= previousSelection then
            print("Dropdown changed to:", Value)
            previousSelection = Value  -- Update previous selection

            local targetPosition = teleportAreaLocations[Value]
            if targetPosition then
                local player = game.Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

                -- Teleport the player to the target position
                humanoidRootPart.CFrame = CFrame.new(targetPosition)

                Fluent:Notify({
                    Title = "Miners Haven Autofarm",
                    Content = "Teleported to: " .. tostring(Value),
                    Duration = 5,
                })
            else
                Fluent:Notify({
                    Title = "Miners Haven Autofarm",
                    Content = "No teleport location found for: " .. tostring(Value),
                    Duration = 5,
                })
            end
        end
    end)

    Tabs.Teleport:AddButton({
        Title = "Teleport to your base",
        Description = "Teleports you to your base",
        Callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
    
            local tycoon = nil
            -- Iterate over the children of the Tycoons model
            for _, tycoon in pairs(game:GetService("Workspace").Tycoons:GetChildren()) do
                -- Check if the tycoon has a StringValue with the player's name
                local playerNameValue = tycoon:FindFirstChildOfClass("StringValue")
                if playerNameValue and playerNameValue.Value == player.Name then
                    -- If found, teleport to the Base position of that tycoon
                    local targetPosition = tycoon.Base.Position
                    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
                    -- Teleport the player to the target position
                    humanoidRootPart.CFrame = CFrame.new(targetPosition)
    
                    Fluent:Notify({
                        Title = "Miners Haven Autofarm",
                        Content = "Teleported to your base!",
                        Duration = 5,
                    })
    
                    return
                end
            end
            
            -- If no tycoon was found for the player
            Fluent:Notify({
                Title = "Miners Haven Autofarm",
                Content = "No base found for you!",
                Duration = 5,
            })
        end
    })

    -- Misc Tab
    local MiscSection = Tabs.Misc:AddSection("Quality of Life")

    -- Pulse button
    MiscSection:AddButton({
        Title = "Pulse ores",
        Description = "Needs to have a pulsar placed",
        Callback = function()
            game:GetService("ReplicatedStorage").Pulse:FireServer()
        end
    })

    local pulseEnabled = false
    Tabs.Misc:AddToggle("PulseToggle", {
        Title = "Auto Pulse after Delay",
        Default = false,
        Callback = function(Value)
            pulseEnabled = Value
        end,
    })

    local pulseDelay = nil;
    Tabs.Misc:AddSlider("WalkSpeedSlider", {
        Title = "Pulse Delay",
        Min = 32, -- Default Roblox walk speed
        Max = 600,
        Default = 300,
        Rounding = 1,
        Callback = function(Value)
            pulseDelay = Value
        end,
    })
    
    task.spawn(function()
        while true do
            if pulseEnabled then
                game:GetService("ReplicatedStorage").Pulse:FireServer()

                wait(pulseDelay)
            end
            task.wait(0.1)
        end
    end)

    -- Function to refresh proximity items
    local function refreshProximityItems()
        proximityItems = {} -- Clear existing items

        getProximityItems() -- Re-fetch items

        -- Use a dictionary to avoid duplicates
        local uniqueItems = {}
        local newDropdownValues = {}

        for _, item in ipairs(proximityItems) do
            if not uniqueItems[item.Name] then
                uniqueItems[item.Name] = true
                table.insert(newDropdownValues, item.Name)
            end
            wait(0.01)
        end

        ProximityDropdown:SetValues(newDropdownValues) -- Update the dropdown

        Fluent:Notify({
            Title = "Proximity Mines Updated",
            Content = "The dropdown has been refreshed.",
            Duration = 3,
        })
    end

    local function refreshFurnaces()
        furnaces = {}  -- Clear existing furnaces
        getFurnaces()  -- Re-fetch the furnaces

        local uniqueFurnaces = {}
        local newDropdownValues = {}

        for _, furnace in ipairs(furnaces) do
            if not uniqueFurnaces[furnace.Name] then
                uniqueFurnaces[furnace.Name] = true
                table.insert(newDropdownValues, furnace.Name)
            end
        end

        FurnaceDropdown:SetValues(newDropdownValues)

        Fluent:Notify({
            Title = "Furnaces Updated",
            Content = "The dropdown has been refreshed.",
            Duration = 3,
        })
    end

    -- Monitor workspace for new items
    task.spawn(function()
        local factory = findPlayerFactory()
        if factory then
            factory.ChildAdded:Connect(function(child)
                task.wait(0.5) -- Small delay to ensure the item is fully loaded
                if child:IsA("Model") and child.Model.Internal:FindFirstChild("ProximityPrompt") then
                    refreshProximityItems()
                elseif child:IsA("Model") and child.Model:FindFirstChild("Lava") then
                    refreshFurnaces()   -- Refresh furnaces when a new furnace is added
                end
            end)

            factory.ChildRemoved:Connect(function(child)
                task.wait(0.5) -- Small delay to ensure changes are reflected
                refreshProximityItems()
                refreshFurnaces()       -- Refresh furnaces when an item is removed
            end)
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Factory not found for the player. Cannot monitor items.",
                Duration = 5,
            })
        end
    end)
end

-- Settings Tab
InterfaceManager:SetLibrary(Fluent)
SaveManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
InterfaceManager:SetFolder("MinersHaven")
SaveManager:SetFolder("MinersHaven/Configs")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Finalize
Window:SelectTab(1)
Fluent:Notify({
    Title = "Miners Haven Autofarm",
    Content = "Script Loaded Successfully!",
    Duration = 5,
})
