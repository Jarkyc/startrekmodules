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
--    Copyright © 2021 Jan Ziegler   --
---------------------------------------
---------------------------------------

---------------------------------------
--       Utilities | Warp Core       --
---------------------------------------

net.Receive("Star_Trek.Util.SetWarpCore", function()
	local speed = net.ReadFloat()
	local brightness = net.ReadFloat()
	local flashSpeed = net.ReadFloat()
	local flashMin = net.ReadFloat()
	local flashMax = net.ReadFloat()

	local warpCoreMaterial = Material("models/kingpommes/startrek/intrepid/core_effect")
	warpCoreMaterial:SetFloat("$speed", speed)	
	warpCoreMaterial:SetFloat("$brightness", brightness)
	warpCoreMaterial:SetFloat("$flashspeed", flashSpeed)
	warpCoreMaterial:SetFloat("$flashminmul", flashMin)
	warpCoreMaterial:SetFloat("$flashmaxmul", flashMax)
end)