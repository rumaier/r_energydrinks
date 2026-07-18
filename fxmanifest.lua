---@diagnostic disable: undefined-global
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'r_energydrinks'
description 'A simple energy drink resource for FiveM.'
author 'r_scripts'
version '2.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    '@r_bridge/init.lua',
    'core/shared/*.lua',
    'locales/*.lua',
    'config.lua',
}

server_scripts {
    'core/server/*.lua',
}

client_scripts {
    'core/client/*.lua',
}

ui_page 'web/dist/index.html'
files {
    'web/dist/index.html',
    'web/dist/**/*',
}

data_file 'DLC_ITYP_REQUEST' 'rscripts_junkcans.ytyp'

dependencies {
    'r_bridge'
}

escrow_ignore {
    'install/**/*.*',
    'locales/*.*',
    'config.lua'    
}