function getAsset(filename, githubFilePath)
  -- Check if the file exists locally, if not download it
  if not isfile(filename) then
    local repo = "softbf395/Guiding-light-roblox/refs/heads/main/"
    local method = "raw.githubusercontent.com/" .. repo
    local content = game:HttpGet(method..githubFilePath)
    writefile(filename, content)  -- Save the file locally
  end
  
  -- Return the asset content based on the available method
  local gotten = nil
  if getsynasset then
    gotten = getsynasset(filename)  -- If executor has getsynasset
  elseif getcustomasset then
    gotten = getcustomasset(filename)  -- If executor has getcustomasset
  end
  return gotten
end

-- Main function to display guiding light
function glight(list, entity, color)
  local max = #list
  local deaths

  -- Read the deaths count or set it to 1 if the file doesn't exist
  if not isfile(entity.."/deaths") then
    deaths = 1
    writefile(entity.."/deaths", "1")  -- Initialize deaths to 1 and save it
  else
    deaths = tonumber(readfile(entity.."/deaths")) + 1  -- Increment death count
    if deaths <= max then
      writefile(entity.."/deaths", tostring(deaths))  -- Overwrite deaths file with the new value
    else
      deaths = tonumber(readfile(entity.."/deaths"))  -- Use the max deaths count if exceeded
    end
  end

  -- Get the current message from the list using the death count
  local messages = list[deaths]
  local GLightBG = getAsset("guidingLight/BG.png", "GLightBG.png")
  local Music = getAsset("guidingLight/Song.mp3", "GLIGHT.mp3")

  -- Create GUI elements
  local ScrGui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
  local BG = Instance.new("ImageLabel", ScrGui)
  local Sound = Instance.new("Sound", ScrGui)

  BG.BackgroundTransparency = 1
  BG.ImageColor3 = color == nil and Color3.new(0, 0.5, 0.5) or Color3.fromRGB(color.R / 2, color.G / 2, color.B / 2)
  BG.Image = GLightBG
  Sound.SoundId = Music

  local text = Instance.new("TextLabel", BG)
  text.BackgroundTransparency = 1
  text.Size = UDim2.new(1, 0, 1, 0)
  text.TextSize = 50
  text.TextTransparency = 1
  text.TextColor3 = color == nil and Color3.new(0.35, 1, 1) or Color3.fromRGB(color.R, color.G, color.B)

  -- Function to show message with fade-in effect
  function showMessage(message)
    text.Text = message
    game:GetService("TweenService"):Create(text, TweenInfo.new(1), {TextTransparency = 0}):Play()  -- Fade in the text
    wait(1)  -- Wait for a moment

    local time = 3  -- Set time to wait before the message disappears
    game.Players.LocalPlayer:GetMouse().Button1Down:Connect(function()
      time = 0  -- Allow early exit if player clicks
    end)

    -- Countdown timer
    while time > 0 do
      wait(0.1)
      time = time - 0.1
    end

    -- Fade out the text after the countdown
    game:GetService("TweenService"):Create(text, TweenInfo.new(1), {TextTransparency = 1}):Play()
    wait(1)  -- Wait before fully removing the text
  end

  -- Show each message for the current death count
  for _, message in ipairs(list[deaths]) do
    showMessage(message)
  end

  -- Clean up by destroying the UI elements
  text:Destroy()
  ScrGui:Destroy()
end
