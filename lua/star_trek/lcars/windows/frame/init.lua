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
--    LCARS Single Frame | Server    --
---------------------------------------

if not istable(WINDOW) then Star_Trek:LoadAllModules() return end
local SELF = WINDOW

function SELF:OnCreate(title, titleShort, hFlip)
	self.Title 		= title or ""
	self.TitleShort = titleShort or ""

	if not isnumber(hFlip) then
		hFlip = (hFlip or false) and WINDOW_BORDER_RIGHT or WINDOW_BORDER_LEFT
	end
	self.HFlip = hFlip or WINDOW_BORDER_LEFT

	self.Color1 = Star_Trek.LCARS.ColorOrange
	self.Color2 = Star_Trek.LCARS.ColorBlue
	self.Color3 = Star_Trek.LCARS.ColorRed
	self.Color4 = Star_Trek.LCARS.ColorBlue

	return true
end

function SELF:GetClientData()
	local clientData = SELF.Base.GetClientData(self)

	clientData.FrameType = self.FrameType
	clientData.Padding = self.Padding

	clientData.Title 	  = self.Title
	clientData.TitleShort = self.TitleShort
	clientData.HFlip 	  = self.HFlip

	clientData.Color1 = self.Color1
	clientData.Color2 = self.Color2
	clientData.Color3 = self.Color3
	clientData.Color4 = self.Color4

	return clientData
end