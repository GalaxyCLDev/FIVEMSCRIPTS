ESX = exports["es_extended"]:getSharedObject()

local barbaActivada = true

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.minutes * 60000)
        
        if barbaActivada then
            TriggerEvent('skinchanger:getSkin', function(skinData)
                if skinData ~= nil then
                    if skinData['sex'] == 0 and skinData['beard_2'] > 0 and skinData['beard_2'] < 10 then
                        skinData['beard_2'] = skinData['beard_2'] + 1
                        TriggerEvent('skinchanger:loadSkin', skinData)
                        TriggerServerEvent('esx_skin:save', skinData)
                        
                        -- Notificación al jugador
                        TriggerEvent('mythic_notify:client:SendAlert', { type = 'success', text = '¡Tu barba está creciendo!', length = 5000 })
                    end
                end
            end)
        end
    end
end)

RegisterNetEvent('crecimientobarba:shave')
AddEventHandler('crecimientobarba:shave', function()
    TriggerEvent('skinchanger:getSkin', function(skinData)
        if skinData ~= nil then
            if skinData['sex'] == 0 and skinData['beard_2'] > 1 and skinData['beard_2'] < 10 then
                skinData['beard_2'] = 1
                TriggerEvent('skinchanger:loadSkin', skinData)
                TriggerServerEvent('esx_skin:save', skinData)
                
                -- Notificación al jugador
                TriggerEvent('mythic_notify:client:SendAlert', { type = 'success', text = '¡Te has afeitado la barba!', length = 5000 })
            end
        end
    end)
end)

RegisterCommand('barbaon', function()
    barbaActivada = true
    TriggerEvent('chatMessage', 'Sistema de barba', {255, 255, 255}, 'La barba ahora crecerá.')
end, false)

RegisterCommand('barbaoff', function()
    barbaActivada = false
    TriggerEvent('chatMessage', 'Sistema de barba', {255, 255, 255}, 'La barba ya no crecerá.')
end, false)
