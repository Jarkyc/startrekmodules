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
--    Copyright © 2022 Jan Ziegler   --
---------------------------------------
---------------------------------------

---------------------------------------
--     Transporter Cycle | Server    --
---------------------------------------

-- Applies the serverside effects to the entity depending on the current state of the transport cycle.
--
-- @param Table transportData
-- @param Entity ent
function Star_Trek.Transporter:TriggerEffect(transportData, ent)

	if mode == 1 then
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			transportData.OldMotionEnabled = phys:IsMotionEnabled()
			phys:EnableMotion(false)
		end
	elseif mode == 3 then
	else
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			if transportData.OldMotionEnabled ~= nil then
				phys:EnableMotion(transportData.OldMotionEnabled)
			end
		end
	end
end