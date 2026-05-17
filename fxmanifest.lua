fx_version 'cerulean'
game 'gta5'

author 'JaredScar (Qbox refactor)'
description 'Emergency job blips for Qbox (LEO/EMS on framework duty)'
version '3.0'
url 'https://github.com/JaredScar/PoliceEMSActivity'

dependencies {
    'qbx_core',
}

client_scripts {
    'EmergencyBlips/cl_emergencyblips.lua',
}

server_scripts {
    'config.lua',
    'server.lua',
    'EmergencyBlips/sv_emergencyblips.lua',
}
