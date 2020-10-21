local function getCategoryRow(self, categories)
    local rowData = {
        Categories = {}
    }

    if #categories == 1 then
        rowData.Width = self.WWidth -58

        table.insert(rowData.Categories, categories[1])
    elseif #categories == 2 then
        rowData.Width = (self.WWidth -58) / 2

        table.insert(rowData.Categories, categories[1])
        table.insert(rowData.Categories, categories[2])
    elseif #categories == 3 or #categories == 4 then
        rowData.Width = (self.WWidth -58) / 4

        table.insert(rowData.Categories, categories[1])
        table.insert(rowData.Categories, categories[2])
        table.insert(rowData.Categories, categories[3])
        if #categories == 4 then
            table.insert(rowData.Categories, categories[4])
        end
    end

    return rowData
end

function WINDOW.OnCreate(self, windowData)
    self.Title = windowData.Title
    self.Selected = windowData.Selected
    self.Categories = windowData.Categories

    self.WD2 = self.WWidth / 2
    self.HD2 = self.WHeight / 2

    self.MaxN = table.Count(self.Categories)
    self.CategoryHeight = math.max(2, math.ceil(self.MaxN / 4)) * 35

    self.ButtonsHeight = self.WHeight - self.CategoryHeight - 105
    self.ButtonsStart = self.HD2 - self.ButtonsHeight

    self.ButtonsTopAlpha = self.ButtonsStart
    self.ButtonsBotAlpha = self.HD2 - 25

    self.CategoryRows = {}
    local categories = table.Copy(self.Categories)
    while true do
        if #categories > 4 then
            local subCategories = {
                table.remove(categories, 1),
                table.remove(categories, 1),
                table.remove(categories, 1),
                table.remove(categories, 1),
            }

            table.insert(self.CategoryRows, getCategoryRow(self, subCategories))
        else
            table.insert(self.CategoryRows, getCategoryRow(self, categories))

            break
        end
    end

    return self
end

local function isButtonPressed(x, y, width, height, pos)
    return pos.x >= (x -1) and pos.x <= (x + width) and pos.y >= (y -1) and pos.y <= (y + height)
end

function WINDOW.OnPress(self, pos, animPos)
    local selected = self.Selected

    if pos.y <= -self.HD2 + self.CategoryHeight + 65 then
        -- Selection
        for i, rowData in pairs(self.CategoryRows) do
            for j, categoryData in pairs(rowData.Categories) do
                if isButtonPressed(-self.WD2 + 53 + (j - 1) * rowData.Width, -self.HD2 + 30 + i * 35, rowData.Width - 3, 32, pos) then
                    return categoryData.Id
                end
            end
        end
    else
        -- Button List
        if selected and istable(self.Categories[selected]) then
            local buttons = self.Categories[selected].Buttons
            local n = table.maxn(buttons)

            local offset = Star_Trek.LCARS:GetButtonOffset(self.ButtonsStart, self.ButtonsHeight, n, pos.y)
            for i, button in pairs(buttons) do
                if button.Disabled then continue end

                local y = Star_Trek.LCARS:GetButtonYPos(self.ButtonsHeight, i, n, offset)
                if pos.y >= y - 1 and pos.y <= y + 31 then
                    return #self.Categories + i
                end
            end
        end
    end
end

local color_grey = Star_Trek.LCARS.ColorGrey
local color_yellow = Star_Trek.LCARS.ColorYellow
local color_blues = {
    Star_Trek.LCARS.ColorLightBlue,
    Star_Trek.LCARS.ColorBlue,
}

function WINDOW.OnDraw(self, pos, animPos)
    local selected = self.Selected

    local alpha = 255 * animPos
    local lcars_black = Color(0, 0, 0, alpha)
    local lcars_top = ColorAlpha(Star_Trek.LCARS.ColorOrange, alpha)
    local lcars_middle = ColorAlpha(Star_Trek.LCARS.ColorLightRed, alpha)
    local lcars_bottom = ColorAlpha(Star_Trek.LCARS.ColorYellow, alpha)

    for i, rowData in pairs(self.CategoryRows) do
        for j, categoryData in pairs(rowData.Categories) do
            local color
            if selected == categoryData.Id then
                color = color_yellow
            else
                if categoryData.Color then
                    color = categoryData.Color
                else
                    color = color_blues[(i + j) % 2 + 1]
                end
            end

            if categoryData.Disabled then
                color = color_grey
            end

            Star_Trek.LCARS:DrawButtonGraphic(-self.WD2 + 55 + (j - 1) * rowData.Width, -self.HD2 + (i + 1) * 35, rowData.Width - 3, 32, color, alpha, pos)
            draw.DrawText(categoryData.Name, "LCARSText", -self.WD2 + 64 + (j - 1) * rowData.Width, -self.HD2 + (i + 1) * 35 + 12, lcars_black, TEXT_ALIGN_LEFT)
        end
    end

    if selected and istable(self.Categories[selected]) then
        local buttons = self.Categories[selected].Buttons
        local n = table.maxn(buttons)

        local offset = Star_Trek.LCARS:GetButtonOffset(self.ButtonsStart, self.ButtonsHeight, n, pos.y)

        for i, button in pairs(buttons) do
            local color = button.Color
            if button.Disabled then
                color = color_grey
            elseif button.Selected then
                color = color_yellow
            end

            local y = Star_Trek.LCARS:GetButtonYPos(self.ButtonsHeight, i, n, offset)

            local buttonAlpha = 255
            if y < self.ButtonsTopAlpha or y > self.ButtonsBotAlpha then
                if y < self.ButtonsTopAlpha then
                    buttonAlpha = -y + self.ButtonsTopAlpha
                else
                    buttonAlpha = y - self.ButtonsBotAlpha
                end

                buttonAlpha = math.min(math.max(0, 255 - buttonAlpha * 10), 255)
            end
            buttonAlpha = buttonAlpha * animPos

            local title = button.Name or "[ERROR]"

            Star_Trek.LCARS:DrawButton(28, y, self.WWidth, title, color, button.RandomS, button.RandomL, buttonAlpha, pos)
        end
    end

    -- Custom Drawing the Double Frame

    -- Title
    draw.DrawText(self.Title, "LCARSBig", self.WD2 -8, -self.HD2 -2, color_white, TEXT_ALIGN_RIGHT)

    Star_Trek.LCARS:DrawFrameSpacer(-self.HD2                       + 35, self.WWidth, self.WD2, lcars_black, lcars_top,    lcars_middle)
    Star_Trek.LCARS:DrawFrameSpacer(-self.HD2 + self.CategoryHeight + 70, self.WWidth, self.WD2, lcars_black, lcars_middle, lcars_bottom)

    -- Middle Bars
    draw.RoundedBox(0, -self.WD2    , -self.HD2 + 104, 50, self.CategoryHeight - 70, lcars_black)
    draw.RoundedBox(0, -self.WD2 + 1, -self.HD2 + 103, 48, self.CategoryHeight - 68, lcars_middle)

    draw.RoundedBox(0, -self.WD2    , -self.HD2 + 97, 50, 2, lcars_black)

    -- Bottom Red Bars 
    draw.RoundedBox(0, -self.WD2    , -self.HD2 + self.CategoryHeight + 130, 50, self.HD2 -60, lcars_black)
    draw.RoundedBox(0, -self.WD2 + 1, -self.HD2 + self.CategoryHeight + 130, 48, self.HD2 -60, lcars_bottom)

    -- Very Bottom Orange Bars
    draw.RoundedBox(0, -self.WD2    , 100, 50, self.HD2 -100, lcars_black)
    draw.RoundedBox(0, -self.WD2 + 1, 100, 48, self.HD2 -100, lcars_top)

    -- Small Black Bars
    draw.RoundedBox(0, -self.WD2, 100, 50, 2, lcars_black)
    draw.RoundedBox(0, -self.WD2, 120, 50, 2, lcars_black)
end