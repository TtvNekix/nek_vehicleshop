ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if GetCurrentResourceName() == resource then
        Wait(1000)
        deleteNearbyVehicles(20)
        Wait(5000)
        spawnVehicles()
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if GetCurrentResourceName() == resource then
        deleteNearbyVehicles(20)
    end
end)

deleteNearbyVehicles = function(radius)
    local playerPed = PlayerPedId()

	if radius and tonumber(radius) then
		radius = tonumber(radius) + 0.01
        for k, v in pairs(Config['VS']['Cars']) do
		    local vehicles = ESX.Game.GetVehiclesInArea(vector3(v['x'], v['y'], v['z']), radius)

            for k,entity in ipairs(vehicles) do
                local attempt = 0

                while not NetworkHasControlOfEntity(entity) and attempt < 100 and DoesEntityExist(entity) do
                    Citizen.Wait(10)
                    NetworkRequestControlOfEntity(entity)
                    attempt = attempt + 1
                end

                if DoesEntityExist(entity) and NetworkHasControlOfEntity(entity) then
                    NetworkFadeOutEntity(entity, true, true)
                    Wait(500)
                    ESX.Game.DeleteVehicle(entity)
                end
            end
        end
	else
		local vehicle, attempt = ESX.Game.GetVehicleInDirection(), 0

		if IsPedInAnyVehicle(playerPed, true) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		end

		while not NetworkHasControlOfEntity(vehicle) and attempt < 100 and DoesEntityExist(vehicle) do
			Citizen.Wait(10)
			NetworkRequestControlOfEntity(vehicle)
			attempt = attempt + 1
		end

		if DoesEntityExist(vehicle) and NetworkHasControlOfEntity(vehicle) then
            NetworkFadeOutEntity(vehicle, true, true)
            Wait(500)
			ESX.Game.DeleteVehicle(vehicle)
		end
	end
end

spawnVehicles = function()
    for k, v in pairs(Config['VS']['Cars']) do
        local z = v['z'] - 1.00
        ESX.Game.SpawnVehicle(v['model'], vector3(v['x'], v['y'], z), v['r'], function(veh)
            SetEntityLocallyInvisible(veh)
            NetworkFadeInEntity(veh, true, true)

            SetVehicleUndriveable(veh, true)
            FreezeEntityPosition(veh, true)
        end)
    end
end

DrawText3D = function(x,y,z, text, scale1, scale2)

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
	local scale1 = scale1 or 0.65
	local scale2 = scale2 or 0.65

    SetTextScale(scale1, scale2)
    SetTextFont(1)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370 
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 0)

end

floatingText = function(msg, coords)
	AddTextEntry('FloatingHelpNotification', msg)
	SetFloatingHelpTextWorldPosition(1, coords)
	SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
	BeginTextCommandDisplayHelp('FloatingHelpNotification')
	EndTextCommandDisplayHelp(2, false, false, -1)
end

ConceMenu = function(model, model2, price, hash)
    local elements = Config['VS']['Menu']

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu', 
    {
            title    = '¿Con metodo que deseas pagar?',
            align    = 'center-right',
            elements = elements
    }, 
    function(data, menu)
    local data = data.current.value

    TriggerServerEvent('nek_vs:buyCar', model, model2, price, hash, data)

    ESX.UI.Menu.CloseAll()
    end, function(data, menu)
        menu.close()
    end)
end

RegisterNetEvent('nek_vs:giveCar', function(model, plate)
    for k ,v in pairs(Config['VS']['Spawn']) do
        ESX.Game.SpawnVehicle(model, vector3(v['x'], v['y'], v['z']), v['r'], function(veh) 
            SetPedIntoVehicle(PlayerPedId(), veh, -1)
            FreezeEntityPosition(veh, false)
            SetVehicleNumberPlateText(veh, tostring(plate))
        end)
        Wait(2500)
        ESX.ShowNotification("Vehiculo ~g~Entregado~w~.")
    end
end)

Citizen.CreateThread(function()
    while true do
        local msec = 750
        local playerPed = PlayerPedId()
        local pedCoords = GetEntityCoords(playerPed)
            for k, v in pairs(Config['VS']['Cars']) do
                local dist = Vdist(pedCoords, vector3(v['x'], v['y'], v['z']))

                if dist <= 2.5 then
                    msec = 0
                    local z = v['z'] + 1.30
                    floatingText("Modelo: ~g~" ..v['label'].. "~w~\nPrecio: ~g~$" ..v['price'].. "~w~\nPulsa ~y~E ~w~para ~g~comprar", vector3(v['x'], v['y'], z))
                    if IsControlJustPressed(0, Config['VS']['PressKey']) then
                        if Config['VS']['NeedLicense'] then
                            ESX.ShowNotification("Verificando licencia...")
                            Wait(3500)
                            ESX.TriggerServerCallback('nek_vs:checkLicense', function(cb) 
                                if cb then
                                    ConceMenu(v['label'], v['model'], v['price'], GetHashKey(v['model']))
                                end
                            end, Config['VS']['LicenseRequired'])
                        else
                            ConceMenu(v['label'], v['model'], v['price'], GetHashKey(v['model']))
                        end
                    end
                end
            end
        Citizen.Wait(msec)
    end
end)
