local whitelistEnabled = true  -- Pour activer ou désactiver la whitelist BB !!!

RegisterServerEvent('playerConnecting')
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local src = source
    local identifiers = GetPlayerIdentifiers(src)
    local license = nil

    for _, id in pairs(identifiers) do
        if string.find(id, "license:") then
            license = id
            break
        end
    end

    if not license then
        deferrals.done("Erreur: Impossible de trouver votre licence Rockstar.")
        return
    end

    if whitelistEnabled then
        exports.oxmysql:fetch("SELECT COUNT(*) FROM whitelist WHERE license = ?", {license}, function(count)
            if count > 0 then
                deferrals.done()
            else
                deferrals.done("❌ Vous n'êtes pas whitelisté sur ce serveur. Rejoignez Discord pour faire une demande.")
            end
        end)
    else
        deferrals.done()
    end
end)

-- Commande pour ajouter un joueur à la whitelist qui est addwl a mettre sur console du serv
RegisterCommand("addwl", function(source, args, rawCommand)
    if source ~= 0 then return end 

    if not args[1] or not args[2] then
        print("Usage: addwl licenseID NomDuJoueur")
        return
    end

    local license = args[1]
    local name = table.concat(args, " ", 2)

    exports.oxmysql:execute("INSERT INTO whitelist (license, name) VALUES (?, ?)", {license, name}, function(rowsChanged)
        if rowsChanged > 0 then
            print("✅ " .. name .. " a été whitelisté avec succès !")
        else
            print("❌ Erreur lors de l'ajout à la whitelist.")
        end
    end)
end, false)

-- Commande pour retirer un joueur de la whitelist qui est aussi removewl a merttre dcp sur la consol du serv
RegisterCommand("removewl", function(source, args, rawCommand)
    if source ~= 0 then return end 

    if not args[1] then
        print("Usage: removewl licenseID")
        return
    end

    local license = args[1]

    exports.oxmysql:execute("DELETE FROM whitelist WHERE license = ?", {license}, function(rowsChanged)
        if rowsChanged > 0 then
            print("✅ La licence " .. license .. " a été retirée de la whitelist.")
        else
            print("❌ Aucune entrée trouvée avec cette licence.")
        end
    end)
end, false)
