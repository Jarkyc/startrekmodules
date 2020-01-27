
-- Setting up Doors.
local setupDoors = function()
	LCARS.Doors = {}

    for _, ent in pairs(ents.GetAll()) do
		if ent:GetClass() == "prop_dynamic" and table.HasValue(LCARS.DoorModels, ent:GetModel()) then
			table.insert(LCARS.Doors, ent)
		end
	end
end
hook.Add("InitPostEntity", "LCARS.DoorInitPostEntity", setupDoors)
hook.Add("PostCleanupMap", "LCARS.DoorPostCleanupMap", setupDoors)

-- Block Doors aborting animations.
hook.Add("AcceptInput", "LCARS.BlockDoorIfAlreadyDooring", function(ent, input, activator, caller, value)
	if table.HasValue(LCARS.Doors, ent) then
        if input == "SetAnimation" then
			-- Prevent the same animation again.
			local currentSequence = ent:GetSequence()
			local sequence = ent:LookupSequence(value)
			if sequence and currentSequence and sequence == currentSequence then
				return true	
			end

			-- Prevent aborting the animation.
			local duration = ent:SequenceDuration()
			if value == "close" then
				duration = duration + 5
			end
			if CurTime() < (ent.DoorLastSequenceStart or 0) + duration then
				return true
			end

			if value == "open" then
				ent.Open = true
			elseif value == "close" then
				ent.Open = false
			end

			if ent.LCARSKeyData then
				local partnerDoorName = ent.LCARSKeyData["lcars_partnerdoor"]
				if isstring(partnerDoorName) then
					local partnerDoors = ents.FindByName(partnerDoorName)
					for _, partnerDoor in pairs(partnerDoors) do
						print(ent, partnerDoor, value)
						partnerDoor:Fire("SetAnimation", value)
					end
				end
			end

			ent.DoorLastSequenceStart = CurTime()
        end
    end
end)

-- TODO: Locks
-- hook.Add("")

-- Open door when pressing use on them.
hook.Add("KeyPress", "LCARS.OpenDoors", function(ply, key)
	if key == IN_USE then
		local ent = ply:GetEyeTrace().Entity
		if IsValid(ent) and table.HasValue(LCARS.Doors, ent) then
			local distance = ent:GetPos():Distance(ply:GetPos())
			if distance < 64 then
				ent:Fire("SetAnimation", "open")
			end
		end
	end
end)

local function checkPlayers(door)
    local attachmentId1 = door:LookupAttachment("exit1")
    local attachmentId2 = door:LookupAttachment("exit2")

    if isnumber(attachmentId1) and isnumber(attachmentId2) and attachmentId1 ~= -1 and attachmentId2 ~= -1 then
        local attachmentPoint1 = door:GetAttachment(attachmentId1)
        local attachmentPoint2 = door:GetAttachment(attachmentId2)

        local entities = ents.FindInBox(attachmentPoint1.Pos, attachmentPoint2.Pos)

		for _, nearbyEnt in pairs(entities) do
			if nearbyEnt:IsPlayer() then
				return true
			end
		end
	end
end

-- Think hook for auto-closing the doors.
hook.Add("Think", "LCARS.DoorThink", function()
	local diffTime = CurTime() - (LCARS.LastDoorThink or 0)
	if diffTime > 0.1 then
		for _, ent in pairs(LCARS.Doors) do

			if ent.Open then
				if not checkPlayers(ent) then
					if ent.LCARSKeyData then
						local allDoorsFree = true
						local partnerDoorName = ent.LCARSKeyData["lcars_partnerdoor"]
						if isstring(partnerDoorName) then
							local partnerDoors = ents.FindByName(partnerDoorName)
							for _, partnerDoor in pairs(partnerDoors) do
								if checkPlayers(partnerDoor) then
									allDoorsFree = false
								end
							end
						end

						if not allDoorsFree then continue end
					end

					ent:Fire("SetAnimation", "close")
				end

				continue
			end

			if ent.LCARSKeyData and ent.LCARSKeyData["lcars_autoopen"] == "1" then
				if checkPlayers(ent) then
					ent:Fire("SetAnimation", "open")
				end
			end
		end
		
		LCARS.LastDoorThink = CurTime()
	end
end)