local CONFIG = include('ps_bodygroupselector/sh_config.lua')

local PANEL = {}

function PANEL:Init()
	self:SetSize(400, 350)
	self:Center()
	self:MakePopup()
	self:SetDrawOnTop(true)
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

	-- Accept button
	self.Submit = self:Add('DButton')
	self.Submit:Dock(BOTTOM)
	self.Submit:DockMargin(4, 4, 4, 4)
	self.Submit:SetText('Submit!')
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 24, w, h - 24, CONFIG.DermaBackground)
	draw.RoundedBoxEx(6, 0, 0, w, 24, CONFIG.DermaBar, true, true, false, false)
end

function PANEL:SetItem(item, mods) -- mods is short for modifications
	-- Update variables
	self:SetTitle('Modifying ' .. item.Name)
	self.ModelStand:SetModel(item.Model)
	self.ModelStand:SetFOV(45)

	-- Store modifications
	self.Mods = table.Copy(mods)

	local ent = self.ModelStand.Entity
	-- Make colorable
	ent.GetPlayerColor = function() return LocalPlayer():GetPlayerColor() end
	-- Make stand rotable
	self.ModelStand.Rotating = true
	self.ModelStand.Angles = Angle(0, 0, 0)
	self.ModelStand:SetAnimated(true)
	-- Allow rotation and player rotation
	self.ModelStand.DragMousePress = function(this)
		this.PressX, this.PressY = gui.MousePos()
		this.Pressed = true
		this.Rotating = false
	end
	-- Stop following mouse on its release
	self.ModelStand.DragMouseRelease = function(this)
		this.Pressed = false
	end
	-- Display angles and walk anim
	self.ModelStand.LayoutEntity = function(this, _ent)
		if this.bAnimated then
			this:RunAnimation()
		end

		if this.Rotating then
			this.Angles:RotateAroundAxis(Vector(0, 0, 0.15), 1)
		end

		if this.Pressed then
			local mx = gui.MousePos()
			this.Angles = this.Angles - Angle(0,(this.PressX || mx) - mx, 0)
			this.PressX, this.PressY = gui.MousePos()
		end

		_ent:SetAngles(this.Angles)
	end

	-- Adding sliders
	self.SliderPanels = {}

	if item.Skins then
		self:AddSlider('Skin', false, 'Skin', item.Skins, self.Mods)
	end
	for name, bg in pairs(item.Bodygroups || {}) do
		self:AddSlider(name, bg.id, 'BG_' .. bg.id, bg.values, self.Mods)
	end

	-- Create submit function
	self.Submit.DoClick = function()
		PS:SendModifications(item.ID, self.Mods)
		self:Close()
	end
end

function PANEL:AddSlider(name, id, mod_id, values, mods)
	-- Panel containing slider
	local panel = self.SP:Add('DPanel')
	panel:Dock(TOP)
	panel:SetTall(56)

	-- Draw name
	panel.Paint = function(this, w, h)
		draw.SimpleText(name, 'DermaDefaultBold', w / 2 - 1, 7, CONFIG.SlidersDark && Color(0, 0, 0) || Color(0, 0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(name, 'DermaDefaultBold', w / 2, 6, CONFIG.SlidersDark && Color(255, 255, 255) || Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end

	-- Adding slider
	panel.Slider = panel:Add('DNumSlider')
	panel.Slider:Dock(BOTTOM)
	panel.Slider.Label:Hide() -- Hiding text and empty space
	panel.Slider:DockMargin(8, 0, 0, 0) -- Spacing
	panel.Slider:SetDecimals(0)
	panel.Slider:SetMinMax(1, #values)
	panel.Slider.TextArea:SetWide(28) -- Shrinking right text field
	panel.Slider.TextArea:SetTextColor(CONFIG.SlidersDark && Color(255, 255, 255) || Color(0, 0, 0))

	panel.Slider.OnValueChanged = function(this, value)
		value = math.Round(value)

		-- If this slider is a bodygroup
		if id then
			self.ModelStand.Entity:SetBodygroup(id, values[value] || 0)
		else
			self.ModelStand.Entity:SetSkin(values[value] || 0)
		end

		self.Mods[mod_id] = value

		this:SetValue(value) -- Makes slider feel snappier
	end

	-- Updating slider here so it modifies the model
	panel.Slider:SetValue(mods[mod_id] || 1)

	self.SliderPanels[name] = panel
end

vgui.Register('PS_BodygroupSelector.Derma', PANEL, 'DFrame')

-- After game is loaded, create Modify function to show the Modify option
hook.Add('InitPostEntity', 'PS_ModifyBodygroups.Start', function()
	-- For each pointshop item
	for id, item in pairs(PS.Items) do
		-- If item doesn't have any bodygroup/skin, stop
		if !item.Skins && !item.Bodygroups then continue end

		-- Create OnModify function function
		function item:Modify(mods)
			vgui.Create('PS_BodygroupSelector.Derma'):SetItem(self, mods)
		end

		-- Replace pointshop item
		PS.Items [id] = item
	end

	if !LocalPlayer():IsSuperAdmin() then return end
	-- Create a command to see current model's properties
	concommand.Add('ps_bodygroupselector_preview', function()
		-- Ask the server for our current playermodel (using LocalPlayer():GetModel() will return wrong path most of the time)
		net.Start('PS_BodygroupSelector.Preview')
		net.SendToServer()
	end)
end)

-- Taken from https://github.com/Facepunch/garrysmod/blob/1a2c317eeeef691e923453018236cf9f66ee74b4/garrysmod/gamemodes/sandbox/gamemode/editor_player.lua
local function MakeNiceName( str )
	local newname = {}

	for _, s in pairs( string.Explode( '_', str ) ) do
		if ( string.len( s ) == 1 ) then table.insert( newname, string.upper( s ) ) continue end
		table.insert( newname, string.upper( string.Left( s, 1 ) ) .. string.Right( s, string.len( s ) - 1 ) ) -- Ugly way to capitalize first letters.
	end

	return string.Implode( ' ', newname )
end

-- Preview a model
net.Receive('PS_BodygroupSelector.ModelPreview', function()
	local path = net.ReadString()

	local ITEM = {}
	ITEM.Name = '' -- To prevent lua errors
	ITEM.Model = path

	local mainFrame = vgui.Create('PS_BodygroupSelector.Derma')
	mainFrame:SetItem(ITEM, {})
	-- Now we change some parameters
	mainFrame:SetTitle('Previewing current model')
	mainFrame.Submit:SetText('Close')
	mainFrame.Submit.DoClick = function() mainFrame:Close() end

	local ent = mainFrame.ModelStand.Entity

	-- We add sliders
	local skinCount = ent:SkinCount() - 1

	-- Skin
	if skinCount > 0 then
		mainFrame:AddSlider('Skin', nil, 'Skin', {}, {})
		-- Updating values to use skin values instead of a table values
		mainFrame.SliderPanels.Skin.Slider:SetMinMax(0, skinCount)
		mainFrame.SliderPanels.Skin.Slider:SetValue(0.1) -- Using 0 doesn't move the slider to the left
		-- We aren't using a values table, we need to do it raw ( ͡° ͜ʖ ͡°)
		mainFrame.SliderPanels.Skin.Slider.OnValueChanged = function(this, value)
			value = math.Round(value)
			this:SetValue(value)

			ent:SetSkin(value)
		end
	end

	-- Bodygroups
	for i = 0, ent:GetNumBodyGroups() - 1 do
		-- If there is only one bodygroup, ignore
		if ent:GetBodygroupCount(i) <= 1 then continue end
		local name = '[' .. i .. '] ' .. MakeNiceName(ent:GetBodygroupName(i))
		-- Create slider
		mainFrame:AddSlider(name, nil, i, {}, {})
		-- Updating values to use bodygroup values instead of a table values
		mainFrame.SliderPanels[name].Slider:SetMinMax(0, ent:GetBodygroupCount(i) - 1)
		mainFrame.SliderPanels[name].Slider:SetValue(0.1) -- Using 0 doesn't move the slider to the left
		-- We aren't using a values table, we need to do it raw
		mainFrame.SliderPanels[name].Slider.OnValueChanged = function(this, value)
			value = math.Round(value)
			this:SetValue(value)

			ent:SetBodygroup(i, value)
		end
	end
end)