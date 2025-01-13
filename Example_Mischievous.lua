-- Example script to be executed with the loadstring

-- Load the module (Main.lua) from the provided raw link
local glight = loadstring(game:HttpGet("https://raw.githubusercontent.com/softbf395/Guiding-light-roblox/refs/heads/main/Main.lua"))()

-- Example death messages table
local messagesList = {
  [1] = { --death #1
    "You have not died to nothing", "example 1"
  },
  [2] = { --death #2
    "You have not died to nothing", "example 2"
  }
}

-- Example usage: Calling the glight function
local entity = "Example Mischievous light"  -- The entity name (player name in this case)
local color = Color3.fromRGB(255, 0, 0)  -- Red color

-- Call the glight function with the messages list, entity, and color
glight(messagesList, entity, color)
