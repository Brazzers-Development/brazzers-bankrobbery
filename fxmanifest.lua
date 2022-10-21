fx_version "cerulean"
game "gta5"

name "Brazzers Bank Robberies"
author "Brazzers Development | MannyOnBrazzers#6826"
version "1.0"

lua54 'yes'

client_scripts {
    "client/*.lua",
    '@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/ComboZone.lua',
}

server_scripts {
    "server/*.lua", 
}

shared_scripts {
	'@5life-core/shared/locale.lua',
	'locales/*.lua',
	'shared/*.lua',
}

escrow_ignore {
    'client/open.lua',
    'server/open.lua',
    'shared.lua',
}