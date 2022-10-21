QBCore = exports[Config.Core]:GetCoreObject()

local disableControl = false
local PlayerData = {}

-- Functions

function hasItem(item)
    PlayerData = QBCore.Functions.GetPlayerData()
    if PlayerData.items then
        for _, v in pairs(PlayerData.items) do
            if v.name == item then
                return true
            end
        end
    end
end

local function passedBankHack(bankId)
    TriggerServerEvent("brazzers-bankrobbery:server:globalCooldown") -- Global Cooldown
    TriggerServerEvent("brazzers-bankrobbery:server:setBankCooldown", bankId) -- Individual Bank Cool down
    TriggerServerEvent("brazzers-bankrobbery:server:robBankCheck", bankId)
end

local function computerCleanup(bank, computer)
    TriggerServerEvent("brazzers-bankrobbery:server:setComputerStatus", "isBusy", false, bank, computer)
    TriggerServerEvent("brazzers-bankrobbery:server:setComputerAttempts", "attempts", bank, computer, true)
end

local function bankCleanup(bank)
    TriggerServerEvent("brazzers-bankrobbery:server:setBankStatus", "onRob", false, bank) -- General Bank
    TriggerServerEvent('brazzers-bankrobbery:server:setTrollyStatus', 'isBusy', false, bank) -- Trolly
    TriggerServerEvent("brazzers-bankrobbery:server:setPowerBoxStatus", 'isBusy', false, bank) -- Power Box
    TriggerServerEvent("brazzers-bankrobbery:server:setPostVaultPanel", 'isBusy', false, bank) -- Post Vault Panel

    for k, _ in pairs(Config.Banks[bank]['drills']) do
        TriggerServerEvent("brazzers-bankrobbery:server:setLockerStatus", "isBusy", false, bank, k) -- Lockers
    end

    local fullyTrolly = GetClosestObjectOfType(Config.Banks[bank]['trolly']['coords'].x, Config.Banks[bank]['trolly']['coords'].y, Config.Banks[bank]['trolly']['coords'].z, 1.0, `hei_prop_hei_cash_trolly_01`, false, false, false)
    local emptyTrolly = GetClosestObjectOfType(Config.Banks[bank]['trolly']['coords'].x, Config.Banks[bank]['trolly']['coords'].y, Config.Banks[bank]['trolly']['coords'].z, 1.0, `hei_prop_hei_cash_trolly_03`, false, false, false)
    if DoesEntityExist(fullyTrolly) then
        DeleteEntity(fullyTrolly)
    elseif DoesEntityExist(emptyTrolly) then
        DeleteEntity(emptyTrolly)
    end
end

local function SpawnTrolleys(bank)
    RequestModel("hei_prop_hei_cash_trolly_01")
    while not HasModelLoaded("hei_prop_hei_cash_trolly_01") do
        Wait(1)
    end
    local Trolley = CreateObject(`hei_prop_hei_cash_trolly_01`, Config.Banks[bank]['trolly']['coords'].x, Config.Banks[bank]['trolly']['coords'].y, Config.Banks[bank]['trolly']['coords'].z - 1.0, 1, 1, 0)
    local h1 = GetEntityHeading(Trolley)

    SetEntityHeading(Trolley, h1 + Config.Banks[bank]['trolly']['heading'])
end

function thermiteSuccess(bank)
    if not bank then return end

    alertPolice('thermite')
    TriggerServerEvent("brazzers-bankrobbery:server:setPowerBoxStatus", 'isBusy', true, bank)
    -- Remove Item
    TriggerServerEvent('brazzers-bankrobbery:server:removeWastefulShit', Config.ThermiteItem)
    toggleDoorlock(Config.Banks[bank]['doorIds']['preVault'])
end

function thermiteFail()
    alertPolice('thermite')
    -- Remove Item
    TriggerServerEvent('brazzers-bankrobbery:server:removeWastefulShit', Config.ThermiteItem)
end

local function thermitePowerBox(bank)
    if Config.Banks[bank]['powerbox']['isBusy'] then return end

    doThermiteOnPowerBox(bank)
end

local function decryptComputers(bank, computer)
    if Config.Banks[bank]['computers'][computer]['isBusy'] then return end

    doDecryptionOnComputers(bank, computer)
end

function decryptComputersResult(result, bank, computer)
    if result == 'passed' then
        TriggerServerEvent("brazzers-bankrobbery:server:setComputerStatus", "isBusy", true, bank, computer) -- Sets status busy when completed or failed
        TriggerServerEvent("brazzers-bankrobbery:server:computerCleanup", bank, computer) -- Sets Waiting period until a full reset
        -- Add Crypto
        TriggerServerEvent("brazzers-bankrobbery:server:reward", bank, 'computer')

    elseif result == 'failed' then
        if Config.Banks[bank]['computers'][computer]['attempts'] ~= 1 then
            TriggerServerEvent("brazzers-bankrobbery:server:setComputerAttempts", "attempts", bank, computer, false) -- 3 attempts total, subtracts 1 every fail
        else
            QBCore.Functions.Notify(Lang:t("error.computer_lockdown"), "error", 5000)
            TriggerServerEvent("brazzers-bankrobbery:server:setComputerStatus", "isBusy", true, bank, computer) -- Sets status busy when completed or failed
            TriggerServerEvent("brazzers-bankrobbery:server:computerCleanup", bank, computer) -- Sets Waiting period until a full reset
        end
    end
end

local function decryptPostVault(bank)
    if not hasItem(Config.DecrypterItem) then return QBCore.Functions.Notify(Lang:t("error.missing_decrypter"), "error", 5000) end
    if Config.Banks[bank]['postVault']['isBusy'] then return end

    doPostVaultHack(bank)
end

function decryptPostVaultResult(result, bank)
    if result == 'passed' then
        TriggerServerEvent("brazzers-bankrobbery:server:setPostVaultPanel", 'isBusy', true, bank)
        toggleDoorlock(Config.Banks[bank]['postVault']['doorId'])
        -- Remove Item
        TriggerServerEvent('brazzers-bankrobbery:server:removeWastefulShit', Config.DecrypterItem)
    elseif result == 'failed' then
        -- Remove Item
        TriggerServerEvent('brazzers-bankrobbery:server:removeWastefulShit', Config.DecrypterItem)
    end
end



local function drillLockers(bank, locker)
    if not hasItem(Config.DrillItem) then return QBCore.Functions.Notify(Lang:t("error.missing_drill"), "error", 5000) end
    if Config.Banks[bank]['drills'][locker]['isBusy'] then return end

    TriggerServerEvent("brazzers-bankrobbery:server:setLockerStatus", "isBusy", true, bank, locker)

    local ped = PlayerPedId()
    local animDict = "anim@heists@fleeca_bank@drilling"
    local animLib = "drill_straight_idle"
    
    FreezeEntityPosition(ped, true)
    
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(50)
    end
    
    local drillProp = GetHashKey('hei_prop_heist_drill')
    local boneIndex = GetPedBoneIndex(ped, 28422)
    
    RequestModel(drillProp)
    while not HasModelLoaded(drillProp) do
        Wait(100)
    end
    
    SetEntityCoords(ped, Config.Banks[bank]['drills'][locker]['drillCoords'].x, Config.Banks[bank]['drills'][locker]['drillCoords'].y, Config.Banks[bank]['drills'][locker]['drillCoords'].z-0.95) vector3(149.69, -1044.92, 29.37)
    SetEntityHeading(ped, Config.Banks[bank]['drills'][locker]['heading'])
    TaskPlayAnimAdvanced(ped, animDict, animLib, Config.Banks[bank]['drills'][locker]['drillCoords'].x, Config.Banks[bank]['drills'][locker]['drillCoords'].y, Config.Banks[bank]['drills'][locker]['drillCoords'].z, 0.0, 0.0, Config.Banks[bank]['drills'][locker]['heading'], 1.0, -1.0, -1, 2, 0, 0, 0 )
    
    local attachedDrill = CreateObject(drillProp, 1.0, 1.0, 1.0, 1, 1, 0)
    AttachEntityToEntity(attachedDrill, ped, boneIndex, 0.0, 0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
    
    SetEntityAsMissionEntity(attachedDrill, true, true)
        
    RequestAmbientAudioBank("DLC_HEIST_FLEECA_SOUNDSET", 0)
    RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL", 0)
    RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2", 0)
    local drillSound = GetSoundId()
    Wait(100)
    PlaySoundFromEntity(drillSound, "Drill", attachedDrill, "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
    Wait(100)
    
    local particleDictionary = "scr_fbi5a"
    local particleName = "scr_bio_cutter_flame"

    RequestNamedPtfxAsset(particleDictionary)
    while not HasNamedPtfxAssetLoaded(particleDictionary) do
        Wait(0)
    end

    SetPtfxAssetNextCall(particleDictionary)
    local effect = StartParticleFxLoopedOnEntity(particleName, attachedDrill, 0.0, -0.6, 0.0, 0.0, 0.0, 0.0, 10.0, 0, 0, 0)
    ShakeGameplayCam("ROAD_VIBRATION_SHAKE", 1.0)
    Wait(100)

    TriggerEvent("Drilling:Start",function(success)
        disableControl = true
        if success then
            disableControl = false
            TriggerServerEvent("brazzers-bankrobbery:server:reward", bank, 'locker')

            ClearPedTasksImmediately(ped)
            StopSound(drillSound)
            ReleaseSoundId(drillSound)
            DeleteObject(attachedDrill)
            DeleteEntity(attachedDrill)
            FreezeEntityPosition(ped, false)
            StopParticleFxLooped(effect, 0)
            StopGameplayCamShaking(true)
        else
            disableControl = false
            TriggerServerEvent('brazzers-bankrobbery:server:removeWastefulShit', Config.DrillItem)

            ClearPedTasksImmediately(ped)
            StopSound(drillSound)
            ReleaseSoundId(drillSound)
            DeleteObject(attachedDrill)
            DeleteEntity(attachedDrill)
            FreezeEntityPosition(ped, false)
            StopParticleFxLooped(effect, 0)
            StopGameplayCamShaking(true)
        end
    end)
end

local function grabCash(bank)
    if not Config.Banks[bank]['trolly']['isBusy'] then
        disableControl = true
        TriggerServerEvent('brazzers-bankrobbery:server:setTrollyStatus', 'isBusy', true, bank)
    
        local ped = PlayerPedId()
        local model = "hei_prop_heist_cash_pile"

        local Trolley = GetClosestObjectOfType(GetEntityCoords(ped), 1.0, `hei_prop_hei_cash_trolly_01`, false, false, false)
        local CashAppear = function()
            local pedCoords = GetEntityCoords(ped)
            local grabmodel = GetHashKey(model)

            RequestModel(grabmodel)
            while not HasModelLoaded(grabmodel) do
                Wait(100)
            end
            local grabobj = CreateObject(grabmodel, pedCoords, true)

            FreezeEntityPosition(grabobj, true)
            SetEntityInvincible(grabobj, true)
            SetEntityNoCollisionEntity(grabobj, ped)
            SetEntityVisible(grabobj, false, false)
            AttachEntityToEntity(grabobj, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
            local startedGrabbing = GetGameTimer()

            CreateThread(function()
                while GetGameTimer() - startedGrabbing < 37000 do
                    Wait(1)
                    DisableControlAction(0, 73, true)
                    if HasAnimEventFired(ped, `CASH_APPEAR`) then
                        if not IsEntityVisible(grabobj) then
                            SetEntityVisible(grabobj, true, false)
                        end
                    end
                    if HasAnimEventFired(ped, `RELEASE_CASH_DESTROY`) then
                        if IsEntityVisible(grabobj) then
                            SetEntityVisible(grabobj, false, false)
                        end
                    end
                end
                DeleteObject(grabobj)
            end)
        end
        local trollyobj = Trolley
        local emptyobj = `hei_prop_hei_cash_trolly_03`

        if IsEntityPlayingAnim(trollyobj, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 3) then
            return
        end
        local baghash = `hei_p_m_bag_var22_arm_s`

        RequestAnimDict("anim@heists@ornate_bank@grab_cash")
        RequestModel(baghash)
        RequestModel(emptyobj)
        while not HasAnimDictLoaded("anim@heists@ornate_bank@grab_cash") and not HasModelLoaded(emptyobj) and not HasModelLoaded(baghash) do
            Wait(100)
        end
        while not NetworkHasControlOfEntity(trollyobj) do
            Wait(1)
            NetworkRequestControlOfEntity(trollyobj)
        end
        local bag = CreateObject(`hei_p_m_bag_var22_arm_s`, GetEntityCoords(PlayerPedId()), true, false, false)
        local scene1 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

        NetworkAddPedToSynchronisedScene(ped, scene1, "anim@heists@ornate_bank@grab_cash", "intro", 1.5, -4.0, 1, 16, 1148846080, 0)
        NetworkAddEntityToSynchronisedScene(bag, scene1, "anim@heists@ornate_bank@grab_cash", "bag_intro", 4.0, -8.0, 1)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        NetworkStartSynchronisedScene(scene1)
        
        CashAppear()
        local scene2 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

        NetworkAddPedToSynchronisedScene(ped, scene2, "anim@heists@ornate_bank@grab_cash", "grab", 1.5, -4.0, 1, 16, 1148846080, 0)
        NetworkAddEntityToSynchronisedScene(bag, scene2, "anim@heists@ornate_bank@grab_cash", "bag_grab", 4.0, -8.0, 1)
        NetworkAddEntityToSynchronisedScene(trollyobj, scene2, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 4.0, -8.0, 1)
        NetworkStartSynchronisedScene(scene2)
        Wait(37000)
        local scene3 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

        NetworkAddPedToSynchronisedScene(ped, scene3, "anim@heists@ornate_bank@grab_cash", "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
        NetworkAddEntityToSynchronisedScene(bag, scene3, "anim@heists@ornate_bank@grab_cash", "bag_exit", 4.0, -8.0, 1)
        NetworkStartSynchronisedScene(scene3)
        local NewTrolley = CreateObject(emptyobj, GetEntityCoords(trollyobj) + vector3(0.0, 0.0, - 0.985), true)
        SetEntityRotation(NewTrolley, GetEntityRotation(trollyobj))
        while not NetworkHasControlOfEntity(trollyobj) do
            Wait(1)
            NetworkRequestControlOfEntity(trollyobj)
        end
        disableControl = false
        TriggerServerEvent("brazzers-bankrobbery:server:reward", bank, 'trolly')
        DeleteObject(trollyobj)
        PlaceObjectOnGroundProperly(NewTrolley)
        Wait(1800)
        DeleteObject(bag)
        RemoveAnimDict("anim@heists@ornate_bank@grab_cash")
        SetModelAsNoLongerNeeded(emptyobj)
        SetModelAsNoLongerNeeded(`hei_p_m_bag_var22_arm_s`)
    end
end

local function forceVaultClosed(bank)
    if not Config.Banks[bank]['doors']['locked'] then
        Config.Banks[bank]['doors']['locked'] = true
        TriggerServerEvent("brazzers-bankrobbery:server:updateVaultState", bank, Config.Banks[bank]['doors']['locked'])

        local obj = GetClosestObjectOfType(vector3(Config.Banks[bank]['doors']['startLoc'].x, Config.Banks[bank]['doors']['startLoc'].y, Config.Banks[bank]['doors']['startLoc'].z), 2.0, GetHashKey(Config.Banks[bank]['vaultModel']), false, false, false)
        local count = 0

        repeat
            local heading = GetEntityHeading(obj) + 0.10

            SetEntityHeading(obj, heading)
            count = count + 1
            Wait(10)
        until count == 900
    end
end

-- | UPDATE STATUS | --

RegisterNetEvent('brazzers-bankrobbery:client:setBankStatus', function(stateType, state, k)
    Config.Banks[k][stateType] = state
end)

RegisterNetEvent('brazzers-bankrobbery:client:setTrollyStatus', function(stateType, state, k)
    Config.Banks[k]['trolly'][stateType] = state
end)

RegisterNetEvent('brazzers-bankrobbery:client:setLockerStatus', function(stateType, state, k, i)
    Config.Banks[k]['drills'][i][stateType] = state
end)

RegisterNetEvent("brazzers-bankrobbery:client:setComputerStatus", function(stateType, state, k, i)
    Config.Banks[k]['computers'][i][stateType] = state
end)

RegisterNetEvent('brazzers-bankrobbery:client:setComputerAttempts', function(stateType, k, i, reset)
    if not reset then
        Config.Banks[k]['computers'][i][stateType] = Config.Banks[k]['computers'][i][stateType] - 1
    elseif reset then
        Config.Banks[k]['computers'][i][stateType] = Config.ComputerAttempts
    end
end)

RegisterNetEvent('brazzers-bankrobbery:client:setPowerBoxStatus', function(stateType, state, k)
    Config.Banks[k]['powerbox'][stateType] = state
end)

RegisterNetEvent('brazzers-bankrobbery:client:setPostVaultPanel', function(stateType, state, k)
    Config.Banks[k]['postVault'][stateType] = state
end)

RegisterNetEvent("brazzers-bankrobbery:client:bankCleanup", function(bank)
    bankCleanup(bank)
end)

RegisterNetEvent("brazzers-bankrobbery:client:computerCleanup", function(bank, computer)
    computerCleanup(bank, computer)
end)

RegisterNetEvent("thermite:client:useThermite", function()
    for k, v in pairs(Config.Banks) do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local dist = #(pos - v['powerbox']['coords'].xyz)

        if dist <= 4.0 then
            if v['powerbox']['isBusy'] then return end
            if not hasItem(Config.ThermiteItem) then return QBCore.Functions.Notify(Lang:t("error.missing_thermite"), "error", 5000) end

            QBCore.Functions.TriggerCallback("brazzers-bankrobbery:server:enoughCops", function(enoughCops)
                if enoughCops < Config.MinimumPolice then return QBCore.Functions.Notify(Lang:t("error.enough_police"), "error", 5000) end
                QBCore.Functions.TriggerCallback("brazzers-bankrobbery:server:onCooldown", function(onCoolDown)
                    if onCoolDown then return QBCore.Functions.Notify(Lang:t("error.bank_cooldown"), "error", 5000) end

                    thermitePowerBox(k)
                end)
            end)
        end
    end
end)

RegisterNetEvent("lockpicks:UseLockpick", function(isAdvanced)
    local usingAdvanced = isAdvanced
    if usingAdvanced then
        for _, v in pairs(Config.Banks) do
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local dist = #(pos - v['behindCounter']['coords'].xyz)

            if dist <= 4.0 then
                QBCore.Functions.TriggerCallback("brazzers-bankrobbery:server:enoughCops", function(enoughCops)
                    if enoughCops < Config.MinimumPolice then return QBCore.Functions.Notify(Lang:t("error.enough_police"), "error", 5000) end
                    QBCore.Functions.TriggerCallback("brazzers-bankrobbery:server:onComputerCooldown", function(onCoolDown)
                        if onCoolDown then return QBCore.Functions.Notify(Lang:t("error.computer_cooldown"), "error", 5000) end

                        doLockpickOnDoor(v['behindCounter']['doorId'])
                    end)
                end)
            end
        end
    end
end)

function lockpickResult(result, doorId)
    if result == 'passed' then
        TriggerServerEvent('5life-lockpick:server:degradeItem', 'advancedlockpick')

        alertPolice('securitydoor')
        toggleDoorlock(doorId)
    elseif result == 'failed' then
        TriggerServerEvent('5life-lockpick:server:degradeItem', 'advancedlockpick')
    end
end

RegisterNetEvent('brazzers-bankrobbery:client:robTheBank', function()
    if not hasItem(Config.Laptop) then return QBCore.Functions.Notify(Lang:t("error.missing_laptop"), "error", 5000) end
    for k, v in pairs(Config.Banks) do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local dist = #(pos - vector3(v['doors']['animCoords'].x, v['doors']['animCoords'].y, v['doors']['animCoords'].z))

        if dist <= 4.0 then
            if v['onRob'] then return QBCore.Functions.Notify(Lang:t("error.recently_robbed"), "error", 5000) end
            if not v['doors']['locked'] then return QBCore.Functions.Notify(Lang:t("error.unavailable"), "error", 5000) end

            QBCore.Functions.TriggerCallback("brazzers-bankrobbery:server:enoughCops", function(enoughCops)
                if enoughCops < Config.MinimumPolice then return QBCore.Functions.Notify(Lang:t("error.enough_police"), "error", 5000) end
                QBCore.Functions.TriggerCallback("brazzers-bankrobbery:server:checkGlobalCooldown",function(isGlobalCooldown)
                    if isGlobalCooldown then return QBCore.Functions.Notify(Lang:t("error.firstload_cooldown"), "error", 5000) end

                    doBankPadHack(k)
                end)
            end)
        end
    end
end)

function bankPadResult(result, bankId)
    if result == 'passed' then
        passedBankHack(bankId)
        TriggerServerEvent('brazzers-bankrobbery:server:degradeItem', 'greenlaptop')
    elseif result == 'failed' then
        TriggerServerEvent('brazzers-bankrobbery:server:degradeItem', 'greenlaptop')
    end
end

RegisterNetEvent("brazzers-bankrobbery:client:toggleVault", function(bank)
    if not Config.Banks[bank] then return end

    if Config.Banks[bank]['doors']['locked'] then
        local obj = GetClosestObjectOfType(vector3(Config.Banks[bank]['doors']['startLoc'].x, Config.Banks[bank]['doors']['startLoc'].y, Config.Banks[bank]['doors']['startLoc'].z), 2.0, GetHashKey(Config.Banks[bank]['vaultModel']), false, false, false)
        local count = 0

        repeat
            local heading = GetEntityHeading(obj) - 0.10

            SetEntityHeading(obj, heading)
            count = count + 1
            Wait(10)
        until count == 900
        Config.Banks[bank]['doors']['locked'] = false
        TriggerServerEvent("brazzers-bankrobbery:server:updateVaultState", bank, Config.Banks[bank]['doors']['locked'])
    elseif not Config.Banks[bank]['doors']['locked'] then
        forceVaultClosed(bank)
    end
end)

RegisterNetEvent("brazzers-bankrobbery:client:startHeist", function(bank)
    local bankId = Config.Banks[bank]
    local ped = PlayerPedId()

    SetEntityCoords(ped, vector3(bankId['doors']['animCoords'].x, bankId['doors']['animCoords'].y, bankId['doors']['animCoords'].z - 1.0))
    SetEntityHeading(ped, bankId['doors']['animHeading'])
    
    TaskStartScenarioInPlace(ped, "PROP_HUMAN_ATM", 0, true)
    
    ClearPedTasksImmediately(ped)
    Wait(1000)
    PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET")
    TriggerServerEvent("brazzers-bankrobbery:server:setBankStatus", "onRob", true, bank)

    QBCore.Functions.Notify(Lang:t("success.vault_open", { value = Config.VaultOpenTimer}), "primary", 5000)
    Wait(60000*Config.VaultOpenTimer)

    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 10, 'vault-door-close', 0.1) -- Sound
    TriggerServerEvent("brazzers-bankrobbery:server:toggleVault", bank)
    SpawnTrolleys(bank)
end)

RegisterNetEvent("brazzers-bankrobbery:client:ptfx", function(x, y, z)
    local ptfx

    RequestNamedPtfxAsset("scr_ornate_heist")
    while not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
        Wait(1)
    end
        ptfx = vector3(x, y, z)
    SetPtfxAssetNextCall("scr_ornate_heist")
    local effect = StartParticleFxLoopedAtCoord("scr_heist_ornate_thermal_burn", ptfx, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
    Wait(7000)
    StopParticleFxLooped(effect, 0)
end) 

-- Threads

CreateThread(function()
    while true do
        for _, v in pairs(Config.Banks) do
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local dist = #(pos - vector3(v['doors']['startLoc'].x, v['doors']['startLoc'].y, v['doors']['startLoc'].z))
            if dist < 6 then
                if not v['doors']['locked'] then
                    local obj = GetClosestObjectOfType(vector3(v['doors']['startLoc'].x, v['doors']['startLoc'].y, v['doors']['startLoc'].z), 2.0, GetHashKey(v['vaultModel']), false, false, false)
                    if obj ~= 0 then
                        SetEntityHeading(obj, v['doors']['vaultOpenHeading'])
                    end
                end
            end
        end
        Wait(1000)
    end
end)

CreateThread(function()
    for k, v in pairs(Config.Banks) do
        exports[Config.Target]:AddBoxZone("trolly_fleeca"..k, vector3(v['trolly']['coords'].x, v['trolly']['coords'].y, v['trolly']['coords'].z - 0.3), 0.6, 1.2, {
            name = "trolly_fleeca"..k,
            heading = v['trolly']['heading'],
            debugPoly = Config.Debug,
            minZ = v['trolly']['coords'].z - 1,
            maxZ = v['trolly']['coords'].z + 2,
            }, {
                options = {
                {
                    action = function()
                        grabCash(k)
                    end,
                    icon = 'fas fa-dollar-sign',
                    label = 'Grab Cash!',
                    canInteract = function()
                        if v["onRob"] and not v['trolly']['isBusy'] and not disableControl then
                            return true
                        end
                    end,
                }
            },
            distance = 1.5,
        })
        exports[Config.Target]:AddBoxZone("postVaultPanel"..k, vector3(v['postVault']['coords'].x, v['postVault']['coords'].y, v['postVault']['coords'].z + 0.5), 0.4, 0.6, {
            name = "postVaultPanel"..k,
            heading = v['postVault']['heading'],
            debugPoly = Config.Debug,
            minZ = v['postVault']['coords'].z - 1,
            maxZ = v['postVault']['coords'].z + 2,
            }, {
                options = {
                {
                    action = function()
                        decryptPostVault(k)
                    end,
                    icon = 'fas fa-cube',
                    label = 'Decrypt',
                    canInteract = function()
                        if v["onRob"] and not v['postVault']['isBusy'] and not disableControl then
                            return true
                        end
                    end,
                }
            },
            distance = 1.5,
        })
        exports[Config.Target]:AddBoxZone("panel_fleeca"..k, vector3(v['panel']['coords'].x, v['panel']['coords'].y, v['panel']['coords'].z + 0.5), 0.6, 1.2, {
            name = "panel_fleeca"..k,
            heading = v['panel']['heading'],
            debugPoly = Config.Debug,
            minZ = v['panel']['coords'].z - 1,
            maxZ = v['panel']['coords'].z + 2,
            }, {
                options = {
                {
                    action = function()
                        forceVaultClosed(k)
                    end,
                    icon = 'fas fa-lock',
                    label = 'Lock Vault',
                    canInteract = function()
                        if not v["doors"]['locked'] and not disableControl and isPolice() then
                            return true
                        end
                    end,
                }
            },
            distance = 1.5,
        })
        for i, j in pairs(Config.Banks[k]['drills']) do
            exports[Config.Target]:AddBoxZone("drills_fleeca"..i, vector3(j['coords'].x, j['coords'].y, j['coords'].z + 0.5), 0.6, 2.0, {
                name = "drills_fleeca"..i,
                heading = j['heading'],
                debugPoly = Config.Debug,
                minZ = j['coords'].z - 1,
                maxZ = j['coords'].z + 2,
                }, {
                    options = {
                    {
                        action = function()
                            drillLockers(k, i)
                        end,
                        icon = 'fas fa-wrench',
                        label = 'Drill!',
                        canInteract = function()
                            if v["onRob"] and not j['isBusy'] and not disableControl then
                                return true
                            end
                        end,
                    }
                },
                distance = 1.5,
            })
        end
        for a, b in pairs(Config.Banks[k]['computers']) do
            exports[Config.Target]:AddBoxZone("computers_fleeca"..a, vector3(b['coords'].x, b['coords'].y, b['coords'].z + 0.5), 0.2, 0.4, {
                name = "computers_fleeca"..a,
                heading = b['heading'],
                debugPoly = Config.Debug,
                minZ = b['coords'].z + 0.65,
                maxZ = b['coords'].z + 1.0,
                }, {
                    options = {
                    {
                        action = function()
                            decryptComputers(k, a)
                        end,
                        icon = 'fas fa-keyboard',
                        label = 'Decrypt!',
                        canInteract = function()
                            if not b['isBusy'] and not disableControl then
                                return true
                            end
                        end,
                    }
                },
                distance = 0.75,
            })
        end
    end
end)


CreateThread(function()
    while true do
        Wait(1)
        if disableControl then
            DisableAllControlActions(0)
            DisableControlAction(0, 37, true)
            DisableControlAction(0, 157, true)
            DisableControlAction(0, 158, true)
            DisableControlAction(0, 160, true)
            DisableControlAction(0, 164, true)
            DisableControlAction(0, 165, true)
            DisableControlAction(0, 159, true)

            EnableControlAction(0, 172, true)
            EnableControlAction(0, 173, true)
            EnableControlAction(0, 174, true)
            EnableControlAction(0, 175, true)

            EnableControlAction(0, 1, true)
            EnableControlAction(0, 2, true)
            EnableControlAction(0, 3, true)
            EnableControlAction(0, 4, true)
            EnableControlAction(0, 5, true)
            EnableControlAction(0, 6, true)
        end
        if not disableControl then
            Wait(2500)
        end
    end
end)