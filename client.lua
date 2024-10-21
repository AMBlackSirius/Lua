
local actionCles, ShowName, gamerTags, invisible = {select = {"Prêter", "Détruire"}, index = 1}, false, {}, false

object = {}

local Rperso = {
    ItemSelected = {},
    ItemSelected2 = {},
    WeaponData = {},
    factures = {},
    cledevoiture = {},
    bank = nil,
    sale = nil,
    DoorState = {
		FrontLeft = false,
		FrontRight = false,
		BackLeft = false,
		BackRight = false,
		Hood = false,
		Trunk = false
	},
    minimap = true,
}

local Peds = {
    name = {
        'Singe',
        'Danseuse',
        'Cosmonaute',
        'Alien',
        'Chat',
        'Aigle',
        'Coyote',
    },
list = 1
}

local eGestVeh = {
    DoorState = {
		FrontLeft = false,
		FrontRight = false,
		BackLeft = false,
		BackRight = false,
        All = false,
		Hood = false,
		Trunk = false
	},
	DoorIndex = 1,
	DoorList = {"Avant Gauche","Avant Droite","Arrière Gauche","Arrière Droite","Toutes les portes"},
    WindowIndex = 1,
    WindowList = {"Avant Gauche","Avant Droite","Arrière Gauche","Arrière Droite","Toutes les fenêtres"},

    PlaceIndex = 1,
    PlaceList = {"Conducteur","Passager","Arrière Gauche","Arrière Droit"},

    Limitateur = 1,
    StatusCapot = "~r~Fermer",
    StatusCoffre = "~r~Fermer",
}

local societymoney, societymoney2 = nil, nil

Citizen.CreateThread(function()
    while ESX == nil do
        ESX = exports["es_extended"]:getSharedObject()

        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    RefreshMoney()
	RefreshMoney2()

    Rperso.WeaponData = ESX.GetWeaponList()
	for i = 1, #Rperso.WeaponData, 1 do
		if Rperso.WeaponData[i].name == 'WEAPON_UNARMED' then
			Rperso.WeaponData[i] = nil
		else
			Rperso.WeaponData[i].hash = GetHashKey(Rperso.WeaponData[i].name)
		end
    end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(200)

		if invisible then
			SetEntityVisible(GetPlayerPed(-1), 0, 0)
			NetworkSetEntityInvisibleToNetwork(pPed, 1)
		else
			SetEntityVisible(GetPlayerPed(-1), 1, 0)
			NetworkSetEntityInvisibleToNetwork(pPed, 0)
		end

		if ShowName then
			local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
			for _, v in pairs(GetActivePlayers()) do
				local otherPed = GetPlayerPed(v)
			
				if otherPed ~= pPed then
					if #(pCoords - GetEntityCoords(otherPed, false)) < 250.0 then
						gamerTags[v] = CreateFakeMpGamerTag(otherPed, ('[%s] %s'):format(GetPlayerServerId(v), GetPlayerName(v)), false, false, '', 0)
						SetMpGamerTagVisibility(gamerTags[v], 4, 1)
					else
						RemoveMpGamerTag(gamerTags[v])
						gamerTags[v] = nil
					end
				end
			end
		else
			for _, v in pairs(GetActivePlayers()) do
				RemoveMpGamerTag(gamerTags[v])
			end
		end
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
end)

RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(money)
	  ESX.PlayerData.money = money
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	RefreshMoney()
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	ESX.PlayerData.job2 = job2
	RefreshMoney2()
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	for i=1, #ESX.PlayerData.accounts, 1 do
		if ESX.PlayerData.accounts[i].name == account.name then
			ESX.PlayerData.accounts[i] = account
			break
		end
	end
end)

--- Argent entreprise/orga

RegisterNetEvent('esx_addonaccount:setMoney')
AddEventHandler('esx_addonaccount:setMoney', function(society, money)
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' and 'society_' .. ESX.PlayerData.job.name == society then
		societymoney = ESX.Math.GroupDigits(money)
	end

	if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' and 'society_' .. ESX.PlayerData.job2.name == society then
		societymoney2 = ESX.Math.GroupDigits(money)
	end
end)

RegisterNetEvent('gPersonalmenu:Weapon_addAmmoToPedC')
AddEventHandler('gPersonalmenu:Weapon_addAmmoToPedC', function(value, quantity)
  local weaponHash = GetHashKey(value)

    if HasPedGotWeapon(PlayerPed, weaponHash, false) and value ~= 'WEAPON_UNARMED' then
        AddAmmoToPed(PlayerPed, value, quantity)
    end
end)


function RefreshMoney()
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
		ESX.TriggerServerCallback('eSociety:getSocietyMoney', function(money)
			societymoney = ESX.Math.GroupDigits(money)
		end, ESX.PlayerData.job.name)
	end
end

function RefreshMoney2()
	if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
		ESX.TriggerServerCallback('eSociety:getSocietyMoney', function(money)
			societymoney2 = ESX.Math.GroupDigits(money)
		end, ESX.PlayerData.job2.name)
	end
end

function RemoveObj(id, k)
    print("1")
    SetNetworkIdCanMigrate(id, true)
    local entity = NetworkGetEntityFromNetworkId(id)
    NetworkRequestControlOfEntity(entity)
    local test = 0
    while test > 100 and not NetworkHasControlOfEntity(entity) do
        NetworkRequestControlOfEntity(entity)
        Wait(1)
        test = test + 1
    end
    SetEntityAsNoLongerNeeded(entity)
    print("2")
    local test = 0
    while test < 100 and DoesEntityExist(entity) do 
        SetEntityAsNoLongerNeeded(entity)
        DeleteEntity(entity)
        DeleteObject(entity)
        print("3")
        if not DoesEntityExist(entity) then 
            table.remove(object, k)
        end
        SetEntityCoords(entity, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0)
        Wait(1)
        test = test + 1
    end
end

function SetUnsetAccessory(accessory)
	ESX.TriggerServerCallback('esx_accessories:get', function(hasAccessory, accessorySkin)
		local _accessory = string.lower(accessory)

		if hasAccessory then
			TriggerEvent('skinchanger:getSkin', function(skin)
				local mAccessory = -1
				local mColor = 0

				if _accessory == "mask" then
					mAccessory = 0
				end

				if skin[_accessory .. '_1'] == mAccessory then
					mAccessory = accessorySkin[_accessory .. '_1']
					mColor = accessorySkin[_accessory .. '_2']
				end

				local accessorySkin = {}
				accessorySkin[_accessory .. '_1'] = mAccessory
				accessorySkin[_accessory .. '_2'] = mColor
				TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
			end)
		else
			ESX.ShowNotification("Vous n'avez pas d'accessoires")
		end
	end, accessory)
end

local watodo = {
	indexwatodo = 1,
	listwatodo = {'Equiper', 'Renommer', 'Supprimer'},
}

local watodoo = {
	indexwatodoo = 1,
	listwatodoo = {'Equiper', 'Renommer', 'Donner', 'Jeter'},
}


local watoda = {
	indexwatoda = 1,
	listwatoda = {'Masque', 'Chapeau', 'Lunettes', 'Boucles d\'oreilles'},
}

MaskTab = {}

local PermaWeapons = {
    {weapon = "WEAPON_SAWNOFFSHOTGUN"},
}

local MyDoubleIndex = 1

function GetEtatMoteur()
    local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)

    if GetIsVehicleEngineRunning(plyVeh) then
        StatusMoteur = "~g~ON"
    elseif not GetIsVehicleEngineRunning(plyVeh) then
        StatusMoteur = "~r~OFF"
    end
end

function GetEtatPortes()
    local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
    local locked = GetVehicleDoorLockStatus(plyVeh)
    if locked == 1 or locked == 0 then -- if unlocked
        StatusPortes = "~g~Ouvert"
    elseif locked == 2 then -- if locked
        StatusPortes = "~r~Fermer"
    end
end

local weapon_list = {
    "Normal",
    "Vert",
    "Or",
    "Rose",
    "Armée",
    "LSPD",
    "Fissure",
    "Platinium",
}
local weapon_list_index = 1
local blocked_camo_weapon_button = false
local washvehicle = false
local xenon_color_list = {
    "Normal",
    "Blanc",
    "Bleu",
    "Bleu Éléctrique",
    "Menthe Verte",
    "Vert Lime",
    "Jaune",
    "Or",
    "Orange",
    "Rouge",
    "Rose",
    "Rose Fluo",
    "Violet",
    "Sobre",
}
local xenon_color_index = 1
local enabled_xenon = false
local blocked_xenon_color_button = false
local activeXenon = false
local window_tint_list = {
    "Normal",
    "Noir pure",
    "Foncé",
    "Clair",
    "Sans vitre",
    "Limousine",
    "Vert"
}
local window_action = { "Ouvrir", "Fermer "}
local window_action_index = 1
local window_tint_index = 1
local activeWindowTint = false
local plate_color_list = {
    "Bleu sur Blanc",
    "Jaune sur Noir",
    "Jaune sur Bleu",
    "Bleu sur Blanc2",
    "Bleu sur Blanc3",
    "Yankton",
}
local plate_color_index = 1
local activePlate = false
local IddIndex = 1
local Pdarme = 1
local PmIndex = 1

DeleteVipProps = function()
	local pCoords = GetEntityCoords(PlayerPedId())
    local closestDistance = -1
    local closestEntity   = nil
    for i=1, #Vip.props_model_name, 1 do
        local object = GetClosestObjectOfType(pCoords, 3.0, GetHashKey(Vip.props_model_name[i]), false, false, false)
        if DoesEntityExist(object) then
            local objCoords = GetEntityCoords(object)
			local distance = #(pCoords - objCoords)
            if closestDistance == -1 or closestDistance > distance then
				closestDistance = distance
				closestEntity   = object
                end
        	end
        if closestDistance ~= -1 and closestDistance <= 3.0 then
            DeleteEntity(object)
        end
    end
end

local IndexVIPP = 1 

function gPersonalmenu()
    local MPersonalmenu = RageUI.CreateMenu("Atomic", "Interaction")
    local Minventaire = RageUI.CreateSubMenu(MPersonalmenu, "Atomic", "Interaction")
    local Minventaire2 = RageUI.CreateSubMenu(Minventaire, "Atomic", "Interaction")
    local Marmes = RageUI.CreateSubMenu(Minventaire, "Atomic", "Interaction")
    local Marmes2 = RageUI.CreateSubMenu(Marmes, "Atomic", "Interaction")
    local Mportefeuille = RageUI.CreateSubMenu(MPersonalmenu, "Atomic", "Interaction")
    local Mportefeuilleli = RageUI.CreateSubMenu(Mportefeuille, "Atomic", "Interaction")
    local Mportefeuillesale = RageUI.CreateSubMenu(Mportefeuille, "Atomic", "Interaction")
    local Mfacture = RageUI.CreateSubMenu(Mportefeuille, "Atomic", "Interaction")
    local Mvetements = RageUI.CreateSubMenu(MPersonalmenu, "Atomic", "Interaction")
    local Access = RageUI.CreateSubMenu(Mvetements, "Atomic", "Interaction")

    local Mgestveh = RageUI.CreateSubMenu(MPersonalmenu, "Atomic", "Interaction")
    local Mgestentreprise = RageUI.CreateSubMenu(MPersonalmenu, "Atomic", "Interaction")
    local Mgestoraga = RageUI.CreateSubMenu(MPersonalmenu, "Atomic", "Interaction")
    local Mdivers = RageUI.CreateSubMenu(MPersonalmenu, "Atomic", "Interaction")
    local Mclef = RageUI.CreateSubMenu(MPersonalmenu, "Atomic", "Interaction")
    local Madmin = RageUI.CreateSubMenu(MPersonalmenu, "Atomic", "Interaction")
    local WeaponVise = RageUI.CreateSubMenu(MPersonalmenu, "Atomic", "Interaction")
    local WeaponAnim = RageUI.CreateSubMenu(MPersonalmenu, "Atomic", "Interaction")
    local reditor = RageUI.CreateSubMenu(MPersonalmenu, "Atomic", "Interaction")

    local eVip = RageUI.CreateSubMenu(MPersonalmenu, "Atomic", "Interaction")
    local vip_car = RageUI.CreateSubMenu(eVip, "Atomic", "Interaction")
    local vip_filtre = RageUI.CreateSubMenu(eVip, "Atomic", "Interaction")
    local vip_menu = RageUI.CreateSubMenu(eVip, "Atomic", "Interaction")
    local vip_ped = RageUI.CreateSubMenu(eVip, "Atomic", "Interaction")

    local vip_props = RageUI.CreateSubMenu(eVip, "Atomic", "Interaction")
    local PropsMenuobject = RageUI.CreateSubMenu(vip_props, "Atomic", "Appuyer sur ~g~E~w~ pour poser les objet")
    local PropsMenuobjectlist = RageUI.CreateSubMenu(vip_props, "Atomic", "Suppression d'objets")

    local vip_weapon = RageUI.CreateSubMenu(eVip, "Atomic", "Interaction")

        RageUI.Visible(MPersonalmenu, not RageUI.Visible(MPersonalmenu))
            while MPersonalmenu do
            Citizen.Wait(0)
            RageUI.IsVisible(MPersonalmenu, true, true, true, function()
                RageUI.Separator('Votre ID : ~b~'..GetPlayerServerId(PlayerId()))

                RageUI.ButtonWithStyle("→ Portefeuille", nil, {RightLabel = ""}, true, function(Hovered,Active,Selected)
                end, Mportefeuille)

                if IsPedSittingInAnyVehicle(PlayerPedId()) then
                    RageUI.ButtonWithStyle("→ Gestion Véhicule", nil, {RightLabel = ""}, true, function(Hovered,Active,Selected)
                        if Selected then
                            GetEtatMoteur()
                            GetEtatPortes()
                        end
                    end, Mgestveh)                       
                else
                    RageUI.ButtonWithStyle('→ Gestion Véhicule', description, {RightBadge = RageUI.BadgeStyle.Lock }, false, function(Hovered, Active, Selected)
                    end)
                end

                if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
                    RageUI.ButtonWithStyle("→ Gestion Entreprise", nil, {RightLabel = ""}, true, function(Hovered,Active,Selected)
                    end, Mgestentreprise)
                else
                    RageUI.ButtonWithStyle('→ Gestion Entreprise', nil, {RightBadge = RageUI.BadgeStyle.Lock }, false, function(Hovered, Active, Selected)
                    end)
                end

                if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
                    RageUI.ButtonWithStyle("→ Gestion Organisation", nil, {RightLabel = ""}, true, function(Hovered,Active,Selected)
                    end, Mgestoraga)
                else
                    RageUI.ButtonWithStyle('→ Gestion Organisation', nil, {RightBadge = RageUI.BadgeStyle.Lock }, false, function(Hovered, Active, Selected)
                    end)
                end
            
                RageUI.ButtonWithStyle("→ Cle(s)", nil, {RightLabel = ""}, true, function(Hovered,Active,Selected)
                    if (Selected) then
                        RefreshCles()
                    end
                end, Mclef)

                RageUI.ButtonWithStyle("→ Boutique", nil, {RightLabel = ""}, true, function(Hovered,Active,Selected)
                    if Selected then 
                        RageUI.CloseAll()
                        ExecuteCommand("boutique")
                    end
                end)  

                RageUI.ButtonWithStyle("→ Divers", nil, {RightLabel = ""}, true, function(Hovered,Active,Selected)
                end, Mdivers)

            end, function()
            end)

            RageUI.IsVisible(eVip, true, true, true, function()

                --RageUI.List('→ Mettre', {"Patin à roulette", "Patin à glace"}, IndexVIPP, "/roller - /iceroller", {RightLabel = ""}, true, function(Hovered, Active, Selected, Index)
                --    IndexVIPP = Index;              
                --end)

                --RageUI.ButtonWithStyle("→ Enlever", "/leave", {RightLabel = ""}, true, function(_,_,s)
                --end)

                if Vip.EnabledOrDisabledOptions.AuthorizeWeaponMenu then
                    RageUI.ButtonWithStyle("→ Armes", "Accèder à la catégorie armes.", {RightLabel = ""}, true, function(_,_,s)
                    end, vip_weapon)
                end
                if Vip.EnabledOrDisabledOptions.AuthorizeCarMenu then
                    RageUI.ButtonWithStyle("→ Véhicules", "Accèder à la catégorie véhicules.", {RightLabel = ""}, true, function(_,_,s)
                    end, vip_car)
                end
                if Vip.EnabledOrDisabledOptions.AuthorizePedMenu then
                    RageUI.ButtonWithStyle("→ Peds", "Accèder à la catégorie peds.", {RightLabel = ""}, true, function(_,_,s)
                    end, vip_ped)
                end
                if Vip.EnabledOrDisabledOptions.AuthorizePropsMenu then
                    RageUI.ButtonWithStyle("→ Props", "Accèder à la catégorie props.", {RightLabel = ""}, true, function(_,_,s)
                    end, vip_props)
                end

            end, function()
            end)


            RageUI.IsVisible(vip_props, true, true, true, function()

                RageUI.ButtonWithStyle("→ Objet(s)", "Appuyer sur [~g~E~w~] pour poser les objet", { RightLabel = "" }, true, function(Hovered, Active, Selected)
                end, PropsMenuobject)
        
                RageUI.ButtonWithStyle("→ Mode suppression", "Supprimer des objets", { RightLabel = "" }, true, function(Hovered, Active, Selected)
                end, PropsMenuobjectlist)

            end, function()
            end)

            RageUI.IsVisible(PropsMenuobject, true, true, true, function()

                for k,v in pairs(Vip.Props) do 
                    RageUI.ButtonWithStyle(v.label, nil, {}, true, function(Hovered, Active, Selected)
                        if Selected then
                            SpawnObj(v.name)
                        end
                    end)
                end
        
                end, function()
                end)
        
                RageUI.IsVisible(PropsMenuobjectlist, true, true, true, function()

                    for k,v in pairs(object) do
                        if GoodName(GetEntityModel(NetworkGetEntityFromNetworkId(v))) == 0 then 
                            table.remove(object, k) 
                        end
                        RageUI.ButtonWithStyle("Objet: "..GoodName(GetEntityModel(NetworkGetEntityFromNetworkId(v))).." ["..v.."]", nil, {}, true, function(Hovered, Active, Selected)
                            if (Active) then
                                local entity = NetworkGetEntityFromNetworkId(v)
                                local ObjCoords = GetEntityCoords(entity)
                                DrawMarker(0, ObjCoords.x, ObjCoords.y, ObjCoords.z+1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 1, 0, 2, 1, nil, nil, 0)
                            end
                            if (Selected) then
                                DeleteVipProps()
                            end
                        end)
                    end
                    
                end, function()
                end)

            RageUI.IsVisible(vip_car, true, true, true, function()


                pVeh = GetVehiclePedIsUsing(PlayerPedId())
                pVeh2 = GetVehiclePedIsIn(PlayerPedId(), true)
                if not IsPedSittingInAnyVehicle(PlayerPedId()) then
                    RageUI.Separator("") 
                    RageUI.Separator("~r~Vous n'êtes pas dans un véhicule !") 
                    RageUI.Separator("")
                else
                    if Vip.EnabledOrDisabledOptions.AuthorizeWashVehicle then
                        RageUI.ButtonWithStyle("Nettoyer le véhicule", "Nettoyer le véhicule dans lequel vous êtes.", {RightLabel = "→→"}, true, function(_,_,s)
                            if s then
                                if not IsPedSittingInAnyVehicle(PlayerPedId()) then
                                    ESX.ShowAdvancedNotification('Information', 'VIP', 'Vous n\'êtes pas dans un véhicule.', 'CHAR_SOCIAL_CLUB', 1)
                                else
                                    washvehicle = true
                                    WashDecalsFromVehicle(pVeh, 1.0)
                                    ESX.ShowAdvancedNotification('Information', 'VIP', 'Véhicule nettoyé avec succès !', 'CHAR_SOCIAL_CLUB', 1)
                                end
                            end
                        end)
                    end
                    if Vip.EnabledOrDisabledOptions.AuthorizeXenonVehicle then
                        RageUI.Separator('↓ Phares xénon ↓')
                        RageUI.Checkbox("Activer les phares xénon", "Activer / Désactiver les phares xénon", activeXenon, { Style = RageUI.CheckboxStyle.Tick }, function(_,s,_,c)
                            activeXenon = c;
                            if s then
                                if c then
                                if not IsPedSittingInAnyVehicle(PlayerPedId()) then
                                    ESX.ShowAdvancedNotification('Information', 'VIP', 'Vous n\'êtes pas dans un véhicule.', 'CHAR_SOCIAL_CLUB', 1)
                                    activeXenon = false
                                else
                                    activeXenon = true
                                    enabled_xenon = true
                                    local player_vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
                                    SetVehicleModKit(player_vehicle, 0)
                               --     ToggleVehicleMod(player_vehicle, 18, true)
                                    SetVehicleWindowTint(player_vehicle, 2)
                                    ToggleVehicleMod(player_vehicle, 22, true)
                                    SetVehicleWindowTint(player_vehicle, 3)
                                 --   ToggleVehicleMod(player_vehicle, 20, true)
                                end
                                else
                                    activeXenon = false
                                    xenon_check = false
                                    ToggleVehicleMod(pVeh, 22, false)
                                end
                            end
                        end)
                    end
                    if activeXenon then
                        RageUI.List("Couleur phares xenon", xenon_color_list, xenon_color_index, "Choisissez une couleur de phares xenon.", {RightBadge = RageUI.BadgeStyle.Car}, true, function(_,a,s,i)
                            xenon_color_index = i
                            if a then
                                if xenon_color_index == 1 then
                                    if s then
                                        SetVehicleHeadlightsColour(pVeh, -1)
                                    end
                                else
                                    if xenon_color_index == 2 then
                                        if s then
                                            blocked_xenon_color_button = true
                                            SetVehicleHeadlightsColour(pVeh, 0)
                                        end
                                    else
                                        if xenon_color_index == 3 then
                                            if s then
                                                blocked_xenon_color_button = true
                                                SetVehicleHeadlightsColour(pVeh, 1)
                                            end
                                        else
                                            if xenon_color_index == 4 then
                                                if s then
                                                    blocked_xenon_color_button = true
                                                    SetVehicleHeadlightsColour(pVeh, 2)
                                                end
                                            else
                                                if xenon_color_index == 5 then
                                                    if s then
                                                        blocked_xenon_color_button = true
                                                        SetVehicleHeadlightsColour(pVeh, 3)
                                                    end
                                                else
                                                    if xenon_color_index == 6 then
                                                        if s then
                                                            blocked_xenon_color_button = true
                                                            SetVehicleHeadlightsColour(pVeh, 4)
                                                        end
                                                    else
                                                        if xenon_color_index == 7 then
                                                            if s then
                                                                blocked_xenon_color_button = true
                                                                SetVehicleHeadlightsColour(pVeh, 5)
                                                            end
                                                        else
                                                            if xenon_color_index == 8 then
                                                                if s then
                                                                    blocked_xenon_color_button = true
                                                                    SetVehicleHeadlightsColour(pVeh, 6)
                                                                end
                                                            else
                                                                if xenon_color_index == 9 then
                                                                    if s then
                                                                        blocked_xenon_color_button = true
                                                                        SetVehicleHeadlightsColour(pVeh, 7)
                                                                    end
                                                                else
                                                                    if xenon_color_index == 10 then
                                                                        if s then
                                                                            blocked_xenon_color_button = true
                                                                            SetVehicleHeadlightsColour(pVeh, 8)
                                                                        end
                                                                    else
                                                                        if xenon_color_index == 11 then
                                                                            if s then
                                                                                blocked_xenon_color_button = true
                                                                                SetVehicleHeadlightsColour(pVeh, 9)
                                                                            end
                                                                        else
                                                                            if xenon_color_index == 12 then
                                                                                if s then
                                                                                    blocked_xenon_color_button = true
                                                                                    SetVehicleHeadlightsColour(pVeh, 10)
                                                                                end
                                                                            else
                                                                                if xenon_color_index == 13 then
                                                                                    if s then
                                                                                        blocked_xenon_color_button = true
                                                                                        SetVehicleHeadlightsColour(pVeh, 11)
                                                                                    end
                                                                                else
                                                                                    if xenon_color_index == 14 then
                                                                                        if s then
                                                                                            blocked_xenon_color_button = true
                                                                                            SetVehicleHeadlightsColour(pVeh, 12)
                                                                                        end
                                                                                    end
                                                                                end
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end)
                    end
                    if Vip.EnabledOrDisabledOptions.AuthorizeWindowActions or Vip.EnabledOrDisabledOptions.AuthorizeColorWindow then
                        RageUI.Separator('↓ Vitres ↓')
                    end
                        if Vip.EnabledOrDisabledOptions.AuthorizeWindowActions then
                        RageUI.List("Actions vitres", window_action, window_action_index, "Ouvrez ou fermez vos fenêtres.", {}, true, function(_,a,s,i)
                            window_action_index = i
                            if a then
                                if window_action_index == 1 then
                                    if s then
                                        RollDownWindows(pVeh2)
                                    end
                                else
                                    if window_action_index == 2 then
                                        if s then
                                            for i = 0,7,1 do
                                                RollUpWindow(pVeh2, i)
                                                FixVehicleWindow(pVeh2, i)
                                            end
                                        end
                                    end
                                end
                            end
                        end)
                    end
                    if Vip.EnabledOrDisabledOptions.AuthorizeColorWindow then
                        RageUI.List("Couleur", window_tint_list, window_tint_index, "Choisissez la couleur de vos vitres.", {}, true, function(_,a,s,i)
                            window_tint_index = i
                            if a then
                                if window_tint_index == 1 then
                                    if s then
                                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
                                        activeWindowTint = true
                                        SetVehicleWindowTint(vehicle, 0)
                                    end
                                else
                                    if window_tint_index == 2 then
                                        if s then
                                            local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
                                            activeWindowTint = true
                                            SetVehicleWindowTint(vehicle, 1)
                                        end
                                    else
                                        if window_tint_index == 3 then
                                            if s then
                                                local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
                                                activeWindowTint = true
                                                SetVehicleWindowTint(vehicle, 2)
                                            end
                                        else
                                            if window_tint_index == 4 then
                                                if s then
                                                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
                                                    activeWindowTint = true
                                                    SetVehicleWindowTint(vehicle, 3)
                                                end
                                            else
                                                if window_tint_index == 5 then
                                                    if s then
                                                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
                                                        activeWindowTint = true
                                                        SetVehicleWindowTint(vehicle, 4)
                                                    end
                                                else
                                                    if window_tint_index == 6 then
                                                        if s then
                                                            local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
                                                            activeWindowTint = true
                                                            SetVehicleWindowTint(vehicle, 5)
                                                        end
                                                    else
                                                        if window_tint_index == 7 then
                                                            if s then
                                                                local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
                                                                activeWindowTint = true
                                                                SetVehicleWindowTint(vehicle, 6)
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end)
                    end
                    if Vip.EnabledOrDisabledOptions.AuthorizeColorPlaque then
                        RageUI.Separator('↓ Plaques ↓')
                        RageUI.List("Couleur", plate_color_list, plate_color_index, "Choisissez la couleur de votre plaque.", {}, true, function(_,a,s,i)
                            plate_color_index = i
                            if a then
                                if plate_color_index == 1 then
                                    if s then
                                        activePlate = true
                                        SetVehicleNumberPlateTextIndex(pVeh, 0)
                                    end
                                else
                                    if plate_color_index == 2 then
                                        if s then
                                            activePlate = true
                                            SetVehicleNumberPlateTextIndex(pVeh, 1)
                                        end
                                    else
                                        if plate_color_index == 3 then
                                            if s then
                                                activePlate = true
                                                SetVehicleNumberPlateTextIndex(pVeh, 2)
                                            end
                                        else
                                            if plate_color_index == 4 then
                                                if s then
                                                    activePlate = true
                                                    SetVehicleNumberPlateTextIndex(pVeh, 3)
                                                end
                                            else
                                                if plate_color_index == 5 then
                                                    if s then
                                                        activePlate = true
                                                        SetVehicleNumberPlateTextIndex(pVeh, 4)
                                                    end
                                                else
                                                    if plate_color_index == 6 then
                                                        if s then
                                                            activePlate = true
                                                            SetVehicleNumberPlateTextIndex(pVeh, 5)
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end)
                    end
                end

            end, function()
            end)

            RageUI.IsVisible(vip_weapon, true, true, true, function()
                if IsPedSittingInAnyVehicle(PlayerPedId()) then
                    RageUI.Separator('') RageUI.Separator('~r~Aucune actions possible dans un véhicule !') RageUI.Separator('')
                else
                    if Vip.EnabledOrDisabledOptions.AuthorizeWeaponTint then
                        RageUI.List("Camouflages Armes", weapon_list, weapon_list_index, "Choisissez un camouflage pour votre arme.", {RightBadge = RageUI.BadgeStyle.Gun}, true, function(_,a,s,i)
                            weapon_list_index = i
                            if a then
                                if weapon_list_index == 1 then
                                    if s then
                                        SetPedWeaponTintIndex(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0)
                                    end
                                else
                                    if weapon_list_index == 2 then
                                        if s then
                                           blocked_camo_weapon_button = true
                                            SetPedWeaponTintIndex(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 1)
                                        end
                                    else
                                        if weapon_list_index == 3 then
                                            if s then
                                                blocked_camo_weapon_button = true
                                                SetPedWeaponTintIndex(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 2)
                                            end
                                        else
                                            if weapon_list_index == 4 then
                                                if s then
                                                    blocked_camo_weapon_button = true
                                                    SetPedWeaponTintIndex(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 3)
                                                end
                                            else
                                                if weapon_list_index == 5 then
                                                    if s then
                                                        blocked_camo_weapon_button = true
                                                        SetPedWeaponTintIndex(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 4)
                                                    end
                                                else
                                                    if weapon_list_index == 6 then
                                                        if s then
                                                            blocked_camo_weapon_button = true
                                                            SetPedWeaponTintIndex(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 5)
                                                        end
                                                    else
                                                        if weapon_list_index == 7 then
                                                            if s then
                                                                blocked_camo_weapon_button = true
                                                                SetPedWeaponTintIndex(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 6)
                                                            end
                                                        else
                                                            if weapon_list_index == 8 then
                                                                if s then
                                                                    blocked_camo_weapon_button = true
                                                                    SetPedWeaponTintIndex(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 7)
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end)
                    end
                end
            end, function()
            end)

            RageUI.IsVisible(vip_ped, true, true, true, function()
                RageUI.ButtonWithStyle("→ Revenir à son personnage", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                    if (Selected) then  
                        SetParticle() 
                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                            local isMale = skin.sex == 0
                            TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
                                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                                    TriggerEvent('skinchanger:loadSkin', skin)
                                end)
                            end)
                        end)
                    end
                end)

                
                RageUI.List('→ Se mettre en ', Peds.name, Peds.list, nil, {RightLabel = ""}, true, function(Hovered, Active, Selected, Index)
                    if (Selected) then 
                        SetParticle()
                        if Index == 1 then

                            RequestModel("a_c_chimp")
                            while not HasModelLoaded("a_c_chimp") do
                                Wait(100)
                                end
                            SetPlayerModel(PlayerId(), "a_c_chimp")
                            SetModelAsNoLongerNeeded("a_c_chimp")
                        
                        elseif Index == 2 then
                            
                            RequestModel("csb_stripper_01")
                            while not HasModelLoaded("csb_stripper_01") do
                                Wait(100)
                                end
                            SetPlayerModel(PlayerId(), "csb_stripper_01")
                            SetModelAsNoLongerNeeded("csb_stripper_01")

                    elseif Index == 3 then

                        RequestModel("s_m_m_movspace_01")
                        while not HasModelLoaded("s_m_m_movspace_01") do
                            Wait(100)
                            end
                        SetPlayerModel(PlayerId(), "s_m_m_movspace_01")
                        SetModelAsNoLongerNeeded("s_m_m_movspace_01")

                    elseif Index == 4 then

                        RequestModel("s_m_m_movalien_01")
                        while not HasModelLoaded("s_m_m_movalien_01") do
                            Wait(100)
                            end
                        SetPlayerModel(PlayerId(), "s_m_m_movalien_01")
                        SetModelAsNoLongerNeeded("s_m_m_movalien_01")

                    elseif Index == 5 then

                        RequestModel("a_c_cat_01")
                        while not HasModelLoaded("a_c_cat_01") do
                            Wait(100)
                            end
                        SetPlayerModel(PlayerId(), "a_c_cat_01")
                        SetModelAsNoLongerNeeded("a_c_cat_01")

                    elseif Index == 6 then

                        RequestModel("a_c_chickenhawk")
                        while not HasModelLoaded("a_c_chickenhawk") do
                            Wait(100)
                            end
                        SetPlayerModel(PlayerId(), "a_c_chickenhawk")
                        SetModelAsNoLongerNeeded("a_c_chickenhawk")

                    elseif Index == 7 then

                        RequestModel("a_c_coyote")
                        while not HasModelLoaded("a_c_coyote") do
                            Wait(100)
                            end
                        SetPlayerModel(PlayerId(), "a_c_coyote")
                        SetModelAsNoLongerNeeded("a_c_coyote")

                    end
                end
                    Peds.list = Index;              
                end)

                    RageUI.ButtonWithStyle("→ Choisir un ped perso", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                    if (Selected) then   
                    local j1 = PlayerId()
                    local newped = KeyboardInput('ped a choisir', '', 45)
                    local p1 = GetHashKey(newped)
                    RequestModel(p1)
                    while not HasModelLoaded(p1) do Wait(100) end
                        SetParticle()
                        SetPlayerModel(j1, p1)
                        SetModelAsNoLongerNeeded(p1)
                    end      
                end)
            end, function()
            end)

        RageUI.IsVisible(Mportefeuille, true, true, true, function()

            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

            --RageUI.ButtonWithStyle("→ Factures", nil, {RightLabel = ""}, true, function(Hovered,Active,Selected)
            --end, Mfacture)

            --RageUI.Line()
            RageUI.Separator('~b~Métier → ~s~'..ESX.PlayerData.job.label.." - "..ESX.PlayerData.job.grade_label)
            RageUI.Separator('~r~Oganisation → ~s~'..ESX.PlayerData.job2.label.." - "..ESX.PlayerData.job2.grade_label)
            --RageUI.Line()

            for i = 1, #ESX.PlayerData.accounts, 1 do
                if ESX.PlayerData.accounts[i].name == 'bank' then
                    RageUI.ButtonWithStyle('→ Banque : ', description,{ RightLabel = "~b~$" .. ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money .. "~s~") }, true, function(Hovered, Active, Selected)
                    end)
                end

                if ESX.PlayerData.accounts[i].name == 'black_money' then
                    RageUI.ButtonWithStyle('→ Argent Sale : ', description,{ RightLabel = "~r~$" .. ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money .. "~s~") },true, function(Hovered, Active, Selected)
                    end)
                end

                if ESX.PlayerData.accounts[i].name == 'money' then
                    RageUI.ButtonWithStyle('→ Liquide : ', description,{ RightLabel = "~g~$" .. ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money .. "~s~") },true, function(Hovered, Active, Selected)
                    end)
                end
            end

            RageUI.Separator('~b~ ↓ Vos papiers ↓')
            
            RageUI.List("→ Carte d'itentité", {"Voir", "Montrer"}, IddIndex, nil,{}, true, function(_, _, Selected, Index)
                if (Selected) then
                    if Index == 1 then
                        TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
                    elseif Index == 2 then
                        if closestDistance ~= -1 and closestDistance <= 3.0 then
                            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
                        else
                            ESX.ShowNotification('Aucun joueur proche !')
                        end
                    end
                end
                IddIndex = Index
            end)

            RageUI.List("→ Permis", {"Voir", "Montrer"}, PmIndex, nil,{}, true, function(_, _, Selected, Index)
                if (Selected) then
                    if Index == 1 then
                        TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
                    elseif Index == 2 then
                        if closestDistance ~= -1 and closestDistance <= 3.0 then
                            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'driver')
                        else
                            ESX.ShowNotification('Aucun joueur proche !')
                        end
                    end
                end
                PmIndex = Index
            end)

            RageUI.List("→ Port d'arme", {"Voir", "Montrer"}, Pdarme, nil,{}, true, function(_, _, Selected, Index)
                if (Selected) then
                    if Index == 1 then
                        TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
                    elseif Index == 2 then
                        if closestDistance ~= -1 and closestDistance <= 3.0 then
                            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'weapon')
                        else
                            ESX.ShowNotification('Aucun joueur proche !')
                        end
                    end
                end
                Pdarme = Index
            end)

            end, function()
            end)

            RageUI.IsVisible(Mportefeuilleli, true, true, true, function()
                RageUI.ButtonWithStyle("Donner", nil, {RightBadge = RageUI.BadgeStyle.Lock}, true, function(Hovered,Active,Selected)
                    if Selected then
                        local black, quantity = CheckQuantity(KeyboardInput("Somme d'argent que vous voulez donner", '', 1000))
                            if black then
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                        if closestDistance ~= -1 and closestDistance <= 3 then
                            local closestPed = GetPlayerPed(closestPlayer)

                            if not IsPedSittingInAnyVehicle(closestPed) then
                                TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_money', 'rien', quantity)
                            else
                               ESX.ShowNotification('Vous ne pouvez pas donner de l\'argent dans un véhicles')
                            end
                        else
                           ESX.ShowNotification('Aucun joueur proche !')
                        end
                    else
                       ESX.ShowNotification('Somme invalid')
                    end
                end
            end)

            RageUI.ButtonWithStyle("Jeter", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, function(Hovered, Active, Selected)
                if Selected then
                    local quantity = KeyboardInput("Somme d'argent que vous voulez jeter", "", 25)
                    if tonumber(quantity) then
                        if not IsPedSittingInAnyVehicle(PlayerPedId()) then
                            TriggerServerEvent('esx:removeInventoryItem', 'item_money', 'rien', tonumber(quantity))
                            RageUI.CloseAll()
                        else
                            ESX.ShowNotification("Cette action est impossible dans un véhicule !")
                        end
                    else
                        ESX.ShowNotification("Les champs sont incorrects !")
                    end
                end
            end)

        end, function()
        end)

            RageUI.IsVisible(Mportefeuillesale, true, true, true, function()
                for i = 1, #ESX.PlayerData.accounts, 1 do
                    if ESX.PlayerData.accounts[i].name == 'black_money' then
                        RageUI.ButtonWithStyle("Donner", nil, {RightBadge = RageUI.BadgeStyle.Lock}, true, function(Hovered,Active,Selected)
                            if Selected then
                                local quantity = KeyboardInput("Somme d'argent que vous voulez jeter", "", 25)
                                if tonumber(quantity) then
                                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                                if closestDistance ~= -1 and closestDistance <= 3 then
                                    local closestPed = GetPlayerPed(closestPlayer)

                                    if not IsPedSittingInAnyVehicle(closestPed) then
                                        TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_account', ESX.PlayerData.accounts[i].name, tonumber(quantity))
                                        --RageUI.CloseAll()
                                    else
                                       ESX.ShowNotification(_U('Vous ne pouvez pas donner ', 'de l\'argent dans un véhicles'))
                                    end
                                else
                                   ESX.ShowNotification('Aucun joueur proche !')
                                end
                            else
                               ESX.ShowNotification('Somme invalid')
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Jeter", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local quantity = KeyboardInput("Somme d'argent que vous voulez jeter", "", 25)
                            if tonumber(quantity) then
                                if not IsPedSittingInAnyVehicle(PlayerPed) then
                                    TriggerServerEvent('esx:removeInventoryItem', 'item_account', ESX.PlayerData.accounts[i].name, tonumber(quantity))
                                   -- RageUI.CloseAll()
                                        else
                                           ESX.ShowNotification('Vous pouvez pas jeter', 'de l\'argent')
                                            end
                                        else
                                           ESX.ShowNotification('Somme Invalid')
                                        end
                                    end
                                end)
                            end
                        end
            end, function()
            end)


            RageUI.IsVisible(Mfacture, true, true, true, function()



            end, function()
            end)


            RageUI.IsVisible(Mvetements, true, true, true, function()

                RageUI.List("Choix", {"Vêtements", "Accessoires"}, MyDoubleIndex, nil, {}, true,function(h,a,s, Index)
                    MyDoubleIndex = Index
                    if Index == 1 then
                        vetements = true
                        acc = false
                    else
                        vetements = false
                        acc = true
                    end
                end)

                if vetements then 

                RageUI.Separator('~g~↓ Vêtements ↓')

                RageUI.ButtonWithStyle("Haut", nil, {RightBadge = RageUI.BadgeStyle.Clothes}, not cooldown, function(Hovered, Active,Selected)
                    if (Selected) then
                       TriggerEvent('rPersonalmenu:actionhaut')   
                   end 
               end)
           
               RageUI.ButtonWithStyle("Pantalon", nil, {RightBadge = RageUI.BadgeStyle.Clothes}, not cooldown, function(Hovered, Active,Selected)
                    if (Selected) then
                       TriggerEvent('rPersonalmenu:actionpantalon')  
                   end 
               end)
           
               RageUI.ButtonWithStyle("Chaussure", nil, {RightBadge = RageUI.BadgeStyle.Clothes}, not cooldown, function(Hovered, Active,Selected)
                   if (Selected) then 
                   TriggerEvent('rPersonalmenu:actionchaussure')
                  end 
              end)

            else
              RageUI.Separator('~g~↓ Accessoires ↓')

           
              RageUI.ButtonWithStyle("Sac", nil, {RightBadge = RageUI.BadgeStyle.Clothes}, not cooldown, function(Hovered, Active,Selected)
               if (Selected) then
                   TriggerEvent('rPersonalmenu:actionsac') 
                   end 
               end)
           
               RageUI.ButtonWithStyle("Gilet par balle", nil, {RightBadge = RageUI.BadgeStyle.Clothes}, not cooldown, function(Hovered, Active,Selected)
                   if (Selected) then
                    TriggerEvent('rPersonalmenu:actiongiletparballe') 
                   end 
               end)

               RageUI.ButtonWithStyle("Masque", nil, {RightBadge = RageUI.BadgeStyle.Clothes}, not cooldown, function(Hovered, Active,Selected)
                if (Selected) then
                        local lib, anim = 'clothingtie', 'try_tie_neutral_a'
                        ESX.Streaming.RequestAnimDict(lib, function()
                            TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                        end)
                        Citizen.Wait(1000)

                        ClearPedTasks(PlayerPedId())
                        SetUnsetAccessory("Mask")
                    end 
                end)

            RageUI.ButtonWithStyle("Chapeau", nil, {RightBadge = RageUI.BadgeStyle.Clothes}, not cooldown, function(Hovered, Active,Selected)
                if (Selected) then
                    local lib, anim = 'clothingtie', 'try_tie_neutral_a'

                    ESX.Streaming.RequestAnimDict(lib, function()
                        TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                    end)
                    Citizen.Wait(1000)
                    ClearPedTasks(PlayerPedId())
                    SetUnsetAccessory("Helmet")
                end 
            end)

            RageUI.ButtonWithStyle("Lunette", nil, {RightBadge = RageUI.BadgeStyle.Clothes}, not cooldown, function(Hovered, Active,Selected)
                if (Selected) then
                    local lib, anim = 'clothingtie', 'try_tie_neutral_a'

                    ESX.Streaming.RequestAnimDict(lib, function()
                        TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                    end)
                    Citizen.Wait(1000)
                    ClearPedTasks(PlayerPedId())
                    TriggerEvent('rPersonalmenu:actionlunette')
                end 
            end)

            RageUI.ButtonWithStyle("Boucle oreille", nil, {RightBadge = RageUI.BadgeStyle.Clothes}, not cooldown, function(Hovered, Active,Selected)
                if (Selected) then
                    local lib, anim = 'clothingtie', 'try_tie_neutral_a'

                    ESX.Streaming.RequestAnimDict(lib, function()
                        TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                    end)
                    Citizen.Wait(1000)
                    ClearPedTasks(PlayerPedId())
                    SetUnsetAccessory("Ears")
                end 
            end)

            RageUI.ButtonWithStyle("Montre", nil, {RightBadge = RageUI.BadgeStyle.Clothes}, not cooldown, function(Hovered, Active,Selected)
                if (Selected) then
                    TriggerEvent('rPersonalmenu:Montre') 
                end 
            end)

            RageUI.ButtonWithStyle("Chaine", nil, {RightBadge = RageUI.BadgeStyle.Clothes}, not cooldown, function(Hovered, Active,Selected)
                if (Selected) then
                    TriggerEvent('rPersonalmenu:Chaine') 
                end 
            end)
        end

            end, function()
            end)

            RageUI.IsVisible(Mgestveh, true, true, true, function()

                local Ped = PlayerPedId()
                local GetSourcevehicle = GetVehiclePedIsIn(Ped, false)
                local Vengine = GetVehicleEngineHealth(GetSourcevehicle) / 10
                local Plaque = GetVehicleNumberPlateText(GetSourcevehicle)
                local essence = GetVehicleFuelLevel(GetSourcevehicle)
    
                RageUI.Line()
                RageUI.Separator("Plaque d'immatriculation → ~b~" ..Plaque.. " ")
                RageUI.Separator("État du moteur~s~ →~b~ " ..math.floor(Vengine).. "% ~s~/ Essence → ~b~ "..math.floor(essence).. "%")
                RageUI.Line()
                
                RageUI.ButtonWithStyle("→ Status du moteur", nil, {RightLabel = "→ "..StatusMoteur.. " ~s~←"}, not cooldown,function(Hovered, Active, Selected)
                    if (Selected) then
                        if GetIsVehicleEngineRunning(GetSourcevehicle) then
                            SetVehicleEngineOn(GetSourcevehicle, false, false, true)
                            SetVehicleUndriveable(GetSourcevehicle, true)
                            StatusMoteur = "~r~OFF"
                        elseif not GetIsVehicleEngineRunning(GetSourcevehicle) then
                            SetVehicleEngineOn(GetSourcevehicle, true, false, true)
                            SetVehicleUndriveable(GetSourcevehicle, false)
                            StatusMoteur = "~g~ON"
                        end
                        coolcoolmec(1500)
                    end
                end)
    
                RageUI.ButtonWithStyle("→ Status du Capot", nil, {RightLabel = "→ "..eGestVeh.StatusCapot.. " ~s~←"}, not cooldown,function(Hovered, Active, Selected)
                    if (Selected) then
                        if not eGestVeh.DoorState.Hood then
                            eGestVeh.DoorState.Hood = true
                            SetVehicleDoorOpen(GetSourcevehicle, 4, false, false)
                            eGestVeh.StatusCapot = "~g~Ouvert"
                        elseif eGestVeh.DoorState.Hood then
                            eGestVeh.DoorState.Hood = false
                            SetVehicleDoorShut(GetSourcevehicle, 4, false, false)
                            eGestVeh.StatusCapot = "~r~Fermer"
                        end
                        coolcoolmec(1500)
                    end
                end)
    
                RageUI.ButtonWithStyle("→ Status du Coffre", nil, {RightLabel = "→ "..eGestVeh.StatusCoffre.. " ~s~←"}, not cooldown,function(Hovered, Active, Selected)
                    if (Selected) then
                        if not eGestVeh.DoorState.Trunk then
                            eGestVeh.DoorState.Trunk = true
                            SetVehicleDoorOpen(GetSourcevehicle, 5, false, false)
                            eGestVeh.StatusCoffre = "~g~Ouvert"
                        elseif eGestVeh.DoorState.Trunk then
                            eGestVeh.DoorState.Trunk = false
                            SetVehicleDoorShut(GetSourcevehicle, 5, false, false)
                            eGestVeh.StatusCoffre = "~r~Fermer"
                        end
                        coolcoolmec(1500)
                    end
                end)
    
                RageUI.List("→ Gestion portes", eGestVeh.DoorList, eGestVeh.DoorIndex, nil, {}, not cooldown,function(Hovered, Active, Selected, Index)
                    if (Selected) then
                        if Index == 1 then
                            if not eGestVeh.DoorState.FrontLeft then
                                eGestVeh.DoorState.FrontLeft = true
                                SetVehicleDoorOpen(GetSourcevehicle, 0, false, false)
                            elseif eGestVeh.DoorState.FrontLeft then
                                eGestVeh.DoorState.FrontLeft = false
                                SetVehicleDoorShut(GetSourcevehicle, 0, false, false)
                            end
                        elseif Index == 2 then
                            if not eGestVeh.DoorState.FrontRight then
                                eGestVeh.DoorState.FrontRight = true
                                SetVehicleDoorOpen(GetSourcevehicle, 1, false, false)
                            elseif eGestVeh.DoorState.FrontRight then
                                eGestVeh.DoorState.FrontRight = false
                                SetVehicleDoorShut(GetSourcevehicle, 1, false, false)
                            end
                        elseif Index == 3 then
                            if not eGestVeh.DoorState.BackLeft then
                                eGestVeh.DoorState.BackLeft = true
                                SetVehicleDoorOpen(GetSourcevehicle, 2, false, false)
                            elseif eGestVeh.DoorState.BackLeft then
                                eGestVeh.DoorState.BackLeft = false
                                SetVehicleDoorShut(GetSourcevehicle, 2, false, false)
                            end
                        elseif Index == 4 then
                            if not eGestVeh.DoorState.BackRight then
                                eGestVeh.DoorState.BackRight = true
                                SetVehicleDoorOpen(GetSourcevehicle, 3, false, false)
                            elseif eGestVeh.DoorState.BackRight then
                                eGestVeh.DoorState.BackRight = false
                                SetVehicleDoorShut(GetSourcevehicle, 3, false, false)
                            end
                        elseif Index == 5 then
                            if not eGestVeh.DoorState.All then
                                eGestVeh.DoorState.All = true
                                SetVehicleDoorOpen(GetSourcevehicle, 0, false, false)
                                SetVehicleDoorOpen(GetSourcevehicle, 1, false, false)
                                SetVehicleDoorOpen(GetSourcevehicle, 2, false, false)
                                SetVehicleDoorOpen(GetSourcevehicle, 3, false, false)
                            elseif eGestVeh.DoorState.All then
                                eGestVeh.DoorState.All = false
                                SetVehicleDoorShut(GetSourcevehicle, 0, false, false)
                                SetVehicleDoorShut(GetSourcevehicle, 1, false, false)
                                SetVehicleDoorShut(GetSourcevehicle, 2, false, false)
                                SetVehicleDoorShut(GetSourcevehicle, 3, false, false)
                            end
                        end
                        coolcoolmec(1500)
                    end
                    eGestVeh.DoorIndex = Index
                end)
    
                RageUI.List('→ Gestion fenêtres', eGestVeh.WindowList, eGestVeh.WindowIndex, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                    if (Selected) then 
                        if Index == 1 then
                            if not avantg then
                                avantg = true
                                RollDownWindow(GetVehiclePedIsIn(PlayerPedId()), 0) 
                            elseif avantg then
                                avantg = false
                                RollUpWindow(GetVehiclePedIsIn(PlayerPedId()), 0) 
                            end
                        end
                        if Index == 2 then
                            if not avantd then
                                avantd = true
                                RollDownWindow(GetVehiclePedIsIn(PlayerPedId()), 1) 
                            elseif avantd then
                                avantd = false
                                RollUpWindow(GetVehiclePedIsIn(PlayerPedId()), 1) 
                            end
                        end
                        if Index == 3 then
                            if not arrg then
                                arrg = true
                                RollDownWindow(GetVehiclePedIsIn(PlayerPedId()), 2) 
                            elseif arrg then
                                arrg = false
                                RollUpWindow(GetVehiclePedIsIn(PlayerPedId()), 2) 
                            end
                        end
                        if Index == 4 then
                            if not arrd then
                                arrd = true
                                RollDownWindow(GetVehiclePedIsIn(PlayerPedId()), 3) 
                            elseif arrd then
                                arrd = false
                                RollUpWindow(GetVehiclePedIsIn(PlayerPedId()), 3) 
                            end
                        end
                        if Index == 5 then
                            if not allw then
                                allw = true
                                RollDownWindow(GetVehiclePedIsIn(PlayerPedId()), 0)
                                RollDownWindow(GetVehiclePedIsIn(PlayerPedId()), 1) 
                                RollDownWindow(GetVehiclePedIsIn(PlayerPedId()), 2) 
                                RollDownWindow(GetVehiclePedIsIn(PlayerPedId()), 3) 
                            elseif allw then
                                allw = false
                                RollUpWindow(GetVehiclePedIsIn(PlayerPedId()), 0) 
                                RollUpWindow(GetVehiclePedIsIn(PlayerPedId()), 1) 
                                RollUpWindow(GetVehiclePedIsIn(PlayerPedId()), 2) 
                                RollUpWindow(GetVehiclePedIsIn(PlayerPedId()), 3) 
                            end
                        end
                        coolcoolmec(1500)
                    end
                    eGestVeh.WindowIndex = Index           
                end)
                
        
                RageUI.List("→ Limitateur", {"Par défaut", "Personalisé", "50/KMH", "80/KMH", "130/KMH"}, eGestVeh.Limitateur, nil,{}, not cooldown, function(_, _, Selected, Index)
                    if (Selected) then
                        if Index == 1 then
                            SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 1000.0 / 3.6)
                            crtSpeed = "Aucun(e)"
                            RageUI.Popup({ message = "Limitateur par ~b~défaut" })
                        elseif Index == 2 then
                            local crtSpeed = KeyboardInput("Vitesse ?", "", 3)
                            if crtSpeed ~= nil and tonumber(crtSpeed) then
                                RageUI.Popup({ message = "Limitateur à ~b~" .. crtSpeed .. "/KMH" })
                                SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), crtSpeed / 3.6)
                            else
                                RageUI.Popup({ message = "Champ invalide" })
                            end
                        elseif Index == 3 then
                            RageUI.Popup({ message = "Limitateur à ~b~50/KMH" })
                            SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 50.0 / 3.6)
                        elseif Index == 4 then
                            RageUI.Popup({ message = "Limitateur à ~b~80/KMH" })
                            SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 80.0 / 3.6)
                        elseif Index == 5 then
                            RageUI.Popup({ message = "Limitateur à ~b~130/KMH" })
                            SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 130.0 / 3.6)
                        end
                        coolcoolmec(1500)
                    end
                    eGestVeh.Limitateur = Index
                end)
    
                RageUI.List("→ Changer de place", eGestVeh.PlaceList, eGestVeh.PlaceIndex, nil, {}, not cooldown,function(Hovered, Active, Selected, Index)
                    if (Selected) then
                        CarSpeed = GetEntitySpeed(GetSourcevehicle) * 3.6 
                        if CarSpeed <= 50.0 then -- si la vitesse du véhicule est au dessus ou égale à 50 km/h
                            if Index == 1 then
                                SetPedIntoVehicle(Ped, GetSourcevehicle, -1)
                            elseif Index == 2 then
                                SetPedIntoVehicle(Ped, GetSourcevehicle, 0)
                            elseif Index == 3 then
                                SetPedIntoVehicle(Ped, GetSourcevehicle, 1)
                            elseif Index == 4 then
                                SetPedIntoVehicle(Ped, GetSourcevehicle, 2)
                            end
                        else
                            RageUI.Popup({ message = "[~b~Gestion Véhicule~s~]\n~r~La vitesse du véhicule est trop élevée"})
                        end
                        coolcoolmec(1500)
                    end
                    eGestVeh.PlaceIndex = Index
                end)

            end, function()
            end)

            RageUI.IsVisible(Mgestentreprise, true, true, true, function()
            RageUI.Separator("~y~Societé → "..ESX.PlayerData.job.label.." - "..ESX.PlayerData.job.grade_label)
            if societymoney ~= nil then
                RageUI.Separator("~b~Coffre Entreprise → "..societymoney.." $")
            end

            RageUI.ButtonWithStyle('→ Recruter une personne', nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    if ESX.PlayerData.job.grade_name == 'boss' then
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
   
                        if closestPlayer == -1 or closestDistance > 3.0 then
                            ESX.ShowNotification('Aucun joueur proche')
                        else
                            TriggerServerEvent('rPersonalmenu:Boss_recruterplayer', GetPlayerServerId(closestPlayer))
                            --TriggerServerEvent('rPersonalmenu:Boss_recruterplayer', GetPlayerServerId(closestPlayer), ESX.PlayerData.job.name, 0)
                        end
                    else
                        ESX.ShowNotification('Vous n\'avez pas les droits')
                    end
                end
            end)

            RageUI.ButtonWithStyle('→ Virer une personne', nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    if ESX.PlayerData.job.grade_name == 'boss' then
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
   
                        if closestPlayer == -1 or closestDistance > 3.0 then
                            ESX.ShowNotification('Aucun joueur proche')
                        else
                            TriggerServerEvent('rPersonalmenu:Boss_virerplayer', GetPlayerServerId(closestPlayer))
                        end
                    else
                        ESX.ShowNotification('Vous n\'avez pas les droits')
                    end
                end
            end)

            RageUI.ButtonWithStyle('→ Promouvoir une personne', nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if (Selected) then
                     if ESX.PlayerData.job.grade_name == 'boss' then
                         local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    
                         if closestPlayer == -1 or closestDistance > 3.0 then
                             ESX.ShowNotification('Aucun joueur proche')
                         else
                             TriggerServerEvent('rPersonalmenu:Boss_promouvoirplayer', GetPlayerServerId(closestPlayer))
                     end
                     else
                         ESX.ShowNotification('Vous n\'avez pas les droits')
                     end
                 end
             end)
    
             RageUI.ButtonWithStyle('→ Destituer une personne', nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                 if (Selected) then
                     if ESX.PlayerData.job.grade_name == 'boss' then
                         local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    
                         if closestPlayer == -1 or closestDistance > 3.0 then
                                 ESX.ShowNotification('Aucun joueur proche')
                             else
                            TriggerServerEvent('rPersonalmenu:Boss_destituerplayer', GetPlayerServerId(closestPlayer))
                                 end
                             else
                                 ESX.ShowNotification('Vous n\'avez pas les droits')
                             end
                         end
                     end)

                     RageUI.ButtonWithStyle("→ Message aux employés", nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            local info = 'patron'
                            local message = KeyboardInput('Veuillez mettre le messsage à envoyer', '', 40)
                            TriggerServerEvent('rPersonalmenu:envoyeremployer', info, message)
                        end
                    end)

            end, function()
            end)

            RageUI.IsVisible(Mgestoraga, true, true, true, function()
                RageUI.Separator("~r~Oganisation → "..ESX.PlayerData.job2.label.." - "..ESX.PlayerData.job2.grade_label)
                if societymoney2 ~= nil then
                    RageUI.Separator("~y~Coffre Organisation → "..societymoney2.." $")
                end
    
                RageUI.ButtonWithStyle('→ Recruter une personne', nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        if ESX.PlayerData.job2.grade_name == 'boss' then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
       
                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ESX.ShowNotification('Aucun joueur proche')
                            else
                                TriggerServerEvent('rPersonalmenu:Boss_recruterplayer2', GetPlayerServerId(closestPlayer))
                               --TriggerServerEvent('rPersonalmenu:Boss_recruterplayer2', GetPlayerServerId(closestPlayer), ESX.PlayerData.job2.name, 0)
                            end
                        else
                            ESX.ShowNotification('Vous n\'avez pas les droits')
                        end
                    end
                end)
    
                RageUI.ButtonWithStyle('→ Virer une personne', nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        if ESX.PlayerData.job2.grade_name == 'boss' then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
       
                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ESX.ShowNotification('Aucun joueur proche')
                            else
                                TriggerServerEvent('rPersonalmenu:Boss_virerplayer2', GetPlayerServerId(closestPlayer))
                            end
                        else
                            ESX.ShowNotification('Vous n\'avez pas les droits')
                        end
                    end
                end)
    
                RageUI.ButtonWithStyle('→ Promouvoir une personne', nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                         if ESX.PlayerData.job2.grade_name == 'boss' then
                             local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        
                             if closestPlayer == -1 or closestDistance > 3.0 then
                                 ESX.ShowNotification('Aucun joueur proche')
                             else
                                 TriggerServerEvent('rPersonalmenu:Boss_promouvoirplayer2', GetPlayerServerId(closestPlayer))
                         end
                         else
                             ESX.ShowNotification('Vous n\'avez pas les droits')
                         end
                     end
                 end)
        
                 RageUI.ButtonWithStyle('→ Destituer une personne', nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                     if (Selected) then
                         if ESX.PlayerData.job2.grade_name == 'boss' then
                             local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        
                             if closestPlayer == -1 or closestDistance > 3.0 then
                                     ESX.ShowNotification('Aucun joueur proche')
                                 else
                                TriggerServerEvent('rPersonalmenu:Boss_destituerplayer2', GetPlayerServerId(closestPlayer))
                                     end
                                 else
                                     ESX.ShowNotification('Vous n\'avez pas les droits')
                                 end
                             end
                         end)
    
                end, function()
                end)

                RageUI.IsVisible(Mdivers, true, true, true, function()


                RageUI.ButtonWithStyle("→ Style de viser", nil, {RightLabel = ""},true, function(Hovered, Active, Selected)
                    if (Selected) then                         
                    end
                end, WeaponVise)

                RageUI.ButtonWithStyle("→ Animation dégainer", nil, {RightLabel = ""},true, function(Hovered, Active, Selected)
                    if (Selected) then                           
                    end
                end, WeaponAnim)
                
                RageUI.Checkbox("→ Afficher / Désactiver la map", nil, Rperso.minimap,{},function(Hovered,Ative,Selected,Checked)
                    if Selected then
                        Rperso.minimap = Checked
                        if Checked then
                            DisplayRadar(true)
                        else
                            DisplayRadar(false)
                        end
                    end
                end)

                local ragdolling = false
                RageUI.ButtonWithStyle('→ Dormir / Se Reveiller', description, {RightLabel = ""}, true, function(Hovered, Active, Selected) 
                    if (Selected) then
                        ragdolling = not ragdolling
                        while ragdolling do
                         Wait(0)
                        local myPed = GetPlayerPed(-1)
                        SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
                        ResetPedRagdollTimer(myPed)
                        AddTextEntry(GetCurrentResourceName(), ('Appuyez sur ~INPUT_JUMP~ pour vous ~b~Réveillé'))
                        DisplayHelpTextThisFrame(GetCurrentResourceName(), false)
                        ResetPedRagdollTimer(myPed)
                        if IsControlJustPressed(0, 22) then 
                        break
                            end
                        end
                    end
                end)
        

                RageUI.ButtonWithStyle("→ Rockstar Editor", nil, {}, true, function(Hovered, Active, Selected)
                end, reditor)

                end, function()
                end)

                RageUI.IsVisible(reditor, true, true, true, function()

                    RageUI.ButtonWithStyle("→ Commencer l'enregistrement", nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            TriggerEvent("nad_rockstar:record")
                        end
                    end)
        
                    RageUI.ButtonWithStyle("→ Enregistrer l'enregistrement", nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            TriggerEvent("nad_rockstar:saveclip")
                        end
                    end)
            
                    RageUI.ButtonWithStyle("→ Supprimer l'enregistrement", nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            TriggerEvent("nad_rockstar:delclip")
                        end
                    end)
            
                    RageUI.ButtonWithStyle("~r~→~s~ Ouvrir l'éditeur rockstar", "~r~Action Irréversible, vous quitterez Atomic", {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            TriggerEvent("nad_rockstar:editor")
                        end
                    end)
        
                end, function()
                end)

                RageUI.IsVisible(Mclef, true, true, true, function()

                    if #getCles >= 1 then

                    RageUI.Separator('~y~↓ Vos clés ↓')

                    for k, v in ipairs(getCles) do
                        RageUI.List("Clés Numéro : [~g~" .. v.id .. "~s~] - [~b~" .. v.value .. "~s~]",actionCles.select,actionCles.index,nil,{},true,function(Hovered, Active, Selected, Index)
                                if Selected then
                                    if Index == 1 then
                                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                        if closestDistance ~= -1 and closestDistance <= 3 then
                                            TriggerServerEvent("esx_vehiclelock:preterkey", GetPlayerServerId(closestPlayer), v.value)
                                            RageUI.GoBack()
                                        else
                                            ESX.ShowNotification("Aucun individus près de vous.")
                                        end
                                    elseif Index == 2 then
                                        TriggerServerEvent("rPersonalmenu:DeleteKey", v.id)
                                        ESX.ShowNotification("- Clés détruite\n- Plaque : " ..v.value .. "\n- Numéro : " .. v.id)
                                        RageUI.GoBack()
                                    end
                                end
                                actionCles.index = Index
                            end)
                    end
                else
                    RageUI.Separator("")
                    RageUI.Separator("~r~Aucune paire de clés")
                    RageUI.Separator("")
                end

                end, function()
                end)

            RageUI.IsVisible(WeaponVise, true, true, true, function()
                RageUI.ButtonWithStyle("Par défault", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                    if (Selected) then   
                        HillbillyAS = false
                        GangsterAS = false                        
                    end
                end)
                RageUI.ButtonWithStyle("Gangster", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                    if (Selected) then 
                        HillbillyAS = false
                        GangsterAS = true                            
                    end
                end)
                RageUI.ButtonWithStyle("Mafia", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                    if (Selected) then 
                        HillbillyAS = true
                        GangsterAS = false                            
                    end
                end)
            end)              
            
            RageUI.IsVisible(WeaponAnim, true, true, true, function()
                RageUI.ButtonWithStyle("Par défault", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                    if (Selected) then   
                        SideHolsterAnimation = false
                        SideLegHolsterAnimation = false
                        FrontHolsterAnimation = false
                        AgressiveFrontHolsterAnimation = false
                        BackHolsterAnimation = false
                    end
                end)
                RageUI.ButtonWithStyle("Déguainer a la ceinture", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                    if (Selected) then          
                        SideHolsterAnimation = true
                        SideLegHolsterAnimation = false
                        FrontHolsterAnimation = false
                        AgressiveFrontHolsterAnimation = false
                        BackHolsterAnimation = false                         
                    end
                end)
                RageUI.ButtonWithStyle("Déguainer a la jambe", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                    if (Selected) then 
                        SideHolsterAnimation = false
                        SideLegHolsterAnimation = true
                        FrontHolsterAnimation = false
                        AgressiveFrontHolsterAnimation = false
                        BackHolsterAnimation = false
                    end
                end)
                RageUI.ButtonWithStyle("Déguainer a la sacoche", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                    if (Selected) then 
                        SideHolsterAnimation = false
                        SideLegHolsterAnimation = false
                        FrontHolsterAnimation = true
                        AgressiveFrontHolsterAnimation = false
                        BackHolsterAnimation = false
                    end
                end)
                RageUI.ButtonWithStyle("Déguainer a la sacoche nrv", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                    if (Selected) then 
                        SideHolsterAnimation = false
                        SideLegHolsterAnimation = false
                        FrontHolsterAnimation = false
                        AgressiveFrontHolsterAnimation = true
                        BackHolsterAnimation = false
                    end
                end)
                RageUI.ButtonWithStyle("Déguainer dans le dos", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                    if (Selected) then 
                        SideHolsterAnimation = false
                        SideLegHolsterAnimation = false
                        FrontHolsterAnimation = false
                        AgressiveFrontHolsterAnimation = false
                        BackHolsterAnimation = true
                    end
                end)
            end)         
            
            if not RageUI.Visible(MPersonalmenu) 
            and not RageUI.Visible(Access) 
            and not RageUI.Visible(eVip) 
            and not RageUI.Visible(reditor) 
            and not RageUI.Visible(Minventaire) 
            and not RageUI.Visible(Minventaire2) 
            and not RageUI.Visible(Marmes) 
            and not RageUI.Visible(Marmes2) 
            and not RageUI.Visible(Mportefeuille) 
            and not RageUI.Visible(Mportefeuilleli) 
            and not RageUI.Visible(Mportefeuillesale) 
            and not RageUI.Visible(Mfacture) 
            and not RageUI.Visible(Mvetements) 
            and not RageUI.Visible(Manimations) 
            and not RageUI.Visible(Mfestives) 
            and not RageUI.Visible(Msalutations) 
            and not RageUI.Visible(Mtravail) 
            and not RageUI.Visible(Mhumeurs) 
            and not RageUI.Visible(Msports) 
            and not RageUI.Visible(Mattitudes) 
            and not RageUI.Visible(Mpegi18) 
            and not RageUI.Visible(Manimationsdivers) 
            and not RageUI.Visible(Mgestveh) 
            and not RageUI.Visible(Mgestentreprise) 
            and not RageUI.Visible(Mgestoraga) 
            and not RageUI.Visible(Mdivers) 
            and not RageUI.Visible(Madmin) 
            and not RageUI.Visible(Mclef) 
            and not RageUI.Visible(WeaponAnim) 
            and not RageUI.Visible(WeaponVise)
            and not RageUI.Visible(vip_car) 
            and not RageUI.Visible(vip_filtre) 
            and not RageUI.Visible(vip_menu) 
            and not RageUI.Visible(vip_ped) 
            and not RageUI.Visible(vip_props) 
            and not RageUI.Visible(PropsMenu) 
            and not RageUI.Visible(PropsMenuobject) 
            and not RageUI.Visible(PropsMenuobjectlist) 
            and not RageUI.Visible(vip_weapon) 
            then
            MPersonalmenu = RMenu:DeleteType("MPersonalmenu", true)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        local Timer = 0
        if IsControlJustPressed(1,166) then
            ESX.TriggerServerCallback('esx_billing:getBills', function(bills)
                Rperso.factures = bills
            end)

            gPersonalmenu()
        end

        if IsControlJustReleased(0, 73) and IsInputDisabled(2) then
			ClearPedTasks(PlayerPedId())
		end
        
        Citizen.Wait(Timer)
    end
end)

function RefreshCles()
    getCles = {}
    ESX.TriggerServerCallback("rPersonalmenu:clevoiture", function(cles)
            for k, v in pairs(cles) do
                table.insert(getCles, {id = v.id, label = v.label, value = v.value})
            end
        end)
end


function CheckQuantity(number)
    number = tonumber(number)
  
    if type(number) == 'number' then
      number = ESX.Math.Round(number)
  
      if number > 0 then
        return true, number
      end
    end
  
    return false, number
end

--- Animations

function startAttitude(lib, anim)
	ESX.Streaming.RequestAnimSet(lib, function()
		SetPedMovementClipset(PlayerPedId(), anim, true)
	end)
end

function startAnim(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
	end)
end

function startScenario(anim)
	TaskStartScenarioInPlace(PlayerPedId(), anim, 0, false)
end

RegisterNetEvent('rPersonalmenu:envoyeremployer')
AddEventHandler('rPersonalmenu:envoyeremployer', function(service, nom, message)
	if service == 'patron' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('INFO '..ESX.PlayerData.job.label, 'A lire', 'Patron: '..nom..'\nMessage: '..message..'', 'CHAR_MINOTAUR', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)	
	end
end)

CreateThread(function()
    while true do
        Citizen.Wait(80)

        inVeh = IsPedInVehicle(PlayerPedId(-1), GetVehiclePedIsIn(PlayerPedId(-1), false), false)
        

        if GangsterAS == true then
            local ped = PlayerPedId(), DecorGetInt(PlayerPedId())
            local _, hash = GetCurrentPedWeapon(ped, 1)
            if not inVeh then
                loadAnimDict2("combat@aim_variations@1h@gang")
                if IsPlayerFreeAiming(PlayerId()) or (IsControlPressed(0, 24) and GetAmmoInClip(ped, hash) > 0) then
                    if not IsEntityPlayingAnim(ped, "combat@aim_variations@1h@gang", "aim_variation_a", 3) then
                        TaskPlayAnim(ped, "combat@aim_variations@1h@gang", "aim_variation_a", 8.0, -8.0, -1, 49, 0, 0, 0, 0)
                        SetEnableHandcuffs(ped, true)
                    end
                elseif IsEntityPlayingAnim(ped, "combat@aim_variations@1h@gang", "aim_variation_a", 3) then
                    ClearPedTasks(ped)
                    SetEnableHandcuffs(ped, false)
                end
            end
        elseif HillbillyAS == true then
            local ped = PlayerPedId(), DecorGetInt(PlayerPedId())
            local _, hash = GetCurrentPedWeapon(ped, 1)
            if not inVeh then
                loadAnimDict2("combat@aim_variations@1h@hillbilly")
                if IsPlayerFreeAiming(PlayerId()) or (IsControlPressed(0, 24) and GetAmmoInClip(ped, hash) > 0) then
                    if not IsEntityPlayingAnim(ped, "combat@aim_variations@1h@hillbilly", "aim_variation_a", 3) then
                        TaskPlayAnim(ped, "combat@aim_variations@1h@hillbilly", "aim_variation_a", 8.0, -8.0, -1, 49, 0, 0, 0, 0)
                        SetEnableHandcuffs(ped, true)
                    end
                elseif IsEntityPlayingAnim(ped, "combat@aim_variations@1h@hillbilly", "aim_variation_a", 3) then
                    ClearPedTasks(ped)
                    SetEnableHandcuffs(ped, false)
                end
            end
        end
    end
end)

function CheckWeapon(ped)
	if IsEntityDead(ped) then
		blocked = false
			return false
		else
			for i = 1, #Config.Weapons do
				if GetHashKey(Config.Weapons[i]) == GetSelectedPedWeapon(ped) then
					return true
				end
			end
		return false
	end
end

function loadAnimDict2(dict)
	while ( not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(0)
	end
end
    
CreateThread(function()
    while true do
        local WaitingPapcz = 350

        if SideHolsterAnimation == true then
            WaitingPapcz = 0
            loadAnimDict2("rcmjosh4")
            loadAnimDict2("reaction@intimidation@cop@unarmed")
            local ped = PlayerPedId()
            if not IsPedInAnyVehicle(ped, false) then
                if GetVehiclePedIsTryingToEnter (ped) == 0 and (GetPedParachuteState(ped) == -1 or GetPedParachuteState(ped) == 0) and not IsPedInParachuteFreeFall(ped) then
                    if CheckWeapon(ped) then
                        if holstered then
                            blocked   = true
                                SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
                                TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "intro", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
                                
                                    Citizen.Wait(100)
                                    SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
                                TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
                                    Citizen.Wait(400)
                                ClearPedTasks(ped)
                            holstered = false
                        else
                            blocked = false
                        end
                    else
                        if not holstered then
                                TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
                                    Citizen.Wait(500)
                                TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "outro", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
                                    Citizen.Wait(60)
                                ClearPedTasks(ped)
                            holstered = true
                        end
                    end
                else
                    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
                end
            else
                holstered = true
            end
        elseif BackHolsterAnimation == true then
            WaitingPapcz = 0
            local ped = PlayerPedId()
            loadAnimDict2("reaction@intimidation@1h")

            if not IsPedInAnyVehicle(ped, false) then
                if GetVehiclePedIsTryingToEnter (ped) == 0 and (GetPedParachuteState(ped) == -1 or GetPedParachuteState(ped) == 0) and not IsPedInParachuteFreeFall(ped) then
                    if CheckWeapon(ped) then
                        if holstered then
                            pos = GetEntityCoords(ped, true)
                            rot = GetEntityHeading(ped)
                            blocked   = true
                                TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "intro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.325, 0, 0)
                                    Citizen.Wait(600)
                                ClearPedTasks(ped)
                            holstered = false
                        else
                            blocked = false
                        end
                    else
                        if not holstered then
                            pos = GetEntityCoords(ped, true)
                            rot = GetEntityHeading(ped)
                                TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "outro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.125, 0, 0)
                                    Citizen.Wait(2000)
                                ClearPedTasks(ped)
                            holstered = true
                        end
                    end
                else
                    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
                end
            else
                holstered = true
            end
        elseif FrontHolsterAnimation == true then
            WaitingPapcz = 0
            local ped = PlayerPedId()
            loadAnimDict2("combat@combat_reactions@pistol_1h_gang")

            if not IsPedInAnyVehicle(ped, false) then
                if GetVehiclePedIsTryingToEnter (ped) == 0 and (GetPedParachuteState(ped) == -1 or GetPedParachuteState(ped) == 0) and not IsPedInParachuteFreeFall(ped) then
                    if CheckWeapon(ped) then
                        if holstered then
                            pos = GetEntityCoords(ped, true)
                            rot = GetEntityHeading(ped)
                            blocked   = true
                                TaskPlayAnimAdvanced(ped, "combat@combat_reactions@pistol_1h_gang", "0", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.325, 0, 0)
                                    Citizen.Wait(600)
                                ClearPedTasks(ped)
                            holstered = false
                        else
                            blocked = false
                        end
                    else
                        if not holstered then
                            pos = GetEntityCoords(ped, true)
                            rot = GetEntityHeading(ped)
                                TaskPlayAnimAdvanced(ped, "combat@combat_reactions@pistol_1h_gang", "0", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.125, 0, 0)
                                    Citizen.Wait(1000)
                                ClearPedTasks(ped)
                            holstered = true
                        end
                    end
                else
                    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
                end
            else
                holstered = true
            end
        elseif AgressiveFrontHolsterAnimation == true then
            WaitingPapcz = 0
            local ped = PlayerPedId()
            loadAnimDict2("combat@combat_reactions@pistol_1h_hillbilly")
            loadAnimDict2("combat@combat_reactions@pistol_1h_gang")

            if not IsPedInAnyVehicle(ped, false) then
                if GetVehiclePedIsTryingToEnter (ped) == 0 and (GetPedParachuteState(ped) == -1 or GetPedParachuteState(ped) == 0) and not IsPedInParachuteFreeFall(ped) then
                    if CheckWeapon(ped) then
                        if holstered then
                            pos = GetEntityCoords(ped, true)
                            rot = GetEntityHeading(ped)
                            blocked   = true
                                TaskPlayAnimAdvanced(ped, "combat@combat_reactions@pistol_1h_hillbilly", "0", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.325, 0, 0)
                                    Citizen.Wait(600)
                                ClearPedTasks(ped)
                            holstered = false
                        else
                            blocked = false
                        end
                    else
                        if not holstered then
                            pos = GetEntityCoords(ped, true)
                            rot = GetEntityHeading(ped)
                                TaskPlayAnimAdvanced(ped, "combat@combat_reactions@pistol_1h_gang", "0", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.125, 0, 0)
                                    Citizen.Wait(1000)
                                ClearPedTasks(ped)
                            holstered = true
                        end
                    end
                else
                    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
                end
            else
                holstered = true
            end
        elseif SideLegHolsterAnimation == true then
            WaitingPapcz = 0
            local ped = PlayerPedId()
            loadAnimDict2("reaction@male_stand@big_variations@d")

            if not IsPedInAnyVehicle(ped, false) then
                if GetVehiclePedIsTryingToEnter (ped) == 0 and (GetPedParachuteState(ped) == -1 or GetPedParachuteState(ped) == 0) and not IsPedInParachuteFreeFall(ped) then
                    if CheckWeapon(ped) then
                        if holstered then
                            pos = GetEntityCoords(ped, true)
                            rot = GetEntityHeading(ped)
                            blocked   = true
                                TaskPlayAnimAdvanced(ped, "reaction@male_stand@big_variations@d", "react_big_variations_m", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.325, 0, 0)
                                    Citizen.Wait(500)
                                ClearPedTasks(ped)
                            holstered = false
                        else
                            blocked = false
                        end
                    else
                        if not holstered then
                            pos = GetEntityCoords(ped, true)
                            rot = GetEntityHeading(ped)
                                TaskPlayAnimAdvanced(ped, "reaction@male_stand@big_variations@d", "react_big_variations_m", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.125, 0, 0)
                                    Citizen.Wait(500)
                                ClearPedTasks(ped)
                            holstered = true
                        end
                    end
                else
                    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
                end
            else
                holstered = true
            end
        end
        Wait(WaitingPapcz)
    end
end)

-- Block
CreateThread(function()
    while true do
        local bebepqsdf = 250

        if blocked then
            bebepqsdf = 0
            DisableControlAction(1, 25, true )
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
            DisableControlAction(1, 23, true)
            DisableControlAction(1, 37, true) -- Disables INPUT_SELECT_WEAPON (TAB)
            DisablePlayerFiring(ped, true) -- Disable weapon firing
        end
        Wait(bebepqsdf)
    end
end)

RegisterNetEvent("nad_rockstar:record")
AddEventHandler("nad_rockstar:record", function()
    StartRecording(1) -- https://docs.fivem.net/natives/?_0xC3AC2FFF9612AC81
end)

RegisterNetEvent("nad_rockstar:saveclip")
AddEventHandler("nad_rockstar:saveclip", function()
    StartRecording(0) -- https://docs.fivem.net/natives/?_0xC3AC2FFF9612AC81
    StopRecordingAndSaveClip() -- https://docs.fivem.net/natives/?_0x071A5197D6AFC8B3
end)

RegisterNetEvent("nad_rockstar:delclip")
AddEventHandler("nad_rockstar:delclip", function()
    StopRecordingAndDiscardClip() -- https://docs.fivem.net/natives/?_0x88BB3507ED41A240
end)

RegisterNetEvent("nad_rockstar:editor")
AddEventHandler("nad_rockstar:editor", function()
    NetworkSessionLeaveSinglePlayer() -- https://docs.fivem.net/natives/?_0x3442775428FD2DAA
    ActivateRockstarEditor() -- https://docs.fivem.net/natives/?_0x49DA8145672B2725
end)

--- props 

function SpawnObj(obj)
    local playerPed = PlayerPedId()
	local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
    local objectCoords = (coords + forward * 1.0)
    local Ent = nil

    SpawnObject(obj, objectCoords, function(obj)
        SetEntityCoords(obj, objectCoords, 0.0, 0.0, 0.0, 0)
        SetEntityHeading(obj, GetEntityHeading(playerPed))
        PlaceObjectOnGroundProperly(obj)
        Ent = obj
        Wait(1)
    end)
    Wait(1)
    while Ent == nil do Wait(1) end
    SetEntityHeading(Ent, GetEntityHeading(playerPed))
    PlaceObjectOnGroundProperly(Ent)
    local placed = false
    while not placed do
        Citizen.Wait(1)
        local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
        local objectCoords = (coords + forward * 2.0)
        SetEntityCoords(Ent, objectCoords, 0.0, 0.0, 0.0, 0)
        SetEntityHeading(Ent, GetEntityHeading(playerPed))
        PlaceObjectOnGroundProperly(Ent)
        SetEntityAlpha(Ent, 170, 170)

        if IsControlJustReleased(1, 38) then
            placed = true
        end
    end

    FreezeEntityPosition(Ent, true)
    SetEntityInvincible(Ent, true)
    ResetEntityAlpha(Ent)
    local NetId = NetworkGetNetworkIdFromEntity(Ent)
    table.insert(object, NetId)

end


function GoodName(hash)
    if hash == GetHashKey("prop_roadcone02a") then
        return "Cone"
    elseif hash == GetHashKey("prop_barrier_work05") then
        return "Barrière"
    else
        return hash
    end

end



function SpawnObject(model, coords, cb)
	local model = GetHashKey(model)

	Citizen.CreateThread(function()
		RequestModels(model)
        Wait(1)
		local obj = CreateObject(model, coords.x, coords.y, coords.z, true, false, true)

		if cb then
			cb(obj)
		end
	end)
end


function RequestModels(modelHash)
	if not HasModelLoaded(modelHash) and IsModelInCdimage(modelHash) then
		RequestModel(modelHash)

        while not HasModelLoaded(modelHash) do
			Citizen.Wait(1)
		end
	end
end


local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end

		enum.destructor = nil
		enum.handle = nil
	end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
		coroutine.yield(id)
		next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end
