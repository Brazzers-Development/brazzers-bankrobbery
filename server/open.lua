QBCore = exports[Config.Core]:GetCoreObject()

RegisterServerEvent('brazzers-bankrobbery:server:degradeItem', function(shitter)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local item = Player.Functions.GetItemByName(shitter)
    if Config.DegradeItem then
        if Player.PlayerData.items[item.slot].info.quality <= 25 then
            Player.Functions.RemoveItem(item, 1)
            TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[item], "remove")
        else
            Player.PlayerData.items[item.slot].info.quality = Player.PlayerData.items[item.slot].info.quality - 25
            Player.Functions.SetInventory(Player.PlayerData.items)
        end
    else
        Player.Functions.RemoveItem(shitter, 1)
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[shitter], "remove")
    end
end)

RegisterServerEvent("brazzers-bankrobbery:server:reward", function(bank, type)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if not bank then return DropPlayer(src, "Attempted exploit abuse") end

    local playerPed = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(playerPed)
    if #(playerCoords - Config.Banks[bank]['doors']['startLoc'].xyz) > 10.0 then
        return DropPlayer(src, "Attempted exploit abuse")
    end

    local chance = math.random(1, 100)

    if type == 'trolly' then
        local info = {}
        info.worth = math.random(5000, 10000)
        -- TROLLY EARNINGS BELOW
        Player.Functions.AddItem(Config.MarkedBills, Config.TrollyMarkedReward, false, info)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Config.MarkedBills], "add")
    elseif type == 'locker' then
        local info = {}
        info.worth = math.random(5000, 10000)
        -- LOCKER EARNINGS FROM DRILL
        Player.Functions.AddItem(Config.MarkedBills, Config.LockerMarkedReward)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.MarkedBills], "add")
        if chance <= 15 then
            Player.Functions.AddItem(Config.InkedBills, Config.InkedBillReward)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.InkedBills], "add")
        end
    elseif type == 'computer' then
        -- COMPUTER EARNINGS
        Player.Functions.AddItem(Config.ComputerUSB, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.ComputerUSB], "add")
    end
end)

RegisterNetEvent('brazzers-bankrobbery:server:removeWastefulShit', function(item)
    local src = source
    if not src then return end
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    Player.Functions.RemoveItem(item, 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'remove')
end)

-- [CRIMINAL HUB]

RegisterNetEvent('brazzers-bankrobbery:server:purchaseFromBuyer', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local paid = exports[Config.Phone]:RemoveCrypto(src, data.crypto, data.amount)
    if not paid then return TriggerClientEvent('QBCore:Notify', src, Lang:t("error.enough_crypto"), 'error') end

    Player.Functions.AddItem(data.item, 1)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[data.item], "add")
end)

RegisterNetEvent('brazzers-bankrobbery:server:tradeInUSBs', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local item = Player.Functions.GetItemByName(Config.ComputerUSB)
    if not item then return end

    if Player.Functions.RemoveItem(Config.ComputerUSB, 1) then
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Config.ComputerUSB], "remove")
        exports[Config.Phone]:AddCrypto(src, 'xcoin', 6)
        TriggerClientEvent('qb-phone:client:CustomNotification', src,
            "CRYPTO",
            "6 X Coin added!",
            "fas fa-chart-line",
            "#D3B300",
            3500
        )
    end
end)

-- [USEABLE ITEMS]

-- HACKING LAPTOP ITEM
QBCore.Functions.CreateUseableItem('greenlaptop',function(source)
    local src = source
    TriggerClientEvent("brazzers-bankrobbery:client:robTheBank", src)
end)

-- THERMITE ITEM
QBCore.Functions.CreateUseableItem('thermitecharge', function(source)
	local src = source
    TriggerClientEvent("thermite:client:useThermite", src)
end)

-- Callbacks

QBCore.Functions.CreateCallback('brazzers-bankrobbery:server:enoughCops', function(_, cb)
	local Cops = 0
    for _, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player then
            if Player.PlayerData.job.type == "leo" and Player.PlayerData.job.onduty then
                Cops = Cops + 1
            end
        end
    end
    cb(Cops)
end)