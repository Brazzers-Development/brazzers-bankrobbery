QBCore = exports[Config.Core]:GetCoreObject()

-- [INFO] --
-- Alert the police based off specific actions
function alertPolice(alertType)
    if alertType == 'securitydoor' then
        -- Call Type: Security Disturbance
        -- [INFO]
        -- You lock picked the door to the computers and received this alert
        -- Due to spam, the alert is one time on the lockpick of the door and not each computer attempt for each computer
    elseif alertType == 'thermite' then
        -- Call Type: Power Disturbance
        -- [INFO]
        -- You just thermited the power, the alert will trigger on success and fail
    elseif alertType == 'vault' then
        -- Call Type: Vault Hacked ( Only works on success attempts )
        -- [INFO]
        -- You just successfully hacked the panel to get pass the main door
    end
end

-- [INFO]
-- YOU CAN ADD ANYMORE POLICE JOBS HERE TO GIVE YOU ACCESS TO THE VAULT PANEL
function isPolice()
    local PlayerData = QBCore.Functions.GetPlayerData()
    if (PlayerData.job.name == 'police') and PlayerData.job.onduty then
        return true
    end
end

-- [INFO] --
-- Item used for this hack: Config.ThermiteItem
-- This minigame is for thermiting the powerbox to unlock the door to access the bank panel
function doThermiteOnPowerBox(bank)
    CreateThread(function()
        local ped = PlayerPedId()
        local loc = GetEntityCoords(ped)
        RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
        RequestModel("hei_p_m_bag_var22_arm_s")
        while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") and not HasModelLoaded("hei_p_m_bag_var22_arm_s") do
        Wait(0)
        end
        SetEntityHeading(ped, GetEntityHeading(ped))
        Wait(100)
        local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(PlayerPedId())))
        local bagscene = NetworkCreateSynchronisedScene(loc.x, loc.y, loc.z, rotx, roty, rotz + 0.0, 2, false, false, 1065353216, 0, 1.3)
        local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), loc.x, loc.y, loc.z,  true,  true, false)
        SetEntityCollision(bag, false, true)
        NetworkAddPedToSynchronisedScene(ped, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.5, -4.0, 1, 16, 1148846080, 0)
        NetworkAddEntityToSynchronisedScene(bag, bagscene, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge", 4.0, -8.0, 1)
        if GetEntityModel(PlayerPedId()) then
        GetPedDrawableVariation(ped, 5)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        end
        NetworkStartSynchronisedScene(bagscene)
        Wait(1500)
        local x, y, z = Config.Banks[bank]['powerbox']['coords'].x, Config.Banks[bank]['powerbox']['coords'].y, Config.Banks[bank]['powerbox']['coords'].z
        local bomba = CreateObject(GetHashKey("hei_prop_heist_thermite"), x, y, z + 0.2,  true,  true, true)
        SetEntityCollision(bomba, false, true)
        AttachEntityToEntity(bomba, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
        Wait(4000)
        DeleteObject(bag)
        DetachEntity(bomba, 1, 1)
        FreezeEntityPosition(bomba, true)
        NetworkStopSynchronisedScene(bagscene)

        exports['ps-ui']:Thermite(function(success)
            if success then
                thermiteSuccess(bank)
                    
                TriggerServerEvent("brazzers-bankrobbery:server:ptfx", x, y, z)
                SetPtfxAssetNextCall("scr_ornate_heist")
                TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, 0, 0, 0)
                TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, 8.0, 6000, 49, 1, 0, 0, 0)
                Wait(2000)
                ClearPedTasks(ped)
                Wait(2000)
                DeleteObject(bomba)
            else
                thermiteFail()
                ClearPedTasks(ped)
                DeleteObject(bomba)
            end
        end, 10, 5, 3) -- Time, Gridsize (5, 6, 7, 8, 9, 10), IncorrectBlocks  
    end)
end

-- [INFO] --
-- Item used for this hack: No item required. If you would like to add an item requirement, simply use the function provided above
-- This minigame is for decrypting the computers at the front of the bank
function doDecryptionOnComputers(bank, computer)
    --if not hasItem('whateveritemyouwanthere') then return false end
    local chance = math.random(1, 4)
    if chance == 1 then shit = 'alphanumeric' elseif chance == 2 then shit = 'greek' elseif chance == 3 then shit = 'numeric' elseif chance == 4 then shit = 'alphabet' end

    exports['ps-ui']:Scrambler(function(success)
        if success then
            decryptComputersResult('passed', bank, computer) -- [DO NOT CHANGE THIS]
        else
            decryptComputersResult('failed', bank, computer) -- [DO NOT CHANGE THIS]
        end
    end, 'alphanumeric', 20, 0) -- Type (alphabet, numeric, alphanumeric, greek, braille, runes), Time (Seconds), Mirrored (0: Normal, 1: Normal + Mirrored 2: Mirrored only )
end

-- [INFO] --
-- Item used for this hack: Config.DecrypterItem
-- This minigame is after the vault opens. This is to get pass the gate and give access to the trolly
function doPostVaultHack(bank)
    exports['ps-ui']:VarHack(function(success)
        if not success then return decryptPostVaultResult('failed', bank) end
        decryptPostVaultResult('passed', bank)
    end, 5, 5) -- Number of Blocks, Time (seconds)
end

-- [INFO] --
-- Item used for this hack: lockpick/ advancedlockpick
-- Events used: "lockpicks:UseLockpick" // Global event for lockpicks
-- This minigame is for hacking through the door to get to the computers
function doLockpickOnDoor(doorId)
    local success = exports['qb-lock']:StartLockPickCircle(1, math.random(40, 60))
    if not success then return lockpickResult('failed', doorId) end
    lockpickResult('passed', doorId)
end

-- [INFO] --
-- Item used for this hack: Config.Laptop
-- This hack is the main panel hack to get pass the vault door
function doBankPadHack(bankId)
    exports['NoPixel-minigame']:OpenHackingGame(function(success)
        if not success then return bankPadResult('failed', bankId) end
        bankPadResult('passed', bankId)
    end)
end

-- [INFO] --
-- Input your doorlock event here ( the door id is used as `doorId`)
function toggleDoorlock(doorId)
    TriggerServerEvent('qb-doorlock:server:updateState', doorId, false, false, false, true)
end

-- [CRIMINAL HUB]

local function tradeInUsbs()
    if not hasItem(Config.ComputerUSB) then QBCore.Functions.Notify(Lang:t("error.missing_usbs"), "error", 5000) end
    TriggerServerEvent('brazzers-bankrobbery:server:tradeInUSBs')
end

RegisterNetEvent('brazzers-bankrobbery:client:xcoinBuyer', function()
    local menu = {
        {
            header = 'Criminal Hub',
            isMenuHeader = true,
        },
    }

    for k, v in pairs(Config.CriminalHub) do
        menu[#menu+1] = {
            header = v['name'],
            txt = 'Cost: '..v['cost']..' '..v['crypto'],
            icon = v['icon'],
            params = {
                isServer = true,
                event = "brazzers-bankrobbery:server:purchaseFromBuyer",
                args = {
                    crypto = v['crypto'],
                    amount = v['cost'],
                    item = k,
                }
            }
        }
    end
    exports[Config.Menu]:openMenu(menu)
end)

-- CRIMINAL HUB PED

exports[Config.Target]:SpawnPed({
    model = Config.Ped,
    coords = Config.PedLocation,
    minusOne = true,
    freeze = true,
    invincible = true,
    blockevents = true,
    scenario = 'WORLD_HUMAN_GUARD_STAND',
    target = {
        options = {
            {
                type = "client",
                event = "brazzers-bankrobbery:client:xcoinBuyer",
                icon = "fas fa-comment",
                label = "Talk",
            }
        },
        distance = 2.5,
    },
})

-- THREADS

CreateThread(function()
    exports[Config.Target]:AddBoxZone("tradein_usb", vector3(-1620.10, -3010.48, -75.30), 0.2, 0.4, {
        name = "tradein_usb",
        heading = 49.15,
        debugPoly = false,
        minZ = -75.30 - 0.65,
        maxZ = -75.30,
        }, {
            options = {
            {
                action = function()
                    tradeInUsbs()
                end,
                icon = 'fas fa-plug',
                label = 'Trade in USBs!',
            }
        },
        distance = 1.0,
    })
end)

CreateThread(function()
    local powerPoly = {}
    for k, v in pairs(Config.Banks) do
        powerPoly[#powerPoly+1] = BoxZone:Create(vector3(vector3(v['powerbox']['coords'].x, v['powerbox']['coords'].y, v['powerbox']['coords'].z)), 2.5, 1, {
            name="powerbox"..k,
            debugPoly = Config.Debug,
            heading = v['powerbox']['heading'],
            minZ = v['powerbox']['coords'].z - 2,
            maxZ = v['powerbox']['coords'].z + 2,
        })
    end

    local signCombo = ComboZone:Create(powerPoly, {name = "powerbox", debugPoly = Config.Debug})
    signCombo:onPlayerInOut(function(isPointInside)
        if isPointInside then
            exports[Config.Core]:DrawText(Lang:t("info.powerbox"), 'left')
        else
            exports[Config.Core]:HideText()
        end
    end)
end)