---@diagnostic disable: undefined-global
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'base'
description 'base for r_scripts resources'
author 'r_scripts'
version '1.0.0'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'bridge/**/server.lua',
    'server/*.lua',
}

client_scripts {
    'bridge/**/client.lua',
    'client/*.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
    'locales/*.lua',
    'shared/*.lua',
    'config.lua',
}

dependencies {
    'ox_lib',
}

escrow_ignore {
    'bridge/**/*.lua',
    'locales/*.lua',
    'config.lua' 
}