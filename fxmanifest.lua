fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'hoaaiww'
version '1.0'
latest ''
description 'A simple smoking script with remaining smoking time indicator'

shared_scripts {
    '@es_extended/imports.lua',
    'config.lua'
}

client_script 'client.lua'
server_script 'server.lua'

files {
    'html/ui.html',
    'html/cigarette.png'
}

ui_page 'html/ui.html'

dependency 'es_extended'
