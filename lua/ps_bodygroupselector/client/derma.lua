local CONFIG = include('ps_bodygroupselector/sh_config.lua')

local PANEL = {}

function PANEL:Init()
	self:SetSize(400, 350)
	self:Center()
	self:MakePopup()
	self:SetTitle('Bodygroup Selector | Loading...')
	self:DockPadding(0, 24, 0, 0)

	-- Model background
	self.ModelBG = self:Add('DPanel')
	self.ModelBG:Dock(LEFT)
	self.ModelBG:SetWide(220)
	self.ModelBG:SetBackgroundColor(CONFIG.ModelBackground)

	-- Model panel
	self.ModelStand = self.ModelBG:Add('DModelPanel')
	self.ModelStand:Dock(FILL)

	-- Slider to control model's FOV
	self.FOV = self.ModelBG:Add('DNumSlider')
	self.FOV:Dock(BOTTOM)
	-- Removing text and white area because it's already understood what the slider means
	self.FOV.Label:Hide()
	self.FOV:SetMinMax(10, 120)
	self.FOV:SetDecimals(0)
	self.FOV:SetValue(45)
	-- Spacing
	self.FOV:DockMargin(8, 0, 0, 0)
	-- Change FOV
	self.FOV.OnValueChanged = function(this, value)
		this:SetValue(math.Round(value)) -- This makes the slider more snappier
		self.ModelStand:SetFOV(value) -- This changes the FOV
	end

	-- Scroll panel for sliders
	self.SP = self:Add('DScrollPanel')
	self.SP:Dock(FILL)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 24, w, h - 24, CONFIG.DermaBackground)
	draw.RoundedBoxEx(8, 0, 0, w, 24, CONFIG.DermaBar, true, true, false, false)
end

vgui.Register('PS_BodygroupSelector.Derma', PANEL, 'DFrame')
vgui.Create('PS_BodygroupSelector.Derma')