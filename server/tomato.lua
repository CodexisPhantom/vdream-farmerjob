local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('vdream-farmerjob:server:plantTomatoSeed', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local seed = false
    if Player.Functions.GetItemByName("tomato_seed") ~= nil then
        seed = true
        Player.Functions.RemoveItem("tomato_seed", 1)
    else
        seed = false
    end

    cb(seed)
end)

RegisterNetEvent('vdream-farmerjob:server:GetTomato', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local rnd = math.random(Config.TomatoGainMin, Config.TomatoGainMax)

    Player.Functions.AddItem("tomato", rnd)
end)

QBCore.Functions.CreateUseableItem("tomato_seed", function(source, item)
    TriggerClientEvent("vdream-farmerjob:client:plantTomatoSeed", source)
end)