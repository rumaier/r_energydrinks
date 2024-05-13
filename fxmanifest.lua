---@diagnostic disable: undefined-global
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'r_energydrinks'
description 'A simple energy drink resource to give your players a boost!'
author 'r_scripts'
version '0.9.6'

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

files {
    'assets/images/*.png',
}

dependencies {
    'ox_lib',
}

escrow_ignore {
    'bridge/**/*.lua',
    'locales/*.lua',
    'config.lua' 
}