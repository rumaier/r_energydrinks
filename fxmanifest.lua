---@diagnostic disable: undefined-global

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'resource-name'
description 'fivem-react-mantine'
author 'rumaier'
version '1.0.0'

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

dependencies {
  'ox_lib',
  'r_bridge',
}

escrow_ignore {
  'install/**/*.*',
  'locales/*.*',
  'configs/*.lua',
}