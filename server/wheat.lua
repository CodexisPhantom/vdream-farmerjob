local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('vdream-farmerjob:server:plantWeathSeed', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local planted = false

    if Player.Functions.GetItemByName("weath_seed") ~= nil then
        planted = true
        Player.Functions.RemoveItem("weath_seed", 1)
    else
        planted = false
    end

    cb(planted)
end)

RegisterNetEvent('vdream-farmerjob:server:GetWeath', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local rnd = math.random(Config.WeathGainMin, Config.WeathGainMax)

    Player.Functions.AddItem("weath", rnd)
end)

RegisterNetEvent('vdream-farmerjob:server:GetHay', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local rnd = math.random(Config.WeathGainMin, Config.WeathGainMax)
    
    Player.Functions.AddItem("hay", rnd)
end)

QBCore.Functions.CreateUseableItem("weath_seed", function(source, item)
    TriggerClientEvent("vdream-farmerjob:client:plantWeathSeed", source)
end)