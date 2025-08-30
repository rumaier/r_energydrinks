---@diagnostic disable: undefined-global

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'r_energydrinks'
description 'A simple energy drink resource to give your players a boost!'
author 'r_scripts'
version '1.1.0'

shared_scripts {
  '@ox_lib/init.lua',
  'utils/shared.lua',
  'locales/*.lua',
  'configs/*.lua'
}

server_scripts {
  'utils/server.lua',
  'core/server/*.lua',
}

client_scripts {
  'utils/client.lua',
  'core/client/*.lua',
}

data_file 'DLC_ITYP_REQUEST' 'rscripts_junkcans.ytyp'

dependencies {
  'ox_lib',
  'r_bridge',
}

escrow_ignore {
  'install/**/*.*',
  'locales/*.*',
  'configs/*.lua',
}