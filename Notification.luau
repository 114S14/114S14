-- 创建一个新的通知系统
local NotificationSystem = {}
NotificationSystem.__index = NotificationSystem

-- 默认设置
NotificationSystem.DefaultColor = Color3.fromRGB(0, 170, 255)
NotificationSystem.DefaultDuration = 3
NotificationSystem.Notifications = {}
NotificationSystem.Spacing = 60  -- 通知之间的间距

function NotificationSystem.new()
    local self = setmetatable({}, NotificationSystem)
    
    -- 创建通知容器
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "NotificationSystem"
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = game:GetService("CoreGui")
    
    return self
end

function NotificationSystem:ShowNotification(options)
    local text = options.Text or "Notification"
    local duration = options.Duration or self.DefaultDuration
    local color = options.Color or self.DefaultColor

    -- 创建通知框架
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.BackgroundColor3 = color
    notification.BackgroundTransparency = 0.2
    notification.BorderSizePixel = 0
    notification.Position = UDim2.new(1, 10, 1, 0)  -- 初始位置在屏幕右侧外
    notification.Size = UDim2.new(0, 300, 0, 50)
    notification.AnchorPoint = Vector2.new(1, 1)
    notification.ZIndex = 100
    
    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, 8)
    uicorner.Parent = notification
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Text"
    textLabel.BackgroundTransparency = 1
    textLabel.Position = UDim2.new(0, 15, 0, 0)
    textLabel.Size = UDim2.new(1, -30, 1, 0)
    textLabel.Font = Enum.Font.GothamSemibold
    textLabel.Text = text
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextSize = 14
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextWrapped = true
    textLabel.ZIndex = 101
    textLabel.Parent = notification
    
    -- 添加到屏幕
    notification.Parent = self.ScreenGui
    
    -- 计算新通知的位置（考虑已有通知）
    local targetY = 10
    for _, note in ipairs(self.Notifications) do
        targetY = targetY + note.AbsoluteSize.Y + self.Spacing
    end
    
    -- 动画效果：滑入
    notification:TweenPosition(UDim2.new(1, -10, 1, -targetY), "Out", "Quad", 0.3, true)
    
    -- 存储通知信息
    local notificationInfo = {
        Frame = notification,
        StartTime = tick(),
        Duration = duration,
        TargetY = targetY
    }
    table.insert(self.Notifications, notificationInfo)
    
    -- 设置自动关闭
    delay(duration, function()
        self:RemoveNotification(notificationInfo)
    end)
end

function NotificationSystem:RemoveNotification(notificationInfo)
    if not notificationInfo or not notificationInfo.Frame or not notificationInfo.Frame.Parent then
        return
    end
    
    -- 动画效果：滑出
    notificationInfo.Frame:TweenPosition(UDim2.new(1, 10, 1, -notificationInfo.TargetY), "Out", "Quad", 0.3, true,
        function()
            notificationInfo.Frame:Destroy()
            
            -- 从通知列表中移除
            for i, note in ipairs(self.Notifications) do
                if note == notificationInfo then
                    table.remove(self.Notifications, i)
                    break
                end
            end
            
            -- 更新剩余通知的位置
            self:UpdateNotificationPositions()
        end)
end

function NotificationSystem:UpdateNotificationPositions()
    local currentY = 10
    for _, note in ipairs(self.Notifications) do
        note.TargetY = currentY
        note.Frame:TweenPosition(UDim2.new(1, -10, 1, -currentY), "Out", "Quad", 0.3, true)
        currentY = currentY + note.Frame.AbsoluteSize.Y + self.Spacing
    end
end

-- 创建库的加载函数
local function CreateLibrary()
    return NotificationSystem.new()
end

return CreateLibrary
