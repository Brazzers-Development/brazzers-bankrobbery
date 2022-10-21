local Translations = {
    error = {
        computer_lockdown = 'Computer has been locked down',
        missing_decrypter = 'You\'re missing a decrypter',
        missing_drill = 'You\'re missing a drill',
        missing_thermite = 'You\'re missing a thermite charge',
        enough_police = 'Not enough police available',
        bank_cooldown = 'Bank is not available',
        computer_cooldown = 'Computer has already been decrypted',
        missing_laptop = 'You\'re missing a laptop',
        recently_robbed = 'This bank has recently been robbed',
        unavailable = 'Unavailable',
        firstload_cooldown = 'This bank is not available yet',
        enough_crypto = 'Not enough crypto',
        missing_usbs = 'You don\'t have any usbs',
    },
    success = {
        vault_open = "%{value} minutes until vault opens",
    },
    info = {
        powerbox = 'Power Box',
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
