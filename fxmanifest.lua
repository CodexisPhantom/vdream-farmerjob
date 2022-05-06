fx_version 'cerulean'
game 'gta5'

lua54 'yes'

shared_scripts { 
	'config.lua'
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/job.lua',
    'client/wheat.lua',
    'client/tomato.lua',
    'client/delivery.lua',
	'config.lua'
}

server_scripts {
    "server/wheat.lua",
    "server/tomato.lua",
    "server/delivery.lua",
    "config.lua",
}