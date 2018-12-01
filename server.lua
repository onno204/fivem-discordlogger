local configuration = {
  ["Webhooks"] = {},
  ["Colors"] = {}
}

---------------------------------------------------------------
-------- - - - - - - - - - - Startup - - - - - - - - - --------
---------------------------------------------------------------

local Prefix = ""
local DefaultFallbackHook = "https://discordapp.com/api/webhooks/518508809577299988/fe2lHE5GlqsMWa_iBk_sHWES6T-ONo8TeXYS_-gMDRYjt9d1n2bUiX7BaKzboSBhb-5t" --Admin log
function StartUp()
	--Hooks
  -- This makes everything ALSO log into another channel. So you have one massive log. And multiple smaller logs
  configuration["Webhooks"][#configuration["Webhooks"]+1] = {name="LogEverythingInHere",hook="https://discordapp.com/api/webhooks/518508809577299988/fe2lHE5GlqsMWa_iBk_sHWES6T-ONo8TeXYS_-gMDRYjt9d1n2bUiX7BaKzboSBhb-5t"}
  
  -- Just copy paste one of these and add one
  configuration["Webhooks"][#configuration["Webhooks"]+1] = {name="Klok",hook="https://discordapp.com/api/webhooks/518508809577299988/fe2lHE5GlqsMWa_iBk_sHWES6T-ONo8TeXYS_-gMDRYjt9d1n2bUiX7BaKzboSBhb-5t"}
	configuration["Webhooks"][#configuration["Webhooks"]+1] = {name="Poso",hook="https://discordapp.com/api/webhooks/518508809577299988/fe2lHE5GlqsMWa_iBk_sHWES6T-ONo8TeXYS_-gMDRYjt9d1n2bUiX7BaKzboSBhb-5t"}


	--Colors ( RGB hex to Decimal ) -- https://www.binaryhexconverter.com/hex-to-decimal-converter
	configuration["Colors"][#configuration["Colors"]+1] = {color="Blue",int=25087}
	configuration["Colors"][#configuration["Colors"]+1] = {color="Red",int=16711680}
	configuration["Colors"][#configuration["Colors"]+1] = {color="pink",int=16711900}
	configuration["Colors"][#configuration["Colors"]+1] = {color="Turqouse",int=62207}
	configuration["Colors"][#configuration["Colors"]+1] = {color="lightgreen",int=65309}
	configuration["Colors"][#configuration["Colors"]+1] = {color="Yellow",int=15335168}
	configuration["Colors"][#configuration["Colors"]+1] = {color="Orange",int=16743168}
	configuration["Colors"][#configuration["Colors"]+1] = {color="Black",int=0}
	configuration["Colors"][#configuration["Colors"]+1] = {color="White",int=16777215}
	configuration["Colors"][#configuration["Colors"]+1] = {color="Green",int=762640}
end
StartUp()


------------------------------------------------------------
-------- - - - - - - - - - - misc - - - - - - - - - --------
------------------------------------------------------------

--Console Commands
AddEventHandler('rconCommand', function(commandName, args)
  if commandName:lower() == 'loggertestmessage' then -- Test command for testing the logs
    TriggerEvent("LOGGER:MessageHook", "LogEverythingInHere", "Username", "Message")
    TriggerEvent("LOGGER:SimpleEmbedHook", "LogEverythingInHere", "pink", "Username", "Message")
    TriggerEvent("LOGGER:DefaultLogHook", "LogEverythingInHere", "pink", "Username", "Title", "Message")
    TriggerEvent("LOGGER:ALotOfInfoLogHook", "LogEverythingInHere", "pink", "Username", "Title", "subtitle", "Message")
    print("Send messages")
    CancelEvent()
  end
end)


RegisterServerEvent('LOGGER:MessageHook')
AddEventHandler('LOGGER:MessageHook', function(Hook, Message, Name)
  MessageHook(Hook, Name, Message)
end)
function MessageHook(Hook, Message, Name) -- Send a normal message
  JsonD = { ['content'] = Prefix..Message, ['username'] = Name }
  SendHTTPRequest(Hook, JsonD) -- Execute the json
end

RegisterServerEvent('LOGGER:SimpleEmbedHook')
AddEventHandler('LOGGER:SimpleEmbedHook', function(Hook, Color, Name, Message)
  SimpleEmbedHook(Hook, Color, Name, Title, Message)
end)
function SimpleEmbedHook(Hook, Color, Name, Title, Message)
  EmbedsD = {
    ["color"] = GetColor(Color),
    ["footer"] = {
        ["text"] = os.date("%c"),
    },
    ["description"] = Prefix..Message
  }
  --Embeds test
  JsonD = { ['username'] = Name, ['embeds']={EmbedsD} }
  SendHTTPRequest(Hook, JsonD) -- Execute the json
end

RegisterServerEvent('LOGGER:DefaultLogHook')
AddEventHandler('LOGGER:DefaultLogHook', function(Hook, Color, Name, Title, Message)
  DefaultLogHook(Hook, Color, Name, Title, Message)
end)
function DefaultLogHook(Hook, Color, Name, Title, Message)
  EmbedsD = {
    ["title"] = Title,
    ["color"] = GetColor(Color),
    ["footer"] = {
        ["text"] = os.date("%c"),
    },
    ["description"] = Prefix..tostring(Message)
  }
  --Embeds test
  JsonD = { ['username'] = Name, ['embeds']={EmbedsD} }
  SendHTTPRequest(Hook, JsonD) -- Execute the json
end


RegisterServerEvent('LOGGER:ALotOfInfoLogHook')
AddEventHandler('LOGGER:ALotOfInfoLogHook', function(Hook, Color, Name, Title, Subtitle, Message)
  ALotOfInfoLogHook(Hook, Color, Name, Title, Subtitle, Message)
end)
function ALotOfInfoLogHook(Hook, Color, Name, Title, Subtitle, Message)
  EmbedsD = {
    ["title"] = Subtitle,
    ["color"] = GetColor(Color),
    ["footer"] = {
        ["text"] = os.date("%c"),
    },
    ["description"] = Prefix..Message,
	["author"] = {
		["name"] = Title
	}
  }
  --Embeds test
  JsonD = { ['username'] = Name, ['embeds']={EmbedsD} }
  SendHTTPRequest(Hook, JsonD) -- Execute the json
end



function SendHTTPRequest(Hookname, data) -- Send a HTTP request to Discord
	if(DoesWebhoekExist(Hookname)) then -- Check if hook exists
		for key in ipairs(configuration["Webhooks"]) do -- Loops trough al the hooks and looks for correct hook
			if( configuration["Webhooks"][key].name:lower() == Hookname:lower() ) then -- If match
			  PerformHttpRequest(configuration["Webhooks"][key].hook, function(statusCode, text, headers) -- Then send request to discord
				end, 'POST', json.encode(data), { ["Content-Type"] = 'multipart/form-data' })
			end
		end
	else
	  PerformHttpRequest(DefaultFallbackHook, function(statusCode, text, headers) -- Send message to fallback logbook if hookname isn't found
		end, 'POST', json.encode(data), { ["Content-Type"] = 'multipart/form-data' })
	end
	if (Hookname:lower() ~= string.format("LogEverythingInHere"):lower()) then -- Send a message to the 'LogEverythingInHere' hook
		SendHTTPRequest("LogEverythingInHere", data)
	end
end
function GetWebHook(Hookname) -- Get webhook
	for key in ipairs(configuration["Webhooks"]) do 
		if( configuration["Webhooks"][key].name:lower() == Hookname:lower() ) then
			return configuration["Webhooks"][key].hook
		end
	end
    return DefaultFallbackHook
end
function DoesWebhoekExist(Hookname) -- Check if webook exists
	for key in ipairs(configuration["Webhooks"]) do 
		if( configuration["Webhooks"][key].name:lower() == Hookname:lower() ) then
			return true
		end
	end
    return false
end

function GetColor(ColorName) -- Get color from color name
	for key in ipairs(configuration["Colors"]) do 
		if( configuration["Colors"][key].color:lower() == ColorName:lower() ) then
			return configuration["Colors"][key].int
		end
	end
    return 0
end


function DiscordWebhookMessage(TextMessage, PlayerID) -- Test function
  user = GetPlayerName(PlayerID)--.."("..GetPlayerIdentifiers(PlayerID)[1]..")"
  JsonD = { ['content'] = TextMessage, ['username'] = user }
  PerformHttpRequest(DiscordAPIHook, function(statusCode, text, headers)
      if text then
          --print("DiscordCallback: " .. text)
      end
  end, 'POST', string.gsub(json.encode(JsonD), "\\", ""), { ["Content-Type"] = 'multipart/form-data' })
end



function DiscordEmbededWebhookMessage(title, ColorCode, message, PlayerID) -- Test function
  user = GetPlayerName(PlayerID)--.."("..GetPlayerIdentifiers(PlayerID)[1]..")"
  --user = "onno203"
  EmbedsD = {
    ["title"] = title,
    ["color"] = ColorCode,
    ["footer"] = {
        ["text"] = os.date("%c"),
    },
    ["description"] = Prefix..message
  }
  --Embeds test
  JsonD = { ['username'] = user, ['embeds']={EmbedsD} }
  PerformHttpRequest(DiscordAPIHook, function(statusCode, text, headers)
      if text then
          --print("DiscordCallback: " .. text)
      end
  end, 'POST', json.encode(JsonD), { ["Content-Type"] = 'multipart/form-data' })
end

-- Player commands
-- AddEventHandler('chatMessage', function(id, color, message)
  -- if commandName:lower() == "/id" then
    -- print("Your ID: " .. id)
    -- CancelEvent()
  -- end
-- end)
