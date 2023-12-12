ESX = exports["es_extended"]:getSharedObject()

local barbaActivada = true
local navajaItem = 'afeitadora'  -- Reemplaza con el nombre real del objeto de la navaja

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.minutes * 60000)
        
        if barbaActivada then
            TriggerEvent('skinchanger:getSkin', function(skinData)
                if skinData ~= nil then
                    if skinData['sex'] == 0 then
                        -- Crecimiento de barba
                        if skinData['beard_2'] > 0 and skinData['beard_2'] < 10 then
                            skinData['beard_2'] = skinData['beard_2'] + 1
                        end

                        -- Crecimiento de cabello
                        if skinData['hair_2'] > 0 and skinData['hair_2'] < 45 then
                            skinData['hair_2'] = skinData['hair_2'] + 1
                        end

                        -- Aplicar cambios y guardar
                        TriggerEvent('skinchanger:loadSkin', skinData)
                        TriggerServerEvent('esx_skin:save', skinData)
                        
                        -- Notificación al jugador con efecto de sonido y animación
                        TriggerEvent('mythic_notify:client:SendAlert', { type = 'success', text = '¡Tu barba y cabello están creciendo!', length = 5000, style = { ['background-color'] = '#00FF00', ['color'] = '#ffffff' } })
                        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                    end
                end
            end)
        end
    end
end)

RegisterCommand('afeitarse', function()
    local playerPed = PlayerId()
    local hasNavaja = false

    -- Verificar si el jugador tiene una navaja en el inventario
    TriggerEvent('esx_inventoryhud:getInventory', function(inventory)
        for _, item in ipairs(inventory.items) do
            if item.name == navajaItem and item.count > 0 then
                hasNavaja = true
                break
            end
        end
    end)

    -- Afeitarse solo si tiene una navaja
    if hasNavaja then
        TriggerEvent('crecimientobarba:shave')
    else
        TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Necesitas una navaja para afeitarte.', length = 5000 })
    end
end, false)

RegisterNetEvent('crecimientobarba:shave')
AddEventHandler('crecimientobarba:shave', function()
    TriggerEvent('skinchanger:getSkin', function(skinData)
        if skinData ~= nil then
            if skinData['sex'] == 0 then
                -- Afeitado de barba
                if skinData['beard_2'] > 1 and skinData['beard_2'] < 10 then
                    skinData['beard_2'] = 1
                end

                -- Corte de cabello
                if skinData['hair_2'] > 1 and skinData['hair_2'] < 45 then
                    skinData['hair_2'] = 1
                end

                -- Aplicar cambios y guardar
                TriggerEvent('skinchanger:loadSkin', skinData)
                TriggerServerEvent('esx_skin:save', skinData)
                
                -- Notificación al jugador con efecto de sonido y animación
                TriggerEvent('mythic_notify:client:SendAlert', { type = 'success', text = '¡Te has afeitado la barba y cortado el cabello!', length = 5000, style = { ['background-color'] = '#00FF00', ['color'] = '#ffffff' } })
                PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
            end
        end
    end)
end)

RegisterCommand('barbaon', function()
    barbaActivada = true
    TriggerEvent('chatMessage', 'Sistema de barba', {255, 255, 255}, 'La barba y el cabello ahora crecerán.')
end, false)

RegisterCommand('barbaoff', function()
    barbaActivada = false
    TriggerEvent('chatMessage', 'Sistema de barba', {255, 255, 255}, 'La barba y el cabello ya no crecerán.')
end, false)
