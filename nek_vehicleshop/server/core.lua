ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj Wait(5000) print("Nekix Vehicle Shop ^2initialized^0") end)

local plate = nil
local created = false

ESX.RegisterServerCallback('nek_vs:checkLicense', function(src, cb, type)
    local xPlayer = ESX.GetPlayerFromId(src)

    MySQL.Async.fetchAll("SELECT * FROM user_licenses WHERE owner = @owner AND type = @type",
    {
        ['@owner'] = xPlayer.identifier,
        ['@type'] = type
    }, 
    function(results)
        if results[1] then
            cb(true)
        else
            xPlayer.showNotification("No tienes la licencia de conducir")
        end
    end)
end)

local status = false
RegisterNetEvent('sendStatus', function()
    print(status)
    if status == false then
        status = true
        TriggerClientEvent('sendStatusClient', source, true)
    end
end)

generatePlate = function(hash)
    local xPlayer = ESX.GetPlayerFromId(source)

    plate = nil

    plate = "NEK " ..math.random(1000, 9999)

    MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE plate = @plate",
    {
        ['@plate'] = tostring(plate)
    }, 
    function(results)
        if results[1] then
            generatePlate()
        else
            print("Ya generada")
        end
        created = false
    end)
end

RegisterNetEvent('nek_vs:carInDb', function(vehicleData)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Sync.execute("INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)",
    {
        ['@owner'] = xPlayer.identifier,
        ['@plate'] = tostring(plate),
        ['@vehicle'] = tostring(json.encode(vehicleData))
    })
end)

sendWB = function(message)
	PerformHttpRequest(Config['Webhook'], function(err, text, headers) end, 'POST', json.encode({
		username = Config['Username'],
		embeds = {{
			["color"] = color,
			["author"] = {
				["name"] = Config['CommunityName'],
				["icon_url"] = Config['CommunityLogo']
			},
			["description"] = "".. message .."",
			["footer"] = {
				["text"] = "• "..os.date("%x %X %p"),
			},
		}}, 
		avatar_url = Config['Avatar']
	}),
	{
		['Content-Type'] = 'application/json'
	})

	print("Webhook Enviado")
end

RegisterNetEvent('nek_vs:buyCar', function(model, model2, price, hash, mode, vehData)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier

    if model and price then
        if mode == 'vipcoins' then
            if xPlayer.getAccount('vipcoins').money >= tonumber(price) then
                xPlayer.removeAccountMoney('vipcoins', tonumber(price))
                xPlayer.showNotification("Obteniendo matricula...")
                generatePlate(hash, vehData)
                Citizen.Wait(3500)
                TriggerClientEvent('nek_vs:giveCar', src, model, plate)
                xPlayer.showNotification("Has recibido un vehiculo -- Matricula: " .. plate .. " / Modelo: " .. model)
                if Config['EnableWebhook'] then
                	sendWB("**".. identifier .."** ha comprado un vehiculo\n\n**Coste:** ".. price .." BellaCoins\n**Modelo:** ".. model .."\n**Matricula:** ".. plate .."\n**Cuenta utilizada:** ".. mode)
            	end
            else
                if Config['EnableWebhook'] then
                	sendWB("**".. identifier .."** intento comprar mediante la cuenta **".. mode .."** por el valor de **".. price .." BellaCoins** pero no tenia dinero suficiente.")
                end
                xPlayer.showNotification("No tienes BellaCoins suficientes")
            end
        end
    end
end)


-- VERSION CHECKER DON'T DELETE THIS IF YOU WANT TO RECEIVE NEW UPDATES
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        function checkVersion(error, latestVersion, headers)
			local currentVersion = Config['Version']    
            local name = "[^4nek_vehicleshop^7]"
            Citizen.Wait(2000)
            
			if tonumber(currentVersion) < tonumber(latestVersion) then
				print(name .. " ^1is outdated.\nCurrent version: ^8" .. currentVersion .. "\nNewest version: ^2" .. latestVersion .. "\n^3Update^7: https://github.com/TtvNekix/nekix_vehicleshop")
			else
				print(name .. " is updated.")
			end
		end
	
		PerformHttpRequest("https://raw.githubusercontent.com/TtvNekix/vschecker/main/version", checkVersion, "GET")
    end
end)
-----------------------------------