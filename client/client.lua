frameworkObject = nil
local shouldDraw = false
local playerDistances = {}

Citizen.CreateThread(function()
    frameworkObject = GetFrameworkObject() 
end)
RegisterCommand(Config.Command, function()
    shouldDraw = not shouldDraw
    if Config.Framework == "qb" then
        frameworkObject.Functions.Notify(Config.Lang["command"], 'success', 3000)
    end
    if Config.Framework == "esx" then
        exports["esx_notify"]:Notify("success", 3000, Config.Lang["command"])
    end
end, false)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if Config.Key == 0 then 
            return 
        end
        if IsControlJustPressed(1, Config.Key) then
            shouldDraw = not shouldDraw
            if Config.Framework == "qb" then
                frameworkObject.Functions.Notify(Config.Lang["command"], 'success', 3000)
            end
            if Config.Framework == "esx" then
                exports["esx_notify"]:Notify("success", 3000, Config.Lang["command"])
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if shouldDraw then 
			for _, id in ipairs(GetActivePlayers()) do
				if playerDistances[id] then
					if (playerDistances[id] < 20) then
						if IsPedInAnyVehicle(GetPlayerPed(id), true) then
							local vehicle = GetVehiclePedIsIn(GetPlayerPed(id), true)
							
							if GetPedInVehicleSeat(vehicle, -1) == GetPlayerPed(id) then
								x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
								DrawText3D(x2, y2-0.3, z2+1, GetPlayerServerId(id), 255,255,255)
							elseif GetPedInVehicleSeat(vehicle, 0) == GetPlayerPed(id) then
								x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
								DrawText3D(x2, y2+0.3, z2+1, GetPlayerServerId(id), 255,255,255)
							elseif GetPedInVehicleSeat(vehicle, 1) == GetPlayerPed(id) then
								x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
								DrawText3D(x2+1, y2-0.3, z2+1, GetPlayerServerId(id), 255,255,255)
							elseif GetPedInVehicleSeat(vehicle, 2) == GetPlayerPed(id) then
								x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
								DrawText3D(x2+1, y2+0.3, z2+1, GetPlayerServerId(id), 255,255,255)
							elseif GetPedInVehicleSeat(vehicle, 3) == GetPlayerPed(id) then
								x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
								DrawText3D(x2+2.1, y2-0.3, z2+1, GetPlayerServerId(id), 255,255,255)
							elseif GetPedInVehicleSeat(vehicle, 4) == GetPlayerPed(id) then
								x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
								DrawText3D(x2+2.1, y2+0.3, z2+1, GetPlayerServerId(id), 255,255,255)
							end
						else
							x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
							DrawText3D(x2, y2, z2+1, GetPlayerServerId(id), 255,255,255)
						end
					end 
				end
			end
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        for _, id in ipairs(GetActivePlayers()) do
            x1, y1, z1 = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
            x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
            distance = math.floor(#(vector3(x1,  y1,  z1)-vector3(x2,  y2,  z2)))
			playerDistances[id] = distance
        end
        Citizen.Wait(1000)
    end
end)

function DrawText3D(x, y, z, text)
    -- Check if coords are visible and get 2D screen coords
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        -- Calculate text scale to use
        local dist = GetDistanceBetweenCoords(GetGameplayCamCoords(), x, y, z, 1)
        local scale = 1 * (1 / dist) * (1 / GetGameplayCamFov()) * 100

        -- Draw text on screen
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropShadow(0, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextEdge(4, 0, 0, 0, 255)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end