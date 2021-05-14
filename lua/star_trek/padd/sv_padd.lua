---------------------------------------
---------------------------------------
--        Star Trek Utilities        --
--                                   --
--            Created by             --
--       Jan 'Oninoni' Ziegler       --
--                                   --
-- This software can be used freely, --
--    but only distributed by me.    --
--                                   --
--    Copyright © 2020 Jan Ziegler   --
---------------------------------------
---------------------------------------

---------------------------------------
--           PADD | Server           --
---------------------------------------

function Star_Trek.PADD:Enable(padd, interfaceName)
	local ply = padd:GetOwner()
	if not IsValid(ply) then
		return false, "Invalid Owner"
	end

	Star_Trek.LCARS:CloseInterface(padd)

	local ent = ply:GetEyeTrace().Entity
	if IsValid(ent) then
		local data = ent.LastData

		local interfaceData = Star_Trek.LCARS.ActiveInterfaces[ent]
		if interfaceData then
			data = interfaceData:GetData()
		end

		if data and data.LogData then
			Star_Trek.LCARS:OpenInterface(ply, padd, "padd_log", data.LogTitle, data.LogData)
		end
	end

	return true
end