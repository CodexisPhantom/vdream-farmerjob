local QBCore = exports['qb-core']:GetCoreObject()

local data = nil
local zone = nil
local zonecombo = nil
local inMissionZone = false
local item = false
local quantity = false
local price = false
local png = nil
local blip = nil

local function CreatePedZone(ped)
    zone = BoxZone:Create(Config.PngLocation[ped].coords, 2, 2, {
        minZ = Config.PngLocation[ped].coords.z - 2.0,
        maxZ = Config.PngLocation[ped].coords.z + 2.0,
        name = "ped_farmer_delivery",
        debugPoly = Config.PngDebug,
        heading = Config.PngLocation[ped].coords.w
    })
    zonecombo = ComboZone:Create({zone}, {
        name = "combo",
        debugPoly = Config.PngDebug
    })
    zonecombo:onPlayerInOut(function(isPointInside)
        if isPointInside then
            inMissionZone = true
            exports['qb-core']:DrawText('[E] Pour finir la livraison', 'right')
        else
            inMissionZone = false
            exports['qb-core']:HideText()
        end
    end)
end

local function CreateBlip(blipData)
    blip = AddBlipForCoord(blipData.coords.x, blipData.coords.y, blipData.coords.z)
    SetBlipSprite(blip, 280)
    SetBlipDisplay(blip, 6)
    SetBlipScale(blip, 0.40)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, 2)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Livraison")
    EndTextCommandSetBlipName(blip)
end

local function DeleteBlipAndPng()
	if DoesBlipExist(blip) then
        RemoveBlip(blip)
        ClearAllBlipRoutes()
	end
    DeleteEntity(png)
end

CreateThread(function()
    while true do
        Wait(1)
        if data ~= nil then
            if data.job.name == "farmer" then
                if inMissionZone then
                    if IsControlJustPressed(0, 38) then
                        TriggerEvent("vdream-farmerjob:client:finishLiveryMission")
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('vdream-farmerjob:client:StartLiveryMission', function()
    local rnd = math.random(1, Config.PngLocationNumber)

    png = CreatePed(4, Config.PngLocation[rnd].model, Config.PngLocation[rnd].coords.x, Config.PngLocation[rnd].coords.y, Config.PngLocation[rnd].coords.z, Config.PngLocation[rnd].coords.w, true, true)
    SetEntityAsMissionEntity(png, true, true)
    Wait(1000)
    FreezeEntityPosition(png, true)
    CreatePedZone(rnd)

    item = Config.PngLocation[rnd].item
    quantity = math.random(Config.LiveryMin, Config.LiveryMax)
    price = Config.PngLocation[rnd].price * quantity

    CreateBlip(Config.PngLocation[rnd])
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 3)

    QBCore.Functions.Notify('Effectuer une livraison de ' .. quantity .. ' ' .. Config.PngLocation[rnd].itemName, 'success')
end)

RegisterNetEvent('vdream-farmerjob:client:finishLiveryMission', function()
    QBCore.Functions.TriggerCallback("vdream-farmerjob:server:finishLiveryMission", function(Finished)
        if Finished then
            DeleteBlipAndPng()
            zonecombo:destroy()
            zone:destroy()
            inMissionZone = false
            QBCore.Functions.Notify('Vous avez livré la livraison.', 'success')
        else
            QBCore.Functions.Notify('Vous n\'avez pas suffisament d\'item', 'error')
        end
    end, quantity, item, price)

    quantity = false
    item = false
    price = false
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        data = PlayerData
    end)
end)

RegisterNetEvent("QBCore:Client:OnJobUpdate")
AddEventHandler("QBCore:Client:OnJobUpdate", function(JobInfo)
    QBCore.Functions.GetPlayerData(function(PlayerData)
        data = PlayerData
    end)
end)