function WINDOW.OnCreate(self, windowData)
    self.Title = windowData.Title
    self.Buttons = windowData.Buttons

    self.WD2 = self.WWidth / 2
    self.HD2 = self.WHeight / 2

    self.MaxN = table.maxn(self.Buttons)

    self.ButtonsHeight = self.WHeight - 70
    self.ButtonsStart = self.HD2 - self.ButtonsHeight

    self.ButtonsTopAlpha = self.ButtonsStart
    self.ButtonsBotAlpha = self.HD2 - 25

    return self
end

function WINDOW.OnPress(self, pos, animPos)
    local offset = Star_Trek.LCARS:GetButtonOffset(self.ButtonsStart, self.ButtonsHeight, self.MaxN, pos.y)
    for i, button in pairs(self.Buttons) do
        if button.Disabled then continue end

        local y = Star_Trek.LCARS:GetButtonYPos(self.ButtonsHeight, i, self.MaxN, offset)
        if pos.y >= y - 1 and pos.y <= y + 31 then
            return i
        end
    end
end

local color_grey = Star_Trek.LCARS.ColorGrey
local color_yellow = Star_Trek.LCARS.ColorYellow

function WINDOW.OnDraw(self, pos, animPos)
    local offset = Star_Trek.LCARS:GetButtonOffset(self.ButtonsStart, self.ButtonsHeight, self.MaxN, pos.y)
    for i, button in pairs(self.Buttons) do
        local color = button.Color
        if button.Disabled then
            color = color_grey
        elseif button.Selected then
            color = color_yellow
        end

        local y = Star_Trek.LCARS:GetButtonYPos(self.ButtonsHeight, i, self.MaxN, offset)

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

    Star_Trek.LCARS:DrawFrame(self.WWidth, self.WD2, self.HD2, self.Title, 255 * animPos)
end