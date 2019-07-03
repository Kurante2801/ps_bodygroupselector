if SERVER then
	include('ps_bodygroupselector/server/selectorenabler.lua')
	AddCSLuaFile('ps_bodygroupselector/client/derma.lua')
	AddCSLuaFile('ps_bodygroupselector/sh_config.lua')
elseif CLIENT then
	include('ps_bodygroupselector/client/derma.lua')
end