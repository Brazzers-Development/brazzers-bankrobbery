Config = {}

-- GLOBAL CONFIG
Config.Debug = false
Config.Core = 'qb-core'
Config.Target = 'qb-target'
Config.Phone = 'qb-phone'
Config.Menu = 'qb-menu'

-- MINIMUM POLICE TO START A HEIST
Config.MinimumPolice = 0
-- AMOUNT OF ATTEMPTS TO HACK COMPUTER BEFORE IT LOCKS YOU OUT
Config.ComputerAttempts = 3
-- IF USING DECAY, WOULD YOU RATHER DECAY ITEMS INSTEAD OF REMOVING // YOU CAN ENABLE THAT HERE
Config.DegradeItem = false

-- [INFO]
-- ITEMS REQUIRED TO DO SPECIFIC HACKS
Config.Laptop = "greenlaptop" -- [GENERAL BANK HACK (SHAPES)]
Config.DrillItem = 'heavydutydrill' -- [DRILL HACK]
Config.ThermiteItem = 'thermitecharge' -- [THERMITE HACK]
Config.DecrypterItem = 'green_decrypter' -- [VAR HACK]

-- EARNINGS ITEMS
Config.MarkedBills = 'markedbills' -- [LOCKER & TROLLY REWARD]
Config.ComputerUSB = 'bank_usb' -- [DECRYPT COMPUTER REWARD]
Config.InkedBills = 'inkedbills' -- [RARE EARNING]

-- [INFO]
-- EARNINGS AMOUNT
Config.TrollyMarkedReward = math.random(95, 105) -- [EARNED FROM TROLLY]
Config.LockerMarkedReward = math.random(24, 26) -- [EARNED FROM DRILL/ LOCKERS]
Config.InkedBillReward = 1 -- [RARE SPECIAL ITEM AMOUNT]

-- [INFO]
-- EARNINGS FROM BANK USBS (YOU ARE REQUIRED TO HAVE RENEWED-PHONE FOR THIS)
Config.CryptoType = 'xcoin' -- TYPE OF CRYPTO [META NAME]
Config.CryptoReward = math.random(3, 7) -- AMOUNT EARNED PER USB

-- TIME IT TAKES THE VAULT TO OPEN AFTER SUCCESSFUL HACK
Config.VaultOpenTimer = 1 -- [TIME IN MINUTES]

-- GLOBAL COOL DOWN: THIS COOL DOWN IS THE GLOBAL COOL DOWN FOR ALL BANKS
-- IF 1 BANK IS BEING HIT, YOU WILL NOT BE ABLE TO HIT ANOTHER BANK FOR Config.GlobalCooldown MINUTES
Config.GlobalCooldown = 90 -- [YOU CAN DISABLE THIS WITH 0] [RECOMMENDED MINIMUM: 90 MINUTES]

-- FIRST LOAD COOL DOWN: THIS COOL DOWN RIGHT AFTER A SERVER RESTART/ SERVER LOAD
-- PLAYERS AFTER JOINING DIRECTLY FROM A SERVER RESTART WILL NOT BE ABLE TO HIT THE BANK FOR Config.FirstLoadCoolDown MINUTES
Config.FirstLoadCoolDown = 0 -- [YOU CAN DISABLE WITH 0] [RECOMMENDED MINIMUM: 60 MINUTES]

-- COMPUTER RESET WAIT COOL DOWN: THIS COOL DOWN IS INITIATED RIGHT WHEN YOU SUCCESSFULLY DECRYPT THE COMPUTER
-- PLAYERS WILL NOT BE ABLE TO HIT THE SAME COMPUTER FOR Config.ComputerResetWait MINUTES
Config.ComputerResetWait = 60 -- [RECOMMENDED MINIMUM: 60 MINUTES]

-- BANK RESET WAIT: THIS COOL DOWN IS INITIATED AFTER YOU PASS THE PANEL HACK FOR A BANK
-- THE BANK WILL RESET COMPLETELY AFTER Config.BankResetWait MINUTES ( AUTO CLOSE VAULT DOORS / PROP CLEANUP / INTERACTIONS RESET )
Config.BankResetWait = 180 -- [RECOMMENDED MINIMUM: 120 MINUTES]

-- CRIMINAL HUB

Config.Ped = 'a_m_m_soucent_02'
Config.PedLocation = vector4(-1617.8, -3013.02, -75.21, 85.77)

Config.CriminalHub = {
    ['green_decrypter'] = {
        ['name'] = 'Basic Decrypter',
        ['icon'] = 'fas fa-project-diagram',
        ['crypto'] = 'xcoin',
        ['cost'] = 2,
    },
    ['heavydutydrill'] = {
        ['name'] = 'Basic Drill',
        ['icon'] = 'fas fa-th',
        ['crypto'] = 'xcoin',
        ['cost'] = 5,
    },
    ['greenlaptop'] = {
        ['name'] = 'Green Laptop',
        ['icon'] = 'fas fa-laptop',
        ['crypto'] = 'xcoin',
        ['cost'] = 8,
    },
}

Config.Banks = {
    [1] = { -- Legion Square
        ['powerbox'] = { -- Main Interaction to get past preVault door [THERMITE]
            ['coords'] = vector3(135.87, -1045.76, 29.16), -- Coords
            ['heading'] = 341.79, -- Heading
            ['isBusy'] = false, -- DON'T TOUCH
        },
        ['panel'] = { -- Vault Panel/ Keypad [LAPTOP HACK]
            ['coords'] = vector3(146.74, -1046.28, 28.87), -- Coords
            ['heading'] = 159.16, -- Heading
        },
        ['behindCounter'] = { -- DOOR TO COMPUTER
            ['coords'] = vector3(145.29, -1041.22, 29.37), -- DOOR COORDS
            ['doorId'] = 117, -- DOOR ID 
        },
        ['postVault'] = { -- Inner Vault Door Before Trolly
            ['coords'] = vector3(148.47, -1046.57, 29.06), -- Coords
            ['heading'] = 159.05, -- Heading
            ['doorId'] = 119, -- Door ID
            ['isBusy'] = false, -- DON'T TOUCH
        },
        ['doors'] = { -- Vault Door/ Main Middle Bank Location
            ['startLoc'] = vector3(146.61, -1046.02, 29.37), -- Vault Door Coords
            ['animCoords'] = vector3(146.91, -1045.94, 29.37), -- Animation Coords for Panel
            ['animHeading'] = 159.8, -- Animation Heading for Panel
            ['vaultOpenHeading'] = 160.0, -- Vault Open Heading
            ['vaultCloseHeading'] = 250.0, -- Vault Close Heading
            ['locked'] = true, -- DON'T TOUCH
        },
        ['doorIds'] = { -- DOOR THAT OPENS AFTER THERMITE
            ['preVault'] = 118, -- Door ID 
        },
        ['computers'] = {
            [1] = {
                ['coords'] = vector3(151.0, -1042.17, 28.93),
                ['heading'] = 339.44,
                ['attempts'] = Config.ComputerAttempts,
                ['isBusy'] = false,
            },
            [2] = {
                ['coords'] = vector3(149.67, -1041.72, 28.93),
                ['heading'] = 339.44,
                ['attempts'] = Config.ComputerAttempts,
                ['isBusy'] = false,
            },
            [3] = {
                ['coords'] = vector3(148.44, -1041.2, 28.93),
                ['heading'] = 339.44,
                ['attempts'] = Config.ComputerAttempts,
                ['isBusy'] = false,
            },
            [4] = {
                ['coords'] = vector3(147.11, -1040.82, 28.93),
                ['heading'] = 339.44,
                ['attempts'] = Config.ComputerAttempts,
                ['isBusy'] = false,
            }
        },
        ['drills'] = { -- Dril Locations
            [1] = {
                ['coords'] = vector3(149.9, -1044.75, 29.03), -- Main Eye Interaction Coords
                ['drillCoords'] = vector3(149.64, -1045.49, 29.37), -- Drill Animation Coords
                ['heading'] = 339.66, -- Heading
                ['isBusy'] = false, -- DON'T TOUCH
            },
            [2] = {
                ['coords'] = vector3(151.49, -1046.82, 28.85),
                ['drillCoords'] = vector3(150.72, -1046.5, 29.37),
                ['heading'] = 250.98,
                ['isBusy'] = false,
            },
            [3] = {
                ['coords'] = vector3(150.62, -1049.96, 28.95),
                ['drillCoords'] = vector3(149.97, -1049.76, 29.37),
                ['heading'] = 250.98,
                ['isBusy'] = false,
            },
            [4] = {
                ['coords'] = vector3(147.95, -1051.03, 29.01),
                ['drillCoords'] = vector3(148.26, -1050.4, 29.37),
                ['heading'] = 162.98,
                ['isBusy'] = false,
            },
        },
        ['trolly'] = { -- Main Trolly Spawn
            ['coords'] = vector3(147.3, -1049.48, 29.37), -- Coords
            ['heading'] = 295.12, -- Heading
            ['isBusy'] = false, -- DON'T TOUCH
        },
        ['vaultModel'] = 'v_ilev_gb_vauldr', -- Bank Vault Door Model
        ['onRob'] = false, -- DON'T TOUCH
        ['lastRobbed'] = 0 -- DON'T TOUCH
    },
    [2] = { -- Hawick Ave
        ['powerbox'] = { -- Main Interaction to get past preVault door [THERMITE]
            ['coords'] = vector3(320.11, -315.96, 51.13), -- Coords
            ['heading'] = 163.98, -- Heading
            ['isBusy'] = false, -- DON'T TOUCH
        },
        ['panel'] = { -- Vault Panel/ Keypad [LAPTOP HACK]
            ['coords'] = vector3(311.11, -284.52, 53.66), -- Coords
            ['heading'] = 160.06, -- Heading
        },
        ['behindCounter'] = {
            ['coords'] = vector3(309.56, -279.55, 54.16),
            ['doorId'] = 120,
        },
        ['postVault'] = { -- Inner Vault Door Before Trolly
            ['coords'] = vector3(312.8, -284.94, 53.66), -- Coords
            ['heading'] = 159.59, -- Heading
            ['doorId'] = 122, -- Door ID
            ['isBusy'] = false, -- DON'T TOUCH
        },
        ['doors'] = { -- Vault Door/ Main Middle Bank Location
            ['startLoc'] = vector3(310.93, -284.44, 54.16), -- Vault Door Coords
            ['animCoords'] = vector3(311.2, -284.3, 54.16), -- Animation Coords for Panel
            ['animHeading'] = 164.16, -- Animation Heading for Panel
            ['vaultOpenHeading'] = 160.0, -- Vault Open Heading
            ['vaultCloseHeading'] = 250.0, -- Vault Close Heading
            ['locked'] = true, -- DON'T TOUCH
        },
        ['doorIds'] = {
            ['preVault'] = 121, -- Door ID
        },
        ['computers'] = {
            [5] = {
                ['coords'] = vector3(315.33, -280.55, 53.71),
                ['heading'] = 339.96,
                ['attempts'] = Config.ComputerAttempts,
                ['isBusy'] = false,
            },
            [6] = {
                ['coords'] = vector3(314.01, -280.05, 53.71),
                ['heading'] = 339.96,
                ['attempts'] = Config.ComputerAttempts,
                ['isBusy'] = false,
            },
            [7] = {
                ['coords'] = vector3(312.72, -279.68, 53.71),
                ['heading'] = 339.96,
                ['attempts'] = Config.ComputerAttempts,
                ['isBusy'] = false,
            },
            [8] = {
                ['coords'] = vector3(311.47, -279.16, 53.71),
                ['heading'] = 339.96,
                ['attempts'] = Config.ComputerAttempts,
                ['isBusy'] = false,
            }
        },
        ['drills'] = { -- Dril Locations
            [5] = {
                ['coords'] = vector3(314.23, -283.03, 53.77), -- Main Eye Interaction Coords
                ['drillCoords'] = vector3(313.9, -283.71, 54.16), -- Drill Animation Coords
                ['heading'] = 340.23, -- Heading
                ['isBusy'] = false, -- DON'T TOUCH
            },
            [6] = {
                ['coords'] = vector3(316.04, -285.18, 53.71),
                ['drillCoords'] = vector3(315.2, -284.88, 54.16),
                ['heading'] = 250.09,
                ['isBusy'] = false,
            },
            [7] = {
                ['coords'] = vector3(315.11, -288.36, 53.8),
                ['drillCoords'] = vector3(314.54, -288.1, 54.16),
                ['heading'] = 250.09,
                ['isBusy'] = false,
            },
            [8] = {
                ['coords'] = vector3(312.26, -289.64, 53.72),
                ['drillCoords'] = vector3(312.61, -288.73, 54.16),
                ['heading'] = 157.65,
                ['isBusy'] = false,
            },
        },
        ['trolly'] = { -- Main Trolly Spawn
            ['coords'] = vector3(311.5, -288.02, 54.16), -- Coords
            ['heading'] = 296.38, -- Heading
            ['isBusy'] = false, -- DON'T TOUCH
        },
        ['vaultModel'] = 'v_ilev_gb_vauldr', -- Bank Vault Door Model
        ['onRob'] = false, -- DON'T TOUCH
        ['lastRobbed'] = 0 -- DON'T TOUCH
    },
    [3] = { -- Hawick Ave #2
        ['powerbox'] = { -- Main Interaction to get past preVault door [THERMITE]
            ['coords'] = vector3(-356.16, -49.98, 54.42), -- Coords
            ['heading'] = 163.98, -- Heading
            ['isBusy'] = false, -- DON'T TOUCH
        },
        ['panel'] = { -- Vault Panel/ Keypad [LAPTOP HACK]
            ['coords'] = vector3(-353.98, -55.54, 48.55), -- Coords
            ['heading'] = 160.31, -- Heading
        },
        ['behindCounter'] = {
            ['coords'] = vector3(-355.52, -50.54, 49.04),
            ['doorId'] = 123,
        },
        ['postVault'] = { -- Inner Vault Door Before Trolly
            ['coords'] = vector3(-352.24, -55.82, 48.55), -- Decrypter Coords
            ['heading'] = 160.31, -- Heading
            ['doorId'] = 125, -- Door ID
            ['isBusy'] = false, -- DON'T TOUCH
        },
        ['doors'] = { -- Vault Door/ Main Middle Bank Location
            ['startLoc'] = vector3(-354.15, -55.11, 49.04), -- Vault Door Coords
            ['animCoords'] = vector3(-353.88, -55.15, 49.04), -- Animation Coords for Panel
            ['animHeading'] = 161.75, -- Animation Heading for Panel
            ['vaultOpenHeading'] = 160.0, -- Vault Open Heading
            ['vaultCloseHeading'] = 250.0, -- Vault Close Heading
            ['locked'] = true, -- DON'T TOUCH
        },
        ['doorIds'] = {
            ['preVault'] = 124, -- Door ID
        },
        ['computers'] = {
            [9] = {
                ['coords'] = vector3(-349.8, -51.37, 48.57),
                ['heading'] = 340.39,
                ['attempts'] = Config.ComputerAttempts,
                ['isBusy'] = false,
            },
            [10] = {
                ['coords'] = vector3(-351.12, -50.90, 48.57),
                ['heading'] = 340.39,
                ['attempts'] = Config.ComputerAttempts,
                ['isBusy'] = false,
            },
            [11] = {
                ['coords'] = vector3(-352.38, -50.5, 48.57),
                ['heading'] = 340.39,
                ['attempts'] = Config.ComputerAttempts,
                ['isBusy'] = false,
            },
            [12] = {
                ['coords'] = vector3(-353.76, -50.0, 48.57),
                ['heading'] = 340.39,
                ['attempts'] = Config.ComputerAttempts,
                ['isBusy'] = false,
            }
        },
        ['drills'] = { -- Dril Locations
            [9] = {
                ['coords'] = vector3(-350.87, -53.83, 48.55), -- Main Eye Interaction Coords
                ['drillCoords'] = vector3(-351.14, -54.51, 49.04), -- Drill Animation Coords
                ['heading'] = 342.23, -- Heading
                ['isBusy'] = false, -- DON'T TOUCH
            },
            [10] = {
                ['coords'] = vector3(-349.41, -55.84, 48.55),
                ['drillCoords'] = vector3(-349.92, -55.56, 49.04),
                ['heading'] = 251.25,
                ['isBusy'] = false,
            },
            [11] = {
                ['coords'] = vector3(-349.96, -59.12, 48.55),
                ['drillCoords'] = vector3(-350.53, -58.9, 49.04),
                ['heading'] = 248.1,
                ['isBusy'] = false,
            },
            [12] = {
                ['coords'] = vector3(-352.67, -60.37, 48.55),
                ['drillCoords'] = vector3(-352.4, -59.51, 49.04),
                ['heading'] = 162.32,
                ['isBusy'] = false,
            },
        },
        ['trolly'] = { -- Main Trolly Spawn
            ['coords'] = vector3(-353.74, -58.99, 49.04), -- Coords
            ['heading'] = 298.63, -- Heading
            ['isBusy'] = false, -- DON'T TOUCH
        },
        ['vaultModel'] = 'v_ilev_gb_vauldr', -- Bank Vault Door Model
        ['onRob'] = false, -- DON'T TOUCH
        ['lastRobbed'] = 0 -- DON'T TOUCH
    },
    [4] = { -- Hawick Ave #3
        ['powerbox'] = { -- Main Interaction to get past preVault door [THERMITE]
            ['coords'] = vector3(-1231.43, -327.27, 37.4), -- Coords
            ['heading'] = 119.09, -- Heading
            ['isBusy'] = false, -- DON'T TOUCH
        },
        ['panel'] = { -- Vault Panel/ Keypad [LAPTOP HACK]
            ['coords'] = vector3(-1210.77, -336.7, 37.33), -- Coords
            ['heading'] = 206.92, -- Heading
        },
        ['behindCounter'] = {
            ['coords'] = vector3(-1215.37, -334.46, 37.78),
            ['doorId'] = 126,
        },
        ['postVault'] = { -- Inner Vault Door Before Trolly
            ['coords'] = vector3(-1209.34, -335.74, 37.33), -- Decrypter Coords
            ['heading'] = 206.92, -- Heading
            ['doorId'] = 128, -- Door ID
            ['isBusy'] = false, -- DON'T TOUCH
        },
        ['doors'] = { -- Vault Door/ Main Middle Bank Location
            ['startLoc'] = vector3(-1211.07, -336.68, 37.78), -- Vault Door Coords
            ['animCoords'] = vector3(-1210.95, -336.35, 37.78), -- Animation Coords for Panel
            ['animHeading'] = 206.4, -- Animation Heading for Panel
            ['vaultOpenHeading'] = 206.863, -- Vault Open Heading
            ['vaultCloseHeading'] = 296.863, -- Vault Close Heading
            ['locked'] = true, -- DON'T TOUCH
        },
        ['doorIds'] = {
            ['preVault'] = 127, -- Door ID
        },
        ['computers'] = {
            [13] = {
                ['coords'] = vector3(-1210.78, -330.91, 37.33),
                ['heading'] = 27.22,
                ['attempts'] = Config.ComputerAttempts,
                ['isBusy'] = false,
            },
            [14] = {
                ['coords'] = vector3(-1212.03, -331.58, 37.33),
                ['heading'] = 27.22,
                ['attempts'] = Config.ComputerAttempts,
                ['isBusy'] = false,
            },
            [15] = {
                ['coords'] = vector3(-1213.28, -332.13, 37.33),
                ['heading'] = 27.22,
                ['attempts'] = Config.ComputerAttempts,
                ['isBusy'] = false,
            },
            [16] = {
                ['coords'] = vector3(-1214.52, -332.77, 37.33),
                ['heading'] = 27.22,
                ['attempts'] = Config.ComputerAttempts,
                ['isBusy'] = false,
            }
        },
        ['drills'] = { -- Dril Locations
            [13] = {
                ['coords'] = vector3(-1209.72, -333.48, 37.33), -- Main Eye Interaction Coords
                ['drillCoords'] = vector3(-1209.48, -334.02, 37.78), -- Drill Animation Coords
                ['heading'] = 26.56, -- Heading
                ['isBusy'] = false, -- DON'T TOUCH
            },
            [14] = {
                ['coords'] = vector3(-1207.28, -333.72, 37.33),
                ['drillCoords'] = vector3(-1207.72, -333.88, 37.78),
                ['heading'] = 297.29,
                ['isBusy'] = false,
            },
            [15] = {
                ['coords'] = vector3(-1205.34, -336.42, 37.56),
                ['drillCoords'] = vector3(-1205.81, -336.63, 37.78),
                ['heading'] = 296.01,
                ['isBusy'] = false,
            },
            [16] = {
                ['coords'] = vector3(-1206.43, -339.01, 37.44),
                ['drillCoords'] = vector3(-1206.73, -338.45, 37.78),
                ['heading'] = 206.93,
                ['isBusy'] = false,
            },
        },
        ['trolly'] = { -- Main Trolly Spawn
            ['coords'] = vector3(-1208.06, -339.03, 37.78), -- Coords
            ['heading'] = 341.97, -- Heading
            ['isBusy'] = false, -- DON'T TOUCH
        },
        ['vaultModel'] = 'v_ilev_gb_vauldr', -- Bank Vault Door Model
        ['onRob'] = false, -- DON'T TOUCH
        ['lastRobbed'] = 0 -- DON'T TOUCH
    },
    [5] = { -- Great Ocean Bank
        ['powerbox'] = { -- Main Interaction to get past preVault door [THERMITE]
            ['coords'] = vector3(-2947.66, 481.21, 15.44), -- Coords
            ['heading'] = 176.66, -- Heading
            ['isBusy'] = false, -- DON'T TOUCH
        },
        ['panel'] = { -- Vault Panel/ Keypad [LAPTOP HACK]
            ['coords'] = vector3(-2956.44, 481.63, 15.25), -- Coords
            ['heading'] = 267.8, -- Heading
        },
        ['behindCounter'] = {
            ['coords'] = vector3(-2960.65, 478.72, 15.7),
            ['doorId'] = 129,
        },
        ['postVault'] = { -- Inner Vault Door Before Trolly
            ['coords'] = vector3(-2956.65, 483.39, 15.25), -- Decrypter Coords
            ['heading'] = 267.8, -- Heading
            ['doorId'] = 131, -- Door ID
            ['isBusy'] = false, -- DON'T TOUCH
        },
        ['doors'] = { -- Vault Door/ Main Middle Bank Location
            ['startLoc'] = vector3(-2956.68, 481.34, 15.70), -- Vault Door Coords
            ['animCoords'] = vector3(-2956.7, 481.66, 15.7), -- Animation Coords for Panel
            ['animHeading'] = 268.44, -- Animation Heading for Panel
            ['vaultOpenHeading'] = 267.542, -- Vault Open Heading
            ['vaultCloseHeading'] = 357.542, -- Vault Close Heading
            ['locked'] = true, -- DON'T TOUCH
        },
        ['doorIds'] = {
            ['preVault'] = 130, -- Door ID
        },
        ['computers'] = {
            [17] = {
                ['coords'] = vector3(-2961.52, 484.44, 15.23),
                ['heading'] = 87.15,
                ['attempts'] = Config.ComputerAttempts,
                ['isBusy'] = false,
            },
            [18] = {
                ['coords'] = vector3(-2961.6, 483.07, 15.23),
                ['heading'] = 87.15,
                ['attempts'] = Config.ComputerAttempts,
                ['isBusy'] = false,
            },
            [19] = {
                ['coords'] = vector3(-2961.62, 481.73, 15.23),
                ['heading'] = 87.15,
                ['attempts'] = Config.ComputerAttempts,
                ['isBusy'] = false,
            },
            [20] = {
                ['coords'] = vector3(-2961.66, 480.29, 15.23),
                ['heading'] = 87.15,
                ['attempts'] = Config.ComputerAttempts,
                ['isBusy'] = false,
            }
        },
        ['drills'] = { -- Dril Locations
            [17] = {
                ['coords'] = vector3(-2958.7, 484.23, 15.25), -- Main Eye Interaction Coords
                ['drillCoords'] = vector3(-2958.19, 484.09, 15.7), -- Drill Animation Coords
                ['heading'] = 87.09, -- Heading
                ['isBusy'] = false, -- DON'T TOUCH
            },
            [18] = {
                ['coords'] = vector3(-2957.38, 486.08, 15.25),
                ['drillCoords'] = vector3(-2957.5, 485.57, 15.7),
                ['heading'] = 358.85,
                ['isBusy'] = false,
            },
            [19] = {
                ['coords'] = vector3(-2954.04, 486.57, 15.25),
                ['drillCoords'] = vector3(-2954.13, 486.04, 15.7),
                ['heading'] = 358.85,
                ['isBusy'] = false,
            },
            [20] = {
                ['coords'] = vector3(-2952.12, 484.27, 15.25),
                ['drillCoords'] = vector3(-2952.84, 484.39, 15.7),
                ['heading'] = 270.49,
                ['isBusy'] = false,
            },
        },
        ['trolly'] = { -- Main Trolly Spawn
            ['coords'] = vector3(-2953.09, 482.88, 15.7), -- Coords
            ['heading'] = 40.21, -- Heading
            ['isBusy'] = false, -- DON'T TOUCH
        },
        ['vaultModel'] = 'v_ilev_gb_vauldr', -- Bank Vault Door Model
        ['onRob'] = false, -- DON'T TOUCH
        ['lastRobbed'] = 0 -- DON'T TOUCH
    },
    [6] = { -- Harmony Bank
        ['powerbox'] = { -- Main Interaction to get past preVault door [THERMITE]
            ['coords'] = vector3(1157.73, 2708.97, 37.98), -- Coords
            ['heading'] = 2.71, -- Heading
            ['isBusy'] = false, -- DON'T TOUCH
        },
        ['panel'] = { -- Vault Panel/ Keypad [LAPTOP HACK]
            ['coords'] = vector3(1176.08, 2713.19, 37.58), -- Coords
            ['heading'] = 359.42, -- Heading
        },
        ['behindCounter'] = {
            ['coords'] = vector3(1179.16, 2708.85, 38.09),
            ['doorId'] = 132,
        },
        ['postVault'] = { -- Inner Vault Door Before Trolly
            ['coords'] = vector3(1174.36, 2712.92, 37.58), -- Decrypter Coords
            ['heading'] = 359.42, -- Heading
            ['doorId'] = 134, -- Door ID
            ['isBusy'] = false, -- DON'T TOUCH
        },
        ['doors'] = { -- Vault Door/ Main Middle Bank Location
            ['startLoc'] = vector3(1176.40, 2712.75, 38.09), -- Vault Door Coords
            ['animCoords'] = vector3(1176.08, 2712.78, 38.09), -- Animation Coords for Panel
            ['animHeading'] = 1.16, -- Animation Heading for Panel
            ['vaultOpenHeading'] = -270.542, -- Vault Open Heading
            ['vaultCloseHeading'] = -370.542, -- Vault Close Heading
            ['locked'] = true, -- DON'T TOUCH
        },
        ['doorIds'] = {
            ['preVault'] = 133, -- Door ID
        },
        ['computers'] = {
            [21] = {
                ['coords'] = vector3(1173.47, 2707.80, 37.56),
                ['heading'] = 179.29,
                ['attempts'] = Config.ComputerAttempts,
                ['isBusy'] = false,
            },
            [22] = {
                ['coords'] = vector3(1174.85, 2707.83, 37.56),
                ['heading'] = 179.29,
                ['attempts'] = Config.ComputerAttempts,
                ['isBusy'] = false,
            },
            [23] = {
                ['coords'] = vector3(1176.2, 2707.80, 37.56),
                ['heading'] = 179.29,
                ['attempts'] = Config.ComputerAttempts,
                ['isBusy'] = false,
            },
            [24] = {
                ['coords'] = vector3(1177.63, 2707.80, 37.56),
                ['heading'] = 179.29,
                ['attempts'] = Config.ComputerAttempts,
                ['isBusy'] = false,
            }
        },
        ['drills'] = { -- Dril Locations
            [21] = {
                ['coords'] = vector3(1173.7, 2710.56, 37.58), -- Main Eye Interaction Coords
                ['drillCoords'] = vector3(1173.8, 2711.15, 38.09), -- Drill Animation Coords
                ['heading'] = 180.41, -- Heading
                ['isBusy'] = false, -- DON'T TOUCH
            },
            [22] = {
                ['coords'] = vector3(1171.43, 2711.87, 37.58),
                ['drillCoords'] = vector3(1172.1, 2711.77, 38.09),
                ['heading'] = 88.79,
                ['isBusy'] = false,
            },
            [23] = {
                ['coords'] = vector3(1170.87, 2715.16, 37.58),
                ['drillCoords'] = vector3(1171.6, 2715.05, 38.09),
                ['heading'] = 88.79,
                ['isBusy'] = false,
            },
            [24] = {
                ['coords'] = vector3(1173.24, 2717.1, 37.57),
                ['drillCoords'] = vector3(1173.22, 2716.38, 38.09),
                ['heading'] = 359.72,
                ['isBusy'] = false,
            },
        },
        ['trolly'] = { -- Main Trolly Spawn
            ['coords'] = vector3(1174.65, 2716.27, 38.09), -- Coords
            ['heading'] = 135.04, -- Heading
            ['isBusy'] = false, -- DON'T TOUCH
        },
        ['vaultModel'] = 'v_ilev_gb_vauldr', -- Bank Vault Door Model
        ['onRob'] = false, -- DON'T TOUCH
        ['lastRobbed'] = 0 -- DON'T TOUCH
    },
}