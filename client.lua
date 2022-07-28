veiculoalugado = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if(not DoesBlipExist(bizblip)) then
            bizblip = AddBlipForCoord(-247.87004, 344.08597, 13.81897)
            ChangeBlipSprite(bizblip, 25)
            ChangeBlipNameFromAscii(bizblip, "Alugar moto")
            ChangeBlipScale(bizblip, 0.5)
            SetBlipAsShortRange(bizblip, true)
        end
        DrawCheckpointWithAlpha(-247.87004, 344.08597, 13.81897, 1.1, 1, 181, 232, 255)
        if IsPlayerNearCoords(-247.87004, 344.08597, 14.81897, 1.1) then
            if veiculoalugado == 0 then  
                ShowText("Pressione 'E' para alugar uma moto por 50R$", 1)
                if IsGameKeyboardKeyJustPressed(18) then 
                    vehalugado = SpawnAluCar(GetHashKey("faggio"), -232.63574, 347.40817, 14.71639, 194.370498657227, true)
                    veiculoalugado = 1
                    exports.SaveSystem:TakeMoney(50)
                end
            elseif veiculoalugado == 1 then 
                ShowText("Pressione 'E' devolver a moto", 1)
                if IsGameKeyboardKeyJustPressed(18) then 
                    if DoesVehicleExist(vehalugado) then
                        DeleteCar(vehalugado)
                        veiculoalugado = 0
                    end
                end
            end
        end
        if(IsPlayerDead(GetPlayerId())) then
			if veiculoalugado == 1 then
				DeleteCar(vehalugado)
				veiculoalugado = 0
			end			
		end
    end
end)

SpawnAluCar = function(model, x, y, z, heading, throwin)
	RequestModel(model)
	while not HasModelLoaded(model) do 
		Citizen.Wait(0) 
	end

	vehalugado = CreateCar(model, x, y, z, true)
	SetCarHeading(vehalugado , heading)
	SetCarOnGroundProperly(vehalugado)
	SetVehicleDirtLevel(vehalugado, 0.0)
	WashVehicleTextures(vehalugado, 255)

	if(throwin == true) then
		WarpCharIntoCar(GetPlayerChar(-1), vehalugado)
	end
	return vehalugado
end
IsPlayerNearCoords = function(x, y, z, radius)
    local pos = table.pack(GetCharCoordinates(GetPlayerChar(-1)))
    local dist = GetDistanceBetweenCoords3d(x, y, z, pos[1], pos[2], pos[3])

    if(dist < radius) then return true
    else return false
    end
end
local lockNearTramp = 0
local texttrank = 0
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if(DoesVehicleExist(vehalugado)) then
            if(IsGameKeyboardKeyJustPressed(38)) then 
                local ped = GetPlayerChar(-1)
                local cx, cy, cz = GetCarCoordinates(vehalugado)
                if IsPlayerNearCoords(cx, cy, cz, 5) then 
                    if(DoesVehicleExist(vehalugado)) then
                        if(lockNearTramp == 0) then
                            lockNearTramp = 1
                            texttrank = 1
                            LockCarDoors(vehalugado, 3)
                            Citizen.Wait(2000)
                            texttrank = 0
                        else
                            lockNearTramp = 0
                            texttrank = 2
                            LockCarDoors(vehalugado, 0)
                            Citizen.Wait(2000)
                            texttrank = 0
                        end
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if texttrank == 1 then
            ShowText("Trancado")
        elseif texttrank == 2 then 
            ShowText("Destrancado")
        end
    end
end)

ShowText = function(text)
    SetTextScale(0.2700000, 0.47000)
    SetTextFont(9)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(false, 0, 0, 0, 0)
    SetTextCentre(true)
    DisplayTextWithLiteralString(0.5, 0.95, "STRING", "".. text)
end