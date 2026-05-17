---Job keys must match qbx_core shared/jobs.lua `['jobname']` exactly (lowercase).
---Only players with job.onduty = true in Qbox get an emergency blip (same pool for all listed jobs).
Config = {
    Jobs = {
        ['police']    = { tag = '👮 LSPD | ',   color = 3,  webhook = nil },
        ['bcso']      = { tag = '👮 BCSO | ',   color = 17, webhook = nil },
        ['sasp']      = { tag = '👮 SASP | ',   color = 29, webhook = nil },
        ['ambulance'] = { tag = '🚑 EMS | ',    color = 1,  webhook = nil },
        -- Uncomment after adding `lscso` to qbx_core shared/jobs.lua:
        -- ['lscso'] = { tag = '👮 LSCSO | ', color = 46, webhook = nil },
    },
    --- How often server refreshes coords for emergency blips (seconds)
    CLIENT_UPDATE_INTERVAL_SECONDS = 3,
}
