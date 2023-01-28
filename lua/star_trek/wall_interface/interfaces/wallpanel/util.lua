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
--      LCARS Wall Pannel | Util     --
---------------------------------------

if not istable(INTERFACE) then Star_Trek:LoadAllModules() return end
local SELF = INTERFACE

function SELF:CreateTestWindow()
    local success, window = Star_Trek.LCARS:CreateWindow(
        "button_matrix",
        self.SecondaryWindowPos,
        Angle(),
        self.SecondaryWindowScale,
        self.SecondaryWindowWidth,
        self.SecondaryWindowHeight,
        function(windowData, interfaceData, ply, buttonId)
        end,
        "Test Window",
        nil,
        false,
        nil,
        100
    )
    if not success then
        return false, window
    end
    return window
end