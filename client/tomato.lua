local QBCore = exports['qb-core']:GetCoreObject()

local data = nil
local inTomatoZone = false

local function CreateZone(id)
    local zone = BoxZone:Create(Config.TomatoZone[id].coords, Config.TomatoZone[id].width, Config.TomatoZone[id].height, {
        minZ = Config.TomatoZone[id].coords.z - 10.0,
        maxZ = Config.TomatoZone[id].coords.z + 10.0,
        name = Config.TomatoZone[id].coords.name,
        debugPoly = Config.TomatoZone[id].debug,
        heading = Config.TomatoZone[id].coords.w
    })
    local zonecombo = ComboZone:Create({zone}, {
        name = "combo",
        debugPoly = Config.TomatoZone[id].debug
    })
    zonecombo:onPlayerInOut(function(isPointInside)
        if isPointInside then
            inTomatoZone = true
        else
            inTomatoZone = false
        end
    end)
end

local function GetClosestTomato()
    local pos = GetEntityCoords(PlayerPedId(), true)
    local current = nil
    local dist = nil
    for k, v in pairs(Config.Tomato) do
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

CreateThread(function()
    local ped = PlayerPedId()
    while true do
        Wait(1)
        if data ~= nil then
            if inTomatoZone == true then
                if data.job.name == "farmer" then
                    if IsControlJustPressed(0, 38) then
                        TriggerEvent('vdream-farmerjob:client:GetTomato')
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('vdream-farmerjob:client:plantTomatoSeed', function()
    if inTomatoZone then
        QBCore.Functions.TriggerCallback("vdream-farmerjob:server:plantTomatoSeed", function(HasSeed)
            local tomato = GetClosestTomato()
            if Config.Tomato[tomato].isPlanted == false then
                if HasSeed then
                    local ped = PlayerPedId()
                    local coords = GetEntityCoords(ped)
                    QBCore.Functions.Progressbar("planting_crop", "Planter des tomates", 5000, false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true
                    }, {}, {}, {}, function()
                        Config.Tomato[tomato].isPlanted = true
                        QBCore.Functions.Notify("Vous avez planté une plante de tomate.", "success")
                    end)
                else
                    QBCore.Functions.Notify("Tu n'as pas de graine de tomate !", "error")
                end
            else
                QBCore.Functions.Notify("Cette plante de tomate est déjà plantée !", "error")
            end
        end)
    else
        QBCore.Functions.Notify("Tu n'es pas dans un champ de tomate !", "error")
    end
end)

RegisterNetEvent('vdream-farmerjob:client:GetTomato', function(data)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped, true)

    local tomato = GetClosestTomato()
    local closestTomatoPlant = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.5, GetHashKey("prop_veg_crop_01"), false, false, false)

    if closestTomatoPlant ~= nil then
        if Config.Tomato[tomato].isPlanted == true then
            QBCore.Functions.Progressbar("tomato_crop", "Récupération de tomates", 7500, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
            }, {}, {}, {}, function()
                Config.Tomato[tomato].isPlanted = false
                TriggerServerEvent("vdream-farmerjob:server:GetTomato")
            end)
        else
            QBCore.Functions.Notify("Cette plante de tomate n'est pas plantée !", "error")
        end
    else
        QBCore.Functions.Notification("Il n'y a pas de plante de tomate devant vous", "error")
    end
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        data = PlayerData
    end)

    for k, v in pairs(Config.TomatoZone) do
        CreateZone(k)
    end
end)

RegisterNetEvent("QBCore:Client:OnJobUpdate")
AddEventHandler("QBCore:Client:OnJobUpdate", function(JobInfo)
    QBCore.Functions.GetPlayerData(function(PlayerData)
        data = PlayerData
    end)

    for k, v in pairs(Config.TomatoZone) do
        CreateZone(k)
    end
end)

AddEventHandler("onResourceStart", function(resourceName)
    for k, v in pairs(Config.TomatoZone) do
        CreateZone(k)
    end
end)