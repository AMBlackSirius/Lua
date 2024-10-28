local VehProps = {}
local CustomMenu = false

RMenu.Add("menu_lscustom", "lscustom_main", RageUI.CreateMenu("Customs", "INTÉRACTIONS"))
RMenu.Add("menu_lscustom", 'Choixcouleur', RageUI.CreateSubMenu(RMenu:Get("menu_lscustom", 'lscustom_main'), "Custom", "INTÉRACTIONS"))
RMenu.Add("menu_lscustom", 'liveries', RageUI.CreateSubMenu(RMenu:Get("menu_lscustom", 'lscustom_main'), "Custom", "INTÉRACTIONS"))
RMenu.Add("menu_lscustom", 'couleur', RageUI.CreateSubMenu(RMenu:Get("menu_lscustom", 'Choixcouleur'), "Custom", "INTÉRACTIONS"))
RMenu.Add("menu_lscustom", 'neon', RageUI.CreateSubMenu(RMenu:Get("menu_lscustom", 'lscustom_main'), "Custom", "INTÉRACTIONS"))
RMenu:Get("menu_lscustom", "lscustom_main").Closed = function()
    ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), 1), VehProps)
    SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), 1), 1, 0, 0)
    FreezeEntityPosition(GetVehiclePedIsIn(GetPlayerPed(-1), 1), 0)
    CustomMenu = false
end

Citizen.CreateThread(function()
    for k,v in ipairs(LSCustom.Carrosserie) do
        RMenu.Add("menu_lscustom", v.name, RageUI.CreateSubMenu(RMenu:Get("menu_lscustom", 'lscustom_main'), "Customs", "INTÉRACTIONS"))
        RMenu:Get("menu_lscustom", v.name).Closed = function()
            ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), 1), VehProps)
            SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), 1), 0, 1, 1)
        end
    end
    for k,v in ipairs(LSCustom.Moteurs) do
        RMenu.Add("menu_lscustom", v.name, RageUI.CreateSubMenu(RMenu:Get("menu_lscustom", 'lscustom_main'), "Customs", "INTÉRACTIONS"))
        RMenu:Get("menu_lscustom", v.name).Closed = function()
            ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), 1), VehProps)
            SetVehicleDoorsShut(GetVehiclePedIsIn(GetPlayerPed(-1), 1), false)
            SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), 1), 0, 1, 1)
        end
    end
    for k,v in ipairs(LSCustom.Roues) do
        RMenu.Add("menu_lscustom", v.name, RageUI.CreateSubMenu(RMenu:Get("menu_lscustom", 'Type : Roues'), "Customs", "INTÉRACTIONS"))
        RMenu:Get("menu_lscustom", v.name).Closed = function()
            ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), 1), VehProps)
            SetVehicleDoorsShut(GetVehiclePedIsIn(GetPlayerPed(-1), 1), false)
            SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), 1), 0, 1, 1)
        end
    end
    for k,v in ipairs(LSCustom.Couleurs) do
        RMenu.Add("menu_lscustom", v.value, RageUI.CreateSubMenu(RMenu:Get("menu_lscustom", 'Choixcouleur'), "Customs", "INTÉRACTIONS"))
        RMenu:Get("menu_lscustom", v.value).Closed = function()
            ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), 1), VehProps)
            SetVehicleDoorsShut(GetVehiclePedIsIn(GetPlayerPed(-1), 1), false)
            SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), 1), 0, 1, 1)
        end
    end
    RMenu.Add("menu_lscustom", "liveries", RageUI.CreateSubMenu(RMenu:Get("menu_lscustom", 'lscustom_main'), "Customs", "INTÉRACTIONS"))
    RMenu:Get("menu_lscustom", "liveries").Closed = function()
        ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), 1), VehProps)
        SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), 1), 0, 1, 1)
    end
end)

function UpdateVehProps(price, type)
    if price == nil then
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
        VehProps = ESX.Game.GetVehicleProperties(vehicle)
        TriggerServerEvent('LSCustom:refreshOwnedVehicle', VehProps)
    else
        ESX.TriggerServerCallback("LSCustom:CheckMoneyInCustom", function(hasmoney, mny)
            if hasmoney then
                local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
                VehProps = ESX.Game.GetVehicleProperties(vehicle)
                TriggerServerEvent('LSCustom:refreshOwnedVehicle', VehProps)
                ESX.ShowNotification("Amélioration véhicule\nPrix : ~g~"..price.."$~s~\nType d'amélioration : ~b~"..type)
            else
                ESX.ShowNotification("~r~Manque d'argent au sein de l'entreprise\n~s~Gain manquant : ~g~"..price-mny.."$")
            end
        end, price)
    end
end

local PaintType = nil

function OpenCustomMenu()
    if (not CustomMenu) then
    vehiclePrice = nil

    ESX.TriggerServerCallback('LSCustom:GetVehPlyPriceInCustoms', function(vehinfos)
        for k,v in pairs(vehinfos) do
            if GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false)) == GetHashKey(v.model) then
                vehiclePrice = tonumber(v.price)
            end
        end

        if vehiclePrice == nil then 
            vehiclePrice = 50000 
        end
    end)

    while (vehiclePrice == nil) do
        Citizen.Wait(0)
    end

    UpdateVehProps()
    SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), 0), 0, 0, 1)
    FreezeEntityPosition(GetVehiclePedIsIn(GetPlayerPed(-1), 0), 1)

	if not CustomMenu then

		CustomMenu = true

        RageUI.Visible(RMenu:Get("menu_lscustom", "lscustom_main"), true)

        Citizen.CreateThread(function()

            while CustomMenu do

                Citizen.Wait(1)
                    if (GetVehiclePedIsIn(GetPlayerPed(-1), 0) == 0) then
                        ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), 1), VehProps)
                        SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), 1), 1, 0, 0)
                        FreezeEntityPosition(GetVehiclePedIsIn(GetPlayerPed(-1), 1), 0)
                        CustomMenu = false
                        RageUI.CloseAll()
                    end

                    RageUI.IsVisible(RMenu:Get("menu_lscustom", "lscustom_main"), true, true, true, function()
                        RageUI.List("Type d'amélioration", {"Carrosserie", "Moteurs", "Options", "Peinture", "Extras & Liveries"}, LSCustom.Index, nil, {}, true, function(_,_,s,Index)
                            LSCustom.Index = Index
                        end)
                        if LSCustom.Index == 1 then
                            SetVehicleModKit(GetVehiclePedIsIn(GetPlayerPed(-1), 0), 0) 
                            for k,v in ipairs(LSCustom.Moteurs) do
                                RageUI.ButtonWithStyle(v.name, nil, {RightLabel = "→→"}, true, function(_,_,s)
                                    if s then
                                        Moteursname = v.name
                                    end
                                end, RMenu:Get("menu_lscustom", v.name))
                            end
                        elseif LSCustom.Index == 2 then
                            SetVehicleModKit(GetVehiclePedIsIn(GetPlayerPed(-1), 0), 0) 
                            for k,v in ipairs(LSCustom.Carrosserie) do
                                RageUI.ButtonWithStyle(v.name, nil, {RightLabel = "→→"}, true, function()
                                end, RMenu:Get("menu_lscustom", v.name))
                            end
                        elseif LSCustom.Index == 3 then
                            SetVehicleModKit(GetVehiclePedIsIn(GetPlayerPed(-1), 0), 0) 
                            SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), 0), 1, 1, 0)
                            RageUI.List("Liste des options", {"Phares", "Vitres", "Couleur de plaque", "Fumer des pneus"}, LSCustom.IndexTwo, nil, {}, true, function(_,_,s,Index)
                                if (LSCustom.IndexTwo ~= Index) then
                                    ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), 1), VehProps)
                                end

                                LSCustom.IndexTwo = Index
                            end)
                            if LSCustom.IndexTwo == 1 then
                                RageUI.Checkbox("[~b~1~s~] - Phares xenon || ~g~"..math.floor(vehiclePrice*3.72/100).."$", nil, VehProps.modXenon, {}, function(_,_,s,Checked)
                                    if s then
                                        ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), 0), {modXenon = not VehProps.modXenon and 1 or 0})
                                        UpdateVehProps(math.floor(vehiclePrice*3.72/100), "Phares xenon")
                                    end
                                end) 
                            elseif LSCustom.IndexTwo == 2 then
                                RageUI.ButtonWithStyle("Par-défaut || ~g~0$", nil, {RightLabel = "→→"}, true, function(_,a,s)
                                    if a then
                                        SetVehicleWindowTint(GetVehiclePedIsIn(GetPlayerPed(-1), 0), 0)
                                    end
                                    if s then
                                        ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), 0), {windowTint = 0})
                                        UpdateVehProps(0, "Vitres")
                                    end
                                end)
                                for i=1, 5 do
                                    RageUI.ButtonWithStyle("[~b~"..i.."~s~] - "..GetWindowName(i).c.." || ~g~"..math.floor(vehiclePrice*GetWindowName(i).price/100).."$", nil, {RightLabel = "→→"}, true, function(_,a,s)
                                        if a then
                                            SetVehicleWindowTint(GetVehiclePedIsIn(GetPlayerPed(-1), 0), i)
                                        end
                                        if s then
                                            ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), 0), {windowTint = i})
                                            UpdateVehProps(math.floor(vehiclePrice*GetWindowName(i).price/100), "Vitres")
                                        end
                                    end)
                                end
                            elseif LSCustom.IndexTwo == 3 then
                                for i = 0,4 do
                                    RageUI.ButtonWithStyle("[~b~"..i.."~s~] - "..GetPlatesName(i).c.." || ~g~"..math.floor(vehiclePrice*GetPlatesName(i).price/100).."$", nil, {}, true, function(_,_,s)
                                        if s then
                                            ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), 0), {plateIndex = i})
                                            UpdateVehProps(math.floor(vehiclePrice*GetPlatesName(i).price/100), "Couleur plaque - "..GetPlatesName(i).c)
                                        end
                                    end)
                                end
                            elseif LSCustom.IndexTwo == 4 then
                                RageUI.Checkbox("Fumer des pneus || ~g~"..(100).."$", nil, VehProps.modSmokeEnabled, {}, function(_,_,s,Checked)
                                    if s then
                                        ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), 0), {modSmokeEnabled = not VehProps.modSmokeEnabled and 1 or 0})
                                        UpdateVehProps(100, "Fumer des pneus")
                                    end
                                end)
                                if (VehProps.modSmokeEnabled) then 
                                    for z,i in pairs(GetNeons()) do
                                        RageUI.ButtonWithStyle("[~b~"..z.."~s~] - "..i.label.." || ~g~"..math.floor(vehiclePrice*1.12/100).."$", nil, {}, true, function(_,_,s)
                                            if s then
                                                ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), 0), {tyreSmokeColor = {i.r, i.g, i.b}})
                                                UpdateVehProps(math.floor(vehiclePrice*1.12/100), i.label)
                                            end
                                        end)
                                    end
                                end
                            end
                        elseif LSCustom.Index == 4 then
                            SetVehicleModKit(GetVehiclePedIsIn(GetPlayerPed(-1), 0), 0) 
                            RageUI.ButtonWithStyle("Couleur primaire", nil, {RightLabel = "→→"}, true, function(_,_,s)
                                if s then
                                    PaintType = 2
                                end
                            end, RMenu:Get("menu_lscustom", "Choixcouleur"))
                            RageUI.ButtonWithStyle("Couleur secondaire", nil, {RightLabel = "→→"}, true, function(_,_,s)
                                if s then
                                    PaintType = 3
                                end
                            end, RMenu:Get("menu_lscustom", "Choixcouleur"))
                            RageUI.ButtonWithStyle("Couleur nacré", nil, {RightLabel = "→→"}, true, function(_,_,s)
                                if s then
                                    PaintType = 1
                                end
                            end, RMenu:Get("menu_lscustom", "Choixcouleur"))
                            RageUI.ButtonWithStyle("Couleur des jantes", nil, {RightLabel = "→→"}, true, function(_,_,s)
                                if s then
                                    PaintType = 4
                                end
                            end, RMenu:Get("menu_lscustom", "Choixcouleur"))
                            RageUI.ButtonWithStyle("Gestion des néons", nil, {RightLabel = "→→"}, true, function(_,_,s)
                                if s then
                                    PaintType = 4
                                end
                            end, RMenu:Get("menu_lscustom", "neon"))
                        elseif LSCustom.Index == 5 then
                            RageUI.ButtonWithStyle("Extras & Liveries", nil, {RightLabel = "→→"}, true, function(_,_,s)
                            end, RMenu:Get("menu_lscustom", "liveries"))
                        end
                    end)

                    RageUI.IsVisible(RMenu:Get("menu_lscustom", "liveries"), true, true, true, function()



                        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
                        local liveryCount = GetVehicleLiveryCount(vehicle)
        
                        RageUI.Separator("~r~Livery(s)")
                
                            for i = 1, liveryCount do
                                local state = GetVehicleLivery(vehicle) 
                                
                                if state == i then
                                    RageUI.ButtonWithStyle("Livery: "..i, nil, {RightLabel = "~g~ON"}, true, function(Hovered, Active, Selected)
                                        if (Selected) then   
                                            SetVehicleLivery(vehicle, i, not state)
                                            VehProps = ESX.Game.GetVehicleProperties(vehicle)
                                            TriggerServerEvent('LSCustom:refreshOwnedVehicle', VehProps)
                                        end      
                                    end)
                                else
                                    RageUI.ButtonWithStyle("Livery: "..i, nil, {RightLabel = "~r~OFF"}, true, function(Hovered, Active, Selected)
                                        if (Selected) then
                                            SetVehicleLivery(vehicle, i, state)
                                            VehProps = ESX.Game.GetVehicleProperties(vehicle)
                                            TriggerServerEvent('LSCustom:refreshOwnedVehicle', VehProps)
                                        end      
                                    end)
                                end
                            end
        
                        RageUI.Separator("~b~Extra(s)")
        
                        for id=0, 12 do
                                if DoesExtraExist(vehicle, id) then
                                    local state2 = IsVehicleExtraTurnedOn(vehicle, id)
                                
                                if state2 then
                                    RageUI.ButtonWithStyle("Extra: "..id, nil, {RightLabel = "~g~ON"}, true, function(Hovered, Active, Selected)
                                        if (Selected) then   
                                            SetVehicleExtra(vehicle, id, state2)
                                            VehProps = ESX.Game.GetVehicleProperties(vehicle)
                                            TriggerServerEvent('LSCustom:refreshOwnedVehicle', VehProps)
                                        end      
                                    end)
                                else
                                    RageUI.ButtonWithStyle("Extra: "..id, nil, {RightLabel = "~r~OFF"}, true, function(Hovered, Active, Selected)
                                        if (Selected) then
                                            SetVehicleExtra(vehicle, id, state2)
                                            VehProps = ESX.Game.GetVehicleProperties(vehicle)
                                            TriggerServerEvent('LSCustom:refreshOwnedVehicle', VehProps)
                                        end      
                                    end)
                                end
                            end
                        end



                    end)

                    RageUI.IsVisible(RMenu:Get("menu_lscustom", "neon"), true, true, true, function()
                        SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), 0), 1, 1, 0)
                        RageUI.Checkbox("[~b~0~s~] - Néons || ~g~100$", nil, IsVehicleNeonLightEnabled(GetVehiclePedIsIn(GetPlayerPed(-1), 0), 2), { Style = RageUI.CheckboxStyle.Tick }, function(_, a, s, Checked)
                            if s then
                                if IsVehicleNeonLightEnabled(GetVehiclePedIsIn(GetPlayerPed(-1), 0), 2) then
                                    for i = 0,3 do
                                        SetVehicleNeonLightEnabled(GetVehiclePedIsIn(GetPlayerPed(-1), 0), i, 0)
                                        UpdateVehProps(100, "Néons")
                                    end
                                else
                                    for i = 0,3 do
                                        SetVehicleNeonLightEnabled(GetVehiclePedIsIn(GetPlayerPed(-1), 0), i, 1)
                                        UpdateVehProps(100, "Néons")
                                    end
                                end
                            end
                        end)
                        if IsVehicleNeonLightEnabled(GetVehiclePedIsIn(GetPlayerPed(-1), 0), 2) then 
                            for k,v in ipairs(GetNeons()) do
                                RageUI.ButtonWithStyle("[~b~"..k.."~s~] - "..v.label.. "|| ~g~"..math.floor(vehiclePrice*1.12/100).."$", nil, { }, true, function(_,a,s)
                                    if a then
                                        SetVehicleNeonLightsColour(GetVehiclePedIsIn(GetPlayerPed(-1), 0), v.r, v.g, v.b)
                                    end
                                    if s then
                                        SetVehicleNeonLightsColour(GetVehiclePedIsIn(GetPlayerPed(-1), 0), v.r, v.g, v.b)
                                        UpdateVehProps(math.floor(vehiclePrice*1.12/100), v.label)
                                    end
                                end)
                            end
                        end
                    end)

                    RageUI.IsVisible(RMenu:Get("menu_lscustom", "Choixcouleur"), true, true, true, function()
                        for k,v in ipairs(LSCustom.Couleurs) do
                            RageUI.ButtonWithStyle(v.label, nil, {RightLabel = "→→"}, true, function(_,_,s)
                                if s then
                                    if PaintType == 1 then
                                        price = 1.12
                                    elseif PaintType == 2 then
                                        price = 1.12
                                    elseif PaintType == 3 then
                                        price = 0.66
                                    elseif PaintType == 4 then
                                        price = 0.88
                                    elseif PaintType == 5 then
                                        price = 1.12
                                    end
                                end
                            end, RMenu:Get("menu_lscustom", v.value))
                        end
                    end)

                    for k,v in ipairs(LSCustom.Couleurs) do
                        RageUI.IsVisible(RMenu:Get("menu_lscustom", v.value), true, true, true, function()
                            for o,i in pairs(GetColors(v.value)) do
                                RageUI.ButtonWithStyle("[~b~"..o.."~s~] - "..i.label.." || ~g~"..math.floor(vehiclePrice*price/100).."$", nil, {RightLabel = "→→"}, true, function(_,a,s)
                                    if a then
                                        if PaintType == 1 then
                                            ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), 0), {pearlescentColor = i.index})
                                        elseif PaintType == 2 then
                                            ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), 0), {color1 = i.index})
                                        elseif PaintType == 3 then
                                            ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), 0), {color2 = i.index})
                                        elseif PaintType == 4 then
                                            ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), 0), {wheelColor = i.index})
                                        end
                                    end
                                    if s then
                                        if PaintType == 1 then
                                            ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), 0), {pearlescentColor = i.index})
                                            UpdateVehProps(math.floor(vehiclePrice*price/100), i.label)
                                        elseif PaintType == 2 then
                                            ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), 0), {color1 = i.index})
                                            UpdateVehProps(math.floor(vehiclePrice*price/100), i.label)
                                        elseif PaintType == 3 then
                                            ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), 0), {color2 = i.index})
                                            UpdateVehProps(math.floor(vehiclePrice*price/100), i.label)
                                        elseif PaintType == 4 then
                                            ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), 0), {wheelColor = i.index})
                                            UpdateVehProps(math.floor(vehiclePrice*price/100), i.label)
                                        end
                                    end
                                end)
                            end
                        end)
                    end

                    for k,v in ipairs(LSCustom.Moteurs) do
                        RageUI.IsVisible(RMenu:Get("menu_lscustom", v.name), true, true, true, function()
                            local NumberCustoms = GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), 0), v.modType)
                            local CustomInstalled = GetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), 0), v.modType)
                            if v.modType == 36 or v.modType == 37 or v.modType == 38 or v.modType == 39 or v.modType == 40 or v.modType == 41 or v.modType == 42 or v.modType == 45 then
                                for i = 0,10 do
                                    SetVehicleDoorOpen(GetVehiclePedIsIn(GetPlayerPed(-1), 0), i, false)
                                end
                            else
                                SetVehicleDoorsShut(GetVehiclePedIsIn(GetPlayerPed(-1), 0), false)
                            end
                            if v.modType == 23 then
                                for _,Roues in pairs(LSCustom.Roues) do
                                    RageUI.ButtonWithStyle(Roues.name, nil, {RightLabel = "→→"}, true, function(_,_,s)
                                        if s then 
                                            SetVehicleWheelType(GetVehiclePedIsIn(GetPlayerPed(-1), 0), Roues.type) 
                                        end
                                    end, RMenu:Get("menu_lscustom", Roues.name))
                                end
                            end
                            RageUI.ButtonWithStyle("Par-défaut", nil, {}, true, function(_,a,s)
                                if s then
                                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), 0), v.modType, -1, 0)
                                    UpdateVehProps()
                                    if v.modType == 48 then
                                        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), 0), 48, -1, 0)
                                        ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), 0), {modLivery = -1})
                                        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                                        VehProps = ESX.Game.GetVehicleProperties(vehicle)
                                        TriggerServerEvent('LSCustom:refreshOwnedVehicle', VehProps)
                                        ESX.ShowNotification("~g~L'autocollant a été remis à défaut !")
                                    end
                                end
                                if a then
                                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), 0), v.modType, -1, 0)
                                end
                            end)
                            if NumberCustoms == 0 then
                                if Moteursname == nil then Moteursname = "Type : Inconnu" else Moteursname = Moteursname end
                                RageUI.Separator("")
                                RageUI.Separator("~b~Ce véhicule ne comporte pas de \n ~y~"..Moteursname.."~s~ :(")
                                RageUI.Separator("")
                            end
                            for i = 0, NumberCustoms-1 do 
                                local modName = GetModTextLabel(GetVehiclePedIsIn(GetPlayerPed(-1), 0), v.modType, i)
                                if v.modType == 14 then
                                    RageUI.ButtonWithStyle(GetHornName(i), nil, { RightLabel = "~g~"..math.floor(vehiclePrice*v.price/100).."$" }, true, function(_,a,s)
                                        if s then
                                            SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), 0), v.modType, i, 0)
                                            UpdateVehProps(math.floor(vehiclePrice*v.price/100), GetHornName(i))
                                        end
                                        if a then
                                            SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), 0), v.modType, i, 0)
                                        end
                                    end)
                                elseif v.modType == 48 then
                                    RageUI.ButtonWithStyle(GetLabelText(modName), nil, { RightLabel = "~g~"..math.floor(vehiclePrice*v.price/100).."$" }, true, function(_,a,s)
                                        if s then
                                            SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), 0), 48, i, 0)
                                            SetVehicleLivery(GetVehiclePedIsIn(GetPlayerPed(-1), 0), i)
                                            ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), 0), {modLivery = i})
                                            UpdateVehProps(math.floor(vehiclePrice*v.price/100), GetLabelText(modName))
                                        end
                                        if a then
                                            SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), 0), 48, i, 0)
                                            SetVehicleLivery(GetVehiclePedIsIn(GetPlayerPed(-1, 0)), i)
                                        end
                                    end)
                                elseif v.modType == 23 then
                                    break
                                else
                                    RageUI.ButtonWithStyle("[~b~"..(i+1).."~s~] - "..GetLabelText(modName).." || ~g~"..math.floor(vehiclePrice*v.price/100).."$", nil, {RightLabel = "→→"}, true, function(_,a,s)
                                        if s then
                                            SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), 0), v.modType, i, 0)
                                            UpdateVehProps(math.floor(vehiclePrice*v.price/100), GetLabelText(modName))
                                        end
                                        if a then
                                            SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), 0), v.modType, i, 0)
                                        end
                                    end)
                                end
                            end
                        end)
                    end

                    for k,v in ipairs(LSCustom.Roues) do
                        RageUI.IsVisible(RMenu:Get("menu_lscustom", v.name), true, true, true, function()
                            SetVehicleWheelType(GetVehiclePedIsIn(GetPlayerPed(-1), 0), v.type)
                            local NumberCustoms = GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), 0), 23)
                            for i = 0, NumberCustoms-1 do
                                local modName = GetModTextLabel(GetVehiclePedIsIn(GetPlayerPed(-1), 0), 23, i)
                                RageUI.ButtonWithStyle("[~b~"..(i+1).."~s~] - "..GetLabelText(modName).." || ~g~"..math.floor(vehiclePrice*v.price/100).."$", nil, {RightLabel = "→→"}, true, function(_,a,s)
                                    if s then
                                        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), 0), 23, i, 0)
                                        UpdateVehProps(math.floor(vehiclePrice*v.price/100), GetLabelText(modName))
                                    end
                                    if a then
                                        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), 0), 23, i, 0)
                                    end
                                end)
                            end
                        end)
                    end

                    for k,v in ipairs(LSCustom.Carrosserie) do
                        RageUI.IsVisible(RMenu:Get("menu_lscustom", v.name), true, true, true, function()
                            local NumberCustoms = GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), 0), v.modType)
                            local CustomInstalled = GetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), 0), v.modType)
                            local currentProps = ESX.Game.GetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), false))
                            if v.modType == 17 then
                                if currentProps["modTurbo"] then
                                    RageUI.ButtonWithStyle("[~b~"..(1).."~s~] - Désactivé le turbo || ~g~"..math.floor(vehiclePrice*1.5/100).."$", nil, {RightLabel = "→→"}, true, function(_,a,s)
                                        if s then
                                            ESX.TriggerServerCallback("LSCustom:CheckMoneyInCustom", function(hasmoney, mny)
                                                if hasmoney then
                                                    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), 0), 17, 1)
                                                    ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), 0), {modTurbo = 0})
                                                    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                                                    VehProps = ESX.Game.GetVehicleProperties(vehicle)
                                                    TriggerServerEvent('LSCustom:refreshOwnedVehicle', VehProps)
                                                    ESX.ShowNotification("Amélioration véhicule\nPrix : ~g~"..math.floor(vehiclePrice*1.5/100).."$~s~\nType d'amélioration : ~b~"..v.name)
                                                else
                                                    ESX.ShowNotification("~r~Manque d'argent au sein de l'entreprise\n~s~Gain manquant : ~g~"..math.floor(vehiclePrice*1.5/100)-mny.."$")
                                                end
                                            end, math.floor(vehiclePrice*1.5/100))
                                        end
                                    end)
                                    RageUI.ButtonWithStyle("[~b~"..(2).."~s~] - Turbo || ~g~"..math.floor(vehiclePrice*v.price[1]/100).."$", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, function(_,a,s)
                                        if s then
                                            ESX.TriggerServerCallback("LSCustom:CheckMoneyInCustom", function(hasmoney, mny)
                                                if hasmoney then
                                                    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), 0), 17, 1)
                                                    ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), 0), {modTurbo = 1})
                                                    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                                                    VehProps = ESX.Game.GetVehicleProperties(vehicle)
                                                    TriggerServerEvent('LSCustom:refreshOwnedVehicle', VehProps)
                                                    ESX.ShowNotification("Amélioration véhicule\nPrix : ~g~"..math.floor(vehiclePrice*v.price[1]/100).."$~s~\nType d'amélioration : ~b~"..v.name)
                                                else
                                                    ESX.ShowNotification("~r~Manque d'argent au sein de l'entreprise\n~s~Gain manquant : ~g~"..math.floor(vehiclePrice*v.price[1]/100)-mny.."$")
                                                end
                                            end, math.floor(vehiclePrice*v.price[1]/100))
                                        end
                                    end)
                                else
                                    RageUI.ButtonWithStyle("[~b~"..(1).."~s~] - Désactivé le turbo || ~g~"..math.floor(vehiclePrice*1.5/100).."$", nil, {RightLabel = "→→"}, true, function(_,a,s)
                                        if s then
                                            ESX.TriggerServerCallback("LSCustom:CheckMoneyInCustom", function(hasmoney, mny)
                                                if hasmoney then
                                                    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), 0), 17, 1)
                                                    ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), 0), {modTurbo = 0})
                                                    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                                                    VehProps = ESX.Game.GetVehicleProperties(vehicle)
                                                    TriggerServerEvent('LSCustom:refreshOwnedVehicle', VehProps)
                                                    ESX.ShowNotification("Amélioration véhicule\nPrix : ~g~"..math.floor(vehiclePrice*1.5/100).."$~s~\nType d'amélioration : ~b~"..v.name)
                                                else
                                                    ESX.ShowNotification("~r~Manque d'argent au sein de l'entreprise\n~s~Gain manquant : ~g~"..math.floor(vehiclePrice*1.5/100)-mny.."$")
                                                end
                                            end, math.floor(vehiclePrice*1.5/100))
                                        end
                                    end)
                                    RageUI.ButtonWithStyle("[~b~"..(2).."~s~] - Turbo || ~g~"..math.floor(vehiclePrice*v.price[1]/100).."$", nil, {RightLabel = "→→"}, true, function(_,a,s)
                                        if s then
                                            ESX.TriggerServerCallback("LSCustom:CheckMoneyInCustom", function(hasmoney, mny)
                                                if hasmoney then
                                                    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), 0), 17, 1)
                                                    ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), 0), {modTurbo = 1})
                                                    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                                                    VehProps = ESX.Game.GetVehicleProperties(vehicle)
                                                    TriggerServerEvent('LSCustom:refreshOwnedVehicle', VehProps)
                                                    ESX.ShowNotification("Amélioration véhicule\nPrix : ~g~"..math.floor(vehiclePrice*v.price[1]/100).."$~s~\nType d'amélioration : ~b~"..v.name)
                                                else
                                                    ESX.ShowNotification("~r~Manque d'argent au sein de l'entreprise\n~s~Gain manquant : ~g~"..math.floor(vehiclePrice*v.price[1]/100)-mny.."$")
                                                end
                                            end, math.floor(vehiclePrice*v.price[1]/100))
                                        end
                                    end)
                                end  
                            end
                            for i = 0, NumberCustoms-1 do 
                                if CustomInstalled == i then
                                    RageUI.ButtonWithStyle("[~b~"..(i+1).."~s~] - "..v.name.." || ~g~"..math.floor(vehiclePrice*v.price[i+1]/100).."$", nil, { RightBadge = RageUI.BadgeStyle.Tick }, true, function(_,a,s)
                                        if s then
                                            ESX.TriggerServerCallback("LSCustom:CheckMoneyInCustom", function(hasmoney, mny)
                                                if hasmoney then
                                                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), 0), v.modType, i, 0)
                                                    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                                                    VehProps = ESX.Game.GetVehicleProperties(vehicle)
                                                    TriggerServerEvent('LSCustom:refreshOwnedVehicle', VehProps)
                                                    ESX.ShowNotification("Amélioration véhicule\nPrix : ~g~"..math.floor(vehiclePrice*v.price[i+1]/100).."$~s~\nType d'amélioration : ~b~"..v.name)
                                                else
                                                    ESX.ShowNotification("~r~Manque d'argent au sein de l'entreprise\n~s~Gain manquant : ~g~"..math.floor(vehiclePrice*v.price[i+1]/100)-mny.."$")
                                                end
                                            end, math.floor(vehiclePrice*v.price[i+1]/100))
                                        end
                                    end)
                                else
                                    RageUI.ButtonWithStyle("[~b~"..(i+1).."~s~] - "..v.name.." || ~g~"..math.floor(vehiclePrice*v.price[i+1]/100).."$", nil, {RightLabel = "→→"}, true, function(_,a,s)
                                        if s then
                                            ESX.TriggerServerCallback("LSCustom:CheckMoneyInCustom", function(hasmoney, mny)
                                                if hasmoney then
                                                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), 0), v.modType, i, 0)
                                                    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                                                    VehProps = ESX.Game.GetVehicleProperties(vehicle)
                                                    TriggerServerEvent('LSCustom:refreshOwnedVehicle', VehProps)
                                                    ESX.ShowNotification("Amélioration véhicule\nPrix : ~g~"..math.floor(vehiclePrice*v.price[i+1]/100).."$~s~\nType d'amélioration : ~b~"..v.name)
                                                else
                                                    ESX.ShowNotification("~r~Manque d'argent au sein de l'entreprise\n~s~Gain manquant : ~g~"..math.floor(vehiclePrice*v.price[i+1]/100)-mny.."$")
                                                end
                                            end, math.floor(vehiclePrice*v.price[i+1]/100))
                                        end
                                    end)
                                end
                            end
                        end)
                    end
                end
            end)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        local wait = 900
        local pcoords = GetEntityCoords(GetPlayerPed(-1), false)
        for k,v in pairs({
            {pos = vector3(-325.51440429688,-138.82202148438,39.0153846740722)},
            {pos = vector3(-327.19271850586,-145.08192443848,39.015323638916)},
            {pos = vector3(-323.17471313477,-133.81008911133,39.016807556152)},
            {pos = vector3(-320.8928527832,-129.32371520996,39.017337799072)},
            {pos = vector3(-319.50714111328,-122.9630279541,39.01575088501)},
        }) do
        local dst = Vdist(pcoords.x, pcoords.y, pcoords.z, v.pos)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'lscustom' then 	
            if dst <= 5.0 then
                DrawReality(v.pos.x,v.pos.y,v.pos.z, 255,255,0,255)
                wait = 0
                ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour accéder au custom")
                    if IsControlJustPressed(1,38) then    
                        OpenCustomMenu()
                    end   
                end 
            end
        end
        Citizen.Wait(wait)
    end
end)

Citizen.CreateThread(function()
    while true do
        local wait = 900
        local pcoords = GetEntityCoords(GetPlayerPed(-1), false)
        for k,v in pairs({
            {pos = vector3(-212.14819335938, -1324.6239013672, 30.906354904175)},
            {pos = vector3(-235.4076385498, -1326.5548095703, 30.902782440186)},
            {pos = vector3(-229.74020385742, -1314.2767333984, 18.462013244629)},
            {pos = vector3(-218.03936767578, -1315.3673095703, 18.462022781372)},

        }) do
        local dst = Vdist(pcoords.x, pcoords.y, pcoords.z, v.pos)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then 	
            if dst <= 15.0 then
                wait = 0
                DrawReality(v.pos.x,v.pos.y,v.pos.z, 255,128,0,255)

            end
            if dst <= 2.0 then
                wait = 0
                ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour accéder au custom")
                    if IsControlJustPressed(1,38) then    
                        OpenCustomMenu()
                    end   
                end 
            end
        end
        Citizen.Wait(wait)
    end
end)

Citizen.CreateThread(function()
    while true do
        local wait = 900
        local pcoords = GetEntityCoords(GetPlayerPed(-1), false)
        for k,v in pairs({
            {pos = vector3(65.487968444824,6518.0478515625,31.255065917969)},
            {pos = vector3(74.659126281738,6523.5966796875,31.254590988159)},
        }) do
        local dst = Vdist(pcoords.x, pcoords.y, pcoords.z, v.pos)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'fayes' then 	
            if dst <= 5.0 then
                DrawReality(v.pos.x,v.pos.y,v.pos.z, 255,255,0,255)
                wait = 0
                ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour accéder au custom")
                    if IsControlJustPressed(1,38) then    
                        OpenCustomMenu()
                    end   
                end 
            end
        end
        Citizen.Wait(wait)
    end
end)
