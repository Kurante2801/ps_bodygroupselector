if SERVER then
	include('ps_bodygrouppicker/server/pickerenabler.lua')
	AddCSLuaFile('ps_bodygrouppicker/client/derma.lua')
	AddCSLuaFile('ps_bodygrouppicker/sh_config.lua')
elseif CLIENT then
	include('ps_bodygrouppicker/client/derma.lua')
end