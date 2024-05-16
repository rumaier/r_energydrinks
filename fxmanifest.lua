---@diagnostic disable: undefined-global
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'r_energydrinks'
description 'A simple energy drink resource to give your players a boost!'
author 'r_scripts'
version '1.0.1'

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

data_file 'DLC_ITYP_REQUEST' 'rscripts_junkcans.ytyp'

dependencies {
    'ox_lib',
}

escrow_ignore {
    'bridge/**/*.lua',
    'locales/*.lua',
    'config.lua' 
}