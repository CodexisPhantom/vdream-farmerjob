local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('vdream-farmerjob:server:finishLiveryMission', function(source, cb, quantity, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local ok = false

    if Player.Functions.GetItemByName(item) ~= nil and Player.Functions.GetItemByName(item).amount >= quantity then
        Player.Functions.RemoveItem(item, quantity)
        exports['qb-management']:AddMoney("farmer", price)
        ok = true
    else
        ok = false
    end

    cb(ok)
end)