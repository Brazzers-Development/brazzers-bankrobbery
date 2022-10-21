QBCore = exports[Config.Core]:GetCoreObject()

local fleecaCooldown = false
local computerCooldown = false
local globalCooldown = false

-- Net Events

RegisterServerEvent("brazzers-bankrobbery:server:robBankCheck", function(bank)
    local src = source
    if not src then return end
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if Config.Banks[bank]['onRob'] then return TriggerClientEvent('QBCore:Notify', src, Lang:t("error.recently_robbed"), 'error') end

    TriggerClientEvent("brazzers-bankrobbery:client:startHeist", src, bank)
end)

-- | UPDATE STATUS | --

RegisterNetEvent('brazzers-bankrobbery:server:setBankStatus', function(stateType, state, k)
    Config.Banks[k][stateType] = state
    TriggerClientEvent('brazzers-bankrobbery:client:setBankStatus', -1, stateType, state, k)
end)

RegisterNetEvent("brazzers-bankrobbery:server:setPowerBoxStatus", function(stateType, state, k)
    Config.Banks[k]['powerbox'][stateType] = state
    TriggerClientEvent('brazzers-bankrobbery:client:setPowerBoxStatus', -1, stateType, state, k)
end)

RegisterNetEvent('brazzers-bankrobbery:server:setPostVaultPanel', function(stateType, state, k)
    Config.Banks[k]['postVault'][stateType] = state
    TriggerClientEvent('brazzers-bankrobbery:client:setPostVaultPanel', -1, stateType, state, k)
end)

RegisterNetEvent('brazzers-bankrobbery:server:setTrollyStatus', function(stateType, state, k)
    Config.Banks[k]['trolly'][stateType] = state
    TriggerClientEvent('brazzers-bankrobbery:client:setTrollyStatus', -1, stateType, state, k)
end)

RegisterNetEvent("brazzers-bankrobbery:server:setLockerStatus", function(stateType, state, k, i)
    Config.Banks[k]['drills'][i][stateType] = state
    TriggerClientEvent('brazzers-bankrobbery:client:setLockerStatus', -1, stateType, state, k, i)
end)

RegisterNetEvent("brazzers-bankrobbery:server:setComputerStatus", function(stateType, state, k, i)
    Config.Banks[k]['computers'][i][stateType] = state
    TriggerClientEvent('brazzers-bankrobbery:client:setComputerStatus', -1, stateType, state, k, i)
end)

RegisterNetEvent('brazzers-bankrobbery:server:computerCleanup', function(k, i)
    computerCooldown = true
    SetTimeout(60000*Config.ComputerResetWait, function()
        TriggerClientEvent("brazzers-bankrobbery:client:computerCleanup", -1, k, i)
        computerCooldown = false
    end)
end)

RegisterServerEvent("brazzers-bankrobbery:server:toggleVault", function(bank)
    TriggerClientEvent("brazzers-bankrobbery:client:toggleVault", -1, bank)
end)

RegisterServerEvent("brazzers-bankrobbery:server:updateVaultState", function(bank, state)
    Config.Banks[bank]['doors']['locked'] = state
end)

RegisterNetEvent("brazzers-bankrobbery:server:setComputerAttempts", function(stateType, k, i, reset)
    if not reset then
        Config.Banks[k]['computers'][i][stateType] = Config.Banks[k]['computers'][i][stateType] - 1
        TriggerClientEvent('brazzers-bankrobbery:client:setComputerAttempts', -1, stateType, k, i, reset)
    elseif reset then
        Config.Banks[k]['computers'][i][stateType] = Config.ComputerAttempts
        TriggerClientEvent('brazzers-bankrobbery:client:setComputerAttempts', -1, stateType, k, i, reset)
    end
end)

RegisterServerEvent("brazzers-bankrobbery:server:setBankCooldown", function(bank)
    local src = source
    Config.Banks[bank]['lastRobbed'] = os.time()
    fleecaCooldown = true
    SetTimeout(60000*Config.BankResetWait, function()
        TriggerClientEvent("brazzers-bankrobbery:client:bankCleanup", -1, bank)
        TriggerEvent("brazzers-bankrobbery:server:toggleVault", bank) -- Force Close the bank
        fleecaCooldown = false
    end)
end)

-- Register Cool Down Events For Locations
RegisterServerEvent('brazzers-bankrobbery:server:globalCooldown', function()
    globalCooldown = true
    local timer = Config.GlobalCooldown * 60000
    while timer > 0 do
        Wait(1000)
        timer = timer - 1000
        if timer == 0 then
            globalCooldown = false
        end
    end
end)

-- CallBack For CoolDown
QBCore.Functions.CreateCallback("brazzers-bankrobbery:server:checkGlobalCooldown",function(source, cb)
    if globalCooldown then
        cb(true)
    else
        cb(false)     
    end
end)

-- Core

CreateThread(function()
    fleecaCooldown = true
    computerCooldown = true
    Wait(60000*Config.FirstLoadCoolDown)
    fleecaCooldown = false
    computerCooldown = false
end)

QBCore.Functions.CreateCallback('brazzers-bankrobbery:server:onCooldown', function(source, cb)
    cb(fleecaCooldown)
end)

QBCore.Functions.CreateCallback('brazzers-bankrobbery:server:onComputerCooldown', function(source, cb)
    cb(computerCooldown)
end)

QBCore.Functions.CreateCallback('brazzers-bankrobbery:server:enoughCops', function(source, cb)
	local Cops = 0 
    for k, v in pairs(QBCore.Functions.GetPlayers()) do 
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then 
                Cops = Cops + 1 
            end
        end
    end 
    cb(Cops)
end)