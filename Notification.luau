local Revenant = {}
Revenant.__index = Revenant

Revenant.DefaultColor = Color3.fromRGB(0, 170, 255)
Revenant.DefaultDuration = 3
Revenant.Notifications = {}

function Revenant.new()
    local self = setmetatable({}, Revenant)
    return self
end
function Revenant:Notification(options)
    local text = options.Text or "Notification"
    local duration = options.Duration or self.DefaultDuration
    local color = options.Color or self.DefaultColor

    local notification = Instance.new("Frame")
    notification.Name = "RevenantNotification"
    notification.BackgroundColor3 = color
    notification.BackgroundTransparency = 0.2
    notification.BorderSizePixel = 0
    notification.Position = UDim2.new(0.5, -150, 1, 50)
    notification.Size = UDim2.new(0, 300, 0, 50)
    notification.AnchorPoint = Vector2.new(0.5, 0)
    notification.ZIndex = 100
    
    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, 8)
    uicorner.Parent = notification
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Text"
    textLabel.BackgroundTransparency = 1
    textLabel.Position = UDim2.new(0, 10, 0, 0)
    textLabel.Size = UDim2.new(1, -20, 1, 0)
    textLabel.Font = Enum.Font.GothamSemibold
    textLabel.Text = text
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextSize = 14
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.ZIndex = 101
    textLabel.Parent = notification
    
    notification.Parent = game:GetService("CoreGui")
  
    notification:TweenPosition(UDim2.new(0.5, -150, 1, -100), "Out", "Quad", 0.3, true)
  
    table.insert(self.Notifications, notification)
  
    delay(duration, function()
        if notification and notification.Parent then
            notification:TweenPosition(UDim2.new(0.5, -150, 1, 50), "Out", "Quad", 0.3, true, 
                function()
                    notification:Destroy()
                    
                    for i, note in ipairs(self.Notifications) do
                        if note == notification then
                            table.remove(self.Notifications, i)
                            break
                        end
                    end
                end)
        end
    end)
end
local function loadLibrary()
    return Revenant.new()
end

return loadLibrary
