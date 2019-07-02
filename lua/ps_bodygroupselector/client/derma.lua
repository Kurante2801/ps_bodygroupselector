local CONFIG = include('ps_bodygroupselector/sh_config.lua')

local PANEL = {}

function PANEL:Init()
	self:SetSize(500, 400)
	self:Center()
	self:MakePopup()
	self:SetTitle('Bodygroup Selector')
end

function PANEL:Paint(w, h)

end

vgui.Register('PS_BodygroupSelector.Derma', PANEL, 'DFrame')
vgui.Create('PS_BodygroupSelector.Derma')