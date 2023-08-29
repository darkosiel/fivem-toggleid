local shouldDraw = false
local playerDistances = {}

RegisterCommand(Config.Command, function()
    shouldDraw = not shouldDraw
end, false)
if Config.Key ~= false then RegisterKeyMapping("toggleid", "Toggle IDs of players", "KEYBOARD", Config.Key) end

local seatOffsets = {
    [-1] = {x = 0, y = 03},
    [0] = {x = 0, y = 0.3},
    [1] = {x = 1, y = 0.3},
    [2] = {x = 1, y = 0.3},
    [3] = {x = 2.1, y = 0.3},
    [4] = {x = 2.1, y = 0.3}
}

Citizen.CreateThread(function()
    while true do
        local playerPos = GetEntityCoords(PlayerPedId())
        
        for _, id in ipairs(GetActivePlayers()) do
            local targetPed = GetPlayerPed(id)
            local targetPos = GetEntityCoords(targetPed)
            local distance = math.floor(#(playerPos - targetPos))
            playerDistances[id] = distance
            
            if shouldDraw and playerDistances[id] and (playerDistances[id] < 20) then
                local x2, y2, z2 = targetPos.x, targetPos.y, targetPos.z
                
                local vehicle = GetVehiclePedIsIn(targetPed, false)
                
                if vehicle ~= nil then
                    local seat = GetPedInVehicleSeat(vehicle, id)
                    
                    if seatOffsets[seat] then
                        local offset = seatOffsets[seat]
                        local labelX = targetPos.x + offset.x
                        local labelY = targetPos.y + offset.y
                        local labelZ = targetPos.z + 1
                        
                        DrawText3D(labelX, labelY, labelZ, GetPlayerServerId(id), 255, 255, 255)
                    end
                else
                    DrawText3D(targetPos.x, targetPos.y, targetPos.z + 1, GetPlayerServerId(id), 255, 255, 255)
                end
            end
        end
        
        Citizen.Wait(0)
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