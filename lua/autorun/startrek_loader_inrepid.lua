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
--               Loader              --
---------------------------------------

if not (string.StartWith(game.GetMap(), "rp_voyager") or string.StartWith(game.GetMap(), "test_")) then return end

Star_Trek = Star_Trek or {}
Star_Trek.Modules = Star_Trek.Modules or {}

function Star_Trek:Message(msg)
    print("[Star Trek] " .. msg)
end

local function loadModule(name)
    local moduleDirectory = "star_trek/" .. name .. "/"

    if SERVER then
        AddCSLuaFile(moduleDirectory .. "sh_index.lua")
    end
    include(moduleDirectory .. "sh_index.lua")

    local entityDirectory = moduleDirectory .. "entities/"
    local weaponDirectory = moduleDirectory .. "weapons/"

    local _, entityDirectories = file.Find(entityDirectory .. "*", "LUA")
    for _, entityName in pairs(entityDirectories) do
        local entDirectory = entityDirectory .. entityName .. "/"

        local oldEnt = ENT
        ENT = {
            ClassName = entityName,
            Folder = "weapons/" .. entityName,
        }

        if SERVER then
            AddCSLuaFile(entDirectory .. "shared.lua")
            AddCSLuaFile(entDirectory .. "cl_init.lua")
            
            include(entDirectory .. "shared.lua")
            include(entDirectory .. "init.lua")
        end

        if CLIENT then
            include(entDirectory .. "shared.lua")
            include(entDirectory .. "cl_init.lua")
        end

        weapons.Register(ENT, entityName)
        ENT = oldEnt

        Star_Trek:Message("Loaded Entity \"" .. entityName .. "\"")
    end

    local _, weaponDirectories = file.Find(weaponDirectory .. "*", "LUA")
    for _, weaponName in pairs(weaponDirectories) do
        local wepDirectory = weaponDirectory .. weaponName .. "/"
    
        local oldSWEP = SWEP
        SWEP = {
            ClassName = weaponName,
            Folder = "weapons/" .. weaponName,
        }

        SWEP.Primary = {}
        SWEP.Secondary = {}
        
        if SERVER then
            AddCSLuaFile(wepDirectory .. "shared.lua")
            AddCSLuaFile(wepDirectory .. "cl_init.lua")
            
            include(wepDirectory .. "shared.lua")
            include(wepDirectory .. "init.lua")
        end

        if CLIENT then
            include(wepDirectory .. "shared.lua")
            include(wepDirectory .. "cl_init.lua")
        end

        weapons.Register(SWEP, weaponName)
        SWEP = oldSWEP
        
        Star_Trek:Message("Loaded Weapon \"" .. weaponName .. "\"")
    end

    Star_Trek:Message("Loaded Module \"" .. name .. "\"")
end

hook.Add("PostGamemodeLoaded", "Star_Trek.Load", function()
    if SERVER then
        AddCSLuaFile("star_trek/config.lua")
    end

    include("star_trek/config.lua")

    for moduleName, enabled in SortedPairs(Star_Trek.Modules) do
        if enabled then
            loadModule(moduleName)
        end
    end
end)