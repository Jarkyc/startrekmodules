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
--    LCARS Basic Interface | Util   --
---------------------------------------

local SELF = INTERFACE

-- Generate the buttons for a general purpose menu.
function SELF:GenerateButtons(keyValues)
	print("Updating...")
	PrintTable(keyValues)

	local buttons = {}
	for i = 1, 20 do
		local name = keyValues["lcars_name_" .. i]
		if isstring(name) then
			local disabled = tobool(keyValues["lcars_disabled_" .. i])

			buttons[i] = {
				Name = name,
				Disabled = disabled,
			}
		else
			break
		end
	end

	return buttons
end

function SELF:GetKeyValues(keyValues, buttons)
	local scale = tonumber(keyValues["lcars_scale"])
	local width = tonumber(keyValues["lcars_width"])
	local height = tonumber(keyValues["lcars_height"])
	local title = keyValues["lcars_title"]
	local titleShort = keyValues["lcars_title_short"]
	if titleShort == false then
		titleShort = ""
	end

	if not height then
		height = math.max(2, math.min(6, table.maxn(buttons))) * 35 + 80
	end

	return scale, width, height, title, titleShort
end

function SELF:GetButtonData(ent)
	local keyValues = ent.LCARSKeyData
	if not istable(keyValues) then
		return false, "Invalid Key Values on OpenMenu"
	end

	local buttons = self:GenerateButtons(keyValues)
	local scale, width, height, title, titleShort = self:GetKeyValues(keyValues, buttons)

	return true, buttons, scale, width, height, title, titleShort
end