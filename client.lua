ESX, vipLevel = nil, 0

local NoClip = {
    Camera = nil,
    Speed = 0.5
}


Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(500)
    end

    ESX.PlayerData = ESX.GetPlayerData()

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(500)
    end

    ESX.TriggerServerCallback('RubyMenu:getUsergroup', function(group)
        playergroup = group
    end)

    TriggerServerEvent("requestVipLevel")
end)

RegisterNetEvent("StaffTP")
AddEventHandler("StaffTP", function(coords)
    ESX.Game.Teleport(PlayerPedId(), coords)
end)

local dict2 = "scr_powerplay"

local particleName2 = "scr_powerplay_beast_vanish"

SetParticle = function()

	Citizen.CreateThread(function()

		RequestNamedPtfxAsset(dict2)

		while not HasNamedPtfxAssetLoaded(dict2) do

			Citizen.Wait(0)

		end

		local ped = PlayerPedId()

		local x,y,z = table.unpack(GetEntityCoords(ped, true))

		local a = 0

		while a < 25 do

			UseParticleFxAssetNextCall(dict2)

			StartParticleFxNonLoopedAtCoord(particleName2, x, y, z, 1.50, 1.50, 1.50, 1.50, false, false, false)

			SetParticleFxLoopedColour(0, 255, 255, 255, 0)

			a = a + 1

			break

			Citizen.Wait(500)

		end

	end)

end

local reportlist = {}

local PlayerData = {}

local Menu = {
    action = {
        '~g~Liquide~s~',
        '~b~Banque~s~',
        '~r~Sale~s~',
    },
    list = 1
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



invisible = false
local ShowName, gamerTags = false, {}
local playerResult = {}



function DrawPlayerInfo(target)
	drawTarget = target
	drawInfo = true
end



function StopDrawPlayerInfo()
	drawInfo = false
	drawTarget = 0
end



local affichername = false 



Citizen.CreateThread( function()

	while true do

		local bebezamwwait = 350



        if invisible then

            bebezamwwait = 0

			SetEntityVisible(GetPlayerPed(-1), 0, 0)
			NetworkSetEntityInvisibleToNetwork(pPed, 1)

		else

			SetEntityVisible(GetPlayerPed(-1), 1, 0)

			NetworkSetEntityInvisibleToNetwork(pPed, 0)

            bebezamwwait = 350

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



		if drawInfo then

            bebezamwwait = 0

			local text = {}

			-- cheat checks

			local targetPed = GetPlayerPed(drawTarget)

			

			table.insert(text,"E pour stop spectate")

			

			for i,theText in pairs(text) do

				SetTextFont(0)

				SetTextProportional(1)

				SetTextScale(0.0, 0.30)

				SetTextDropshadow(0, 0, 0, 0, 255)

				SetTextEdge(1, 0, 0, 0, 255)

				SetTextDropShadow()

				SetTextOutline()

				SetTextEntry("STRING")

				AddTextComponentString(theText)

				EndTextCommandDisplayText(0.3, 0.7+(i/30))

			end

			

			if IsControlJustPressed(0,103) then

				local targetPed = PlayerPedId()

				local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))

	

				RequestCollisionAtCoord(targetx,targety,targetz)

				NetworkSetInSpectatorMode(false, targetPed)

	

				StopDrawPlayerInfo()

				

			end

			

		end

        Citizen.Wait(bebezamwwait)

	end

end)


function getPosition()
    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
    return x,y,z
end



local IndexVIP = 1


function getCamDirection()

    local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(GetPlayerPed(-1))

    local pitch = GetGameplayCamRelativePitch()



    local x = -math.sin(heading*math.pi/180.0)

    local y = math.cos(heading*math.pi/180.0)

    local z = math.sin(pitch*math.pi/180.0)



    local len = math.sqrt(x*x+y*y+z*z)

    if len ~= 0 then

        x = x/len

        y = y/len

        z = z/len

    end



    return x,y,z

end

  


function KeyBoardText(TextEntry, ExampleText, MaxStringLength)



    AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')

    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)

    blockinput = true



    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do

        Citizen.Wait(0)

    end



    if UpdateOnscreenKeyboard() ~= 2 then

        local result = GetOnscreenKeyboardResult()

        Citizen.Wait(500)

        blockinput = false

        return result

    else

        Citizen.Wait(500)

        blockinput = false

        return nil

    end

end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)





    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 

    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)

    blockinput = true



    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 

        Citizen.Wait(0)

    end

        

    if UpdateOnscreenKeyboard() ~= 2 then

        local result = GetOnscreenKeyboardResult() 

        Citizen.Wait(500) 

        blockinput = false

        return result 

    else

        Citizen.Wait(500) 

        blockinput = false 

        return nil 

    end

end

function GiveCash()

    local amount = KeyBoardText("Somme", "", 8)



    if amount ~= nil then

        amount = tonumber(amount)

        

        if type(amount) == 'number' then

            TriggerServerEvent('Administration:GiveCash', amount)

        end

    end

end

function GiveBanque()

    local amount = KeyBoardText("Somme", "", 8)



    if amount ~= nil then

        amount = tonumber(amount)

        

        if type(amount) == 'number' then

            TriggerServerEvent('Administration:GiveBanque', amount)

        end

    end

end

function GiveND()

    local amount = KeyBoardText("Somme", "", 8)



    if amount ~= nil then

        amount = tonumber(amount)

        

        if type(amount) == 'number' then

            TriggerServerEvent('Administration:GiveND', amount)

        end

    end

end

function FullVehicleBoost()

	if IsPedInAnyVehicle(PlayerPedId(), false) then

		local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)

		SetVehicleModKit(vehicle, 0)

		SetVehicleMod(vehicle, 14, 0, true)

		SetVehicleNumberPlateTextIndex(vehicle, 5)

		ToggleVehicleMod(vehicle, 18, true)

		SetVehicleColours(vehicle, 0, 0)

		SetVehicleCustomPrimaryColour(vehicle, 0, 0, 0)

		SetVehicleModColor_2(vehicle, 5, 0)

		SetVehicleExtraColours(vehicle, 111, 111)

		SetVehicleWindowTint(vehicle, 2)

		ToggleVehicleMod(vehicle, 22, true)

		SetVehicleMod(vehicle, 23, 11, false)

		SetVehicleMod(vehicle, 24, 11, false)

		SetVehicleWheelType(vehicle, 12) 

		SetVehicleWindowTint(vehicle, 3)

		ToggleVehicleMod(vehicle, 20, true)

		SetVehicleTyreSmokeColor(vehicle, 0, 0, 0)

		LowerConvertibleRoof(vehicle, true)

		SetVehicleIsStolen(vehicle, false)

		SetVehicleIsWanted(vehicle, false)

		SetVehicleHasBeenOwnedByPlayer(vehicle, true)

		SetVehicleNeedsToBeHotwired(vehicle, false)

		SetCanResprayVehicle(vehicle, true)

		SetPlayersLastVehicle(vehicle)

		SetVehicleFixed(vehicle)

		SetVehicleDeformationFixed(vehicle)

		SetVehicleTyresCanBurst(vehicle, false)

		SetVehicleWheelsCanBreak(vehicle, false)

		SetVehicleCanBeTargetted(vehicle, false)

		SetVehicleExplodesOnHighExplosionDamage(vehicle, false)

		SetVehicleHasStrongAxles(vehicle, true)

		SetVehicleDirtLevel(vehicle, 0)

		SetVehicleCanBeVisiblyDamaged(vehicle, false)

		IsVehicleDriveable(vehicle, true)

		SetVehicleEngineOn(vehicle, true, true)

		SetVehicleStrong(vehicle, true)

		RollDownWindow(vehicle, 0)

		RollDownWindow(vehicle, 1)

		SetVehicleNeonLightEnabled(vehicle, 0, true)

		SetVehicleNeonLightEnabled(vehicle, 1, true)

		SetVehicleNeonLightEnabled(vehicle, 2, true)

		SetVehicleNeonLightEnabled(vehicle, 3, true)

		SetVehicleNeonLightsColour(vehicle, 0, 0, 255)

		SetPedCanBeDraggedOut(PlayerPedId(), false)

		SetPedStayInVehicleWhenJacked(PlayerPedId(), true)

		SetPedRagdollOnCollision(PlayerPedId(), false)

		ResetPedVisibleDamage(PlayerPedId())

		ClearPedDecorations(PlayerPedId())

		SetIgnoreLowPriorityShockingEvents(PlayerPedId(), true)

		for i = 0,14 do

			SetVehicleExtra(veh, i, 0)

		end

		SetVehicleModKit(veh, 0)

		for i = 0,49 do

			local custom = GetNumVehicleMods(veh, i)

			for j = 1,custom do

				SetVehicleMod(veh, i, math.random(1,j), 1)

			end

		end

	end

end

function DrawTxt(text,r,z)

    SetTextColour(MainColor.r, MainColor.g, MainColor.b, 255)

    SetTextFont(0)

    SetTextProportional(1)

    SetTextScale(0.0,0.4)

    SetTextDropshadow(1,0,0,0,255)

    SetTextEdge(1,0,0,0,255)

    SetTextDropShadow()

    SetTextOutline()

    SetTextEntry("STRING")

    AddTextComponentString(text)

    DrawText(r,z)

end



Citizen.CreateThread(function()

    while true do

        local zebipazdowait = 900

    	if Admin.showcoords then

            zebipazdowait = 0

            x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))

            roundx=tonumber(string.format("%.2f",x))

            roundy=tonumber(string.format("%.2f",y))

            roundz=tonumber(string.format("%.2f",z))

            DrawTxt("~r~X:~s~ "..roundx,0.05,0.00)

            DrawTxt("     ~r~Y:~s~ "..roundy,0.11,0.00)

            DrawTxt("        ~r~Z:~s~ "..roundz,0.17,0.00)

            DrawTxt("             ~r~Angle:~s~ "..GetEntityHeading(PlayerPedId()),0.21,0.00)

        end

    	Citizen.Wait(zebipazdowait)

    end

end)



Admin = {

	showcoords = false,

}

MainColor = {

	r = 225, 

	g = 55, 

	b = 55,

	a = 255

}


local ServersIdSession = {}

Citizen.CreateThread(function()

    while true do

        Wait(500)

        for k,v in pairs(GetActivePlayers()) do

            local found = false

            for _,j in pairs(ServersIdSession) do

                if GetPlayerServerId(v) == j then

                    found = true

                end

            end

            if not found then

                table.insert(ServersIdSession, GetPlayerServerId(v))

            end

        end

    end

end)

function admin_vehicle_flip()



    local player = GetPlayerPed(-1)

    posdepmenu = GetEntityCoords(player)

    carTargetDep = GetClosestVehicle(posdepmenu['x'], posdepmenu['y'], posdepmenu['z'], 10.0,0,70)

    if carTargetDep ~= nil then

            platecarTargetDep = GetVehicleNumberPlateText(carTargetDep)

    end

    local playerCoords = GetEntityCoords(GetPlayerPed(-1))

    playerCoords = playerCoords + vector3(0, 2, 0)

    

    SetEntityCoords(carTargetDep, playerCoords)

    

    ESX.ShowNotification("Réussis") 



end

function admin_godmode()

    godmode = not godmode

    

    if godmode then -- activé

          SetEntityInvincible(GetPlayerPed(-1), true)

    ESX.ShowNotification("GodMod - Actif") 

      else

          SetEntityInvincible(GetPlayerPed(-1), false)

    ESX.ShowNotification("GodMod - Inactif") 

    end

end

function admin_tp_toplayer()

    local plyId = KeyBoardText("ID", "", "", 8)



	if plyId ~= nil then

		plyId = tonumber(plyId)

		

		if type(plyId) == 'number' then

			local targetPlyCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(plyId)))

			SetEntityCoords(plyPed, targetPlyCoords)

		end

	end

end



RegisterNetEvent("hAdmin:envoyer")
AddEventHandler("hAdmin:envoyer", function(msg)

	PlaySoundFrontend(-1, "CHARACTER_SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)

	local head = RegisterPedheadshot(PlayerPedId())

	while not IsPedheadshotReady(head) or not IsPedheadshotValid(head) do

		Wait(1)

	end

	headshot = GetPedheadshotTxdString(head)

	ESX.ShowAdvancedNotification('Message du Staff', '~r~Informations', '~r~Raison ~w~: ' ..msg, headshot, 3)

end)



function admin_tp_playertome()

	local plyId = KeyBoardText("ID :", "", "", 8)



	if plyId ~= nil then

		plyId = tonumber(plyId)

		

		if type(plyId) == 'number' then

			local plyPedCoords = GetEntityCoords(plyPed)

			print(plyId)

			TriggerServerEvent('KorioZ-PersonalMenu:Admin_BringS', plyId, plyPedCoords)

		end

	end

end





function DrawPlayerInfo(target)

    drawTarget = target

    drawInfo = true

end



function StopDrawPlayerInfo()

    drawInfo = false

    drawTarget = 0

end


local function rxeJobBuilderKeyboardInput(TextEntry, ExampleText, MaxStringLenght)

    AddTextEntry('FMMC_KEY_TIP1', TextEntry)

    blockinput = true

    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 

        Wait(0)

    end 

        

    if UpdateOnscreenKeyboard() ~= 2 then

        local result = GetOnscreenKeyboardResult()

        Wait(500)

        blockinput = false

        return result

    else

        Wait(500)

        blockinput = false

        return nil

    end

end



function rGangBuilderKeyboardInput(TextEntry, ExampleText, MaxStringLenght)

    AddTextEntry('FMMC_KEY_TIP1', TextEntry)

    blockinput = true

    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 

        Wait(0)

    end 

        

    if UpdateOnscreenKeyboard() ~= 2 then

        local result = GetOnscreenKeyboardResult()

        Wait(500)

        blockinput = false

        return result

    else

        Wait(500)

        blockinput = false

        return nil

    end

end





local modEdit = false

local allJobs = {}



local rxeJobBuilder = {

    Name = nil,

    Label = nil,

    PosVeh = nil,

    PosBoss = nil,

    PosCoffre = nil,

    PosSpawnVeh = nil,

    nameItemR = nil,

    labelItemR = nil,

    PosRecolte = nil,

    nameItemT = nil,

    labelItemT = nil,

    PosTraitement = nil,

    PosVente = nil,

    vehInGarage = {},

    PrixVente = nil,

    Confirm = nil,

    Confirm1 = nil,

    Confirm2 = nil,

    Confirm3 = nil,

    Confirm4 = nil,

    Confirm5 = nil,

    Confirm6 = nil,

    Confirm7 = nil,

    Confirm8 = nil,

    Choisimec = false,

    Blip = {},

    Marker = {},

}


------------------------------------------
function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function Button(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end

function setupScaleform(scaleform)

    local scaleform = RequestScaleformMovie(scaleform)

    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(1)
    end

    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(5)
    Button(GetControlInstructionalButton(2, config.controls.desac, true))
    ButtonMessage("Désactiver NoClip")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(4)
    Button(GetControlInstructionalButton(2, config.controls.goUp, true))
    ButtonMessage("Monter")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(3)
    Button(GetControlInstructionalButton(2, config.controls.goDown, true))
    ButtonMessage("Descendre")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    Button(GetControlInstructionalButton(1, config.controls.turnRight, true))
    Button(GetControlInstructionalButton(1, config.controls.turnLeft, true))
    ButtonMessage("Tourner Droite/Gauche")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    Button(GetControlInstructionalButton(1, config.controls.goBackward, true))
    Button(GetControlInstructionalButton(1, config.controls.goForward, true))
    ButtonMessage("Avancer/Reculer")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    Button(GetControlInstructionalButton(2, config.controls.changeSpeed, true))
    ButtonMessage("Vitesse (" .. config.speeds[index].label .. ")")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(config.bgR)
    PushScaleformMovieFunctionParameterInt(config.bgG)
    PushScaleformMovieFunctionParameterInt(config.bgB)
    PushScaleformMovieFunctionParameterInt(config.bgA)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

function DisableControls()
    DisableControlAction(0, 30, true)
    DisableControlAction(0, 31, true)
    DisableControlAction(0, 32, true)
    DisableControlAction(0, 33, true)
    DisableControlAction(0, 34, true)
    DisableControlAction(0, 35, true)
    DisableControlAction(0, 266, true)
    DisableControlAction(0, 267, true)
    DisableControlAction(0, 268, true)
    DisableControlAction(0, 269, true)
    DisableControlAction(0, 44, true)
    DisableControlAction(0, 20, true)
    DisableControlAction(0, 74, true)
end

--==--==--==--
-- Config
--==--==--==--

config = {
    controls = {
        desac = 38,
        goUp = 85, -- [[Q]]
        goDown = 48, -- [[Z]]
        turnLeft = 34, -- [[A]]
        turnRight = 35, -- [[D]]
        goForward = 32, -- [[W]]
        goBackward = 33, -- [[S]]
        changeSpeed = 21, -- [[L-Shift]]
    },

    speeds = {
        { label = "Vraiment lent", speed = 0 },
        { label = "Lent", speed = 0.5 },
        { label = "Normal", speed = 2 },
        { label = "Rapide", speed = 4 },
        { label = "Vraiment Rapide", speed = 6 },
        { label = "Extrement Rapide", speed = 10 },
        { label = "Extrement Rapide v2.0", speed = 20 },
        { label = "Max", speed = 25 }
    },

    offsets = { y = 0.5, z = 0.2, h = 3, },

    bgR = 0, -- [[Red]]
    bgG = 0, -- [[Green]]
    bgB = 0, -- [[Blue]]
    bgA = 80, -- [[Alpha]]
}

--==--==--==--
-- End Of Config
--==--==--==--

noclipActive = false -- [[Wouldn't touch this.]]
index = 1 -- [[Used to determine the index of the speeds table.]]

Citizen.CreateThread(function()
    RequestScaleformMovie("INSTRUCTIONAL_BUTTONS")
    local buttons = setupScaleform("instructional_buttons")

    currentSpeed = config.speeds[index].speed

    while true do
        local waitingbroo = 900

        if noclipActive then

            waitingbroo = 0

            SetEntityVisible(GetPlayerPed(-1), false, false)

            SetEntityAlpha(noclipEntity, 51, false)

            DrawScaleformMovieFullscreen(buttons)

            local yoff = 0.0
            local zoff = 0.0

            if (IsControlJustPressed(0, 38)) then
                SetEntityVisible(GetPlayerPed(-1), true, true)
                affichernoclip = false
                RageUI.Popup({ message = "~r~NoClip Inactif" })
                onToggleNoClip(false)
            end

            if IsControlJustPressed(1, config.controls.changeSpeed) then
                if index ~= 8 then
                    index = index + 1
                    currentSpeed = config.speeds[index].speed
                else
                    currentSpeed = config.speeds[1].speed
                    index = 1
                end
                buttons = setupScaleform("instructional_buttons")
            end

            DisableControls()

            if IsDisabledControlPressed(0, config.controls.goForward) then
                yoff = config.offsets.y
            end

            if IsDisabledControlPressed(0, config.controls.goBackward) then
                yoff = -config.offsets.y
            end

            if IsDisabledControlPressed(0, config.controls.turnLeft) then
                SetEntityHeading(noclipEntity, GetEntityHeading(noclipEntity) + config.offsets.h)
            end

            if IsDisabledControlPressed(0, config.controls.turnRight) then
                SetEntityHeading(noclipEntity, GetEntityHeading(noclipEntity) - config.offsets.h)
            end

            if IsDisabledControlPressed(0, config.controls.goUp) then
                zoff = config.offsets.z
            end

            if IsDisabledControlPressed(0, config.controls.goDown) then
                zoff = -config.offsets.z
            end

            local newPos = GetOffsetFromEntityInWorldCoords(noclipEntity, 0.0, yoff * (currentSpeed + 0.3),
                zoff * (currentSpeed + 0.3))
            local heading = GetEntityHeading(noclipEntity)
            SetEntityVelocity(noclipEntity, 0.0, 0.0, 0.0)
            SetEntityRotation(noclipEntity, 0.0, 0.0, 0.0, 0, false)
            SetEntityHeading(noclipEntity, heading)
            SetEntityCoordsNoOffset(noclipEntity, newPos.x, newPos.y, newPos.z, noclipActive, noclipActive, noclipActive)
        else
            ResetEntityAlpha(noclipEntity)
        end
        Citizen.Wait(waitingbroo)
    end
end)

local IndexTP = 1

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if (affichernoclip) then
            --HideHudAndRadarThisFrame()

            local camCoords = GetCamCoord(NoClip.Camera)
            local right, forward, _, _ = GetCamMatrix(NoClip.Camera)
            if IsControlPressed(0, 32) then
                local newCamPos = camCoords + forward * NoClip.Speed
                SetCamCoord(NoClip.Camera, newCamPos.x, newCamPos.y, newCamPos.z)
            end
            if IsControlPressed(0, 8) then
                local newCamPos = camCoords + forward * -NoClip.Speed
                SetCamCoord(NoClip.Camera, newCamPos.x, newCamPos.y, newCamPos.z)
            end
            if IsControlPressed(0, 34) then
                local newCamPos = camCoords + right * -NoClip.Speed
                SetCamCoord(NoClip.Camera, newCamPos.x, newCamPos.y, newCamPos.z)
            end
            if IsControlPressed(0, 9) then
                local newCamPos = camCoords + right * NoClip.Speed
                SetCamCoord(NoClip.Camera, newCamPos.x, newCamPos.y, newCamPos.z)
            end
            if IsControlPressed(0, 97) then
                if (NoClip.Speed - 0.1 >= 0.1) then
                    NoClip.Speed = NoClip.Speed - 0.2
                end
            end
            if IsControlPressed(0, 96) then
                if (NoClip.Speed + 0.1 >= 0.1) then
                    NoClip.Speed = NoClip.Speed + 0.2
                end
            end

            if #(GetEntityCoords(PlayerPedId()) - vector3(camCoords.x, camCoords.y, camCoords.z)) <= 10.0 then
                SetEntityCoords(GetPlayerPed(-1), camCoords.x, camCoords.y, camCoords.z)
            else
                local newCamPos = GetEntityCoords(PlayerPedId())
                SetCamCoord(NoClip.Camera, newCamPos.x, newCamPos.y, newCamPos.z)
            end
            
            local xMagnitude = GetDisabledControlNormal(0, 1)
            local yMagnitude = GetDisabledControlNormal(0, 2)
            local camRot = GetCamRot(NoClip.Camera)
            local x = camRot.x - yMagnitude * 10
            local y = camRot.y
            local z = camRot.z - xMagnitude * 10
            if x < -75.0 then
                x = -75.0
            end
            if x > 100.0 then
                x = 100.0
            end
            SetCamRot(NoClip.Camera, x, y, z)
        end
    end
end)



RegisterCommand("tpm", function(source)

    ESX.TriggerServerCallback('RubyMenu:getUsergroup', function(group)

        playergroup = group

        if playergroup == 'superadmin' or playergroup == 'mod' or playergroup == 'admin' then

            TeleportToWaypoint()

        end

    end)

end)



TeleportToWaypoint = function()

    local WaypointHandle = GetFirstBlipInfoId(8)

    if DoesBlipExist(WaypointHandle) then

        local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

        for height = 1, 1000 do

            SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)



            local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)



            if foundGround then

                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)



                break

            end



            Citizen.Wait(2)

        end

    end

end



local IndexGive = 1
local GestionGang, modEdit = {}, false
local eGangBuilder = {
    MarkersPreview = {},
    Builder = {Name = nil,Label = nil,PosVeh = nil,vehInGarage = {},PosBoss = nil,PosCoffre = nil,PosSpawnVeh = nil,Blip = {},Marker = {}},
    Name = "~r~Indéfini",Label = "~r~Indéfini",PosVeh = "~r~Indéfini",vehInGarage = {},PosBoss = "~r~Indéfini",PosCoffre = "~r~Indéfini",PosSpawnVeh = "~r~Indéfini",GarageActif = false,
    Blip = {pos = "~r~Indéfini",label = "~r~Indéfini",sprite = "~r~Indéfini",color = "~r~Indéfini",height = "~r~Indéfini"},
    Marker = {id = "~r~Indéfini",color = "~r~Indéfini",height = "~r~Indéfini"},
}



function eGangBuilderKeyboardInput(TextEntry, ExampleText, MaxStringLenght)

    AddTextEntry('FMMC_KEY_TIP1', TextEntry)

    blockinput = true

    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 

        Wait(0)

    end 

        

    if UpdateOnscreenKeyboard() ~= 2 then

        local result = GetOnscreenKeyboardResult()

        Wait(500)

        blockinput = false

        return result

    else

        Wait(500)

        blockinput = false

        return nil

    end

end





function GangReset()

    eGangBuilder.Builder = {Name = nil,Label = nil,PosVeh = nil,vehInGarage = {},PosBoss = nil,PosCoffre = nil,PosSpawnVeh = nil,Blip = {},Marker = {}}

    eGangBuilder.Blip = {pos = "~r~Indéfini",label = "~r~Indéfini",sprite = "~r~Indéfini",color = "~r~Indéfini",height = "~r~Indéfini"}

    eGangBuilder.Marker = {id = "~r~Indéfini",color = "~r~Indéfini",height = "~r~Indéfini"}

    eGangBuilder.Name = "~r~Indéfini"

    eGangBuilder.Label = "~r~Indéfini"

    eGangBuilder.PosVeh = "~r~Indéfini"

    eGangBuilder.vehInGarage = {}

    eGangBuilder.PosBoss = "~r~Indéfini"

    eGangBuilder.PosCoffre = "~r~Indéfini"

    eGangBuilder.PosSpawnVeh = "~r~Indéfini"

    eGangBuilder.GarageActif = false

end



function DrawTextBuilder(x,y,z, text, color, scaleB)

    if not scaleB then scaleB = 1 end

    local onScreen,_x,_y = World3dToScreen2d(x,y,z)

    local px,py,pz = table.unpack(GetGameplayCamCoord())

    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (((1/dist)*2)*(1/GetGameplayCamFov())*100)*scaleB

    if onScreen then

        SetTextColour(color.r, color.g, color.b, 155)

        SetTextScale(0.0*scale, 0.20*scale)

        SetTextFont(0)

        SetTextProportional(1)

        SetTextCentre(true)

        SetTextEntry("STRING")

        AddTextComponentString(text)

        EndTextCommandDisplayText(_x, _y)

    end

end

local ReportsInDEX = 1

function getReports()
    reportlist = {}
    ESX.TriggerServerCallback('finalmenuadmin:getAllReport', function(report)
        for k,v in pairs(report) do
            table.insert(reportlist,{
                id = v.srcDuMec, 
                nom = v.nomDuMec,
                raison = v.raisonDuReport,
                status = v.status, 
                OnReport = v.OnReport
            })
        end
    end)
end

RegisterNetEvent('gangs:update', function(data)

    ESX.TriggerServerCallback('eGangBuilder:getAllGang', function(result)

        GestionGang = result

    end)

end)

local label = "Activer le mode staff"
local IndexMgl = 1
local IndexWipe = 1

function onToggleNoClip(toggle)
    local playerped = GetPlayerPed(-1)
    if toggle == true then
        NoClip.Camera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        invisible = true
        SetCamActive(NoClip.Camera, true)
        RenderScriptCams(true, false, 0, true, true)
        SetCamCoord(NoClip.Camera, GetEntityCoords(playerped))
        SetCamRot(NoClip.Camera, GetEntityRotation(playerped))
        SetEntityCollision(NoClip.Camera, false, false)
    else
        RenderScriptCams(0, 0, 0, 0, 0, 0)
        SetCamActive(NoClip.Camera, false)
        DestroyCam(NoClip.Camera, false)
        SetEntityCollision(playerped, true, true)
        invisible = false
    end
end

function StaffSpectate(id)
    local id = tonumber(id)
    local currentCoords = GetEntityCoords(PlayerPedId())
    SetEntityVisible(GetPlayerPed(-1), false)
    SetEntityCollision(GetPlayerPed(-1), false, true)
    ExecuteCommand("goto " .. id)
    Citizen.Wait(1000)
    NetworkSetInSpectatorMode(true, GetPlayerPed(GetPlayerFromServerId(id)))
    onStaffSpectate = true
    while (onStaffSpectate) do
        ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~r~arrêter~s~ de spectate")
        if (IsControlJustPressed(0, 38)) then
            onStaffSpectate = false
        end
        Citizen.Wait(0)
    end
    RequestCollisionAtCoord(currentCoords)
    while not HasCollisionLoadedAroundEntity(GetPlayerPed(-1)) do RequestCollisionAtCoord(currentCoords) Citizen.Wait(0) end
    NetworkSetInSpectatorMode(false, GetPlayerPed(GetPlayerFromServerId(id)))
    SetEntityCoords(GetPlayerPed(-1), currentCoords)
    SetEntityCollision(GetPlayerPed(-1), true, true)
    SetEntityVisible(GetPlayerPed(-1), true)
end

function TenueAdmin()
    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin["sex"] == 0 then
            TriggerEvent('skinchanger:loadClothes', skin, {
                ['bags_1'] = 0, ['bags_2'] = 0,
                ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                ['torso_1'] = 178, ['torso_2'] = 5,
                ['arms'] = 14,
                ['pants_1'] = 77, ['pants_2'] = 5,
                ['shoes_1'] = 55, ['shoes_2'] = 5,
                ['mask_1'] = 156, ['mask_2'] = 0,
                ['bproof_1'] = 0,
                ['chain_1'] = 0,
                ['helmet_1'] = -1, ['helmet_2'] = 0,
                ['glasses_1'] = 0, ['glasses_2'] = 0,
                ['watches_1'] = -1, ['watches_2'] = 0,
                ['bracelets_1'] = 0, ['bracelets_2'] = 0,
                ['ears_1'] = -1, ['ears_2'] = 0,
            })
        else
            TriggerEvent('skinchanger:loadClothes', skin, {
                ['bags_1'] = 0, ['bags_2'] = 0,
                ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                ['torso_1'] = 298, ['torso_2'] = 5,
                ['arms'] = 2,
                ['pants_1'] = 120, ['pants_2'] = 5,
                ['shoes_1'] = 74, ['shoes_2'] = 5,
                ['mask_1'] = 0, ['mask_2'] = 0,
                ['bproof_1'] = 0,
                ['chain_1'] = 0,
                ['helmet_1'] = 33, ['helmet_2'] = 0,
                ['glasses_1'] = 0, ['glasses_2'] = 0,
                ['watches_1'] = -1, ['watches_2'] = 0,
                ['bracelets_1'] = 0, ['bracelets_2'] = 0,
                ['ears_1'] = -1, ['ears_2'] = 0,
            })
        end
    end)
end

function OuvrirAdmin()

	local main = RageUI.CreateMenu("Menu Admin", "Intéractions")

	local perso = RageUI.CreateSubMenu(main, "Actions Perso", "Intéractions")

	local veh = RageUI.CreateSubMenu(main, "Actions Véhicules", "Intéractions")

	local joueurs = RageUI.CreateSubMenu(main, "Liste des joueurs", "Intéractions")

	local options = RageUI.CreateSubMenu(joueurs, "Actions sur joueur", "Intéractions")

	local ped = RageUI.CreateSubMenu(main, "Peds", "Intéractions")



    local gestServ = RageUI.CreateSubMenu(main, "Gestion", "Intéractions")



	local createbjob = RageUI.CreateSubMenu(gestServ, "JobBuilder", "Intéractions")

	local menuGestGarage = RageUI.CreateSubMenu(gestServ, "JobBuilder", "Intéractions")

	local modifiejob = RageUI.CreateSubMenu(gestServ, "JobBuilder", "Intéractions")

    local MenuGestionSub = RageUI.CreateSubMenu(gestServ, "JobBuilder", "Intéractions")

    

    local create_menu = RageUI.CreateSubMenu(gestServ, 'Création', '~g~5-Dev')

    local create_submenu = RageUI.CreateSubMenu(create_menu, 'Création', '~g~5-Dev')

    local create_blips = RageUI.CreateSubMenu(create_menu, 'Blips', '~g~5-Dev')

    local create_marker = RageUI.CreateSubMenu(create_menu, 'Marker', '~g~5-Dev')



    local modif_menu = RageUI.CreateSubMenu(gestServ, 'Modification', '~g~5-Dev')

    local modif_submenu = RageUI.CreateSubMenu(modif_menu, 'Modification', '~g~5-Dev')



    local Sanctions = RageUI.CreateSubMenu(main, "Sanctions", "Intéractions")

    local reports = RageUI.CreateSubMenu(main, "Reports", "Interaction")
    local manageReport = RageUI.CreateSubMenu(reports, "Reports", "Interaction")


    create_menu.Closable = false

    create_menu.Closed = function()

        GangReset()

        eGangBuilder.MarkersPreview = {}

    end



	RageUI.Visible(main, not RageUI.Visible(main))

	while main do

		Citizen.Wait(0)

			RageUI.IsVisible(main, true, true, true, function()



                RageUI.Checkbox("~r~→~s~ Mode staff", description, ahouigros, {}, function(Hovered, Ative, Selected, Checked)

                    if Selected then

                        ahouigros = Checked

                        if Checked then

                            adminservice = true
                            ShowName = false
                            GetBlips = false
                            affichernoclip = false
                            affichername = false
                            afficherblips = false

                            TriggerEvent('skinchanger:getSkin', function(skin)
                                if skin["sex"] == 0 then
                                    TriggerEvent('skinchanger:loadClothes', skin, {
                                        ['bags_1'] = 0, ['bags_2'] = 0,
                                        ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                                        ['torso_1'] = 178, ['torso_2'] = 5,
                                        ['arms'] = 14,
                                        ['pants_1'] = 77, ['pants_2'] = 5,
                                        ['shoes_1'] = 55, ['shoes_2'] = 5,
                                        ['mask_1'] = 156, ['mask_2'] = 0,
                                        ['bproof_1'] = 0,
                                        ['chain_1'] = 0,
                                        ['helmet_1'] = -1, ['helmet_2'] = 0,
                                        ['glasses_1'] = 0, ['glasses_2'] = 0,
                                        ['watches_1'] = -1, ['watches_2'] = 0,
                                        ['bracelets_1'] = 0, ['bracelets_2'] = 0,
                                        ['ears_1'] = -1, ['ears_2'] = 0,
                                    })
                                else
                                    TriggerEvent('skinchanger:loadClothes', skin, {
                                        ['bags_1'] = 0, ['bags_2'] = 0,
                                        ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                                        ['torso_1'] = 298, ['torso_2'] = 5,
                                        ['arms'] = 2,
                                        ['pants_1'] = 120, ['pants_2'] = 5,
                                        ['shoes_1'] = 74, ['shoes_2'] = 5,
                                        ['mask_1'] = 0, ['mask_2'] = 0,
                                        ['bproof_1'] = 0,
                                        ['chain_1'] = 0,
                                        ['helmet_1'] = 33, ['helmet_2'] = 0,
                                        ['glasses_1'] = 0, ['glasses_2'] = 0,
                                        ['watches_1'] = -1, ['watches_2'] = 0,
                                        ['bracelets_1'] = 0, ['bracelets_2'] = 0,
                                        ['ears_1'] = -1, ['ears_2'] = 0,
                                    })
                                end
                            end)

                        else

                            adminservice = false
                            ShowName = false
                            GetBlips = false
                            if (affichernoclip) then
                                affichernoclip = false
                                onToggleNoClip(false)
                            end
                            affichernoclip = false
                            affichername = false
                            afficherblips = false
                            onStaffSpectate = false

                            TriggerEvent('skinchanger:getSkin', function(skin)
                                if skin["sex"] == 0 then
                                    TriggerEvent('skinchanger:loadClothes', skin, {
                                        ['mask_1'] = 0, ['mask_2'] = 0,
                                    })
                                else
                                    TriggerEvent('skinchanger:loadClothes', skin, {
                                        ['mask_1'] = 0, ['mask_2'] = 0,
                                    })
                                end
                            end)

                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)

                                TriggerEvent('skinchanger:loadSkin', skin)

                            end)

                        end

                    end

                end)



                RageUI.Line()

                RageUI.Separator("Groupe : [~r~"..playergroup.."~s~]")

                RageUI.Line()





                if adminservice then



                    

                        RageUI.ButtonWithStyle("~r~→~s~ Actions Perso", nil, {RightLabel = ""},true, function()

                        end, perso)



                        RageUI.ButtonWithStyle("~r~→~s~ Actions Véhicules", nil, {RightLabel = ""},true, function()

                        end, veh)



                        RageUI.ButtonWithStyle("~r~→~s~ Liste des joueurs", nil, { RightLabel = "" },true, function(Hovered, Active, Selected)
                            if (Selected) then
                                playersList = {}
                                TriggerServerEvent("Staff:GetPlayers")
                                Wait(100)
                            end
						end, joueurs)

                        

                        if playergroup == 'Responsable' or playergroup == 'Admin' then

                            RageUI.ButtonWithStyle("~r~→~s~ Peds", nil, { RightLabel = "" },true, function()

                            end, ped)

                        else

                            RageUI.ButtonWithStyle('~r~→~s~ Peds', "admin uniquement <3", {RightBadge = RageUI.BadgeStyle.Lock }, false, function(Hovered, Active, Selected)

                            end)

                        end

                        RageUI.ButtonWithStyle("~r~→~s~ Gestion du serveur", nil, { RightLabel = "" },true, function()

						end, gestServ)


                        RageUI.ButtonWithStyle("~r~→~s~ Gestion des reports ( ~o~"..#reportlist.."~s~ )", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                            if Selected then 
                                ESX.TriggerServerCallback('finalmenuadmin:getAllReport', function(info)
                                    reportlist = info
                                end)
                            end
                        end, reports)


                    end



                    end, function()

                    end)

                    RageUI.IsVisible(reports, true, true, true, function()

                        if #reportlist >= 1 then
                            RageUI.Separator("↓ ~r~Report(s)~s~ ↓")
            
                            for k,v in pairs(reportlist) do
                                RageUI.ButtonWithStyle(k.." - [~o~"..v.nomDuMec.."~s~]", nil, {RightLabel = "→→"},true, function(_,_,s)
                                    if s then
                                        rps = v
                                        nom = v.nomDuMec
                                        nbreport = k
                                        id = v.srcDuMec
                                        raison = v.raisonDuReport
                                    end
                                end, manageReport)
                            end
                        else
                            RageUI.Separator("")
                            RageUI.Separator("~r~Aucun Report~s~")
                            RageUI.Separator("")
                        end
            
                    end, function()
                    end)
            
                    RageUI.IsVisible(manageReport, true, true, true, function()
                        local takedByMe = false
                        local takedCount = 0
            
                        for k,v in pairs(reportlist) do
                            if (v.id == rps.id) then
                                for _,t in pairs(v.taked) do
                                    takedByMe = (t == GetPlayerServerId(PlayerId()))
                                end
            
                                takedCount = #v.taked
                            end
                        end
            
                        RageUI.Separator("~o~Report N°"..nbreport)
            
                        RageUI.Separator("~o~Auteur ~s~→ [~r~ID → "..id.."~s~] ~y~"..nom.."")
            
                        RageUI.Separator("~o~Raison ~s~→ ~r~"..raison)            
            
                        RageUI.List("~r~→~s~ Téléportation", {"Sur lui", "Sur moi", "Parking Central"}, ReportsInDEX, nil,{}, true, function(_, _, Selected, Index)
                            if (Selected) then
                                if Index == 1 then
                                    ExecuteCommand("goto "..id)
                                elseif Index == 2 then
                                    ExecuteCommand("bring "..id)
                                    bringback2 = true 
                                elseif Index == 3 then
                                    TriggerServerEvent('StaffBring', id, vector3(217.8954, -808.9475, 30.71239))
                                end
                
                            end
                            ReportsInDEX = Index
                        end)

                        if bringback2 == true then 
                            RageUI.ButtonWithStyle("~r~→~s~ ~o~Renvoyer à l'ancienne position", nil, {}, true, function(Hovered, Active, Selected)
                                if (Selected) then
                                    ExecuteCommand("bringback "..id)
                                    bringback2 = false
                                end
                            end)
                        end
            
                        RageUI.ButtonWithStyle("~r~→~s~ Spectate", nil, {}, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                StaffSpectate(id)
                            end
                        end)
            
                        RageUI.ButtonWithStyle("~r~→~s~ Heal", nil, {}, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                ExecuteCommand("heal "..id)
                            end
                        end)
            
                        RageUI.ButtonWithStyle("~r~→~s~ Revive", nil, {}, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                ExecuteCommand("revive "..id)
                            end
                        end)
            
                        RageUI.Checkbox("~r~→~s~ Freeze / Defreeze", description, Frigo,{},function(Hovered,Ative,Selected,Checked)
                            if Selected then
                                Frigo = Checked
                                if Checked then
                                    ExecuteCommand("freeze "..id)
                                else
                                    ExecuteCommand("unfreeze "..id)
                                end
                            end
                        end)
            
                        RageUI.ButtonWithStyle("~r~→~s~ ~r~Supprimer le report", nil, {}, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                TriggerServerEvent('finalmenuadmin:closeReport', nom, rps.id)
                                RageUI.CloseAll()
                            end
                        end)
            
                    end, function()
                    end)

                    RageUI.IsVisible(gestServ, true, true, true, function()



                        RageUI.ButtonWithStyle("~g~→~s~ (Job) Mode Création", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)

                        end, createbjob)

                        RageUI.ButtonWithStyle("~g~→~s~ (Job) Mode Modification", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)

                        end, modifiejob)



                        RageUI.Line()



                        RageUI.ButtonWithStyle("~r~→~s~ (Gang) Mode Création",nil, {}, true, function(Hovered, Active, Selected)

                        end, create_menu)

                        RageUI.ButtonWithStyle("~r~→~s~ (Gang) Mode Modification",nil, {}, true, function(Hovered, Active, Selected)

                        end, modif_menu)



                        RageUI.Line()

                        RageUI.ButtonWithStyle("~o~→~s~ (Porte) Mode Création", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)

                            if Selected then 

                                ExecuteCommand("door")

                                RageUI.CloseAll()

                            end

                        end)

                        RageUI.ButtonWithStyle("~o~→~s~ (Porte) Mode Suppression", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)

                            if Selected then 

                                ExecuteCommand("deletedoor")

                                RageUI.CloseAll()

                            end

                        end)

                        RageUI.Line()

                        RageUI.ButtonWithStyle("~y~→~s~ (SafeZone) Ouvrir le panel", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)

                            if Selected then 

                                ExecuteCommand("safeZoneBuilder")

                                RageUI.CloseAll()

                            end

                        end)





                    end, function()

                    end)

                    RageUI.IsVisible(create_menu, true, true, true, function()



                        for k,v in pairs(eGangBuilder.MarkersPreview) do

                            local dst = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.pos, true)

                            DrawMarker(22, v.pos.x, v.pos.y, v.pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, v.rgb.r,v.rgb.g,v.rgb.b, 255, 55555, false, true, 2, false, false, false, false)

                            if dst < 2.5 then

                                DrawTextBuilder(v.pos.x, v.pos.y,v.pos.z+0.5, v.name, v.rgb, 1)

                            end

                        end

                        RageUI.ButtonWithStyle("~g~→~s~ Nom", nil, {RightLabel = eGangBuilder.Name}, true, function(Hovered, Active, Selected)

                            if Selected then

                                eGangBuilder.Builder.Name = eGangBuilderKeyboardInput("Nom du gang", "", 30)

                                eGangBuilder.Name = eGangBuilder.Builder.Name

                            end

                        end)

                        RageUI.ButtonWithStyle("~g~→~s~ Label", nil, {RightLabel = eGangBuilder.Label}, true, function(Hovered, Active, Selected)

                            if Selected then

                                eGangBuilder.Builder.Label = eGangBuilderKeyboardInput("Label du gang", "", 30)

                                eGangBuilder.Label = eGangBuilder.Builder.Label

                            end

                        end)

                        RageUI.ButtonWithStyle("~g~→~s~ Blips", nil, {}, true, function(Hovered, Active, Selected)
                        end, create_blips)

                        RageUI.ButtonWithStyle("~g~→~s~ Marker", nil, {}, true, function(Hovered, Active, Selected)
                        end, create_marker)

            

                        RageUI.ButtonWithStyle("~g~→~s~ Position du garage", nil, {RightLabel = eGangBuilder.PosVeh}, true, function(Hovered, Active, Selected)

                            if Selected then

                                eGangBuilder.PosVeh = "~g~Défini"

                                eGangBuilder.Builder.PosVeh = GetEntityCoords(PlayerPedId())

                                eGangBuilder.MarkersPreview["eGangBuilder.PosVeh"] = {pos = eGangBuilder.Builder.PosVeh, rgb = {r = 25, g = 240, b = 25}, name = "Zone : Garage"}    

                                eGangBuilder.GarageActif = true

                            end

                        end)

            

                        RageUI.ButtonWithStyle("~g~→~s~ Véhicule dans le garage", nil, {}, eGangBuilder.GarageActif, function(Hovered, Active, Selected)

                        end, create_submenu)

            

                        RageUI.ButtonWithStyle("~g~→~s~ Position spawn véhicule", nil, {RightLabel = eGangBuilder.PosSpawnVeh}, true, function(Hovered, Active, Selected)

                            if Selected then

                                eGangBuilder.PosSpawnVeh = "~g~Défini"

                                eGangBuilder.Builder.PosSpawnVeh = GetEntityCoords(PlayerPedId())

                                eGangBuilder.MarkersPreview["eGangBuilder.PosSpawnVeh"] = {pos = eGangBuilder.Builder.PosSpawnVeh, rgb = {r = 25, g = 240, b = 25}, name = "Zone : Spawn véhicule"}

                            end

                        end)

            

                        RageUI.ButtonWithStyle("~g~→~s~ Position du menu boss", nil, {RightLabel = eGangBuilder.PosBoss}, true, function(Hovered, Active, Selected)

                            if Selected then

                                eGangBuilder.PosBoss = "~g~Défini"

                                eGangBuilder.Builder.PosBoss = GetEntityCoords(PlayerPedId())

                                eGangBuilder.MarkersPreview["eGangBuilder.PosBoss"] = {pos = eGangBuilder.Builder.PosBoss, rgb = {r = 25, g = 240, b = 25}, name = "Zone : Boss"}

                            end

                        end)

            

                        RageUI.ButtonWithStyle("~g~→~s~ Position du coffre", nil, {RightLabel = eGangBuilder.PosCoffre}, true, function(Hovered, Active, Selected)

                            if Selected then

                                eGangBuilder.PosCoffre = "~g~Défini"

                                eGangBuilder.Builder.PosCoffre = GetEntityCoords(PlayerPedId())

                                eGangBuilder.MarkersPreview["eGangBuilder.PosCoffre"] = {pos = eGangBuilder.Builder.PosCoffre, rgb = {r = 25, g = 240, b = 25}, name = "Zone : Coffre"}

                            end

                        end)

            

            

            

                        RageUI.Separator("")

                        RageUI.ButtonWithStyle("→ ~g~Valider", nil, {}, true, function(Hovered, Active, Selected)

                            if Selected then

                                if eGangBuilder.Name == "~r~Indéfini" 

                                or eGangBuilder.Label == "~r~Indéfini" 

                                or eGangBuilder.PosVeh == "~r~Indéfini" 

                                or eGangBuilder.vehInGarage == "~r~Indéfini"

                                or eGangBuilder.PosCoffre == "~r~Indéfini" 

                                or eGangBuilder.PosBoss == "~r~Indéfini" 

                                or eGangBuilder.PosSpawnVeh == "~r~Indéfini" 

                                or eGangBuilder.GarageActif == false 
                                
                                or eGangBuilder.Blip == "~r~Indéfini"

                                or eGangBuilder.Marker == "~r~Indéfini" then

                                    ESX.ShowNotification('~r~Un ou plusieurs champs n\'ont pas été défini !')

                                else

                                    TriggerServerEvent('eGangBuilder:addGang', eGangBuilder.Builder)

                                    eGangBuilder.MarkersPreview = {}

                                    GangReset()

                                    BlipsInsert = false

                                    RageUI.GoBack()

                                end

                            end

                        end)

                        RageUI.ButtonWithStyle("→ ~r~Annuler", nil, {}, true, function(Hovered, Active, Selected) 

                            if Selected then

                                GangReset()

                                eGangBuilder.MarkersPreview = {}

                            end

                        end, gestServ)

                    end, function()

                    end)

                    RageUI.IsVisible(create_submenu, true, true, true, function()

                        RageUI.ButtonWithStyle("→ Ajouter un véhicule", nil, {}, true, function(Hovered, Active, Selected)

                            if Selected then

                                local modelVeh = eGangBuilderKeyboardInput("Modele du véhicule ?", "", 30)

                                local labelVeh = eGangBuilderKeyboardInput("Label du véhicule ?", "", 30)

                                table.insert(eGangBuilder.Builder.vehInGarage, {model = modelVeh, label = labelVeh})

                                ESX.ShowNotification('Véhicule ajouter au garage !')

                            end

                        end)

                        if #eGangBuilder.vehInGarage == 0 then

                            RageUI.Separator(" ")

                            RageUI.Separator("~o~Aucun véhicule défini !")

                            RageUI.Separator(" ")

                        else

                            RageUI.Separator("↓ ~g~Véhicule disponible ↓")

                        end

                        for k,v in pairs(eGangBuilder.Builder.vehInGarage) do

                            RageUI.ButtonWithStyle("→ Label : "..v.label,nil, {RightLabel = "Model : "..v.model}, true, function(Hovered, Active, Selected)

                                if Selected then

                                    table.remove(eGangBuilder.Builder.vehInGarage, k)

                                    ESX.ShowNotification('Véhicule supprimer !')

                                end

                            end)

                        end

                    end, function()

                    end)
                    RageUI.IsVisible(create_blips, true, true, true, function()

                        RageUI.ButtonWithStyle("Position du blip", nil, {RightLabel = eGangBuilder.Blip.pos}, true, function(Hovered, Active, Selected)
                            if Selected then
                                eGangBuilder.Blip.pos = "~g~Défini"
                                eGangBuilder.Builder.Blip.pos = GetEntityCoords(PlayerPedId())
                            end
                        end)
                        RageUI.ButtonWithStyle("Label",nil, {RightLabel = eGangBuilder.Blip.label}, true, function(Hovered, Active, Selected)
                            if Selected then
                                eGangBuilder.Builder.Blip.label = eGangBuilderKeyboardInput("Label du blip", "", 30)
                                eGangBuilder.Blip.label = eGangBuilder.Builder.Blip.label
                            end
                        end)
                        RageUI.ButtonWithStyle("Sprite",nil, {RightLabel = eGangBuilder.Blip.sprite}, true, function(Hovered, Active, Selected)
                            if Selected then
                                eGangBuilder.Builder.Blip.sprite = eGangBuilderKeyboardInput("Sprite (ID) du blip", "", 30)
                                eGangBuilder.Blip.sprite = eGangBuilder.Builder.Blip.sprite
            
                            end
                        end)
                        RageUI.ButtonWithStyle("Couleur",nil, {RightLabel = eGangBuilder.Blip.color}, true, function(Hovered, Active, Selected)
                            if Selected then
                                eGangBuilder.Builder.Blip.color = eGangBuilderKeyboardInput("Couleur (ID) du blip", "", 30)
                                eGangBuilder.Blip.color = eGangBuilder.Builder.Blip.color
                            end
                        end)
                        RageUI.ButtonWithStyle("Taille",nil, {RightLabel = eGangBuilder.Blip.height}, true, function(Hovered, Active, Selected)
                            if Selected then
                                eGangBuilder.Builder.Blip.height = eGangBuilderKeyboardInput("Taille (0.0 - 1.2) du blip", "", 30)
                                eGangBuilder.Blip.height = eGangBuilder.Builder.Blip.height
                            end
                        end)
                    end, function()
                    end)

                    RageUI.IsVisible(create_marker, true, true, true, function()

                        RageUI.ButtonWithStyle("Marker ID",nil, {RightLabel = eGangBuilder.Marker.id}, true, function(Hovered, Active, Selected)

                            if Selected then

                                eGangBuilder.Builder.Marker.id = eGangBuilderKeyboardInput("ID du marker", "", 30)

                                eGangBuilder.Marker.id = eGangBuilder.Builder.Marker.id

                            end

                        end)

                        RageUI.ButtonWithStyle("Couleur (RGB)",nil, {RightLabel = eGangBuilder.Marker.color}, true, function(Hovered, Active, Selected)

                            if Selected then

                                eGangBuilder.Builder.Marker.color = {}

                                eGangBuilder.Builder.Marker.color[1] = eGangBuilderKeyboardInput("R (0 - 255)", "", 30)

                                eGangBuilder.Builder.Marker.color[2] = eGangBuilderKeyboardInput("G (0 - 255)", "", 30)

                                eGangBuilder.Builder.Marker.color[3] = eGangBuilderKeyboardInput("B (0 - 255)", "", 30)

                                eGangBuilder.Marker.color = "R : "..eGangBuilder.Builder.Marker.color[1].." G : "..eGangBuilder.Builder.Marker.color[2].." B : "..eGangBuilder.Builder.Marker.color[3]

                            end

                        end)

                        RageUI.ButtonWithStyle("Taille",nil, {RightLabel = eGangBuilder.Marker.height}, true, function(Hovered, Active, Selected)

                            if Selected then

                                eGangBuilder.Builder.Marker.height = eGangBuilderKeyboardInput("Taille (0.0 - 1.2) du marker", "", 30)

                                eGangBuilder.Marker.height = eGangBuilder.Builder.Marker.height

                            end

                        end)

                    end, function()

                    end)

            

                    RageUI.IsVisible(modif_menu, true, true, true, function()

                        RageUI.Checkbox("→ Activer/Désactiver le mode modification",nil, modEdit,{},function(Hovered,Ative,Selected,Checked)

                            if Selected then

                                modEdit = Checked

                                if Checked then

                                    TriggerEvent('gangs:update', -1, GestionGang)

                                    RageUI.Popup({message = "Mode modification ~g~Actif ~s~!"})

                                else

                                    RageUI.Popup({message = "Mode modification ~r~Inactif ~s~!"})

                                end

                            end

                        end)

                        if modEdit then

                            for k,v in pairs(GestionGang) do

                                RageUI.ButtonWithStyle("→ Gang : "..v.Label,nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)

                                    if Selected then

                                        GangSelect = v

                                    end

                                end, modif_submenu)

                            end

                        end

                    end, function()

                    end)

            

                    RageUI.IsVisible(modif_submenu, true, true, true, function()

            

                        RageUI.ButtonWithStyle("→ Position du garage",nil, {}, true, function(Hovered, Active, Selected)

                            if Selected then

                                local plyPos = GetEntityCoords(PlayerPedId())

                                TriggerServerEvent('eGangBuilder:editGang', 'Posgarage', plyPos, GangSelect.Name)

                            end

                        end)

                        RageUI.ButtonWithStyle("→ Position spawn véhicule",nil, {}, true, function(Hovered, Active, Selected)

                            if Selected then

                                local plyPos = GetEntityCoords(PlayerPedId())

                                TriggerServerEvent('eGangBuilder:editGang', 'Posspawn', plyPos, GangSelect.Name)

                            end

                        end)

                        RageUI.ButtonWithStyle("→ Position du menu boss",nil, {}, true, function(Hovered, Active, Selected)

                            if Selected then

                                local plyPos = GetEntityCoords(PlayerPedId())

                                TriggerServerEvent('eGangBuilder:editGang', 'PosBoss', plyPos, GangSelect.Name)

                            end

                        end)

                        RageUI.ButtonWithStyle("→ Position du coffre",nil, {}, true, function(Hovered, Active, Selected)

                            if Selected then

                                local plyPos = GetEntityCoords(PlayerPedId())

                                TriggerServerEvent('eGangBuilder:editGang', 'PosCoffre', plyPos, GangSelect.Name)

                            end

                        end)

                    end, function()

                    end)



                    RageUI.IsVisible(createbjob, true, true, true, function()



                            RageUI.ButtonWithStyle("Nom du setjob",nil, {RightLabel = rxeJobBuilder.Name}, true, function(Hovered, Active, Selected)

                                if Selected then

                                    rxeJobBuilder.Name = rxeJobBuilderKeyboardInput("Nom du job", "", 30)

                                    RageUI.Text({ message = "~g~Nom ajouté", time_display = 2500 })

                                end

                            end)

                

                            RageUI.ButtonWithStyle("Label du job",nil, {RightLabel = rxeJobBuilder.Label}, true, function(Hovered, Active, Selected)

                                if Selected then

                                    rxeJobBuilder.Label = rxeJobBuilderKeyboardInput("Label du job", "", 30)

                                    RageUI.Text({ message = "~g~Label ajouté", time_display = 2500 })

                                end

                            end)

                

                            RageUI.ButtonWithStyle("Placer le point coffre",nil, {RightLabel = rxeJobBuilder.Confirm}, true, function(Hovered, Active, Selected)

                                if Selected then

                                    rxeJobBuilder.PosCoffre = GetEntityCoords(PlayerPedId())

                                    rxeJobBuilder.Confirm = "✅"

                                    RageUI.Text({ message = "~g~Point coffre ajouté", time_display = 2500 })

                                end

                            end)

                

                            RageUI.ButtonWithStyle("Placer le point patron",nil, {RightLabel = rxeJobBuilder.Confirm1}, true, function(Hovered, Active, Selected)

                                if Selected then

                                    rxeJobBuilder.PosBoss = GetEntityCoords(PlayerPedId())

                                    rxeJobBuilder.Confirm1 = "✅"

                                    RageUI.Text({ message = "~g~Point menu boss ajouté", time_display = 2500 })

                                end

                            end)

                

                            RageUI.ButtonWithStyle("Placer le point du garage",nil, {RightLabel = rxeJobBuilder.Confirm2}, true, function(Hovered, Active, Selected)

                                if Selected then

                                    rxeJobBuilder.PosVeh = GetEntityCoords(PlayerPedId())

                                    rxeJobBuilder.Confirm2 = "✅"

                                    rxeJobBuilder.Choisimec = true

                                    RageUI.Text({ message = "~g~Point garage ajouté", time_display = 2500 })

                                end

                            end)

                

                            if rxeJobBuilder.Choisimec == true then

                            RageUI.ButtonWithStyle("→ Véhicule dans le garage",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)

                            end, menuGestGarage)

                            end

                

                            RageUI.ButtonWithStyle("Placer le point de spawn véhicule",nil, {RightLabel = rxeJobBuilder.Confirm3}, true, function(Hovered, Active, Selected)

                                if Selected then

                                    rxeJobBuilder.PosSpawnVeh = GetEntityCoords(PlayerPedId())

                                    rxeJobBuilder.Confirm3 = "✅"

                                    RageUI.Text({ message = "~g~Position spawn véhicule ajouté", time_display = 2500 })

                                end

                            end)

                

                

                            RageUI.Separator("↓ ~y~Farm  ~s~↓")

                

                            RageUI.ButtonWithStyle("Nom de l'item récolte",nil, {RightLabel = rxeJobBuilder.nameItemR}, true, function(Hovered, Active, Selected)

                                if Selected then

                                    rxeJobBuilder.nameItemR = rxeJobBuilderKeyboardInput("Nom de l'item récolte", "", 30)

                                    RageUI.Text({ message = "~g~Item récolte ajouté", time_display = 2500 })

                                end

                            end)

                

                            RageUI.ButtonWithStyle("Label de l'item récolte",nil, {RightLabel = rxeJobBuilder.labelItemR}, true, function(Hovered, Active, Selected)

                                if Selected then

                                    rxeJobBuilder.labelItemR = rxeJobBuilderKeyboardInput("Label de l'item récolte", "", 30)

                                    RageUI.Text({ message = "~g~Label de l'item récolte ajouté", time_display = 2500 })

                                end

                            end)

                

                            RageUI.ButtonWithStyle("Position de la récolte",nil, {RightLabel = rxeJobBuilder.Confirm6}, true, function(Hovered, Active, Selected)

                                if Selected then

                                    rxeJobBuilder.PosRecolte = GetEntityCoords(PlayerPedId())

                                    rxeJobBuilder.Confirm6 = "✅"

                                    RageUI.Text({ message = "~g~Position de la récolte ajouté", time_display = 2500 })

                                end

                            end)

                

                

                            RageUI.ButtonWithStyle("Nom de l'item traitement",nil, {RightLabel = rxeJobBuilder.nameItemT}, true, function(Hovered, Active, Selected)

                                if Selected then

                                    rxeJobBuilder.nameItemT = rxeJobBuilderKeyboardInput("Nom de l'item traitement", "", 30)

                                    RageUI.Text({ message = "~g~Nom de l'item traitement ajouté", time_display = 2500 })

                                end

                            end)

                

                            RageUI.ButtonWithStyle("Label de l'item traitement",nil, {RightLabel = rxeJobBuilder.labelItemT}, true, function(Hovered, Active, Selected)

                                if Selected then

                                    rxeJobBuilder.labelItemT = rxeJobBuilderKeyboardInput("Label de l'item traitement", "", 30)

                                    RageUI.Text({ message = "~g~Label de l'item traitement ajouté", time_display = 2500 })

                                    

                                end

                            end)

                

                            RageUI.ButtonWithStyle("Position du traitement",nil, {RightLabel = rxeJobBuilder.Confirm4}, true, function(Hovered, Active, Selected)

                                if Selected then

                                    rxeJobBuilder.PosTraitement = GetEntityCoords(PlayerPedId())

                                    rxeJobBuilder.Confirm4 = "✅"

                                    RageUI.Text({ message = "~g~Position du traitement ajouté", time_display = 2500 })

                                end

                            end)

                

                            RageUI.ButtonWithStyle("Position de la vente",nil, {RightLabel = rxeJobBuilder.Confirm5}, true, function(Hovered, Active, Selected)

                                if Selected then

                                    rxeJobBuilder.PosVente = GetEntityCoords(PlayerPedId())

                                    rxeJobBuilder.Confirm5 = "✅"

                                    RageUI.Text({ message = "~g~Position de vente ajouté", time_display = 2500 })

                                end

                            end)

                

                            RageUI.ButtonWithStyle("Prix de la vente",nil, {RightLabel = rxeJobBuilder.PrixVente}, true, function(Hovered, Active, Selected)

                                if Selected then

                                    rxeJobBuilder.PrixVente = tonumber(rxeJobBuilderKeyboardInput("Prix vente ?", "", 30))

                                    RageUI.Text({ message = "~g~Prix de vente ajouté", time_display = 2500 })

                                end

                            end)

                

                            RageUI.Separator('~y~↓ Blip ↓')

                            RageUI.ButtonWithStyle("Position du blip",nil, {RightLabel = rxeJobBuilder.Confirm7}, true, function(Hovered, Active, Selected)

                                if Selected then

                                    rxeJobBuilder.Blip.pos = GetEntityCoords(PlayerPedId())

                                    rxeJobBuilder.Confirm7 = "✅"

                                    RageUI.Text({ message = "~g~Position du blip ajouté", time_display = 2500 })

                                end

                            end)

                

                            if rxeJobBuilder.Blip.pos then

                                RageUI.ButtonWithStyle("Label",nil, {RightLabel = rxeJobBuilder.Blip.label}, true, function(Hovered, Active, Selected)

                                    if Selected then

                                        rxeJobBuilder.Blip.label = rxeJobBuilderKeyboardInput("Label du blip", "", 30)

                                        RageUI.Text({ message = "~g~Label du blip ajouté", time_display = 2500 })

                                    end

                                end)

                

                                RageUI.ButtonWithStyle("Sprite ID",nil, {RightLabel = rxeJobBuilder.Blip.sprite}, true, function(Hovered, Active, Selected)

                                    if Selected then

                                        rxeJobBuilder.Blip.sprite = rxeJobBuilderKeyboardInput("Sprite (ID) du blip", "", 30)

                                        RageUI.Text({ message = "~g~Sprite du blip ajouté", time_display = 2500 })

                                    end

                                end)

                

                                RageUI.ButtonWithStyle("Couleur ID",nil, {RightLabel = rxeJobBuilder.Blip.color}, true, function(Hovered, Active, Selected)

                                    if Selected then

                                        rxeJobBuilder.Blip.color = rxeJobBuilderKeyboardInput("Couleur (ID) du blip", "", 30)

                                        RageUI.Text({ message = "~g~Couleur du blip ajouté", time_display = 2500 })

                                    end

                                end)

                

                                RageUI.ButtonWithStyle("Taille ID",nil, {RightLabel = rxeJobBuilder.Blip.height}, true, function(Hovered, Active, Selected)

                                    if Selected then

                                        rxeJobBuilder.Blip.height = rxeJobBuilderKeyboardInput("Taille (0.0 - 1.2) du blip", "", 30)

                                        RageUI.Text({ message = "~g~Taille du blip ajouté", time_display = 2500 })

                                    end

                                end)

                            end

                

                            RageUI.Separator('~y~↓ Marker ↓')

                

                            RageUI.ButtonWithStyle("Marker ID",nil, {RightLabel = rxeJobBuilder.Marker.id}, true, function(Hovered, Active, Selected)

                                if Selected then

                                    rxeJobBuilder.Marker.id = rxeJobBuilderKeyboardInput("ID du marker", "", 30)

                                    RageUI.Text({ message = "~g~ID du marker ajouté", time_display = 2500 })

                                end

                            end)

                

                            RageUI.ButtonWithStyle("Couleur (RGB)",nil, {RightLabel = rxeJobBuilder.Marker.color and "R : "..rxeJobBuilder.Marker.color[1].." - G : "..rxeJobBuilder.Marker.color[2].." - B : "..rxeJobBuilder.Marker.color[3]}, true, function(Hovered, Active, Selected)

                                if Selected then

                                    rxeJobBuilder.Marker.color = {}

                                    rxeJobBuilder.Marker.color[1] = rxeJobBuilderKeyboardInput("R (0 - 255)", "", 30)

                                    rxeJobBuilder.Marker.color[2] = rxeJobBuilderKeyboardInput("G (0 - 255)", "", 30)

                                    rxeJobBuilder.Marker.color[3] = rxeJobBuilderKeyboardInput("B (0 - 255)", "", 30)

                                    RageUI.Text({ message = "~g~Couleur du marker (rgb) ajouté", time_display = 2500 })

                                end

                            end)

                

                            RageUI.ButtonWithStyle("Taille",nil, {RightLabel = rxeJobBuilder.Marker.height}, true, function(Hovered, Active, Selected)

                                if Selected then

                                    rxeJobBuilder.Marker.height = rxeJobBuilderKeyboardInput("Taille (0.0 - 1.2) du marker", "", 30)

                                    RageUI.Text({ message = "~g~Taille du marker ajouté", time_display = 2500 })

                                end

                            end)

                            

                            RageUI.Separator('~y~↓ Actions ↓')

                

                            RageUI.ButtonWithStyle("~g~ →→ Valider",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)

                                if Selected then

                                    if rxeJobBuilder.Name == nil or rxeJobBuilder.Label == nil or rxeJobBuilder.PosVeh == nil or rxeJobBuilder.PosCoffre == nil or rxeJobBuilder.PosBoss == nil or rxeJobBuilder.PosSpawnVeh == nil or rxeJobBuilder.nameItemR == nil or rxeJobBuilder.labelItemR == nil or rxeJobBuilder.PosRecolte == nil or rxeJobBuilder.nameItemT == nil or rxeJobBuilder.labelItemT == nil or rxeJobBuilder.PosTraitement == nil or #rxeJobBuilder.vehInGarage == 0 then

                                        RageUI.Text({ message = "~r~Un ou plusieurs champs n\'ont pas été défini !", time_display = 2500 })

                                    else

                                        TriggerServerEvent('rxeJobBuilder:addJob', rxeJobBuilder)

                                        RageUI.Text({ message = "~y~Job ajoute avec succès !", time_display = 2500 })

                                        resetInfo()

                                    end

                                end

                            end)

                

                            RageUI.ButtonWithStyle('~r~ →→ Annuler' , nil, {RightLabel = ""}, true, function(Hovered, Active, Selected) 

                                if (Selected) then

                                resetInfo()

                                RageUI.CloseAll()

                                RageUI.Text({ message = "~r~Annulé !", time_display = 2500 })

                            end

                        end)



                    end, function()

                    end)

                    RageUI.IsVisible(menuGestGarage, true, true, true, function()



                        RageUI.ButtonWithStyle("→ Ajoute un véhicule",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)

                            if Selected then

                                local modelVeh = rxeJobBuilderKeyboardInput("Model du véhicule ?", "", 30)

                                local labelVeh = rxeJobBuilderKeyboardInput("Label du véhicule ?", "", 30)

                                table.insert(rxeJobBuilder.vehInGarage, {

                                    model = modelVeh,

                                    label = labelVeh

                                })

                                ESX.ShowNotification('Véhicule ajouter au garage !')

                            end

                        end)

                        if #rxeJobBuilder.vehInGarage == 0 then

                            RageUI.Separator(" ")

                            RageUI.Separator("~r~Aucun véhicule n'a encore été défini !")

                            RageUI.Separator(" ")

                        else

                            RageUI.Separator("↓ ~g~Véhicule disponible ↓")

                        end

                        for k,v in pairs(rxeJobBuilder.vehInGarage) do

                            RageUI.ButtonWithStyle("Label : "..v.label,nil, {RightLabel = "Model : "..v.model}, true, function(Hovered, Active, Selected)

                                if Selected then

                                    table.remove(rxeJobBuilder.vehInGarage, k)

                                    ESX.ShowNotification('Véhicule supprimer !')

                                end

                            end)

                        end

                

                    end, function()

                    end)

                    RageUI.IsVisible(modifiejob, true, true, true, function()

                        RageUI.Checkbox("Activer/Désactiver le mode modification",nil, modEdit,{},function(Hovered,Ative,Selected,Checked)

                            if Selected then

                                modEdit = Checked

                                if Checked then

                                    RageUI.Text({message = "Vous avez ~g~Activer~s~ le mode modification !", time_display = 2500})

                                else

                                    RageUI.Text({message = "Vous avez ~r~Désactiver~s~ le mode modification !", time_display = 2500})

                                end

                            end

                        end)

            

                        if modEdit then

                            for k,v in pairs(allJobs) do

                                RageUI.ButtonWithStyle("→ Entreprise : "..v.Label,nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)

                                    if Selected then

                                        jobSelect = v

                                    end

                                end, MenuGestionSub)

                            end

                        end

            

                    end, function()

                    end)

                    RageUI.IsVisible(MenuGestionSub, true, true, true, function()

            

                        RageUI.ButtonWithStyle("→ Position du garage",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)

                            if Selected then

                                local plyPos = GetEntityCoords(PlayerPedId())

                                TriggerServerEvent('rxeJobBuilder:editJob', 'Posgarage', plyPos, jobSelect.Name)

                            end

                        end)

                

                        RageUI.ButtonWithStyle("→ Position spawn véhicule",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)

                            if Selected then

                                local plyPos = GetEntityCoords(PlayerPedId())

                                TriggerServerEvent('rxeJobBuilder:editJob', 'Posspawn', plyPos, jobSelect.Name)

                            end

                        end)

                

                        RageUI.ButtonWithStyle("→ Position du menu boss",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)

                            if Selected then

                                local plyPos = GetEntityCoords(PlayerPedId())

                                TriggerServerEvent('rxeJobBuilder:editJob', 'PosBoss', plyPos, jobSelect.Name)

                            end

                        end)

                

                        RageUI.ButtonWithStyle("→ Position du coffre",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)

                            if Selected then

                                local plyPos = GetEntityCoords(PlayerPedId())

                                TriggerServerEvent('rxeJobBuilder:editJob', 'PosCoffre', plyPos, jobSelect.Name)

                            end

                        end)

            

                        RageUI.ButtonWithStyle("→ Position de la récolte",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)

                            if Selected then

                                local plyPos = GetEntityCoords(PlayerPedId())

                                TriggerServerEvent('rxeJobBuilder:editJob', 'PosRecolte', plyPos, jobSelect.Name)

                            end

                        end)

            

                        RageUI.ButtonWithStyle("→ Position du traitement",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)

                            if Selected then

                                local plyPos = GetEntityCoords(PlayerPedId())

                                TriggerServerEvent('rxeJobBuilder:editJob', 'PosTraitement', plyPos, jobSelect.Name)

                            end

                        end)

            

                        RageUI.ButtonWithStyle("→ Position de la vente",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)

                            if Selected then

                                local plyPos = GetEntityCoords(PlayerPedId())

                                TriggerServerEvent('rxeJobBuilder:editJob', 'PosVente', plyPos, jobSelect.Name)

                            end

                        end)

            

                        RageUI.ButtonWithStyle("→ Prix de la vente",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)

                            if Selected then

                                local priceVenteNew = rxeJobBuilderKeyboardInput("Prix de la vente ?", "", 30)

                                TriggerServerEvent('rxeJobBuilder:editJob', 'PrixVente', tonumber(priceVenteNew), jobSelect.Name)

                            end

                        end)

            

                    end, function()

                    end)

                    RageUI.IsVisible(ped, true, true, true, function()



                        RageUI.ButtonWithStyle("~r~→~s~ Revenir à son personnage", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)

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



                        

                        RageUI.List('~r~→~s~ Se mettre en ', Peds.name, Menu.list, nil, {RightLabel = ""}, true, function(Hovered, Active, Selected, Index)

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

                            Menu.list = Index;              

                        end)



                            RageUI.ButtonWithStyle("~r~→~s~ Choisir un ped perso", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)

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

                    RageUI.IsVisible(perso, true, true, true, function()



                        local myid = GetPlayerServerId(PlayerId())



                            RageUI.ButtonWithStyle("~r~→~s~ TP-Marqueur", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)

                                if (Selected) then

                                    ExecuteCommand("tpm")

                                end

                            end)



                            RageUI.Checkbox("~r~→~s~ Coordonnées", description, afficherco, {}, function(Hovered, Ative, Selected, Checked)

                                if Selected then

                                    afficherco = Checked

                                    if Checked then

                                        Admin.showcoords = not Admin.showcoords  

                                    else

                                        Admin.showcoords = not Admin.showcoords  

                                    end

                                end

                            end)



                            RageUI.Checkbox("~r~→~s~ NoClip", description, affichernoclip, {}, function(Hovered, Ative, Selected, Checked)
                                if Selected then
                                    affichernoclip = Checked
                                    if Checked then
                                        onToggleNoClip(true)
                                        local ped = GetPlayerPed(-1)
                                        SetEntityVisible(ped, false, false)
                                        RageUI.Popup({ message = "~g~NoClip Actif" })
                                    else
                                        RageUI.Popup({ message = "~r~NoClip Inactif" })
                                        local ped = GetPlayerPed(-1)
                                        SetEntityVisible(ped, true, true)
                                        onToggleNoClip(false)
                                    end
                                end
                            end)



                            RageUI.Checkbox("~r~→~s~ GodMod",nil, checkbox2,{},function(Hovered,Active,Selected,Checked)

                                if Selected then

                                    checkbox2 = Checked

                                    if Checked then

                                        Checked = true

                                        admin_godmode()

                                        TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nA activé le godmod")

                                    else

                                        admin_godmode()

                                        TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nA désactivé le godmod")

                                    end

                                end

                            end)



                            RageUI.Checkbox("~r~→~s~ Invisible",nil, checkbox3,{},function(Hovered,Active,Selected,Checked)

                                if Selected then

                                    checkbox3 = Checked

                                    if Checked then

                                        Checked = true

                                        invisible = true

                                    else

                                        local ped = GetPlayerPed(-1)

                                        SetEntityVisible(ped, true, true)

                                        invisible = false

                                    end

                                end

                            end)



                            RageUI.Checkbox("~r~→~s~ Afficher id + noms", description, affichername,{},function(Hovered,Ative,Selected,Checked)

                                if Selected then

                                    affichername = Checked

                                    if Checked then

                                        ShowName = true

                                    else

                                        ShowName = false

                                    end

                                end

                            end)

                            RageUI.Checkbox("~r~→~s~ Delgun",nil, checkdelgun,{},function(Hovered,Active,Selected,Checked)

                                if Selected then

                                    checkdelgun = Checked

                                    if Checked then

                                        Checked = true

                                        GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_PISTOL"), 100, true, true)
                                        ExecuteCommand("gundvon")

                                        TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nA activé le delgun")

                                    else

                                        ExecuteCommand("gundvoff")

                                        TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nA désactivé le delgun")

                                    end

                                end

                            end)



                            if playergroup == 'Responsable' then

                                RageUI.List('~r~→~s~ Give money', Menu.action, Menu.list, nil, {RightLabel = ""}, true, function(Hovered, Active, Selected, Index)

                                    if (Selected) then 

                                        if Index == 1 then

                                            GiveCash()

                                    elseif Index == 2 then

                                        GiveBanque()

                                    elseif Index == 3 then

                                        GiveND()

                                    end

                                end

                                    Menu.list = Index;              

                                end)

                            end



                            if playergroup == 'Responsable' then

                                RageUI.ButtonWithStyle("~r~→~s~ Give item", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)

                                    if (Selected) then

                                        local item = KeyBoardText("Item", "", 10)

                                        local amount = KeyBoardText("Nombre", "", 10)

                                        if item and amount then

                                            ExecuteCommand("giveitem "..myid.. " " ..item.. " " ..amount)

                                        else

                                            RageUI.CloseAll()	

                                        end			

                                    end

                                end)

                            end

                            if playergroup == 'Responsable' then

                                RageUI.List('~r~→~s~ setjob', {"job1", "job2"}, IndexMgl, nil, {RightLabel = ""}, true, function(Hovered, Active, Selected, Index)

                                    if (Selected) then 

                                        if Index == 1 then

                                            local job = KeyBoardText("Job", "", 100)

                                            local grade = KeyBoardText("Grade", "", 100)

                                            if job and grade then

                                                ExecuteCommand("setjob "..myid.. " " ..job.. " " ..grade)

                                            else

                                                RageUI.CloseAll()	

                                            end

                                        elseif Index == 2 then

                                            local job2 = KeyBoardText("Job:", "", 100)

                                            local grade = KeyBoardText("Grade:", "", 100)

                                            if job2 and grade then

                                                ExecuteCommand("setjob2 "..myid.. " " ..job2.. " " ..grade)

                                            else

                                                RageUI.CloseAll()	

                                            end

                                        end

                                    end

                                    IndexMgl = Index;              

                                end)

                            end



                    end, function()

                    end)

                    RageUI.IsVisible(Sanctions, true, true, true, function()



                    end, function()
                    end)

                    RageUI.IsVisible(veh, true, true, true, function()



                            if playergroup == 'Responsable' or playergroup == 'Admin' or playergroup == 'Moderateur' then

                                RageUI.ButtonWithStyle("~r~→~s~ Spawn un véhicule", nil, {RightLabel = ""}, true, function(_, _, Selected)

                                    if Selected then                                                                

                                            local ped = GetPlayerPed(tgt)

                                            local ModelName = KeyBoardText("Véhicule", "", 100)

                                        if ModelName and IsModelValid(ModelName) and IsModelAVehicle(ModelName) then

                                            RequestModel(ModelName)

                                            while not HasModelLoaded(ModelName) do

                                            Citizen.Wait(0)

                                        end

                                            local veh = CreateVehicle(GetHashKey(ModelName), GetEntityCoords(GetPlayerPed(-1)), GetEntityHeading(GetPlayerPed(-1)), true, true)

                                            TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)

                                            Wait(50)

                                        else

                                            ESX.ShowNotification("~r~Vehicule invalide !")

                                        end

                                    end

                                end)

                            end



                            RageUI.Separator("~r~Le plus proche")



                            if IsPedSittingInAnyVehicle(PlayerPedId()) then

                                RageUI.ButtonWithStyle("~r~→~s~ Supprimer le véhicule", nil, { RightLabel = "" }, false,function()

                                end)

                                RageUI.ButtonWithStyle("~r~→~s~ Réparer le véhicule", nil, { RightLabel = "" }, false,function()

                                end)

                                RageUI.ButtonWithStyle("~r~→~s~ Custom au max", nil, { RightLabel = "" }, false,function()

                                end)

                            else

                                RageUI.ButtonWithStyle("~r~→~s~ Supprimer le véhicule", nil, { RightLabel = "" }, true,

                                function(Hovered, Active, Selected)

                                    if (Active) then

                                        GetCloseVehi()

                                    end

                                    if (Selected) then

                                        Citizen.CreateThread(function()

                                            local veh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 15.0, 0, 70)

                                            NetworkRequestControlOfEntity(veh)

                                            while not NetworkHasControlOfEntity(veh) do

                                                Wait(1)

                                            end

                                            DeleteEntity(veh)

                                            RageUI.Popup({ message = "Véhicule supprimé",

                                                sound = { audio_name = "BASE_JUMP_PASSED", audio_ref = "HUD_AWARDS", } })

                                        end)

                                    end

                                end)

                            RageUI.ButtonWithStyle("~r~→~s~ Réparer le véhicule", nil, { RightLabel = "" }, true,

                                function(Hovered, Active, Selected)

                                    if (Active) then

                                        GetCloseVehi()

                                    end

                                    if (Selected) then

                                        local veh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 15.0, 0, 70)

                                        NetworkRequestControlOfEntity(veh)

                                        while not NetworkHasControlOfEntity(veh) do

                                            Wait(1)

                                        end

                                        SetVehicleFixed(veh)

                                        SetVehicleDeformationFixed(veh)

                                        SetVehicleDirtLevel(veh, 0.0)

                                        SetVehicleEngineHealth(veh, 1000.0)

                                        RageUI.Popup({ message = "Véhicule réparé",

                                            sound = { audio_name = "BASE_JUMP_PASSED", audio_ref = "HUD_AWARDS", } })

                                    end

                                end)

                

                                if playergroup == 'Responsable' then

                            RageUI.ButtonWithStyle("~r~→~s~ Custom au max", nil, { RightLabel = "" }, true,function(Hovered, Active, Selected)

                                    if (Active) then

                                        GetCloseVehi()

                                    end

                                    if (Selected) then

                                        -- local veh = GetClosestVehicle(GetEntityCoords(GetPlayerPed(-1)), nil)

                                        local veh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 15.0, 0, 70)

                                        NetworkRequestControlOfEntity(veh)

                                        while not NetworkHasControlOfEntity(veh) do

                                            Wait(1)

                                        end

                                        ESX.Game.SetVehicleProperties(veh, {

                                            modEngine = 3,

                                            modBrakes = 3,

                                            modTransmission = 3,

                                            modSuspension = 3,

                                            modTurbo = true

                                        })

                                        RageUI.Popup({ message = "Véhicule amélioré",

                                            sound = { audio_name = "BASE_JUMP_PASSED", audio_ref = "HUD_AWARDS", } })

                                    end

                                end)

                            else

                                RageUI.ButtonWithStyle("~r~→~s~ Custom au max", "Rôle admin requis", { RightLabel = "" }, false,

                                function(Hovered, Active, Selected)

                                end)

                            end

                        end



                            RageUI.Separator("~r~Dans véhicule")



                            if IsPedSittingInAnyVehicle(PlayerPedId()) then

                                RageUI.ButtonWithStyle("~r~→~s~ Réparer le véhicule", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)                                                                                                                   

                                    if Selected then

                                        if IsPedInAnyVehicle(GetPlayerPed(-1), false) then

                                            vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)

                                            if DoesEntityExist(vehicle) then

                                                SetVehicleFixed(vehicle)

                                                SetVehicleDeformationFixed(vehicle)

                                                TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nA réparé sa voiture")

                                            end

                                        end

                                    end

                                end)



                                RageUI.ButtonWithStyle("~r~→~s~ Retourner le véhicule", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)

                                    if (Selected) then

                                        admin_vehicle_flip()

                                    end

                                end)



                                if playergroup == 'Responsable' then

                                    RageUI.ButtonWithStyle("~r~→~s~ Custom maximum", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)

                                        if (Selected) then   

                                        FullVehicleBoost()

                                        TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nA custom sa voiture")

                                        end   

                                    end) 

                                end



                                if playergroup == 'Responsable' then

                                    RageUI.ButtonWithStyle("~r~→~s~ Changer la plaque", nil, {}, true, function(_, Active, Selected)

                                        if Selected then

                                            if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then

                                                local plaqueVehicule = KeyBoardText("Plaque", "", 8)

                                                SetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false) , plaqueVehicule)

                                                ESX.ShowNotification("La plaque du véhicule est désormais : ~g~"..plaqueVehicule)

                                                TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nA changé la plaque de sa voiture par "..plaqueVehicule)

                                            else

                                                ESX.ShowNotification("~r~Erreur\n~s~Vous n'êtes pas dans un véhicule !")

                                            end

                                        end

                                    end)

                                end

                            else

                                RageUI.ButtonWithStyle("~r~→~s~ Réparer le véhicule", nil, {}, false, function()

                                end)

                                RageUI.ButtonWithStyle("~r~→~s~ Retourner le véhicule", nil, {}, false, function()

                                end)

                                RageUI.ButtonWithStyle("~r~→~s~ Custom maximum", nil, {}, false, function()

                                end)

                                RageUI.ButtonWithStyle("~r~→~s~ Changer la plaque", nil, {}, false, function()

                                end)

                            end

                    

                    end, function()

                    end)

			        RageUI.IsVisible(joueurs, true, true, true, function()



                            for k,v in pairs(playersList) do
                                local id = v.id
                                local groupPlayer = tostring(v.group)
                                local PlyName = v.name
            
                                if groupPlayer == "user" then
                                    groupPlayer = ""
                                elseif groupPlayer == "Moderateur" then
                                    groupPlayer = "- ~g~[Modérateur]"
                                elseif groupPlayer == "Admin" then
                                    groupPlayer = "- ~r~[Admin]"
                                elseif groupPlayer == "dev" then
                                    groupPlayer = "- ~b~[Dev]"
                                elseif groupPlayer == "Responsable" then
                                    groupPlayer = "- ~y~[Responsable]"
                                end
            

                                RageUI.ButtonWithStyle("[~r~"..id.."~s~] "..(PlyName or "").." "..groupPlayer, nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                                    if (Selected) then
                                        IdSelected = v
                                    end
                                end, options)

                            end
        

                    end, function()
                    end)

        
            RageUI.IsVisible(options, true, true, true, function()



                RageUI.Separator("~b~Joueur ~s~→→ ~b~"..IdSelected.name)



                RageUI.ButtonWithStyle("~r~→~s~ Envoyer un message", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)

                    if (Selected) then

                        local msg = KeyBoardText("Raison", "", 100)



                        if msg ~= nil then

                            msg = tostring(msg)

                    

                            if type(msg) == 'string' then

                                TriggerServerEvent("hAdmin:Message", IdSelected.id, msg)

                            end

                        end

                        ESX.ShowNotification("Vous venez d'envoyer le message à " .. IdSelected.name)

                    end

                end)



                if playergroup == 'Responsable' then



                    RageUI.ButtonWithStyle("~r~→~s~ Ouvrir l'inventaire", nil, { RightLabel = "" }, true,function(Hovered, Active, Selected)

                        if (Selected) then

                            ExecuteCommand("openinv " .. IdSelected.id)

                        end

                    end)



                end



                RageUI.List('~r~→~s~ Téléportation', {"Sur lui", "Sur vous", "Parking central", "LSPD", "Fourriere", "Concessionnaire"}, IndexTP, nil, {RightLabel = ""}, true, function(Hovered, Active, Selected, Index)

                    if (Selected) then 

                        if Index == 1 then

                            ExecuteCommand("goto "..IdSelected.id)

                            ESX.ShowNotification('Vous venez de vous Téléporter à '.. GetPlayerName(GetPlayerFromServerId(IdSelected.id)) ..'')

                            TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nC'est téléporté sur "..GetPlayerName(GetPlayerFromServerId(IdSelected.id)))

                        elseif Index == 2 then

                            ExecuteCommand("bring "..IdSelected.id)

                            ESX.ShowNotification('Vous venez de Téléporter  '.. GetPlayerName(GetPlayerFromServerId(IdSelected.id)) ..' à vous !')

                            TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nA téléporté sur lui le joueur "..GetPlayerName(GetPlayerFromServerId(IdSelected.id)))

                            bringback = true

                        elseif Index == 3 then

                            TriggerServerEvent('StaffBring', IdSelected.id, vector3(217.5238494873,-810.26831054688, 30.693128585815))
                            ESX.ShowNotification('Vous venez de téléporter '.. GetPlayerName(GetPlayerFromServerId(IdSelected.id)) ..' vers le parking central')

                        elseif Index == 4 then

                            TriggerServerEvent('StaffBring', IdSelected.id, vector3(424.36825561523,-978.53979492188, 30.71138381958))
                            ESX.ShowNotification('Vous venez de téléporter '.. GetPlayerName(GetPlayerFromServerId(IdSelected.id)) ..' vers le comissariat')


                        elseif Index == 5 then

                            TriggerServerEvent('StaffBring', IdSelected.id, vector3(418.9221496582,-1620.4530029297, 29.263717651367))
                            ESX.ShowNotification('Vous venez de téléporter '.. GetPlayerName(GetPlayerFromServerId(IdSelected.id)) ..' vers la fourrière')

                        elseif Index == 6 then

                            TriggerServerEvent('StaffBring', IdSelected.id, vector3(117.66254425049,-163.12188720703, 54.745693206787))
                            ESX.ShowNotification('Vous venez de téléporter '.. GetPlayerName(GetPlayerFromServerId(IdSelected.id)) ..' vers le concessionnaire')


                        end

                    end

                    IndexTP = Index;              

                end)

                if bringback == true then 
                    RageUI.ButtonWithStyle("~r~→~s~ ~o~Renvoyer à l'ancienne position", nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            ExecuteCommand("bringback "..IdSelected.id)
                            bringback = false
                        end
                    end)
                end


            RageUI.ButtonWithStyle("~r~→~s~ Spectate", nil, { RightLabel = "" }, true,function(Hovered, Active, Selected)
                if (Selected) then
                    if (not onStaffSpectate) then
                        StaffSpectate(IdSelected.id)
                    else
                        onStaffSpectate = false
                    end
                end
            end)

            

            RageUI.Checkbox("~r~→~s~ Freeze / Defreeze", description, Frigo,{},function(Hovered,Ative,Selected,Checked)

                if Selected then

                    Frigo = Checked

                    if Checked then

                        ESX.ShowNotification("Joueur Freeze ("..GetPlayerName(GetPlayerFromServerId(IdSelected.id))..")")

                        ExecuteCommand("freeze "..IdSelected.id)

                    else

                        ESX.ShowNotification("Joueur Defreeze ("..GetPlayerName(GetPlayerFromServerId(IdSelected.id))..")")

                        ExecuteCommand("unfreeze "..IdSelected.id)

                    end

                end

            end)



            if playergroup == 'Responsable' then

                RageUI.List('~r~→~s~ setjob', {"job1", "job2"}, IndexMgl, nil, {RightLabel = ""}, true, function(Hovered, Active, Selected, Index)

                    if (Selected) then 

                        if Index == 1 then

                            local job = KeyBoardText("Job", "", 100)

                            local grade = KeyBoardText("Grade", "", 100)

                            if job and grade then

                                ExecuteCommand("setjob "..IdSelected.id.. " " ..job.. " " ..grade)

                            else

                                RageUI.CloseAll()	

                            end

                        elseif Index == 2 then

                            local job2 = KeyBoardText("Job:", "", 100)

                            local grade = KeyBoardText("Grade:", "", 100)

                            if job2 and grade then

                                ExecuteCommand("setjob2 "..IdSelected.id.. " " ..job2.. " " ..grade)

                            else

                                RageUI.CloseAll()	

                            end

                        end

                    end

                    IndexMgl = Index;              

                end)

            end



            if playergroup == 'Responsable' then

                RageUI.List('~r~→~s~ Wype', {"MortRP", "Inventaire", "Armes"}, IndexWipe, nil, {RightLabel = ""}, true, function(Hovered, Active, Selected, Index)

                    if (Selected) then 

                        if Index == 1 then

                            TriggerServerEvent('h4ci:whipezebi', IdSelected.id)

                        elseif Index == 2 then

                            ExecuteCommand("clearinventory "..IdSelected.id)

                            ESX.ShowNotification("Vous venez d'enlever tout les items de ".. GetPlayerName(GetPlayerFromServerId(IdSelected.id)) .." !")

                        elseif Index == 3 then

                            ExecuteCommand("clearloadout "..IdSelected.id)

                            ESX.ShowNotification("Vous venez de enlever toutes les armes de ".. GetPlayerName(GetPlayerFromServerId(IdSelected.id)) .." !")

                        end

                    end

                    IndexWipe = Index;              

                end)

            end



            if playergroup == 'Responsable' then

                RageUI.List('~r~→~s~ Give', {"Item", "Armes"}, IndexGive, nil, {RightLabel = ""}, true, function(Hovered, Active, Selected, Index)

                    if (Selected) then 

                        if Index == 1 then

                            local item = KeyBoardText("Item", "", 10)

                            local amount = KeyBoardText("Nombre", "", 10)

                            if item and amount then

                                ExecuteCommand("giveitem "..IdSelected.id.. " " ..item.. " " ..amount)

                                ESX.ShowNotification("Vous venez de donner "..amount.. " " .. item .. " à " .. GetPlayerName(GetPlayerFromServerId(IdSelected.id)))	

                            else

                                RageUI.CloseAll()	

                            end	

                        elseif Index == 2 then

                            local weapon = KeyBoardText("WEAPON_...", "", 100)

                            local ammo = KeyBoardText("Munitions", "", 100)

                            if weapon and ammo then

                                ExecuteCommand("giveweapon "..IdSelected.id.. " " ..weapon.. " " ..ammo)

                                ESX.ShowNotification("Vous venez de donner "..weapon.. " avec " .. ammo .. " munitions à " .. GetPlayerName(GetPlayerFromServerId(IdSelected.id)))

                            else

                                RageUI.CloseAll()	

                            end

                        end

                    end

                    IndexGive = Index;              

                end)

            end

            



            if playergroup == 'Responsable' then

                RageUI.List('~r~→~s~ V.I.P', {"Mettre", "Enlever"}, IndexVIP, nil, {RightLabel = ""}, true, function(Hovered, Active, Selected, Index)

                    if (Selected) then 

                        if Index == 1 then

                            ExecuteCommand("setvip "..IdSelected.id)

                        elseif Index == 2 then

                            ExecuteCommand("removevip "..IdSelected.id)

                        end

                    end

                    IndexVIP = Index;              

                end)

            end



                RageUI.ButtonWithStyle("~r~→~s~ ~o~Kick", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)

                    if (Selected) then

                        local raison = KeyBoardText("Raison du kick", "", 100)

                        

                        TriggerServerEvent('haciadmin:kickjoueur', IdSelected.id, raison)

                    end

                end)



                RageUI.ButtonWithStyle("~r~→~s~ ~r~Ban", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)

                    if (Selected) then

                        local quelid = KeyBoardText("ID", "", 100)

                        local day = KeyBoardText("Jours", "", 100)

                        local raison = KeyBoardText("Raison du kick", "", 100)

                        if quelid and day and raison then

                            ExecuteCommand("sqlban "..quelid.. " " ..day.. " " ..raison)

                            ESX.ShowNotification("Vous venez de ban l\'ID :"..quelid.. " " ..day.. " pour la raison suivante : " ..raison)

                        else

                            RageUI.CloseAll()	

                        end

                    end

                end)

            

            end, function() 

            end)



        if not RageUI.Visible(main) 

            and not RageUI.Visible(perso) 

            and not RageUI.Visible(createbgang) 

            and not RageUI.Visible(modifiegang) 

            and not RageUI.Visible(createbgangSub) 

            and not RageUI.Visible(gestServ) 

            and not RageUI.Visible(createbjob) 

            and not RageUI.Visible(menuGestJobs) 

            and not RageUI.Visible(menuGestGarage) 

            and not RageUI.Visible(modifiejob) 

            and not RageUI.Visible(veh) 

            and not RageUI.Visible(joueurs) 

            and not RageUI.Visible(options) 

            and not RageUI.Visible(reports) 
            and not RageUI.Visible(manageReport) 

            and not RageUI.Visible(create_menu)

            and not RageUI.Visible(create_blips)  

            and not RageUI.Visible(create_marker) 

            and not RageUI.Visible(modif_menu) 

            and not RageUI.Visible(modif_submenu) 

            and not RageUI.Visible(create_submenu) 

            and not RageUI.Visible(ped) then

            main = RMenu:DeleteType("Menu Admin", true)

        end

    end

end

RegisterNetEvent("Staff:OnGetPlayers")
AddEventHandler("Staff:OnGetPlayers", function(players)
    playersList = players
end)

----------------



function resetInfo()

    rxeJobBuilder.Name = nil

    rxeJobBuilder.Label = nil

    rxeJobBuilder.PosVeh = nil

    rxeJobBuilder.PosBoss = nil

    rxeJobBuilder.PosCoffre = nil

    rxeJobBuilder.PosSpawnVeh = nil

    rxeJobBuilder.nameItemR = nil

    rxeJobBuilder.labelItemR = nil

    rxeJobBuilder.PosRecolte = nil

    rxeJobBuilder.nameItemT = nil

    rxeJobBuilder.labelItemT = nil

    rxeJobBuilder.PosTraitement = nil

    rxeJobBuilder.PosVente = nil

    rxeJobBuilder.vehInGarage = {}

    rxeJobBuilder.Confirm = nil

    rxeJobBuilder.Confirm1 = nil

    rxeJobBuilder.Confirm2 = nil

    rxeJobBuilder.Confirm3 = nil

    rxeJobBuilder.Confirm4 = nil

    rxeJobBuilder.Confirm5 = nil

    rxeJobBuilder.Confirm6 = nil

    rxeJobBuilder.Confirm7 = nil

    rxeJobBuilder.Confirm8 = nil

    rxeJobBuilder.Choisimec = false

    rxeJobBuilder.Blip = {}

    rxeJobBuilder.Marker = {}

end


Keys.Register('F10', 'Admin', 'Ouvrir le menu admin', function()

    ESX.TriggerServerCallback('RubyMenu:getUsergroup', function(group)

        playergroup = group

        if playergroup == 'Responsable' or playergroup == 'Moderateur' or playergroup == 'Admin' then

            OuvrirAdmin()

        end

    end)

end)



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if (IsControlJustPressed(0, 117)) then
            if (playergroup ~= nil and playergroup == 'Moderateur' or playergroup == 'Admin' or playergroup == 'Responsable' or playergroup == "owner") then
                if affichernoclip == false then
                    if ShowName == false then
                        ShowName = true
                    end
                    affichernoclip = true
                    onToggleNoClip(true)
                    SetEntityVisible(GetPlayerPed(-1), false, false)
                    RageUI.Popup({ message = "~g~NoClip Actif" })
                else
                    if ShowName == true then
                        ShowName = false
                    end
                    affichernoclip = false
                    RageUI.Popup({ message = "~r~NoClip Inactif" })
                    SetEntityVisible(GetPlayerPed(-1), true, true)
                    onToggleNoClip(false)
                end
            end
        end
    end
end)

local AdminRanks = {}
local AdminRanks = {"Responsable", "Moderateur", "Admin", "moderateur"}

RegisterNetEvent("finalmenuadmin:sendNotifForReport")
AddEventHandler("finalmenuadmin:sendNotifForReport", function(type, nomdumec)
    if type == 1 then
        ESX.TriggerServerCallback('RubyMenu:getUsergroup', function(group)
            playergroup = group
            for k,v in pairs(AdminRanks) do
                if playergroup == v then
                    ESX.ShowNotification('~r~[REPORT]\n~o~Un nouveau report à été effectué !')
                    ESX.TriggerServerCallback('finalmenuadmin:getAllReport', function(info)
                        reportlist = info
                    end)
                end
            end
        end)
    elseif type == 2 then
        ESX.TriggerServerCallback('RubyMenu:getUsergroup', function(group)
            playergroup = group
            for k,v in pairs(AdminRanks) do
                if playergroup == v then
                    ESX.ShowNotification('~r~[REPORT]\nLe report de ~b~'..nomdumec..'~r~ a bien été fermé !')
                    ESX.TriggerServerCallback('finalmenuadmin:getAllReport', function(info)
                        reportlist = info
                    end)
                end
            end
        end)
    elseif (type == 3) then
        ESX.TriggerServerCallback('RubyMenu:getUsergroup', function(group)
            playergroup = group
            for k,v in pairs(AdminRanks) do
                if playergroup == v then
                    ESX.ShowNotification('~r~[REPORT]\nLe report de ~b~'..nomdumec..'~g~ a été pris en charge !')
                    ESX.TriggerServerCallback('finalmenuadmin:getAllReport', function(info)
                        reportlist = info
                    end)
                end
            end
        end)
    elseif (type == 4) then
        ESX.TriggerServerCallback('RubyMenu:getUsergroup', function(group)
            playergroup = group
            for k,v in pairs(AdminRanks) do
                if playergroup == v then
                    ESX.TriggerServerCallback('finalmenuadmin:getAllReport', function(info)
                        reportlist = info
                    end)
                end
            end
        end)
    end
end)

RegisterCommand("report", function(source, args, rawCommand)
    if ReportOuPas == true then 
        ESX.ShowNotification("~r~Vous avez déjà fait un report il y'a moins de 5 minutes, merci d'attendre")
        return
    end

    local raisonDuReport = table.concat(args, " ") -- Concatène tous les arguments en une seule chaîne

    if raisonDuReport == nil or raisonDuReport == "" or raisonDuReport == " " then 
        ESX.ShowNotification("~r~Champ invalide !")
    else
        TriggerServerEvent("finalmenuadmin:addreport", raisonDuReport)
        ESX.ShowNotification("~g~Votre report à bien été envoyer.")
        ReportOuPas = true
        Citizen.SetTimeout(300000, function()
            ReportOuPas = false
        end)
    end
end, false, {help = "Envoyer un report aux admins. Utilisation : /report [raison]", validate = false, arguments = {
    {name = 'raison', help = 'La raison du report', type = 'string'}
}})


RegisterCommand('id', function(source, args, rawCommand)
    ESX.TriggerServerCallback('RubyMenu:getUsergroup', function(group)
        playergroup = group
        if playergroup == "Responsable" then

            if ShowName then 
                ShowName = false
            else
                ShowName = true
            end  

        else
            ESX.ShowNotification("Vous n'avez pas les droits pour utiliser cette commande.") 
        end
    end)
end, false)