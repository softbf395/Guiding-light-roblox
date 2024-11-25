function getAsset(filename, githubFilePath)
  if not isfile(filename) then
    local repo="softbf395/Guiding-light-roblox/refs/heads/main/"
    local method="raw.githubusercontent.com/" .. repo
    local content=game:HttpGet(method..githubFilePath)
    writefile(filename, content)
  end
  local gotten=nil
  if getsynasset then
    gotten = getsynasset(filename)
  elseif getcustomasset then
    gotten = getcustomasset(filename)
  end
  return gotten
end
-- function glight(list, entity, color)
  local max=#list
  local deaths
  if not isfile(entity.."/deaths") then
    deaths = 1
    writefile(entity.."/deaths", "1")
  else
    if (deaths) < max then
      deaths=tonumber(readfile(entity.."/deaths"))+1
    appendfile(entity.."/deaths", tostring(deaths))
    else
      deaths=tonumber(readfile(entity.."/deaths"))
    end
  end
  local messages=list[tostring(deaths)]
  local GLightBG=getAsset("guidingLight/BG.png", "GLightBG.png")
  local Music=getAsset("guidingLight/Song.mp3", "GLIGHT.mp3")
  local ScrGui=Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
  local BG=Instance.New("ImageLabel", ScrGui)
  local Sound=Instance.new("Sound", ScrGui)
  BG.BackgroundTransparency=1
  BG.ImageColor3=color==nil and Color3.new(0,0.5,0.5) or Color3.fromRGB(color.R/2, color.G/2, color.B/2)
  BG.Image=GLightBG
  Sound.SoundId=Music
  local text=Instance.new("TextLabel", BG)
  text.BackgroundTransparency=1
  text.Size=UDim2.new(1,0,1,0)
    text.TextSize=50
    text.TextTransparency=1
    text.TextColor3=color==nil and Color3.new(0.35,1,1) or Color3.fromRGB(color.R, color.G, color.B)
  function showMessage(text)
    text.Text=text
    game:GetService("TweenService"):Create(text, TweenInfo.new(1), {TextTransparency=0}):Play()
    wait(1)
    local time = 3
    game.Players.LocalPlayer:GetMouse().Button1Down:Connect(function()
        time = 0
      end)
    while time > 0 do
      wait(0.1)
      time += -0.1
    end
    game:GetService("TweenService"):Create(text, TweenInfo.new(1), {TextTransparency=0}):Play()
    wait(1)
  end
  for _, text in ipairs(list[deaths] do
      showMessage(text)
    end
    text:Destroy()
    scrGui:Destroy()
-- end
 -- return glight
