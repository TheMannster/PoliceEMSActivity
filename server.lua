local timeTracker = {}
local onDuty = {}        -- src -> true when player is in emergency blip pool
local activeBlipJob = {} -- src -> job name (for webhooks / cleanup)

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        for src in pairs(onDuty) do
            timeTracker[src] = (timeTracker[src] or 0) + 1
        end
    end
end)

local function sendToDisc(title, message, footer, webhookURL, color)
    if not webhookURL or webhookURL == '' then return end
    local embed = {
        {
            ['color'] = color,
            ['title'] = '**' .. title .. '**',
            ['description'] = '** ' .. message .. ' **',
            ['footer'] = { ['text'] = footer or '' },
        },
    }
    PerformHttpRequest(webhookURL, function() end, 'POST',
        json.encode({ username = 'PoliceEMSActivity', embeds = embed }),
        { ['Content-Type'] = 'application/json' })
end

local function removeFromEmergencyBlips(src)
    if not onDuty[src] then return end

    local jobName = activeBlipJob[src]
    local cfg = jobName and Config.Jobs[jobName]
    if cfg and cfg.webhook then
        local minutes = math.floor((timeTracker[src] or 0) / 60)
        sendToDisc(
            'Player ' .. GetPlayerName(src) .. ' is now off duty',
            'Player ' .. GetPlayerName(src) .. ' has gone off duty as ' .. (cfg.tag or jobName),
            'Duration: ' .. minutes .. ' minutes',
            cfg.webhook,
            16711680
        )
    end

    TriggerEvent('eblips:remove', src)
    onDuty[src] = nil
    activeBlipJob[src] = nil
    timeTracker[src] = nil
end

---Adds or refreshes blip when job is allowed and framework duty is on; removes otherwise.
function syncEmergencyBlip(src)
    local player = exports.qbx_core:GetPlayer(src)
    if not player then
        removeFromEmergencyBlips(src)
        return
    end

    local job = player.PlayerData.job
    local cfg = Config.Jobs[job.name]
    local shouldShow = cfg and job.onduty

    if not shouldShow then
        removeFromEmergencyBlips(src)
        return
    end

    if not onDuty[src] then
        onDuty[src] = true
        timeTracker[src] = 0
        if cfg.webhook then
            sendToDisc(
                'Player ' .. GetPlayerName(src) .. ' is now on duty',
                'Player ' .. GetPlayerName(src) .. ' has gone on duty as ' .. cfg.tag,
                '',
                cfg.webhook,
                65280
            )
        end
    end

    activeBlipJob[src] = job.name
    TriggerEvent('eblips:add', {
        name = cfg.tag .. GetPlayerName(src),
        src = src,
        color = cfg.color,
    })
end

AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
    if Player and Player.PlayerData and Player.PlayerData.source then
        syncEmergencyBlip(Player.PlayerData.source)
    end
end)

AddEventHandler('QBCore:Server:SetDuty', function(src, _)
    syncEmergencyBlip(src)
end)

AddEventHandler('QBCore:Server:OnJobUpdate', function(src, _)
    syncEmergencyBlip(src)
end)

AddEventHandler('QBCore:Server:OnPlayerUnload', function(src)
    removeFromEmergencyBlips(src)
end)

AddEventHandler('playerDropped', function()
    removeFromEmergencyBlips(source)
end)

local function sendMsg(src, msg)
    TriggerClientEvent('chat:addMessage', src, {
        color = { 255, 255, 255 },
        multiline = true,
        args = { 'Emergency Blips', msg },
    })
end

RegisterCommand('cops', function(source, _, _)
    if not next(onDuty) then
        sendMsg(source, 'No eligible personnel are on framework duty right now.')
        return
    end
    sendMsg(source, 'On-duty emergency personnel (framework duty + eligible job):')
    for id in pairs(onDuty) do
        TriggerClientEvent('chat:addMessage', source, {
            color = { 255, 255, 255 },
            args = { tostring(id), GetPlayerName(id) or 'unknown' },
        })
    end
end, false)
