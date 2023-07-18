CreateThread(function()
    for k,v in pairs(Config.ItemsName) do
        ESX.RegisterUsableItem(v, function(source)
            local xPlayer = ESX.GetPlayerFromId(source)

            xPlayer.removeInventoryItem(v, 1)
            xPlayer.showNotification(string.format(Config.Texts['used_item'], k))

            TriggerClientEvent('hoaaiww_smoking:startSmoking', source)
        end)
    end
end)

--Version Check

if Config.CheckForUpdates then
    CreateThread(function()
        if GetCurrentResourceName() ~= "hoaaiww_smoking" then
            resourceName = "hoaaiww_smoking (" .. GetCurrentResourceName() .. ")"
        end
    end)

    CreateThread(function()
        while true do
            PerformHttpRequest("https://api.github.com/repos/hoaaiww/hoaaiww_smoking/releases/latest", CheckVersion, "GET")
            Wait(3600000)
        end
    end)

    CheckVersion = function(err, responseText, headers)
        local repoVersion, repoURL, repoBody = GetRepoInformations()

        CreateThread(function()
            if curVersion ~= repoVersion then
                print("^0[^3WARNING^0] " .. resourceName .. " is ^1NOT ^0up to date!")
                print("^0[^3WARNING^0] Your Version: ^2" .. curVersion .. "^0")
                print("^0[^3WARNING^0] Latest Version: ^2" .. repoVersion .. "^0")
                print("^0[^3WARNING^0] Get the latest Version from: ^2" .. repoURL .. "^0")
                print("^0[^3WARNING^0] Changelog:^0")
                print("^1" .. repoBody .. "^0")
            else
                print("^0[^2INFO^0] " .. resourceName .. " is up to date! (^2" .. curVersion .. "^0)")
            end
        end)
    end

    GetRepoInformations = function()
        local repoVersion, repoURL, repoBody = nil, nil, nil

        PerformHttpRequest("https://api.github.com/repos/hoaaiww/hoaaiww_smoking/releases/latest", function(err, response, headers)
            if err == 200 then
                local data = json.decode(response)

                repoVersion = data.tag_name
                repoURL = data.html_url
                repoBody = data.body
            else
                repoVersion = curVersion
                repoURL = "https://github.com/hoaaiww/hoaaiww_smoking"
            end
        end, "GET")

        repeat
            Wait(50)
        until (repoVersion and repoURL and repoBody)

        return repoVersion, repoURL, repoBody
    end
end
