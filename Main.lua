-- Module: glight.lua

local function getAsset(filename, githubFilePath)
    if not isfile(filename) then
        local repo = "softbf395/Guiding-light-roblox/refs/heads/main/"
        local method = "https://raw.githubusercontent.com/" .. repo
        local content = game:HttpGet(method .. githubFilePath)
        writefile(filename, content)
    end
    local gotten = nil
    if getsynasset then
        gotten = getsynasset(filename)
    elseif getcustomasset then
        gotten = getcustomasset(filename)
    end
    return gotten
end

-- Main glight function, responsible for displaying death messages
local function glight(list, entity, color)
    local max = #list
    local deaths

    -- Check if the deaths file exists for this entity
    if not isfile(entity .. "/deaths") then
        deaths = 1
        writefile(entity .. "/deaths", "1")
    else
        deaths = tonumber(readfile(entity .. "/deaths")) + 1
        if deaths > max then
            deaths = max  -- Ensure deaths don't exceed the max in the list
        end
        writefile(entity .. "/deaths", tostring(deaths))  -- Update the deaths count
    end

    -- Get the messages and resources for the current death count
    local messageData = list[deaths or 1]
    local GLightBG = getAsset("guidingLight/BG.png", "GLightBG.png")
    local Music = getAsset("guidingLight/Song.mp3", "GLIGHT.mp3")
    local ScrGui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
    local BG = Instance.new("ImageLabel", ScrGui)
    local Sound = Instance.new("Sound", ScrGui)

    -- Set up background image and sound
    BG.BackgroundTransparency = 1
    BG.ImageColor3 = color or Color3.new(0, 0.5, 0.5)
    BG.Image = GLightBG
    BG.Size = UDim2.new(1, 0, 1, 0)
    Sound.SoundId = Music

    -- Set up text label for the message
    local text = Instance.new("TextLabel", BG)
    text.BackgroundTransparency = 1
    text.Size = UDim2.new(.4, 0, .4, 0)
    text.Position = UDim2.new(0.5, 0, 0.5, 0)
    text.TextSize = 50
    text.TextScaled = true
    text.TextTransparency = 1
    text.TextColor3 = color or Color3.new(0.35, 1, 1)

    -- Function to show a message with a fade-in effect
    function showMessage(messageText)
        text.Text = messageText
        game:GetService("TweenService"):Create(text, TweenInfo.new(1), {TextTransparency = 0}):Play()
        wait(1)

        local time = 3
        game.Players.LocalPlayer:GetMouse().Button1Down:Connect(function()
            time = 0  -- Stop showing the message if mouse click occurs
        end)

        while time > 0 do
            wait(0.1)
            time = time - 0.1
        end

        game:GetService("TweenService"):Create(text, TweenInfo.new(1), {TextTransparency = 1}):Play()  -- Fade out
        wait(1)
    end

    -- Loop through the message pairs for the current death count and show them
    for _, messagePair in ipairs(messageData) do
        local messageText = messagePair  -- The first part of the pair (e.g., "one death")
        showMessage(messageText)
    end

    -- Clean up
    text:Destroy()
    ScrGui:Destroy()
end

-- Return the glight function so it can be used elsewhere
return glight
