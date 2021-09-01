fx_version 'cerulean'
game 'gta5'
author 'Nekix for BellaCiao Roleplay'

shared_scripts {
    'shared/*.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/*.lua'
}