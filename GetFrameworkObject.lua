function GetFrameworkObject()
    local object = nil
    if Config.Framework == "esx" then
        while object == nil do
            object = exports["es_extended"]:getSharedObject()
            Citizen.Wait(0)
        end
    end
    if Config.Framework == "qb" then
        object = exports["qb-core"]:GetCoreObject()
    end
    return object
end