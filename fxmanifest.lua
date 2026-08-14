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
}

server_scripts {
    'config.lua',
    'core/server/_util.lua',
    'core/server/main.lua',
}

client_scripts {
    'core/client/_util.lua',
    'core/client/main.lua',
}

ui_page 'web/dist/index.html'
files {
    'web/dist/index.html',
    'web/dist/**/*',
}

data_file 'DLC_ITYP_REQUEST' 'rscripts_junkcans.ytyp'

dependencies {
    'ox_lib',
    'r_bridge',
}

escrow_ignore {
    'install/**/*.*',
    'locales/*.*',
    'config.lua'
}
