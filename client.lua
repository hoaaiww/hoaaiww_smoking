isDead = false
smoking = false
smokingIntro = false
smokePrecentage = 100.0

AddEventHandler('esx:onPlayerDeath', function(data) 
    isDead = true 

    if smoking or smokingIntro then
        SendNUIMessage({ type = 'show', show = false })
        smoking = false
        smokingIntro = false
    end
end)

AddEventHandler('esx:onPlayerSpawn', function() 
    isDead = false 
end)

RegisterNetEvent('hoaaiww_smoking:startSmoking', function()
    local playerPed = PlayerPedId()

    if IsPedArmed(playerPed, 4) or IsPedArmed(playerPed, 1) or IsPedArmed(playerPed, 2) then
        SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
        Wait(1500) -- Wait just in case if you are using weapon drawing animations
    end

    smokingIntro = true

    ClearPedTasksImmediately(playerPed)
    TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_SMOKING', 0, true)

    local waited = 0
    repeat
        if smokingIntro then -- checks if the player cancelled the smoking before he would lit the cigarette
            waited = waited + 250

            Wait(250)
        else
            break
        end
    until waited == 11000

    if smokingIntro then
        SendNUIMessage({ type = 'show', show = true })
        smoking = true
        smokingIntro = false
        smokePrecentage = 100.0
    end
end)

CreateThread(function()
    while true do
        if smoking then
            if (smokePrecentage > 31.1) then
                smokePrecentage = smokePrecentage - (Config.smokingSpeed / 25)

                SendNUIMessage({ type = 'setSmokePrecentage', smokePrecentage = smokePrecentage })
            else
                stopSmoking()
            end
        else
            Wait(500)
        end

        Wait(250)
    end
end)

CreateThread(function()
    while true do
        if smoking or smokingIntro then
            HelpNotification(Config.Texts['stop'])

            if IsControlJustPressed(0, Config.CancelButton) then
                stopSmoking()
            end
        else
            Wait(500)
        end
        Wait(0)
    end
end)

function HelpNotification(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0, false, true, -1)
end

function stopSmoking()
    local playerPed = PlayerPedId()
    
    if smokingIntro then
        ClearPedTasksImmediately(playerPed)
    else
        ClearPedTasks(playerPed)
    end

    smokingIntro = false
    smoking = false
    SendNUIMessage({ type = 'show', show = false })
end
