hook.Add("OnScreenSizeChanged", "SSL3P:OnScreenSizeChanged", function()
    SSL3P.Fonts = {}
end)

local tAcceptKeys = {
    ["slot1"] = 1,
    ["slot2"] = 2,
    ["slot3"] = 3,
    ["slot4"] = 4,
    ["slot5"] = 5,
    ["slot6"] = 6,
}

local as = 1
local aw = 1
local nc = 0
local ls = ""
local weapon = ""
local sw, sh = ScrW(), ScrH()
local s = false
local t = CurTime()

local ALPHA = (SSL3P.Config and SSL3P.Config.Transparent) and 100 or 255
local C_PRIMARY     = Color(0, 160, 255, ALPHA)
local C_PANEL       = Color(25, 27, 32, ALPHA)
local C_PANEL_INNER = Color(18, 20, 26, ALPHA)

local function CreateTableWeapon()
    local wt = {}
    local p = LocalPlayer()
    local weps = p:GetWeapons()
    table.sort( weps, function( a, b )
        return a:GetPrintName() < b:GetPrintName()
    end )
    for n, w in pairs(weps) do
        local slot = (w:GetSlot() or 0 ) + 1
        if ! wt[slot] then wt[slot] = {} end
        if table.HasValue(wt[slot], w) then return end
        wt[slot][#wt[slot]+1] = w 
    end
    return wt
end

local function SetHovered(s, nw)
    local wt = CreateTableWeapon()
    for n, t in pairs(wt) do 
        if n == s then 
            for nn, wep in pairs(wt[s]) do 
                if nn == nw then 
                    weapon = wep
                end 
            end 
        end 
    end 
end 

local function GetHovered()
    return weapon
end 

local function MoveToSlotOccupatePlus(ns)
    local wt = CreateTableWeapon()
    local t = table.GetKeys(wt)
    for i = 1, table.Count(wt) do
        if t[i] == ns then 
            if i + 1 == #t then
                return t[#t]
            elseif i + 1 > #t then
                return t[1]
            else
                return t[i + 1]
            end
        end
        i = i + 1
    end
end

local function MoveToSlotOccupateMoins(ns)
    local wt = CreateTableWeapon()
    local t = table.GetKeys(wt)
    for i = 1, table.Count(wt) do
        if t[i] == ns then 
            if i - 1 <= 0 then
                return t[#t]
            else
                if t[i - 1] == nil then 
                    return t[i - 2]
                else 
                    return t[i - 1]
                end
            end
        end
        i = i + 1
    end
end

local function PaintWeapons()
    if not IsValid(LocalPlayer()) or not LocalPlayer():Alive() then return end
    if not s then return end
    if CurTime() - t > 1.4 then s = false aw = 0 as = 1 return end
    local w, h, y = sw * .1, sh * .035, 0

    -- Recompute alpha per frame based on config so changes apply immediately
    local alpha = (SSL3P.Config and SSL3P.Config.Transparent) and 100 or 255
    local C_PRIMARY = Color(0, 160, 255, alpha)
    local C_PANEL = Color(25, 27, 32, alpha)
    local C_PANEL_INNER = Color(18, 20, 26, alpha)

    local weps = CreateTableWeapon()
    local availableCategories = {}

    for n, wep in pairs(weps) do
        for k, v in pairs(wep) do
            
            local slot = (v:GetSlot() or 0) + 1
            if not availableCategories[slot] then
                availableCategories[slot] = {}
            end
            table.insert(availableCategories[slot], v)

        end
    end

    local categories = {}
    for slot, weapons in pairs(availableCategories) do
        table.insert(categories, {slot = slot, weapons = weapons})
    end

    table.sort(categories, function(a, b) return a.slot < b.slot end)

    local categoryCount = table.Count(categories)
    local categoryWidth = w -10
    local totalWidth = categoryWidth * categoryCount
    local startX = sw / 2 - totalWidth / 2

    for i, category in ipairs(categories) do
        
        local slot = category.slot
        local weapons = category.weapons

        local pos_x = startX + (i - 1) * categoryWidth

        for _, v in pairs(weapons) do

            local pos_y = 40 + y * 45
            y = y + 1
            if v == GetHovered() then 
                ls = v
                draw.RoundedBox(6, pos_x, pos_y, sw * .09, h, C_PRIMARY)
                draw.RoundedBox(6, pos_x + 2, pos_y + 2, sw * .09 - 4, h - 4, C_PANEL_INNER)
                draw.SimpleText(v:GetPrintName(), SSL3P:Font((#v:GetPrintName() > 18 and 18 or 22), "Bold"), pos_x + sw * .045, pos_y + h / 2, color_white, 1, 1)
            else
                draw.RoundedBox(6, pos_x, pos_y, sw * .09, h, C_PANEL)
                draw.SimpleText(v:GetPrintName(), SSL3P:Font((#v:GetPrintName() > 18 and 18 or 22), "Medium"), pos_x + sw * .045, pos_y + h / 2, color_white, 1, 1)
            end

        end
        y = 0

    end
end



local function ChangeWeps( p, b )
    if not IsValid(LocalPlayer()) or not LocalPlayer():Alive() then return end
    if LocalPlayer():InVehicle() then return end
    if input.IsButtonDown( MOUSE_LEFT ) then return end

    if istable(LocalPlayer():GetWeapons()) and #LocalPlayer():GetWeapons() <= 0 then return end

    if tAcceptKeys[b] then
        local wt = CreateTableWeapon()
        local num = tAcceptKeys[b]
        local weps = wt[num]
        if not weps then return end
        if as != num then
            aw = 0
        end
        ls = weps[0]
        as = num
        PaintWeapons()
        aw = aw + 1
        if aw > #weps then
            aw = 1
        end
        SetHovered(num, aw)
    
        s = true
        t = CurTime()
        if SSL3P.Config.EnableSound then surface.PlaySound(SSL3P.Config.SwitchSound) end
        nc = nc + 1
    elseif b == "invprev" then
        local wt = CreateTableWeapon()
        ls = wt[as][2]
        PaintWeapons()
        aw = nc == 0 and aw or aw - 1
        if aw <= 0 then
            as = MoveToSlotOccupateMoins(as)
            aw = #wt[as]
        end        
        SetHovered(as, aw)
        s = true
        t = CurTime()
        if SSL3P.Config.EnableSound then surface.PlaySound(SSL3P.Config.SwitchSound) end
        nc = nc + 1
    elseif b == "invnext" then
        local wt = CreateTableWeapon()
        ls = wt[as][1]
        PaintWeapons()
        local slot = (ls:GetSlot() or 0) + 1
        aw = nc == 0 and aw or aw + 1
        if aw - 1 >= #wt[slot] then
            as = MoveToSlotOccupatePlus(as or 1)
            aw = 1
        end
        SetHovered(as, aw)
        s = true
        t = CurTime()
        if SSL3P.Config.EnableSound then surface.PlaySound(SSL3P.Config.SwitchSound) end
        nc = nc + 1
    end
end

local function SetActuallyWeapon( p, c )
    if c:KeyDown( IN_ATTACK ) then
        if CurTime() - t > 1.4 or ! LocalPlayer():Alive() or ! s then return end
        c:ClearButtons()
        input.SelectWeapon( ls )
        if SSL3P.Config.EnableSound then surface.PlaySound(SSL3P.Config.SelectWeaponSound) end
        s = false
        nc = 0
    end
end

hook.Add("PlayerBindPress", "SSL3P:PlayerBindPress", ChangeWeps ) 
hook.Add("HUDPaint", "SSL3P:HUDPaint", function()

    if not LocalPlayer():Alive() then
        as = 1
        aw = 1
        nc = 0
    end

    PaintWeapons()

end)
hook.Add("StartCommand", "SSL3P:StartCommand", SetActuallyWeapon )

local tHideElements = {
    ["CHudWeaponSelection"] = true
}

hook.Add("HUDShouldDraw", "SSL3P:HUDShouldDraw", function(sElementName)
    if tHideElements[sElementName] then return false end
end)