SSL3P = SSL3P or {}
SSL3P.Constants = SSL3P.Constants or {}
SSL3P.Config = SSL3P.Config or {}
SSL3P.Fonts = SSL3P.Fonts or {}

local function Inclu(f) return include("ssl3p/"..f) end
local function AddCS(f) return AddCSLuaFile("ssl3p/"..f) end
local function IncAdd(f) return Inclu(f), AddCS(f) end

local function AddMat(f) return resource.AddSingleFile("materials/ssl3p/"..f) end

IncAdd("config.lua")
IncAdd("shared/sh_functions.lua")

if SERVER then

	AddCS("client/cl_functions.lua")
	AddCS("client/cl_hooks.lua")

else

	Inclu("client/cl_functions.lua")
	Inclu("client/cl_hooks.lua")

end
