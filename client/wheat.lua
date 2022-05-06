local QBCore = exports['qb-core']:GetCoreObject()

local data = nil
local inWeathZone = false

local function CreateZone(id)
    local zone = BoxZone:Create(Config.WeathZone[id].coords, Config.WeathZone[id].width, Config.WeathZone[id].height, {
        minZ = Config.WeathZone[id].coords.z - 10.0,
        maxZ = Config.WeathZone[id].coords.z + 10.0,
        name = Config.WeathZone[id].coords.name,
        debugPoly = Config.WeathZone[id].debug,
        heading = Config.WeathZone[id].coords.w
    })
    local zonecombo = ComboZone:Create({zone}, {
        name = "combo",
        debugPoly = Config.WeathZone[id].debug
    })
    zonecombo:onPlayerInOut(function(isPointInside)
        if isPointInside then
            inWeathZone = true
        else
            inWeathZone = false
        end
    end)
end

local function CreateWeath(id)
    local weath = Config.Weath[id]
    local hashKey = GetHashKey("prop_veg_crop_05")

    local plantProp = CreateObject(hashKey, weath.coords.x, weath.coords.y, weath.coords.z - 0.1, true, true, false)

    while not plantProp do
        Wait(0)
    end

    SetEntityHeading(plantProp, 140.0)
    PlaceObjectOnGroundProperly(plantProp)

    Wait(100)

    FreezeEntityPosition(plantProp, true)
    SetEntityAsMissionEntity(plantProp, true, true)
end

local function GetClosestWeath()
    local pos = GetEntityCoords(PlayerPedId(), true)
    local current = nil
    local dist = nil
    for k, v in pairs(Config.Weath) do
        local dist2 = #(pos - vector3(Config.Weath[k].coords.x, Config.Weath[k].coords.y, Config.Weath[k].coords.z))
        if current then
            if dist2 < dist then
                current = k
                dist = dist2
            end
        else
            dist = dist2
            current = k
        end
    end
    return current
end

local function WeathMenu()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    local coords = GetEntityCoords(PlayerPedId(), true)
    local weathObject = GetClosestObjectOfType(coords.x, coords.y, coords.z, 2.5, GetHashKey("prop_veg_crop_05"), false, false, false)

    local weathMenu = {
        {
            header = "Menu blé",
            isMenuHeader = true,
        },
        {
            header = "Récuperer du blé",
            params = {
                event = "vdream-farmerjob:client:GetWeath",
                args = {
                    object = weathObject
                }
            }
        },
        {
            header = "Récuperer du foin",
            params = {
                event = "vdream-farmerjob:client:GetHay",
                args = {
                    object = weathObject
                }
            }
        },
        {
            header = "Fermer",
            params = {
                event = "qb-menu:closeMenu",
            }
        },
    }

    local result, trailer = GetVehicleTrailerVehicle(veh)

    if weathObject ~= nil then
        if result then
            exports['qb-menu']:openMenu(weathMenu)
        else
            QBCore.Functions.Notify("Vous devez avoir la bonne remorque attachée au tracteur.", "error")
        end
    end
end

CreateThread(function()
    local ped = PlayerPedId()
    while true do
        Wait(1)
        if data ~= nil then
            if data.job.name == "farmer" then
                if inWeathZone then
                    if IsControlJustPressed(0, 38) then
                        WeathMenu()
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('vdream-farmerjob:client:plantWeathSeed', function()
    local weath = GetClosestWeath()
    if inWeathZone then
        if Config.Weath[weath].isPlanted == false then
            QBCore.Functions.TriggerCallback("vdream-farmerjob:server:plantWeathSeed", function(HasPlanted)
                if HasPlanted then
                    QBCore.Functions.Progressbar("planting_crop", "Planter du blé", 2500, false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true
                    }, {}, {}, {}, function()
                        CreateWeath(weath)
                        Config.Weath[weath].isPlanted = true
                        QBCore.Functions.Notify("Vous avez planté un blé.", "success")
                    end)
                else
                    QBCore.Functions.Notify("Tu n'as pas de graine de blé !", "error")
                end
            end)
        else
            QBCore.Functions.Notify("Ce blé est déjà planté !", "error")
        end
    else
        QBCore.Functions.Notify("Tu n'es pas dans un champ de blé !", "error")
    end
end)

RegisterNetEvent('vdream-farmerjob:client:GetWeath', function(data)
    local weath = GetClosestWeath()
    if Config.Weath[weath].isPlanted then
        QBCore.Functions.Progressbar("weath_station", "Récupération de blé", 5000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true
        }, {}, {}, {}, function()
            TriggerServerEvent("vdream-farmerjob:server:GetWeath")
            Config.Weath[weath].isPlanted = false
            DeleteObject(data.object)
        end)
    end
end)

RegisterNetEvent('vdream-farmerjob:client:GetHay', function(data)
    local weath = GetClosestWeath()
    if Config.Weath[weath].isPlanted then
        QBCore.Functions.Progressbar("weath_station", "Récupération de foin", 5000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true
        }, {}, {}, {}, function()
            TriggerServerEvent("vdream-farmerjob:server:GetHay")
            Config.Weath[weath].isPlanted = false
            DeleteObject(data.object)
        end)
    end
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        data = PlayerData
    end)

    for k, v in pairs(Config.WeathZone) do
        CreateZone(k)
    end
end)

RegisterNetEvent("QBCore:Client:OnJobUpdate")
AddEventHandler("QBCore:Client:OnJobUpdate", function(JobInfo)
    QBCore.Functions.GetPlayerData(function(PlayerData)
        data = PlayerData
    end)

    for k, v in pairs(Config.WeathZone) do
        CreateZone(k)
    end
end)

AddEventHandler("onResourceStart", function(resourceName)
    for k, v in pairs(Config.WeathZone) do
        CreateZone(k)
    end
end)