local function createMapWindow(deck)
	local success, mapWindow = Star_Trek.LCARS:CreateWindow("section_map", Vector(13, 0, 0), Angle(0, 0, 0), nil, 850, 500, function(windowData, interfaceData, ent, buttonId)
		-- No Interactivity here yet.
	end, deck)
	if not success then
		return false, mapWindow
	end

	return true, mapWindow
end

function Star_Trek.LCARS:OpenSecurityMenu()
	local success, interfaceEnt = self:GetInterfaceEntity(TRIGGER_PLAYER, CALLER)
	if not success then
		Star_Trek:Message(interfaceEnt)
		return
	end

	if istable(self.ActiveInterfaces[interfaceEnt]) then
		return
	end

	local modes = {
		"Internal Scanners",
		"Security Measures",
	}
	local buttons = {}
	for i, name in pairs(modes) do
		local color = Star_Trek.LCARS.ColorBlue
		if i % 2 == 0 then
			color = Star_Trek.LCARS.ColorLightBlue
		end

		local buttonData = {
			Name = name,
			Color = color,
		}

		buttons[i] = buttonData
	end

	local modeCount = #modes
	local utilButtonData = {
		Name = "Disable Console",
		Color = Star_Trek.LCARS.ColorRed,
	}
	buttons[modeCount + 2] = utilButtonData

	local height = table.maxn(buttons) * 35 + 80
	local success2, menuWindow = Star_Trek.LCARS:CreateWindow("button_list", Vector(-18, -25, 9), Angle(10, 0, -50), 30, 400, height, function(windowData, interfaceData, ent, buttonId)
		if buttonId == modeCount + 2 then
			ent:EmitSound("star_trek.lcars_close")
			Star_Trek.LCARS:CloseInterface(ent)
		else
			print(buttonId)
			-- TODO: Mode Selection
		end
	end , buttons, "Modes")
	if not success2 then
		Star_Trek:Message(menuWindow)
		return
	end

	local success3, mapWindow = createMapWindow(1)
	if not success3 then
		Star_Trek:Message(mapWindow)
		return
	end

	local success4, sectionWindow = Star_Trek.LCARS:CreateWindow("category_list", Vector(-22, 0, 0), Angle(0, 0, 0), nil, 500, 500, function(windowData, interfaceData, ent, categoryId, buttonId)
		if isnumber(buttonId) then
			local windowFunctions = Star_Trek.LCARS.Windows[mapWindow.WindowType]
			if not istable(windowFunctions) then
				Star_Trek:Message("Invalid Map Window Type!")
				return
			end

			local buttonData = windowData.Categories[categoryId].Buttons[buttonId]
			local sectionId = buttonData.Data.Id

			local selected = windowFunctions.GetSelected(mapWindow)
			selected[sectionId] = buttonData.Selected

			windowFunctions.SetSelected(mapWindow, selected)
			
			Star_Trek.LCARS:UpdateWindow(ent, mapWindow.WindowId, mapWindow)
		else
			local updateSuccess, newMapWindow = createMapWindow(categoryId)
			if not updateSuccess then
				Star_Trek:Message(newMapWindow)
				return
			end

			Star_Trek.LCARS:UpdateWindow(ent, mapWindow.WindowId, newMapWindow)
			newMapWindow.WindowId = mapWindow.WindowId
			mapWindow = newMapWindow
		end
	end, Star_Trek.LCARS:GetSectionCategories(), "Sections", true)
	if not success4 then
		Star_Trek:Message(menuWindow)
		return
	end

	local windows = Star_Trek.LCARS:CombineWindows(
		menuWindow,
		sectionWindow,
		mapWindow
	)

	local success5, error = self:OpenInterface(interfaceEnt, windows)
	if not success5 then
		Star_Trek:Message(error)
		return
	end
end