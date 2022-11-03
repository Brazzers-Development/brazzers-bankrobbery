![Brazzers Development Discord](https://i.imgur.com/nXhPxIO.png)

<details>
    <summary><b>Important Links</b></summary>
        <p>
            <a href="https://discord.gg/J7EH9f9Bp3">
                <img alt="GitHub" src="https://logos-download.com/wp-content/uploads/2021/01/Discord_Logo_full.png"
                width="150" height="55">
            </a>
        </p>
        <p>
            <a href="https://ko-fi.com/mannyonbrazzers">
                <img alt="GitHub" src="https://uploads-ssl.webflow.com/5c14e387dab576fe667689cf/61e11149b3af2ee970bb8ead_Ko-fi_logo.png"
                width="150" height="55">
            </a>
        </p>
</details>

# Installation steps

## General Setup
Simply remove all other conflicting bank robbery scripts within Fleeca Banks. Drag and drop brazzers-bankrobbery into your resource folder.

DO NOT rename any file contents for installation. The script is using CFX Escrow System and will not work if your file is renamed.

Navigate to shared/shared.lua file and modify your config. Each config is unique to each user. Carefully read the notes provided for each option
and modify the values to your needs.

YOU WILL need to modify the doorIds for each door at each bank to your servers door Ids. If you use qb-doorlocks I have provided a doorlock file for all doorlocks needed for GabZ Fleeca. This will give you a jump start for those doorIds

## How to get doorIds ?
Simply use this snippet for qb-doorlock replace with your toggledoorlock command ( when unlocking the door, it will produce the doorid in F8 )
```lua
RegisterCommand('toggledoorlock', function()
    if not closestDoor.data or not next(closestDoor.data) then return end

    local distanceCheck = closestDoor.distance > (closestDoor.data.distance or closestDoor.data.maxDistance)
    local unlockableCheck = (closestDoor.data.cantUnlock and closestDoor.data.locked)
    local busyCheck = PlayerData.metadata['isdead'] or PlayerData.metadata['inlaststand'] or PlayerData.metadata['ishandcuffed']
    if distanceCheck or unlockableCheck or busyCheck then return end

    playerPed = PlayerPedId()
    local veh = GetVehiclePedIsIn(playerPed)
    if veh then
        CreateThread(function()
            local siren = IsVehicleSirenOn(veh)
            for _ = 0, 100 do
                DisableControlAction(0, 86, true)
                SetHornEnabled(veh, false)
                if not siren then SetVehicleSiren(veh, false) end
                Wait(0)
            end
            SetHornEnabled(veh, true)
        end)
    end
    local locked = not closestDoor.data.locked
    local src = false
    if closestDoor.data.audioRemote then src = NetworkGetNetworkIdFromEntity(playerPed) end
    print(closestDoor.id) -- Print Door ID in F8
    TriggerServerEvent('qb-doorlock:server:updateState', closestDoor.id, locked, src, false, false, true, true) -- Broadcast new state of the door to everyone
end, false)
TriggerEvent("chat:removeSuggestion", "/toggledoorlock")
RegisterKeyMapping('toggledoorlock', Lang:t("general.keymapping_description"), 'keyboard', 'E')
```

## Features
1. CFX Escrow System ( Encrypted Resource ) [Open Client/ Open Server/ Locale / and Config Open]
2. Low MS (0.00 Idle | 0.00-0.01 In Use)
3. Dynamic Animations
4. Secured Net Events ( Dropping modders on triggered events ) ( Distance checks )
5. Multi-Language Support using QBCore Locales
6. Changeable Locations/ Interactions in Config ( Ability to change for all types of maps )
7. Changeable Mini Games
8. Tsunami Cool downs ( Not allowing players to rob right after server restart )
9. Unique Criminal Hub Utilizing Renewed Phone Crypto System
10. Synced Vault Animations
11. 24/7 Support in discord

Preview: 

## Dependencies
1. GabZ Fleeca Bank [All interaction locations can be changed. This is not dependent, but will require you to change interaction locations in the config for any other map]

2. PolyZone (https://github.com/mkafrin/PolyZone) [Used for powerbox zones]
3. qb-target (https://github.com/qbcore-framework/qb-target) [This is for interaction locations]
4. qb-doorlock (https://github.com/qbcore-framework/qb-doorlock) [This can be changed in the config to utilize any other doorlock system]
5. ps-ui (https://github.com/Project-Sloth/ps-ui) [This is for the mini games which can be changed in the open client]
6. NoPixel-minigame (https://github.com/Jesper-Hustad/NoPixel-minigame) [This is for the panel hack to open the main vault door]
7. fivem-drilling (https://github.com/meta-hub/fivem-drilling) [Mini game used for drilling]
8. prime-elevator (https://github.com/Prime-Script/prime-elevator) [Script used in the video. This is the elevator script to reach the Criminal Hub location]
9. qb-lock (https://github.com/Nathan-FiveM/qb-lock) [Lockpick minigame for lock picking the door to get into the computer area]