-- =========================================================
-- FULL HUB: Alpha Studio (KeySystem + Discord + Freecam + Silent Aim)
-- =========================================================

-- Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Alpha Studio",
    LoadingTitle = "Alpha Studio",
    LoadingSubtitle = "Im The Best Dev",
    ShowText = "Alpha Studio",
    Theme = "Default",
    ToggleUIKeybind = "K",

    -- Key system (enable and set keys)
    KeySystem = true,
    KeySettings = {
        Title = "Alpha Studio Key",
        Subtitle = "Key Is Somo",
        Note = "Get the key from the developer",
        FileName = "AlphaStudio_Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"Somo"} -- <-- REPLACE this with your real key(s)
    },

    -- Discord join
    Discord = {
        Enabled = true,
        Invite = "YOUR_INVITE_CODE", -- <-- REPLACE this with your discord invite code (no discord.gg/)
        RememberJoins = true
    }
})

-- Services & locals
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- -------------------------
-- PLAYER TAB
-- -------------------------
local PlayerTab = Window:CreateTab("Player", 4483362458)

local WalkSpeedToggle = false
local WalkSpeedValue = 16
local JumpPowerToggle = false
local JumpPowerValue = 50
local NoClipEnabled = false

PlayerTab:CreateToggle({
    Name = "WalkSpeed Toggle",
    CurrentValue = false,
    Flag = "WalkSpeedToggle",
    Callback = function(v) WalkSpeedToggle = v end
})
PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16,300},
    Increment = 1,
    CurrentValue = WalkSpeedValue,
    Flag = "WalkSpeedSlider",
    Callback = function(v) WalkSpeedValue = v end
})

PlayerTab:CreateToggle({
    Name = "JumpPower Toggle",
    CurrentValue = false,
    Flag = "JumpPowerToggle",
    Callback = function(v) JumpPowerToggle = v end
})
PlayerTab:CreateSlider({
    Name = "JumpPower",
    Range = {50,400},
    Increment = 1,
    CurrentValue = JumpPowerValue,
    Flag = "JumpPowerSlider",
    Callback = function(v) JumpPowerValue = v end
})

PlayerTab:CreateToggle({
    Name = "NoClip (Walk Through Walls)",
    CurrentValue = false,
    Flag = "NoClipToggle",
    Callback = function(v) NoClipEnabled = v end
})

-- Robust NoClip helper
local function applyCanCollideToCharacter(char, value)
    if not char then return end
    for _, obj in pairs(char:GetDescendants()) do
        if obj:IsA("BasePart") then
            pcall(function() obj.CanCollide = value end)
        elseif obj:IsA("Accessory") then
            local handle = obj:FindFirstChild("Handle")
            if handle and handle:IsA("BasePart") then
                pcall(function() handle.CanCollide = value end)
            end
        end
    end
end

-- Ensure movement values apply and NoClip persists
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if WalkSpeedToggle then hum.WalkSpeed = WalkSpeedValue else hum.WalkSpeed = 16 end
            if JumpPowerToggle then pcall(function() hum.UseJumpPower = true hum.JumpPower = JumpPowerValue end) else pcall(function() hum.JumpPower = 50 end) end
            pcall(function() hum.PlatformStand = false end)
        end

        if NoClipEnabled then
            applyCanCollideToCharacter(char, false)
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.15)
    if NoClipEnabled then applyCanCollideToCharacter(char, false) end
    if WalkSpeedToggle or JumpPowerToggle then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if WalkSpeedToggle then hum.WalkSpeed = WalkSpeedValue end
            if JumpPowerToggle then pcall(function() hum.UseJumpPower = true hum.JumpPower = JumpPowerValue end) end
        end
    end
end)

-- -------------------------
-- ESP TAB
-- -------------------------
local EspTab = Window:CreateTab("ESP", 4483362458)

local EspEnabled = false
local NameEsp = false
local HealthEsp = false
local WeaponEsp = false
local BoxEsp = false

EspTab:CreateToggle({Name="Enable ESP (all)", CurrentValue=false, Flag="EnableESP", Callback=function(v)
    EspEnabled = v
    NameEsp = v
    HealthEsp = v
    WeaponEsp = v
    BoxEsp = v
end})
EspTab:CreateToggle({Name="Name ESP", CurrentValue=false, Flag="NameESP", Callback=function(v) NameEsp = v end})
EspTab:CreateToggle({Name="Health Bar ESP", CurrentValue=false, Flag="HealthESP", Callback=function(v) HealthEsp = v end})
EspTab:CreateToggle({Name="Weapon ESP", CurrentValue=false, Flag="WeaponESP", Callback=function(v) WeaponEsp = v end})
EspTab:CreateToggle({Name="Box ESP", CurrentValue=false, Flag="BoxESP", Callback=function(v) BoxEsp = v end})

local Boxes = {}

local function createBillboardGuiFor(player)
    local bb = Instance.new("BillboardGui")
    bb.Name = "ESP_GUI"
    bb.Size = UDim2.new(0,220,0,60)
    bb.AlwaysOnTop = true
    bb.StudsOffset = Vector3.new(0,2,0)

    -- Name (white, small)
    local nameLabel = Instance.new("TextLabel", bb)
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1,0,0,12)
    nameLabel.Position = UDim2.new(0,0,0,0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255,255,255)
    nameLabel.TextScaled = false
    nameLabel.TextSize = 11
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.Text = player.Name

    -- Weapon (yellow, small)
    local weaponLabel = Instance.new("TextLabel", bb)
    weaponLabel.Name = "WeaponLabel"
    weaponLabel.Position = UDim2.new(0,0,0,14)
    weaponLabel.Size = UDim2.new(1,0,0,18)
    weaponLabel.BackgroundTransparency = 1
    weaponLabel.TextColor3 = Color3.fromRGB(255,210,0)
    weaponLabel.TextScaled = false
    weaponLabel.TextSize = 11
    weaponLabel.Font = Enum.Font.SourceSans
    weaponLabel.Text = ""

    -- Health bar
    local hbBack = Instance.new("Frame", bb)
    hbBack.Name = "HealthBack"
    hbBack.Position = UDim2.new(0.5, -25, 1, -6)
    hbBack.Size = UDim2.new(0,50,0,5)
    hbBack.BackgroundColor3 = Color3.fromRGB(50,50,50)
    hbBack.BorderSizePixel = 0

    local hb = Instance.new("Frame", hbBack)
    hb.Name = "HealthBar"
    hb.Size = UDim2.new(1,0,1,0)
    hb.BackgroundColor3 = Color3.fromRGB(0,255,0)
    hb.BorderSizePixel = 0

    return bb
end

local function CreateESP(player)
    if not player or player == LocalPlayer then return end
    if not player.Character then return end
    local head = player.Character:FindFirstChild("Head")
    if not head then return end
    if head:FindFirstChild("ESP_GUI") then return end
    local gui = createBillboardGuiFor(player)
    gui.Parent = head
end

local function UpdateESP(player)
    if not player or not player.Character then return end
    local head = player.Character:FindFirstChild("Head")
    if not head then return end
    local gui = head:FindFirstChild("ESP_GUI")
    if not gui then return end

    local hum = player.Character:FindFirstChildOfClass("Humanoid")

    if gui:FindFirstChild("NameLabel") then
        gui.NameLabel.Visible = NameEsp
        gui.NameLabel.Text = player.Name
    end

    if gui:FindFirstChild("HealthBack") and gui.HealthBack:FindFirstChild("HealthBar") then
        if HealthEsp and hum then
            local percent = math.clamp(hum.Health / (hum.MaxHealth ~= 0 and hum.MaxHealth or 100), 0, 1)
            gui.HealthBack.Visible = true
            gui.HealthBack.HealthBar.Size = UDim2.new(percent, 0, 1, 0)
            gui.HealthBack.HealthBar.BackgroundColor3 = Color3.fromRGB(math.floor((1-percent)*255), math.floor(percent*255), 0)
        else
            gui.HealthBack.Visible = false
        end
    end

    if gui:FindFirstChild("WeaponLabel") then
        if WeaponEsp then
            local weapons = {}
            if player:FindFirstChild("Backpack") then
                for _, tool in pairs(player.Backpack:GetChildren()) do
                    if tool:IsA("Tool") then table.insert(weapons, tool.Name) end
                end
            end
            for _, tool in pairs(player.Character:GetChildren()) do
                if tool:IsA("Tool") then table.insert(weapons, "["..tool.Name.."]") end
            end
            gui.WeaponLabel.Visible = true
            gui.WeaponLabel.Text = #weapons > 0 and "Weapons: " .. table.concat(weapons, ", ") or "Weapons: -"
        else
            gui.WeaponLabel.Visible = false
        end
    end
end

local function CreateBoxForPlayer(player)
    if Boxes[player] then return end
    local ok, square = pcall(function() return Drawing.new("Square") end)
    if not ok or not square then Boxes[player] = nil return end
    square.Visible = false
    square.Color = Color3.fromRGB(0,255,0)
    square.Thickness = 2
    square.Filled = false
    Boxes[player] = square
end

local function RemoveBox(player)
    if Boxes[player] then
        pcall(function() Boxes[player]:Remove() end)
        Boxes[player] = nil
    end
end

local function UpdateBox(player)
    local box = Boxes[player]
    if not box then return end
    if not player.Character then box.Visible = false return end
    local root = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso")
    if not root then box.Visible = false return end
    local rootPos, onScreen = Camera:WorldToViewportPoint(root.Position)
    if not onScreen then box.Visible = false return end
    local head = player.Character:FindFirstChild("Head")
    if not head then box.Visible = false return end
    local topPos, topOn = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,0.4,0))
    local bottomPos, bottomOn = Camera:WorldToViewportPoint(root.Position - Vector3.new(0,3,0))
    if not topOn or not bottomOn then box.Visible = false return end
    local height = math.abs(topPos.Y - bottomPos.Y)
    local width = math.clamp(height / 2, 20, 300)
    box.Size = Vector2.new(width, height)
    box.Position = Vector2.new(rootPos.X - width / 2, topPos.Y)
    box.Visible = BoxEsp
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.25)
        if EspEnabled then CreateESP(plr) end
        if BoxEsp then CreateBoxForPlayer(plr) end
    end)
end)
Players.PlayerRemoving:Connect(function(plr)
    RemoveBox(plr)
    if plr.Character and plr.Character:FindFirstChild("Head") and plr.Character.Head:FindFirstChild("ESP_GUI") then
        pcall(function() plr.Character.Head.ESP_GUI:Destroy() end)
    end
end)

RunService.RenderStepped:Connect(function()
    if EspEnabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                CreateESP(plr)
                UpdateESP(plr)
                if BoxEsp then CreateBoxForPlayer(plr) UpdateBox(plr) end
            end
        end
    else
        for _, box in pairs(Boxes) do if box then pcall(function() box.Visible = false end) end end
    end
end)

-- -------------------------
-- AIMBOT TAB (F toggle + Silent Aim)
-- -------------------------
local AimTab = Window:CreateTab("Aimbot", 4483362458)

local AimbotEnabled = false
local SilentAimEnabled = false
local FOV_Radius = 150
local AimSmoothing = 0.18
local RequireRMB = false
local AutoShoot = false
local ShowTargetInfo = true

-- Drawing visuals for FOV and info
local Circle = nil
local TextDraw = nil
pcall(function() Circle = Drawing.new("Circle") end)
pcall(function() TextDraw = Drawing.new("Text") end)
if Circle then
    Circle.Color = Color3.fromRGB(255,255,255)
    Circle.Thickness = 2
    Circle.NumSides = 100
    Circle.Radius = FOV_Radius
    Circle.Filled = false
    Circle.Visible = false
end
if TextDraw then
    TextDraw.Visible = false
    TextDraw.Size = 16
    TextDraw.Center = true
    TextDraw.Outline = true
    TextDraw.Color = Color3.fromRGB(255,255,255)
end

AimTab:CreateToggle({Name="Enable Aimbot (F toggle)", CurrentValue=false, Flag="AimbotToggle", Callback=function(v)
    AimbotEnabled = v
    if Circle then Circle.Visible = v end
    if TextDraw then TextDraw.Visible = (v and ShowTargetInfo) end
end})
AimTab:CreateSlider({Name="Aimbot FOV", Range={50,600}, Increment=1, CurrentValue=FOV_Radius, Flag="AimbotFOV", Callback=function(v) FOV_Radius = v if Circle then Circle.Radius = v end end})
AimTab:CreateSlider({Name="Smoothing (0 instant -> 99 slow)", Range={0,99}, Increment=1, CurrentValue=math.floor(AimSmoothing*100), Flag="AimbotSmooth", Callback=function(v) AimSmoothing = math.clamp(v/100, 0, 0.99) end})
AimTab:CreateToggle({Name="Require RMB to aim", CurrentValue=false, Flag="AimbotRequireRMB", Callback=function(v) RequireRMB = v end})
AimTab:CreateToggle({Name="Auto-Shoot (best-effort)", CurrentValue=false, Flag="AimbotAutoShoot", Callback=function(v) AutoShoot = v end})
AimTab:CreateToggle({Name="Show Target Info", CurrentValue=true, Flag="AimbotShowInfo", Callback=function(v) ShowTargetInfo = v if TextDraw then TextDraw.Visible = (AimbotEnabled and v) end end})
AimTab:CreateToggle({Name="Silent Aim (Magic Bullet) - best effort", CurrentValue=false, Flag="SilentAimToggle", Callback=function(v) SilentAimEnabled = v end})

-- Key toggles and RMB tracking
local RMBDown = false
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F then
        AimbotEnabled = not AimbotEnabled
        if Circle then Circle.Visible = AimbotEnabled end
        if TextDraw then TextDraw.Visible = (AimbotEnabled and ShowTargetInfo) end
        pcall(function() Rayfield:Notify({Title="Aimbot", Content = AimbotEnabled and "Enabled (F)" or "Disabled (F)", Duration = 2}) end)
    end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then RMBDown = true end
end)
UserInputService.InputEnded:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then RMBDown = false end
end)

local function GetClosestPlayerInFOV()
    local closest = nil
    local shortest = math.huge
    local mousePos = UserInputService:GetMouseLocation()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            local pos, onScreen = Camera:WorldToViewportPoint(plr.Character.Head.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - mousePos).magnitude
                if dist < shortest and dist <= FOV_Radius then
                    shortest = dist
                    closest = plr
                end
            end
        end
    end
    return closest, shortest
end

-- Auto shoot helper (best-effort)
local function TryAutoShoot()
    pcall(function() if mouse1click then mouse1click() end end)
    pcall(function() if mouse1press then mouse1press() mouse1release() end end)
    pcall(function() local vu = game:GetService("VirtualUser"); vu:Button1Down(Vector2.new(0,0)); task.wait(0.01); vu:Button1Up(Vector2.new(0,0)) end)
end

-- Main aimbot loop
RunService.RenderStepped:Connect(function()
    local mousePos = UserInputService:GetMouseLocation()
    if Circle then pcall(function() Circle.Position = mousePos Circle.Radius = FOV_Radius Circle.Visible = AimbotEnabled end) end
    if TextDraw then pcall(function() TextDraw.Position = mousePos + Vector2.new(0, -FOV_Radius - 16) TextDraw.Visible = (AimbotEnabled and ShowTargetInfo) end) end

    if AimbotEnabled then
        if RequireRMB and not RMBDown then return end
        local target, dist = GetClosestPlayerInFOV()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local headPos = target.Character.Head.Position
            local camPos = Camera.CFrame.Position
            local desired = CFrame.new(camPos, headPos)
            Camera.CFrame = Camera.CFrame:Lerp(desired, 1 - math.clamp(AimSmoothing, 0, 0.99))
            if TextDraw then pcall(function() TextDraw.Text = ("%s | %.0fpx"):format(target.Name, dist or 0) end) end
            if AutoShoot then TryAutoShoot() end
        else
            if TextDraw then pcall(function() TextDraw.Text = "" end) end
        end
    end
end)

-- Silent Aim (Magic Bullet) hook (best-effort; executor-dependent)
-- It tries to intercept namecall FireServer/InvokeServer and replace Vector3 args with head pos of target in FOV
local SilentHookInstalled = false
local originalNamecall = nil
local function installSilentHook()
    if SilentHookInstalled then return end
    local ok, err = pcall(function()
        local mt = getrawmetatable(game)
        originalNamecall = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            if SilentAimEnabled and (method == "FireServer" or method == "InvokeServer") then
                -- try to detect shooter remote by name heuristics
                local ok2, nameStr = pcall(function() return tostring(self.Name) end)
                if ok2 and type(nameStr) == "string" then
                    local lower = nameStr:lower()
                    if lower:find("shoot") or lower:find("fire") or lower:find("hit") or lower:find("gun") or lower:find("projectile") or lower:find("attack") or lower:find("server") then
                        local target = GetClosestPlayerInFOV()
                        if target and target.Character and target.Character:FindFirstChild("Head") then
                            local headPos = target.Character.Head.Position
                            for i=1,#args do
                                if typeof(args[i]) == "Vector3" then
                                    args[i] = headPos
                                elseif type(args[i]) == "table" then
                                    for k,v in pairs(args[i]) do
                                        if typeof(v) == "Vector3" then
                                            args[i][k] = headPos
                                        end
                                    end
                                end
                            end
                            return originalNamecall(self, unpack(args))
                        end
                    end
                end
            end
            return originalNamecall(self, ...)
        end)
        setreadonly(mt, true)
    end)
    SilentHookInstalled = ok
    if not ok then warn("Silent Aim hook failed to install:", err) end
end

-- Install silent hook (pcall to avoid errors if unsupported)
pcall(function() installSilentHook() end)

-- -------------------------
-- POWER TAB (no Fly, with Teleport on Respawn & Freecam)
-- -------------------------
local PowerTab = Window:CreateTab("Power", 4483362458)

local GodmodeEnabled = false
local NoRagdollEnabled = false
local KnockAttempt = false
local KnockForce = 200
local RespawnTPEnabled = false

-- Freecam state
local FreecamEnabled = false
local FreecamSpeed = 2
local freecamMove = {W=false,A=false,S=false,D=false,Q=false,E=false}
local savedCameraState = {CameraType = nil, Subject = nil}

PowerTab:CreateToggle({Name="Godmode (anti-finish)", CurrentValue=false, Flag="GodmodeToggle", Callback=function(v) GodmodeEnabled = v end})
PowerTab:CreateToggle({Name="Disable Ragdoll", CurrentValue=false, Flag="NoRagdollToggle", Callback=function(v) NoRagdollEnabled = v end})
PowerTab:CreateToggle({Name="Knockdown Attempt (best-effort)", CurrentValue=false, Flag="KnockToggle", Callback=function(v) KnockAttempt = v end})
PowerTab:CreateToggle({Name="Teleport On Respawn", CurrentValue=false, Flag="RespawnTeleportToggle", Callback=function(v) RespawnTPEnabled = v end})
PowerTab:CreateToggle({Name="Free Cam", CurrentValue=false, Flag="FreecamToggle", Callback=function(v)
    FreecamEnabled = v
    local cam = workspace.CurrentCamera
    if v then
        -- save previous
        savedCameraState.CameraType = cam.CameraType
        savedCameraState.Subject = cam.CameraSubject
        cam.CameraType = Enum.CameraType.Scriptable
    else
        -- restore
        if savedCameraState.Subject then
            pcall(function() cam.CameraSubject = savedCameraState.Subject end)
        end
        pcall(function() cam.CameraType = savedCameraState.CameraType or Enum.CameraType.Custom end)
    end
end})
PowerTab:CreateSlider({Name="Free Cam Speed", Range={1,20}, Increment=1, CurrentValue=FreecamSpeed, Flag="FreecamSpeed", Callback=function(v) FreecamSpeed = v end})

-- Godmode & NoRagdoll loop
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if GodmodeEnabled then
        pcall(function()
            hum.MaxHealth = 999999
            hum.Health = hum.MaxHealth
            hum.PlatformStand = false
            hum.Sit = false
        end)
    end
    if NoRagdollEnabled then
        pcall(function()
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
        end)
    end
end)

-- Knock attempt (best-effort)
local function attempt_knock_nearby()
    local mePos = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position)
    if not mePos then return end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            if (hrp.Position - mePos).Magnitude <= 30 then
                pcall(function()
                    hrp.Velocity = (hrp.Position - mePos).Unit * KnockForce + Vector3.new(0,50,0)
                    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                    if hum then hum.PlatformStand = true end
                end)
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if KnockAttempt then
        if tick() % 1 < 0.05 then attempt_knock_nearby() end
    end
end)

-- Respawn teleport
local function teleportToSpawns()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    for _, spawn in pairs(workspace:GetDescendants()) do
        if spawn:IsA("SpawnLocation") then
            task.wait(0.5)
            pcall(function() hrp.CFrame = spawn.CFrame + Vector3.new(0,5,0) end)
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if RespawnTPEnabled then teleportToSpawns() end
end)

-- Freecam controls
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.W then freecamMove.W = true end
    if input.KeyCode == Enum.KeyCode.S then freecamMove.S = true end
    if input.KeyCode == Enum.KeyCode.A then freecamMove.A = true end
    if input.KeyCode == Enum.KeyCode.D then freecamMove.D = true end
    if input.KeyCode == Enum.KeyCode.Q then freecamMove.Q = true end
    if input.KeyCode == Enum.KeyCode.E then freecamMove.E = true end
end)
UserInputService.InputEnded:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.W then freecamMove.W = false end
    if input.KeyCode == Enum.KeyCode.S then freecamMove.S = false end
    if input.KeyCode == Enum.KeyCode.A then freecamMove.A = false end
    if input.KeyCode == Enum.KeyCode.D then freecamMove.D = false end
    if input.KeyCode == Enum.KeyCode.Q then freecamMove.Q = false end
    if input.KeyCode == Enum.KeyCode.E then freecamMove.E = false end
end)

RunService.RenderStepped:Connect(function(dt)
    if FreecamEnabled then
        local cam = workspace.CurrentCamera
        cam.CameraType = Enum.CameraType.Scriptable
        local moveVec = Vector3.new(0,0,0)
        if freecamMove.W then moveVec = moveVec + Vector3.new(0,0,-1) end
        if freecamMove.S then moveVec = moveVec + Vector3.new(0,0,1) end
        if freecamMove.A then moveVec = moveVec + Vector3.new(-1,0,0) end
        if freecamMove.D then moveVec = moveVec + Vector3.new(1,0,0) end
        if freecamMove.E then moveVec = moveVec + Vector3.new(0,1,0) end
        if freecamMove.Q then moveVec = moveVec + Vector3.new(0,-1,0) end
        if moveVec.Magnitude > 0 then
            moveVec = moveVec.Unit * FreecamSpeed * (dt * 60)
            cam.CFrame = cam.CFrame + cam.CFrame:VectorToWorldSpace(moveVec)
        end
    end
end)

-- Final notify
pcall(function()
    Rayfield:Notify({Title="Alpha Studio", Content = "Loaded. Replace KEY/INVITE placeholders in script.", Duration = 6})
end)

print("Alpha Studio loaded.")
