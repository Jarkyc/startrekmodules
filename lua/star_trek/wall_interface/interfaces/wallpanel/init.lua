---------------------------------------
---------------------------------------
--         Star Trek Modules         --
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
--     LCARS Wall Panel | Server     --
---------------------------------------

if not istable(INTERFACE) then Star_Trek:LoadAllModules() return end
local SELF = INTERFACE

include("util.lua")

SELF.BaseInterface = "base"

function SELF:Open(ent)
	local keyValues = ent.LCARSKeyData

	local scale = keyValues["lcars_scale"] or 15
	local width = keyValues["lcars_width"]
	local height = keyValues["lcars_height"] or 35
	local title = keyValues["lcars_title"] or "Select Mode"
	title = string.Replace(title, "@", " ")

	local w = 24
	local h = height
	local x = -width / 2 + w / 2 + 0.5
	local success, window = Star_Trek.LCARS:CreateWindow(
		"button_matrix",
		Vector(x, 0, 0),
		Angle(),
		scale,
		w * scale,
		h * scale,
		function(windowData, interfaceData, ply, buttonId)
		end,
		title,
		nil,
		true
	)
	if not success then
		return false, window
	end

	local sRow1 = window:CreateSecondaryButtonRow(32)
	window:AddButtonToRow(sRow1, "Data Display", nil, Star_Trek.LCARS.ColorBlue, Star_Trek.LCARS.ColorOrange, false, false, function(ply, buttonData)
		self:ButtonPressed(window, ply, buttonData)
	end)
	window:AddButtonToRow(sRow1, "Personal Database", nil, Star_Trek.LCARS.ColorLightBlue, Star_Trek.LCARS.ColorOrange, false, false, function(ply, buttonData)
		self:ButtonPressed(window, ply, buttonData)
	end)

	local sRow2 = window:CreateSecondaryButtonRow(32)
	window:AddButtonToRow(sRow2, "Comms System", nil, Star_Trek.LCARS.ColorLightBlue, Star_Trek.LCARS.ColorOrange, true, false, function(ply, buttonData)
		self:ButtonPressed(window, ply, buttonData)
	end)
	window:AddButtonToRow(sRow2, "Force Fields", nil, Star_Trek.LCARS.ColorBlue, Star_Trek.LCARS.ColorOrange, false, false, function(ply, buttonData)
		self:ButtonPressed(window, ply, buttonData)
	end)

	local sRow3 = window:CreateSecondaryButtonRow(32)
	window:AddButtonToRow(sRow3, "Close Menu", nil, Star_Trek.LCARS.ColorRed, nil, false, false, function()
		ent:EmitSound("star_trek.lcars_close")
		self:Close()
	end)

	local w2 = width - w - 1
	self.SecondaryWindowPos = Vector((width - w2) / 2, 0, 0)
	self.SecondaryWindowScale = scale
	self.SecondaryWindowWidth = (w2 - 1) * scale
	self.SecondaryWindowHeight = h * scale
	local success2, mainWindow = Star_Trek.LCARS:CreateWindow(
		"log_entry",
		self.SecondaryWindowPos,
		Angle(),
		scale,
		self.SecondaryWindowWidth,
		self.SecondaryWindowHeight,
		function(windowData, interfaceData, ply, buttonId)
		end,
		true,
		Color(255, 255, 255)
	)
	if not success2 then
		return false, mainWindow
	end

	return true, {window, mainWindow}, Vector(0, 0.5, 0.6)
end

-- Wrap for use in Map.
function Star_Trek.LCARS:OpenWallpanelMenu()
	Star_Trek.LCARS:OpenInterface(TRIGGER_PLAYER, CALLER, "wallpanel")
end

function SELF:ButtonPressed(windowData, ply, buttonData)
	for _, button in pairs(windowData.Buttons) do
		button.Selected = false
	end
	buttonData.Selected = true

	newWindow = self:CreateTestWindow()
	newWindow.Id = self.Windows[2].Id
	newWindow.Interface = self.Windows[2].Interface
	newWindow:Update()
end 	