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


function SELF:OpenPage(activator, name, mainWindow)

    table.Empty(mainWindow.MainButtons) -- Preemptively clearing buttons in preparation for new ones
    local window
    if name == "Force Fields" then

        local deckNum = Star_Trek.Sections:FindDecksFast(activator:GetPos())[1]
        local categoryData = Star_Trek.Sections:GetSectionCategories()[deckNum]

        _, window  = Star_Trek.LCARS:CreateWindow("section_map", self.SecondaryWindowPos, Angle(), self.SecondaryWindowScale, self.SecondaryWindowWidth, self.SecondaryWindowHeight, function(windowData, interfaceData, ply, buttonId)
            -- No Interactivity here yet.
        end, deckNum)


        for k, v in pairs(categoryData.Buttons) do
            name = v.Name
            row = mainWindow:CreateMainButtonRow(32)
            buttonData = mainWindow:AddButtonToRow(row, name, nil, Star_Trek.LCARS.ColorBlue, Star_Trek.LCARS.ColorOrange, false, false, function(ply, buttonData)
                tbl = {}
                table.insert(tbl, v.Data)
                Star_Trek.ForceFields:EnableForceFieldsInSections(deckNum, tbl)
            end)
            buttonData.Data = v.Data
        end

    elseif name == "Personal Database" then
        _, window = Star_Trek.LCARS:CreateWindow(
            "log_entry",
            self.SecondaryWindowPos,
            Angle(),
            self.SecondaryWindowScale,
            self.SecondaryWindowWidth,
            self.SecondaryWindowHeight,
            function(windowData, interfaceData, ply, buttonId)
            end,
            true,
            Color(255, 255, 255)
        )

        -- Create the control buttons for the main window
    end

    return window
end