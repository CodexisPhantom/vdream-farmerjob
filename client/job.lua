local QBCore = exports['qb-core']:GetCoreObject()

local data = nil
local inDutyZone = false
local inTractorZone = false
local inStashZone = false

local function CreateZone(type)
    if type == "duty" then
        local zone = BoxZone:Create(Config.DutyZone.coords, Config.DutyZone.width, Config.DutyZone.height, {
            minZ = Config.DutyZone.coords.z - 3.0,
            maxZ = Config.DutyZone.coords.z + 3.0,
            name = Config.DutyZone.coords.name,
            debugPoly = Config.DutyZone.debug,
            heading = Config.DutyZone.coords.w
        })
        local zonecombo = ComboZone:Create({zone}, {
            name = "combo",
            debugPoly = Config.DutyZone.debug
        })
        zonecombo:onPlayerInOut(function(isPointInside)
            if isPointInside then
                inDutyZone = true
                exports['qb-core']:DrawText('[E] Pour prendre/arrêter son service', 'right')
            else
                inDutyZone = false
                exports['qb-core']:HideText()
            end
        end)
    elseif type == "tractor" then
        local zone = BoxZone:Create(Config.TractorZone.coords, Config.TractorZone.width, Config.TractorZone.height, {
            minZ = Config.TractorZone.coords.z - 3.0,
            maxZ = Config.TractorZone.coords.z + 3.0,
            name = Config.TractorZone.coords.name,
            debugPoly = Config.TractorZone.debug,
            heading = Config.TractorZone.coords.w
        })
        local zonecombo = ComboZone:Create({zone}, {
            name = "combo",
            debugPoly = Config.TractorZone.debug
        })
        zonecombo:onPlayerInOut(function(isPointInside)
            if isPointInside then
                inTractorZone = true
                exports['qb-core']:DrawText('[E] Menu tracteur', 'right')
            else
                inTractorZone = false
                exports['qb-core']:HideText()
            end
        end)
    elseif type == "stash" then
        local zone = BoxZone:Create(Config.StashZone.coords, Config.StashZone.width, Config.StashZone.height, {
            minZ = Config.StashZone.coords.z - 3.0,
            maxZ = Config.StashZone.coords.z + 3.0,
            name = Config.StashZone.coords.name,
            debugPoly = Config.StashZone.debug,
            heading = Config.StashZone.coords.w
        })
        local zonecombo = ComboZone:Create({zone}, {
            name = "combo",
            debugPoly = Config.StashZone.debug
        })
        zonecombo:onPlayerInOut(function(isPointInside)
            if isPointInside then
                inStashZone = true
                exports['qb-core']:DrawText('[E] Pour ouvrir l\'entrepôt', 'right')
            else
                inStashZone = false
                exports['qb-core']:HideText()
            end
        end)
    end
end

local function TractorMenu()
    local tractorMenu = {
        {
            header = "Menu équipment tracteur",
            isMenuHeader = true,
        },
        {
            header = "Remorque à râteau",
            params = {
                event = "vdream-farmerjob:client:EquipTractor",
                args = {
                    trailer = "trailer1"
                }
            }
        },
        {
            header = "Remorque à blé",
            params = {
                event = "vdream-farmerjob:client:EquipTractor",
                args = {
                    trailer = "trailer2"
                }
            }
        },
        {
            header = "Remorque à foin",
            params = {
                event = "vdream-farmerjob:client:EquipTractor",
                args = {
                    trailer = "trailer3"
                }
            }
        },
        {
            header = "Enlever la remorque",
            params = {
                event = "vdream-farmerjob:client:EquipTractor",
                args = {
                    trailer = "remove"
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

    exports['qb-menu']:openMenu(tractorMenu)
end

CreateThread(function()
    local ped = PlayerPedId()
    while true do
        Wait(1)
        if data ~= nil then
            if inTractorZone == true then
                if data.job.name == "farmer" then
                    if IsControlJustPressed(0, 38) then
                        TractorMenu()
                    end
                end
            end
            if inDutyZone == true then
                if data.job.name == "farmer" then
                    if IsControlJustPressed(0, 38) then
                        TriggerServerEvent("QBCore:ToggleDuty")
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('vdream-farmerjob:client:EquipTractor', function(data)
    local tractor = GetVehiclePedIsIn(PlayerPedId(), false)
    local coords = GetEntityCoords(tractor)

    if data.trailer == "remove" then
        local bool, trailer = GetVehicleTrailerVehicle(tractor)
        DetachVehicleFromTrailer(tractor)
        QBCore.Functions.DeleteVehicle(trailer)
    end
    if data.trailer == "trailer1" then
        local ModelHash = GetHashKey("raketrailer")

        RequestModel(ModelHash)
        while not HasModelLoaded(ModelHash) do
            Wait(100)
        end
        local trailer = CreateVehicle(ModelHash, coords.x, coords.y, coords.z, 180, true, true)

        SetEntityAsMissionEntity(trailer, true, true)
        AttachVehicleToTrailer(tractor, trailer, 50.0)
    end
    if data.trailer == "trailer2" then
        local ModelHash = GetHashKey("graintrailer")

        RequestModel(ModelHash)
        while not HasModelLoaded(ModelHash) do
            Wait(100)
        end
        local trailer = CreateVehicle(ModelHash, coords.x, coords.y, coords.z, 180, true, true)

        SetEntityAsMissionEntity(trailer, true, true)
        AttachVehicleToTrailer(tractor, trailer, 50.0)
    end
    if data.trailer == "trailer3" then
        local ModelHash = GetHashKey("baletrailer")

        RequestModel(ModelHash)
        while not HasModelLoaded(ModelHash) do
            Wait(100)
        end
        local trailer = CreateVehicle(ModelHash, coords.x, coords.y, coords.z, 180, true, true)

        SetEntityAsMissionEntity(trailer, true, true)
        AttachVehicleToTrailer(tractor, trailer, 50.0)
    end
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        data = PlayerData
    end)

    CreateZone("duty")
    CreateZone("tractor")
end)

RegisterNetEvent("QBCore:Client:OnJobUpdate")
AddEventHandler("QBCore:Client:OnJobUpdate", function(JobInfo)
    QBCore.Functions.GetPlayerData(function(PlayerData)
        data = PlayerData
    end)

    CreateZone("duty")
    CreateZone("tractor")
end)

AddEventHandler("onResourceStart", function(resourceName)
    CreateZone("duty")
    CreateZone("tractor")
end)