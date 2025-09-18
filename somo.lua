-- Full Universal Hub Script (ESP name white small, weapon yellow small)
-- UI Library (Rayfield)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- Main Window
local Window = Rayfield:CreateWindow({
   Name = "Alpha Studio",
   LoadingTitle = "Alpha Studio",
   LoadingSubtitle = "ESP | Aimbot | Power",
   ConfigurationSaving = { Enabled = false }
})

----------------------------------------------------------------------
-- PLAYER TAB
----------------------------------------------------------------------
local PlayerTab = Window:CreateTab("Player", 4483362458)

-- State
local WalkSpeedToggle = false
local WalkSpeedValue = 16
local JumpPowerToggle = false
local JumpPowerValue = 50
local NoClipEnabled = false

PlayerTab:CreateToggle({
   Name = "WalkSpeed Toggle",
   CurrentValue = false,
   Callback = function(v) WalkSpeedToggle = v end
})
PlayerTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16,200},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(v) WalkSpeedValue = v end
})
PlayerTab:CreateToggle({
   Name = "JumpPower Toggle",
   CurrentValue = false,
   Callback = function(v) JumpPowerToggle = v end
})
PlayerTab:CreateSlider({
   Name = "JumpPower",
   Range = {50,300},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(v) JumpPowerValue = v end
})
PlayerTab:CreateToggle({
   Name = "NoClip",
   CurrentValue = false,
   Callback = function(v) NoClipEnabled = v end
})

-- Apply
RS.Heartbeat:Connect(function()
   local char = LocalPlayer.Character
   if char and char:FindFirstChildOfClass("Humanoid") then
      local hum = char:FindFirstChildOfClass("Humanoid")
      if WalkSpeedToggle then hum.WalkSpeed = WalkSpeedValue else hum.WalkSpeed = 16 end
      if JumpPowerToggle then hum.JumpPower = JumpPowerValue else hum.JumpPower = 50 end
   end
   if NoClipEnabled and char then
      for _,part in pairs(char:GetDescendants()) do
         if part:IsA("BasePart") and part.CanCollide then
            part.CanCollide = false
         end
      end
   end
end)

----------------------------------------------------------------------
-- ESP TAB
----------------------------------------------------------------------
local ESPTab = Window:CreateTab("ESP", 4483362458)

local NameESP, BoxESP, HealthESP, WeaponESP = false,false,false,false

ESPTab:CreateToggle({Name="Enable ESP", CurrentValue=false, Flag="EnableESP", Callback=function(v) NameESP = v; BoxESP = v; HealthESP = v; WeaponESP = v end})
ESPTab:CreateToggle({Name="Name ESP",CurrentValue=false,Flag="NameESP",Callback=function(v) NameESP=v end})
ESPTab:CreateToggle({Name="Box ESP",CurrentValue=false,Flag="BoxESP",Callback=function(v) BoxESP=v end})
ESPTab:CreateToggle({Name="Health ESP",CurrentValue=false,Flag="HealthESP",Callback=function(v) HealthESP=v end})
ESPTab:CreateToggle({Name="Weapon ESP",CurrentValue=false,Flag="WeaponESP",Callback=function(v) WeaponESP=v end})

local Boxes = {}

local function createBillboardGuiFor(player)
   local bb = Instance.new("BillboardGui")
   bb.Name = "ESP_GUI"
   bb.Size = UDim2.new(0,200,0,60)
   bb.AlwaysOnTop = true
   bb.StudsOffset = Vector3.new(0,2,0)
   -- Name label (white, small)
   local nameLabel = Instance.new("TextLabel", bb)
   nameLabel.Name = "NameLabel"
   nameLabel.Size = UDim2.new(1,0,0,15)
   nameLabel.Position = UDim2.new(0,0,0,0)
   nameLabel.BackgroundTransparency = 1
   nameLabel.TextColor3 = Color3.fromRGB(255,255,255) -- white
   nameLabel.TextScaled = false
   nameLabel.TextSize = 11 -- smaller
   nameLabel.Font = Enum.Font.SourceSansBold
   nameLabel.Text = player.Name

   -- Weapon label (yellow, small)
   local weaponLabel = Instance.new("TextLabel", bb)
   weaponLabel.Name = "WeaponLabel"
   weaponLabel.Position = UDim2.new(0,0,0,15)
   weaponLabel.Size = UDim2.new(1,0,0,20)
   weaponLabel.BackgroundTransparency = 1
   weaponLabel.TextColor3 = Color3.fromRGB(255,210,0) -- yellow-ish
   weaponLabel.TextScaled = false
   weaponLabel.TextSize = 11 -- smaller
   weaponLabel.Font = Enum.Font.SourceSans
   weaponLabel.Text = ""

   -- Health bar
   local hbBack = Instance.new("Frame", bb)
   hbBack.Name = "HealthBack"
   hbBack.Position = UDim2.new(0.5, -25, 1, -5)
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
      gui.NameLabel.Visible = NameESP
      gui.NameLabel.Text = player.Name
   end

   if gui:FindFirstChild("HealthBack") and gui.HealthBack:FindFirstChild("HealthBar") then
      if HealthESP and hum then
         local percent = math.clamp(hum.Health / (hum.MaxHealth ~= 0 and hum.MaxHealth or 100), 0, 1)
         gui.HealthBack.Visible = true
         gui.HealthBack.HealthBar.Size = UDim2.new(percent, 0, 1, 0)
         gui.HealthBack.HealthBar.BackgroundColor3 = Color3.fromRGB(math.floor((1-percent)*255), math.floor(percent*255), 0)
      else
         gui.HealthBack.Visible = false
      end
   end

   if gui:FindFirstChild("WeaponLabel") then
      if WeaponESP then
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

-- Drawing boxes
local function CreateBox(player)
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
   local root = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")
   if not root then box.Visible = false return end
   local rootPos, onScreen = Camera:WorldToViewportPoint(root.Position)
   if not onScreen then box.Visible = false return end
   local head = player.Character:FindFirstChild("Head")
   if not head then box.Visible = false return end
   local topPos, _ = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,0.4,0))
   local bottomPos, _ = Camera:WorldToViewportPoint(root.Position - Vector3.new(0,3,0))
   local height = math.abs(topPos.Y - bottomPos.Y)
   local width = math.clamp(height / 2, 20, 300)
   box.Size = Vector2.new(width, height)
   box.Position = Vector2.new(rootPos.X - width / 2, topPos.Y)
   box.Visible = BoxESP
end

-- Events
Players.PlayerAdded:Connect(function(plr)
   plr.CharacterAdded:Connect(function()
      task.wait(0.3)
      if NameESP or HealthESP or WeaponESP then CreateESP(plr) end
      if BoxESP then CreateBox(plr) end
   end)
end)

Players.PlayerRemoving:Connect(function(plr)
   RemoveBox(plr)
   if plr.Character and plr.Character:FindFirstChild("Head") and plr.Character.Head:FindFirstChild("ESP_GUI") then
      pcall(function() plr.Character.Head.ESP_GUI:Destroy() end)
   end
end)

RS.RenderStepped:Connect(function()
   if NameESP or HealthESP or WeaponESP or BoxESP then
      for _,plr in pairs(Players:GetPlayers()) do
         if plr~=LocalPlayer then
            CreateESP(plr)
            UpdateESP(plr)
            if BoxESP then CreateBox(plr) UpdateBox(plr) end
         end
      end
   else
      -- hide boxes/guIs if all toggles off
      for _,box in pairs(Boxes) do if box then pcall(function() box.Visible = false end) end end
   end
end)

----------------------------------------------------------------------
-- AIMBOT TAB
----------------------------------------------------------------------
local AimTab = Window:CreateTab("Aimbot", 4483362458)

local AimbotEnabled = false
local FOV_Radius = 120
local Circle = nil
local okCircle = pcall(function() Circle = Drawing.new("Circle") end)
if okCircle and Circle then
   Circle.Thickness = 1
   Circle.NumSides = 64
   Circle.Radius = FOV_Radius
   Circle.Color = Color3.fromRGB(255,255,255)
   Circle.Filled = false
   Circle.Visible = false
end

AimTab:CreateToggle({Name="Enable Aimbot (F Key)",CurrentValue=false,Callback=function(v) AimbotEnabled=v if Circle then Circle.Visible=v end end})
AimTab:CreateSlider({Name="FOV Radius",Range={50,300},Increment=5,CurrentValue=120,Callback=function(v) FOV_Radius=v if Circle then Circle.Radius=v end end})

UIS.InputBegan:Connect(function(input,gp)
   if gp then return end
   if input.KeyCode==Enum.KeyCode.F then
      AimbotEnabled = not AimbotEnabled
      if Circle then Circle.Visible = AimbotEnabled end
   end
end)

local function GetClosestPlayer()
   local closest=nil
   local shortest=math.huge
   local mousePos=UIS:GetMouseLocation()
   for _,plr in pairs(Players:GetPlayers()) do
      if plr~=LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
         local pos,onScreen=Camera:WorldToViewportPoint(plr.Character.Head.Position)
         if onScreen then
            local dist=(Vector2.new(pos.X,pos.Y)-mousePos).Magnitude
            if dist<shortest and dist<=FOV_Radius then
               shortest=dist closest=plr
            end
         end
      end
   end
   return closest
end

RS.RenderStepped:Connect(function()
   if Circle then Circle.Position = UIS:GetMouseLocation() end
   if AimbotEnabled then
      local target = GetClosestPlayer()
      if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
         Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
      end
   end
end)

----------------------------------------------------------------------
-- POWER TAB
----------------------------------------------------------------------
local PowerTab = Window:CreateTab("Power", 4483362458)

local GodmodeEnabled=false
local NoRagdollEnabled=false
local FlyEnabled=false
local FlySpeed=100
local FlyUpSpeed=60
local FlyKey=Enum.KeyCode.Z
local KnockAttempt=false
local KnockForce=200
local flyState={active=false,vel=nil,gyro=nil}

PowerTab:CreateToggle({Name="Godmode",CurrentValue=false,Callback=function(v)GodmodeEnabled=v end})
PowerTab:CreateToggle({Name="No Ragdoll",CurrentValue=false,Callback=function(v)NoRagdollEnabled=v end})
PowerTab:CreateToggle({Name="Fly (Z key)",CurrentValue=false,Callback=function(v)FlyEnabled=v if not v then if flyState.vel then flyState.vel:Destroy() end if flyState.gyro then flyState.gyro:Destroy() end flyState.active=false end end})
PowerTab:CreateSlider({Name="Fly Speed",Range={20,400},Increment=1,CurrentValue=100,Callback=function(v)FlySpeed=v end})
PowerTab:CreateSlider({Name="Fly Up/Down",Range={20,300},Increment=1,CurrentValue=60,Callback=function(v)FlyUpSpeed=v end})
PowerTab:CreateToggle({Name="Knockdown Attempt",CurrentValue=false,Callback=function(v)KnockAttempt=v end})

-- Godmode loop
RS.Heartbeat:Connect(function()
   local char=LocalPlayer.Character
   if not char then return end
   local hum=char:FindFirstChildOfClass("Humanoid")
   if not hum then return end
   if GodmodeEnabled then hum.MaxHealth=999999 hum.Health=hum.MaxHealth hum.PlatformStand=false hum.Sit=false end
   if NoRagdollEnabled then pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false) end) end
end)

-- Fly toggle with Z
UIS.InputBegan:Connect(function(input,gp)
   if gp then return end
   if input.KeyCode==FlyKey then
      FlyEnabled=not FlyEnabled
      if FlyEnabled then
         local char=LocalPlayer.Character if not char then return end
         local hrp=char:FindFirstChild("HumanoidRootPart")
         if not hrp then return end
         local bv=Instance.new("BodyVelocity",hrp) bv.Name="FLY_VEL" bv.MaxForce=Vector3.new(1e5,1e5,1e5) bv.Velocity=Vector3.new(0,0,0)
         local bg=Instance.new("BodyGyro",hrp) bg.Name="FLY_GYRO" bg.MaxTorque=Vector3.new(1e5,1e5,1e5) bg.CFrame=hrp.CFrame
         flyState.active=true flyState.vel=bv flyState.gyro=bg
      else
         flyState.active=false
         local char=LocalPlayer.Character if not char then return end
         local hrp=char:FindFirstChild("HumanoidRootPart")
         if not hrp then return end
         if hrp:FindFirstChild("FLY_VEL") then hrp.FLY_VEL:Destroy() end
         if hrp:FindFirstChild("FLY_GYRO") then hrp.FLY_GYRO:Destroy() end
      end
   end
end)

local keys={W=false,A=false,S=false,D=false}; local upDown=0
UIS.InputBegan:Connect(function(i,gp) if gp then return end if i.KeyCode==Enum.KeyCode.W then keys.W=true end if i.KeyCode==Enum.KeyCode.S then keys.S=true end if i.KeyCode==Enum.KeyCode.A then keys.A=true end if i.KeyCode==Enum.KeyCode.D then keys.D=true end if i.KeyCode==Enum.KeyCode.Space then upDown=1 end if i.KeyCode==Enum.KeyCode.LeftControl then upDown=-1 end end)
UIS.InputEnded:Connect(function(i,gp) if gp then return end if i.KeyCode==Enum.KeyCode.W then keys.W=false end if i.KeyCode==Enum.KeyCode.S then keys.S=false end if i.KeyCode==Enum.KeyCode.A then keys.A=false end if i.KeyCode==Enum.KeyCode.D then keys.D=false end if i.KeyCode==Enum.KeyCode.Space then upDown=0 end if i.KeyCode==Enum.KeyCode.LeftControl then upDown=0 end end)

RS.Heartbeat:Connect(function()
   if flyState.active and flyState.vel and flyState.gyro and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
      local hrp=LocalPlayer.Character.HumanoidRootPart
      local cam=Camera
      local forward=Vector3.new(cam.CFrame.LookVector.X,0,cam.CFrame.LookVector.Z).Unit
      local right=Vector3.new(cam.CFrame.RightVector.X,0,cam.CFrame.RightVector.Z).Unit
      local dir=Vector3.new()
      if keys.W then dir=dir+forward end
      if keys.S then dir=dir-forward end
      if keys.A then dir=dir-right end
      if keys.D then dir=dir+right end
      if dir.Magnitude>0 then dir=dir.Unit end
      flyState.vel.Velocity=dir*FlySpeed+Vector3.new(0,upDown*FlyUpSpeed,0)
      flyState.gyro.CFrame=CFrame.new(hrp.Position,hrp.Position+cam.CFrame.LookVector)
   end
end)

-- Knock attempt (best-effort)
local function attempt_knock()
   local mePos=(LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position)
   if not mePos then return end
   for _,plr in pairs(Players:GetPlayers()) do
      if plr~=LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
         local hrp=plr.Character.HumanoidRootPart
         if (hrp.Position-mePos).Magnitude<30 then
            pcall(function() hrp.Velocity=(hrp.Position-mePos).Unit*KnockForce+Vector3.new(0,50,0) end)
         end
      end
   end
end
RS.Heartbeat:Connect(function() if KnockAttempt then attempt_knock() end end)

Rayfield:Notify({Title="Universal Hub",Content="Loaded with ESP, Aimbot, Power, Player Mods.",Duration=5})
