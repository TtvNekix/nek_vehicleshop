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

generatePlate = function(hash)
    local xPlayer = ESX.GetPlayerFromId(source)
    plate = nil

    plate = "NEK " ..math.random(1000, 9999) 

    local vehicleData = '{"modSteeringWheel":-1,"modFender":-1,"modEngine":-1,"modBackWheels":-1,"modAPlate":-1,"modHood":-1,"modFrame":-1,"tyreSmokeColor":[255,255,255],"color2":120,"wheels":6,"plateIndex":0,"modSuspension":-1,"dirtLevel":9.9,"modOrnaments":-1,"modDoorSpeaker":-1,"fuelLevel":100.0,"modBrakes":-1,"pearlescentColor":2,"modTank":-1,"modFrontWheels":-1,"modTrunk":-1,"tankHealth":1000.0,"color1":0,"modEngineBlock":-1,"neonColor":[255,0,255],"model":' .. hash .. ',"modShifterLeavers":-1,"modRearBumper":-1,"modTurbo":false,"bodyHealth":1000.0,"modDial":-1,"modStruts":-1,"modAirFilter":-1,"modSpoilers":-1,"modHorns":-1,"modSideSkirt":-1,"modTransmission":-1,"modSeats":-1,"modArchCover":-1,"modFrontBumper":-1,"xenonColor":255,"modSpeakers":-1,"modTrimA":-1,"wheelColor":1,"modPlateHolder":-1,"extras":[],"modSmokeEnabled":false,"modDashboard":-1,"modWindows":-1,"neonEnabled":[false,false,false,false],"modGrille":-1,"modRightFender":-1,"windowTint":-1,"modExhaust":-1,"modVanityPlate":-1,"engineHealth":1000.0,"modTrimB":-1,"modAerials":-1,"modHydrolic":-1,"modLivery":-1,"plate":'.. plate ..',"modArmor":-1,"modXenon":false,"modRoof":-1}'

    MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE plate = @plate",
    {
        ['@plate'] = tostring(plate)
    }, 
    function(results)
        if results[1] then
            generatePlate()
        else
            if created == false then
                MySQL.Sync.execute("INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)",
                {
                    ['@owner'] = xPlayer.identifier,
                    ['@plate'] = tostring(plate),
                    ['@vehicle'] = vehicleData
                }
                )
                created = true
            end
        end
        created = false
    end)
end

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

RegisterNetEvent('nek_vs:buyCar', function(model, model2, price, hash, mode)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier

    if model and price then
        if mode == 'bank' then
            if xPlayer.getAccount('bank').money >= tonumber(price) then
                xPlayer.removeAccountMoney('bank', tonumber(price))
                xPlayer.showNotification("Obteniendo matricula...")
                generatePlate(hash)
                Citizen.Wait(3500)
                TriggerClientEvent('nek_vs:giveCar', src, model, plate)
                xPlayer.showNotification("Has recibido un vehiculo -- Matricula: " .. plate .. " / Modelo: " .. model)
                if Config['EnableWebhook'] then
                	sendWB("**".. identifier .."** ha comprado un vehiculo\n\n**Coste:** $".. price .."\n**Modelo:** ".. model .."\n**Matricula:** ".. plate .."\n**Cuenta utilizada:** ".. mode)
            	end
            else
                if Config['EnableWebhook'] then
                	sendWB("**".. identifier .."** intento comprar mediante la cuenta **".. mode .."** por el valor de **$".. price .."** pero no tenia dinero suficiente.")
                end
                xPlayer.showNotification("No tienes dinero suficiente")
            end
        elseif mode == 'money' then
            if xPlayer.getMoney() >= tonumber(price) then
                xPlayer.removeMoney(tonumber(price))
                xPlayer.showNotification("Obteniendo matricula...")
                generatePlate(hash)
                Citizen.Wait(3500)
                TriggerClientEvent('nek_vs:giveCar', src, model, plate)
                xPlayer.showNotification("Has recibido un vehiculo -- Matricula: " .. plate .. " / Modelo: " .. model)
                if Config['EnableWebhook'] then
                	sendWB("**".. identifier .."** ha comprado un vehiculo\n\n**Coste:** $".. price .."\n**Modelo:** ".. model .."\n**Matricula:** ".. plate .."\n**Cuenta utilizada:** ".. mode)
            	end
            else
                if Config['EnableWebhook'] then
                	sendWB("**".. identifier .."** intento comprar mediante la cuenta **".. mode .."** por el valor de **$".. price .."** pero no tenia dinero suficiente.")
                end
                xPlayer.showNotification("No tienes dinero suficiente")
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